--
-- by bbf
--

---
-- Global Page Controller,manage transition between page, shared data, and page's life-circle
--


require "component.pages.turnPlate.TurnPlatePage"

Slot.libs = Slot.libs or {}

Slot.libs.AppController = {

    --首页
    __indexPage       = "index",

    --当前页
    __currentPage     = "",

    --导演
    director          = cc.Director:getInstance(),

    glview            = cc.Director:getInstance():getOpenGLView(),

    visibleSize       = cc.Director:getInstance():getVisibleSize(),

    visibleOrigin     = cc.Director:getInstance():getVisibleOrigin(),

    framesize         = cc.Director:getInstance():getOpenGLView():getFrameSize(),

    inchanging        = false,

    __history         = {},

    --Route Table
    controllerTable   = {},

    appWebView        = nil,

    _initRouteTable = function(self)
        print("AppController visibleSize ("..self.visibleSize.width..","..self.visibleSize.height..")")
        self:addController( "error", {
            e404 = Slot.pages.PageNotFound
        })

        self:addController( "index", {
            index = Slot.pages.IndexPage
        })

        self:addController( "maintain",{
            index = Slot.pages.MaintainPage
        })

        self:addController("default",{
            login  = Slot.pages.LoginPage ,
            logout = Slot.pages.LoginPage ,
        })

        self:addController("GameHome",{
            index  = Slot.pages.GameHomePage
        })

        self:addController("TurnPlate",{
            index  = Slot.modules.TurnPlatePage
        })

        self:addController("modules",function()

            require "modules.pages"

            return Slot.MP:getModulesTable()

        end)

        self:addController("games",function()

            require "modules.pages"

            return Slot.MP:getGamesTable()

        end)

    end,

    getCurrentPageInstance = function(self)
        return self.__currentPageInstance
    end,

    addController = function(self,controller,actionMap)

        self.controllerTable[controller] = self.controllerTable[controller] or {}

        local mt = actionMap

        if type(actionMap) == "function" then
            mt = actionMap()
        end

        U:extend(false, self.controllerTable[controller], mt)

    end,

    getcontrollerTable = function(self)

        if not next(self.controllerTable) then
           self:_initRouteTable()
        end

        return self.controllerTable

    end,
--
--    registerEngineEventLisener = function()    --todo::::
--        LeverEngine:getInstance():registerScriptHandler(function(event, data)
--            U:debug(event)
--            if event == "enterBackground" or event == "enterForeground" then
--                local e = Slot.libs.Event:new(event)
--                e:fire()
--                if event == "enterForeground" then
--                    --TODO::::
----                    Slot.http:get("/server/ping",{},function(response)  end)
----                    Slot.Audio:reload()
--                end
--            elseif  event == "event_server_maintain" then
--                Slot.App:switchTo("maintain")
--            elseif event == "NetworkChanged" then
--            	local status={st0='NotReachable',st1='ReachableViaWiFi',st2='ReachableViaWWAN'}
--            	local st=status[string.format('st%s',event)]
--       	    	Slot.libs.Event:new("system.network.changed",{status=st}):fire()
--            end
--        end)
--    end,

    _createOrReuseAInstance = function(self,route,params)
        assert(route.cls ~= nil , "controller:"..route.c.." action:"..route.c .." implement class not found")
        print("controller:"..route.c.." action:"..route.a)
--        U:debug(route)
        local instance  = route.cls:new(params)
        if instance == nil then
            error("want to switch to a page which we can't create instance: ["..route.c.."/"..route.a.."]",2)
            return  nil
        else
            return instance
        end
    end,


    switchScene = function(self,controller,params,onEnter)
        local scene = cc.Scene:create()
        scene:registerScriptHandler(function(eventType)

            if eventType     == 'enter' then
                onEnter(scene)
            end
        end)
        self:translateSceneEnd(scene, function()

            if self.director:getRunningScene() then
                self.director:replaceScene(scene)
            else
                self.director:runWithScene(scene)
            end

        end)



        return scene
    end,

    getControllerAndAction = function(self,url)
        local path  = U:split(url,"/")
        if #path < 2 then
            return path[1],"index"
        else
            return path[1],path[2]
        end
    end,

    classForControllerAndAction = function(self,controller,action)
        local controllerTable = self:getcontrollerTable()
        if self.controllerTable[controller] and self.controllerTable[controller][action] then
            return self.controllerTable[controller][action]
        end
        return nil
    end,

    switchTo = function(self,url,params)
        if self.inchanging then return end
        local controller,action = self:getControllerAndAction(url)
        if controller == "__back" then
            self:back()
            return
        end
        local class = self:classForControllerAndAction(controller,action)
        params = params or {}
--        if controller=='home' and
--            action=='index' --and
--
--            then
--        end

        if class then

            self:translateSceneBegin(controller, action, function()
                U:fdebug("Slot.App" , "BEGIN TO","----------------"..url.."----------------")
                self.inchanging = true
                self:notifySwitchOut(class)


                self:switchScene(controller,params,function(scene)

                    self:preloadResource(class)
                    self:initializeScene({ c = controller , a = action , cls = class } , params , scene)
                    -- self:stopTimeoutFunc()

                    U:setTimeout(function()
                        if self.switch then
                            self.switch:switchInEnd(
                                function()
                                    self.switch=nil
                                    self.inchanging = false
                                end)
                        else
                            self.inchanging = false
                        end

                    end, 0.1)


                    U:fdebug("Slot.App" , "END TO","----------------"..url.."----------------\n")
                end)

            end)


        else
            U:ferror("Slot.App","ERROR","Can't find class map controller:%s action:%s",controller,action)
        end
    end,

    translateSceneBegin = function(self, controller, action, callBack)

        local scene = self.director:getRunningScene()
        if controller == "modules" or controller == "games" then

            print("controller==="..controller.."    action===="..action)

            self.switch = Slot.com.SwitchScene:new({
                modulename = action
            })

            self.switch:setAnchorPoint(cc.p(0,0))
            self.switch:setPosition(cc.p(self.visibleOrigin.x,self.visibleOrigin.y))
            scene:addChild(self.switch:getRootNode(), 10)

            self.switch:switchInBegin(callBack)
        else
            callBack()
        end

    end,

    translateSceneEnd = function(self, replaceScene, callBack)

        if self.switch then
            self.switch:retain()
            self.switch:removeFromParent(false)
            replaceScene:addChild(self.switch:getRootNode(), 10)
            self.switch:release()
        end

        self:clearInSwitchScene()
        callBack()

    end,

    notifySwitchOut=function(self,cls)

        if self.__currentPageInstance and self.__currentPageInstance._onSwitchOut then
            self.__currentPageInstance:_onSwitchOut()
            self.__currentPageInstance._onSwitchOut=nil
        end
        
    end,

    initializeScene = function(self,route,params,scene)
        U:fdebug("Slot.App","chage scene","%s --> %s ",self.__currentPage,route.c.."/"..route.a)
        self.__currentPage = route.c.."/"..route.a
        self:_pushHistory(self.__currentPage,params)
        local inpage =  self:_createOrReuseAInstance(route,params)
        self.__currentPageInstance = inpage
        local pageNode = inpage.rootNode
        pageNode:setAnchorPoint(cc.p(0,0))
        pageNode:setPosition(cc.p(self.visibleOrigin.x,self.visibleOrigin.y))
        scene:addChild(pageNode)
        if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then

        end
        
    end,

    preloadResource       = function(self,class)
        local commons = class:getCommonResources()
        for r in ipairs(commons) do
            Slot.SpriteCacheManager:preload(commons[r])
        end
        local modules  = class:getModulesResources()
        for r in ipairs(modules) do
            Slot.SpriteCacheManager:preload(modules[r])
        end
    end,

    clearInSwitchScene    = function(self)
        Slot.libs.Event:new("system.switch.scene"):fire() --notify switch scene
        ---TODO clear the http request queue to avoid asynchonized callback operating the node which is destroyed
--        Slot.http:clearQueue()
        ---TODO clear the event listener in last scene
        Slot.EM:clearAll()
        ---TODO stop all actions in running
--        self.director:getActionManager():pauseAllRunningActions()
--        self.director:getActionManager():removeAllActions()
        local scene = self.director:getRunningScene()
        if scene then scene:stopAllActions() end
        end,

    load = function(self,page)
--        self:getcontrollerTable()
        self:registerAppEventLisener()
        if page then
            self:switchTo(page,{__indexPage = true})
        else
            self:switchTo(self.__indexPage,{__indexPage = true})
        end
    end,

    registerAppEventLisener = function(self)

        cc.LeverUtils:getInstance():unregisterHandler()
        cc.LeverUtils:getInstance():registerHandler(function(eventType)

            local event = Slot.libs.Event:new(eventType)
            event:fire()

--            if eventType == "BecomeActive" then
--
--            elseif  eventType == "DidEnterBackground" then
--
--            elseif  eventType == "WillEnterForeground" then
--
--            elseif  eventType == "WillTerminate" then
--
--            end

        end)

    end,

    back = function(self)
        local prev = self:_popHistory()
        if prev then
            prev.params.__indexPage = nil
            if prev.params.__history_back_load then
                prev.params.__history_back_load()
            else
                self:switchTo(prev.page,prev.params)
            end
        else
            self:switchTo("home")
        end
    end,

    _pushHistory = function(self,pagename,params)
        if #self.__history > 5 then table.remove(self.__history) end
        local lastPage=self.__history[1] or {} --过滤最后相同的历史
        if lastPage.page==pagename then
            return
        end
        table.insert(self.__history,1,{
            page = pagename,
            params = params
        })
    end,

    _popHistory = function(self)
        if #self.__history >= 2 then
            local curr = table.remove(self.__history,1)
            local prev = table.remove(self.__history,1)
            return prev
        end
        return nil
    end,

    getCurrentPage = function(self)

        if not self.__currentPage or (type(self.__currentPage) == "string" and string.len(self.__currentPage:gsub("^%s*(.-)%s*$", "%1")) <= 0) then
            self.__currentPage = self.__indexPage
        end

        local c,a = self:getControllerAndAction(self.__currentPage)
        return {controller = c,action = a}
    end,
}
--add a shortcat for this
Slot.App = Slot.libs.AppController