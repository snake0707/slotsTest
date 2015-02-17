--
-- by bbf
--

Slot.pages = Slot.pages or {}
Slot.pages.Page = Slot.ui.UIComponent:extend({

	__className = "Slot.ui.Page",

    getCommonResources = function(self)
        return {
        }
    end,
    getModulesResources = function(self)
        return {
        }
    end,

	initWithCode = function(self, options)
		self:_super(options)
        self:_addHeader()
        self:_addFooter()
        self:_addBody()
        self:_addMenu()
        self:registerLoginCallBack()

	end,

    _addHeader      = function(self)
        self:_initProfileBar()
    end,

    getHeaderHeight = function(self)
        local height = 0
--        if self._options.broadcast    then height = 18 end
        if self._options.baseProfile  then
            if self.profile then
                height = height + self.profile:getContentSize().height
            else
                height = height + 145

            end
        end -- 固定高度

        --print("getHeaderHeight============"..height)

        return height
    end,

    _initProfileBar = function(self)
        if self._options.baseProfile then

            local baseProfileOptions = U:extend(false,{
                width = self._winsize.width,
                height = self._winsize.height,
                show_back_btn = self._options.show_back_btn,
                style = self._options.style,
                nodeEventAware = true,
                modulename = self._options.modulename,
                --add 11.29
                rootNode=self.rootNode

            }, self._options.baseProfileOptions)

            self.profile = Slot.com.BaseProfile:new(baseProfileOptions)
            self.profile:setAnchorPoint(cc.p(0,1))
            self.profile:setPosition(cc.p(0, self._winsize.height))
            self:addChild(self.profile, {}, 1)
        end
    end,

    _addFooter = function(self)
        if self._options.slottoolbar then

            local toolBarOptions = U:extend(false,{
                style = self._options.style,
                modulename = self._options.modulename,
                component = self._options.component,
                win = self._options.win,
                spin = function(arg)
                    if type(self._options.spin) == "function" then
                        self._options.spin(arg)
                    end
                end,
            }, self._options.slotToolBarOptions)


            self.toolbar = Slot.com.SlotToolBar:new(toolBarOptions)
            self.toolbar:setAnchorPoint(cc.p(0,0))
            self:addChild(self.toolbar,{},1)

        elseif self._options.hometoolbar then

            self.hometoolbar = Slot.com.HomeToolBar:new({

                --add 11.29
                rootNode=self.rootNode

            })
            self.hometoolbar:setAnchorPoint(cc.p(0,0))
            self.hometoolbar:setPosition(cc.p(0, Slot.Margin.homebar.bottom))
            self:addChild(self.hometoolbar,{},2)
        end
    end,

    _addMenu = function(self)

        if Slot.Configuration.DEBUG == "true" then return end

        if self._options.showMenu then

            cc.OASSdk:getInstance():showMenu(true, Slot.SdkMenuPos.MenuPositionLeftDown)
        else

            cc.OASSdk:getInstance():showMenu(false, Slot.SdkMenuPos.MenuPositionLeftDown)

        end

    end,

    getFooterHeight = function(self)
        local height = 0
        if self._options.slottoolbar  then
            if self.toolbar then
                height = height + self.toolbar:getContentSize().height
            else
                height = height + 247

            end
        end -- 固定高度

--        if self._options.hometoolbar then
        --
        --            if self.hometoolbar then
        --                height = height + self.hometoolbar:getContentSize().height
        --            else
        --                height = height + 84
        --            end
        --
        --        end

        --print("getFooterHeight============"..height)
        return height
    end,

    _addBody = function(self)

        local size   = self:getEmptySize()

        if self._options.bodyFullScene then
            size = self._winsize
        end

        self.content = Slot.ui.UIComponent:new({})
        self.content:setContentSize(size)
        U:addToCenter(self.content, self)
    end,

    getEmptySize = function(self)

        local size = cc.size(0, 0)

        size.width = self._winsize.width
        size.height = self._winsize.height - self:getHeaderHeight() - self:getFooterHeight()

        return size
    end,


    touchRegister=function(self,node)


        local layer=cc.Layer:create()
        local _scene = cc.Director:getInstance():getRunningScene()
        _scene:addChild(layer, Slot.ZIndex.Hit)

        layer:registerScriptTouchHandler(function(eventType,x,y)

           -- print("touch===========")

            if eventType=="began" then
                local spinStar=Slot.animation:ShowSpinStar("plist/common/spin_star.plist")
                layer:addChild(spinStar,10)
                spinStar:setPosition(cc.p(x,y))
                spinStar:setDuration(0.1)

                self:fireEvent("close_All",{
                   pos=cc.p(x,y)
                })

                return false
            end

        --11.30 添加一个点击的粒子效果


        end, false, Slot.TouchPriority.layer, false)
        layer:setTouchEnabled(true)

        --Slot.TouchPriority.layer

    end,

    registerLoginCallBack = function(self)

        if Slot.Configuration.DEBUG == "true" then return end

        cc.OASSdk:getInstance():registerHandler(Slot.SdkType.LOGIN, function(userInfo)

            self:_addMenu()

            self._userInfo = userInfo or {}

            Slot.DM:sync(function(data)
                local player = data.player
                cc.OASSdk:getInstance():setUserInfo(""..player.player_id, "1", "all")

                local profile = Slot.DM:getBaseProfile(self._userInfo.userID) -- 重新加载lua文件之后，这个值是空值，必须重新取一遍数据，否则会报错

                self:fireEvent("profile_update", profile)

                Slot.App:switchTo("GameHome")

            end, self._userInfo)
        end)
    end,



	getRootNode = function(self)
		if not self.rootNode then
			self.rootNode = cc.Node:create()
            self.rootNode:setContentSize(self._winsize)
		end
		return self.rootNode 
	end,

    getDefaultOptions = function(self)
		return {
            lastMessageAware=true,
            bgOpacity      = nil,
            broadcast      = false,
			baseProfile    = false,
            show_back_btn  = true,
            slottoolbar    = false,
            postertoolbar    = false,
			transition     = false,
            nodeEventAware = true,
            exitDuration   = 0.3,
            showMenu = false,
            bodyFullScene  = false, -- 与body大小有关
--            layout         = "dock",
            onExit = function(opt, that)
                self:clearEvent("close_All")

                if Slot.Configuration.DEBUG == "false" then
                    cc.OASSdk:getInstance():unregisterHandler(Slot.SdkType.LOGIN)
                end
            end
		}
	end
})