--
-- by bbf
--

Slot.pages.IndexPage = Slot.pages.Page:extend({

    __className = "Slot.ui.IndexPage",

    initWithCode = function(self,options)
        self:_super(options)
        local pagePara = self._options.pagePara or {}
        self._userInfo = pagePara.user_info or {}

        self._downLoadNum = nil
        self._totalFileNum = nil
        require "test"
        --加载公共音乐资源

        self:doNotification()


        self:addContent()
    end,



    doNotification = function(self)


--        Slot.NM:removeNotification("twodayleft")
--        Slot.NM:removeNotification("fourdayleft")
--        Slot.NM:removeNotification("sevendayleft")
        Slot.NM:removeAllNotification()

        -- 距玩家上一次启动游戏后，若干天未再次启动游戏时（2天、4天、7天）
--        Slot.NM:notification(U:locale("pushmessage", "two_days_left"), 86400*2, "twodayleft")
--        Slot.NM:notification(U:locale("pushmessage", "four_days_left"), 86400*4, "fourdayleft")
--        Slot.NM:notification(U:locale("pushmessage", "seven_days_left"), 86400*7, "sevendayleft")

        Slot.NC:fireEvent_Recall()
        Slot.NC:onEvent("noticenter_recall")
    end,

    addContent = function(self)

        self:createIcon()

        self:createProgress()

        self:createLoading()

--        if not Slot.Configuration:setConfig() then return end

        if Slot.Configuration.DEBUG == "false" then

            self:update()

        else

            self._userInfo = Slot.Configuration.debug_user
            Slot.DM:sync(function(data)
                self:gameIn(100, 2)
            end, self._userInfo)

        end

        self:preloadCommonResources()

    end,

    registerLoginCallBack = function(self)

        if Slot.Configuration.DEBUG == "true" then return end

        cc.OASSdk:getInstance():registerHandler(Slot.SdkType.LOGIN, function(userInfo)
            self:gameIn(95)

            self._userInfo = userInfo or {}

            Slot.DM:sync(function(data)

                local player = data.player
                cc.OASSdk:getInstance():setUserInfo(""..player.player_id, "1", "all")
                self:gameIn(100)

            end, self._userInfo)
        end)

    end,


    login = function(self)
        cc.OASSdk:getInstance():autoLogin()
    end,

    update = function(self)
        local pagePara = self._options.pagePara or {}
        local update = Slot.Update:new({
            callBack = function(percent, sec, attach)
                if not self._downLoadNum then
                    self._downLoadNum = 1
                else
                    self._downLoadNum = self._downLoadNum + 1
                end
                if not self._totalFileNum then self._totalFileNum = attach.totalFileNum end

                if self._downLoadNum < attach.downLoadNum then self._downLoadNum = attach.downLoadNum end

                --                if self._downLoadNum > 100 then self._downLoadNum = 100 end

                local down_percent = self._downLoadNum / self._totalFileNum * 100

                if down_percent == 100 and down_percent > percent then
                    down_percent = percent
                end


                if pagePara.login == false then

                    if down_percent >100 or percent == 100 then down_percent = 100 end

                else
                    down_percent = down_percent*0.9
                    if down_percent >90 or percent == 100 then down_percent = 90 end

                end
                down_percent = math.floor(down_percent)
                self:gameIn(down_percent, sec)

            end,
            restartUpdate = function()

                U:reloadModule("update.Update")

                self:update()

            end,
        })

    end,

    gameIn = function(self, percent, sec)
        local pagePara = self._options.pagePara or {}
        if not sec then sec = 0.5 end
        local actions = {}
        local to = cc.ProgressTo:create(sec, percent)
        local switch = cc.CallFunc:create(function()
            if percent == 90 and pagePara.login ~= false then
                U:clearModule(true)
                self:login()
            end

            if percent == 100 then

                Slot.DM:getBaseProfile(self._userInfo.userID) -- 重新加载lua文件之后，这个值是空值，必须重新取一遍数据，否则会报错

                self._modules = Slot.MP:getModulesName()

                for i,v in pairs(self._modules) do
                    Slot.DM:setLocalStorage(v.."_downloading", 0, false) -- 初始化下载状态
                end

                local gameInAction = {}
                table.insert(gameInAction,cc.FadeOut:create(0.5))
                table.insert(gameInAction,cc.DelayTime:create(0.2))
                table.insert(gameInAction,cc.CallFunc:create(function()
                    Slot.App:switchTo("GameHome")
                end))
                local gameSeq = cc.Sequence:create(gameInAction)

                self.loading:runAction(gameSeq)

            end

        end)
        table.insert(actions,to)
        table.insert(actions,cc.DelayTime:create(0.5))
        table.insert(actions,switch)
        local seq = cc.Sequence:create(actions)

        self.progress:runAction(seq)

    end,

    createIcon = function(self)
        local icons = Slot.start_page_icons

        local left = self._winsize.width
        for k, v in pairs(icons) do
            local tsprite =U:getSpriteByName("start_page_"..v..".png")
            local tsize = tsprite:getContentSize()
            left = left - tsize.width
        end

        left = (left - Slot.Margin.start_page_icons.left * 3) / 2


        local bottom = self._winsize.height/2 + Slot.Margin.start_page_icons.bottom

        for k, v in pairs(icons) do

            local sprite =U:getSpriteByName("start_page_"..v..".png")
            local size = sprite:getContentSize()
            sprite:setPosition(cc.p(left + size.width/2, bottom))
            self.rootNode:addChild(sprite)

            --            local action = {}

            U:setTimeout(function()
                local up = cc.MoveBy:create(1, cc.p(0, 16))
                local down = up:reverse()
                local delay = cc.DelayTime:create(0.1)
                local seq = cc.Sequence:create(up, delay, down, delay)
                sprite:runAction(cc.RepeatForever:create(seq))
            end,k*0.5)

            left = left + size.width + Slot.Margin.start_page_icons.left

            if  (#icons)/2 > k then
                bottom = bottom + size.height/2
            elseif (#icons)/2 < k then
                bottom = bottom - size.height/2
            end

        end

        --U:addSpriteFrameResource("plist/common/startPage.plist")
        -- 中间的图标
        local sprite = U:getSpriteByName("game_logo.png")
        sprite:setPosition(cc.p(self._winsize.width/2,self._winsize.height/2 + Slot.Margin.start_page_icons.midBottom))
        self.rootNode:addChild(sprite)

        --添加星星闪烁 1.05
        require "libs.Call_Animation"
        Slot.Call_Animation:StartlightAction(self.rootNode,3)


    end,

    createProgress = function(self)

        local progressBg =U:getSpriteByName("start_page_progress_bg.png")
        progressBg:setAnchorPoint(cc.p(0.5,0.5))
        progressBg:setPosition(cc.p((self._winsize.width) / 2, (self._winsize.height) / 5))
        self.rootNode:addChild(progressBg)
        self.progress = cc.ProgressTimer:create(U:getSpriteByName("start_page_progress.png"))

        self.progress:setType(cc.PROGRESS_TIMER_TYPE_BAR)
        -- Setup for a bar starting from the left since the midpoint is 0 for the x
        self.progress:setMidpoint(cc.p(0, 0))
        -- Setup for a horizontal bar since the bar change rate is 0 for y meaning no vertical change
        self.progress:setBarChangeRate(cc.p(1, 0))
        --        left:runAction(cc.RepeatForever:create(to1))
        self.progress:setAnchorPoint(cc.p(0.5, 0.5))
        self.progress:setPosition(cc.p((self._winsize.width) / 2, (self._winsize.height) / 5 ))
        self.rootNode:addChild(self.progress)

        --        progress:runAction(to)

        self.progress:setPercentage(0)
    end,

    createLoading = function(self)
        self.loading = U:getSpriteByName("start_page_loading.png")
        self.loading:setAnchorPoint(cc.p(0.5,0.5))
        self.loading:setPosition(cc.p((self._winsize.width) / 2, (self._winsize.height) / 4 + 25))
        self.rootNode:addChild(self.loading)

        local show = cc.FadeIn:create(0.5)
        local showreverse = show:reverse()

        local seq = cc.Sequence:create(show, showreverse)
        self.loadingAction = cc.RepeatForever:create(seq)
        self.loading:runAction(self.loadingAction)

    end,

    _addHeader = function(self) end,

    _addFooter = function(self) end,

    _addBody = function(self) end,

    preloadCommonResources = function(self)

--        U:addSpriteFrameResource("plist/common/baseprofile_common.plist")
--        U:addSpriteFrameResource("plist/common/posterPaper.plist")
--        U:addSpriteFrameResource("plist/common/violet_bar.plist")

    end,

    getCommonResources = function(self)

        return {
            "plist/common/common.plist",
            "plist/common/start_page.plist",
        }

    end,

    getRootNode = function(self)

        if #self._options.resources > 0 then

            for i, r in ipairs(self._options.resources) do

                Slot.SpriteCacheManager:preloadImageCache(r)

            end

        end

        if not self.rootNode then

            local bg=self._options.bg
            local texture = cc.Director:getInstance():getTextureCache():addImage(bg)
            local sprite=cc.Sprite:createWithTexture(texture)
            --local sprite=cc.Sprite:create(bg)
            local rect=self._options.inset
            local x,y,x1,y1=rect.x,rect.y,sprite:getTextureRect().width-(rect.x+rect.width),sprite:getTextureRect().height-(rect.y+rect.height)
            self.rootNode = cc.Scale9Sprite:create(cc.rect(x,y,x1,y1),bg)
            self.rootNode:setContentSize(self._winsize)
            self.rootNode:setAnchorPoint(cc.p(0.5,0.5))
            self.rootNode:setPosition(cc.p(self._winsize.width/2,self._winsize.height/2))

        end
        return self.rootNode
    end,


    getDefaultOptions = function(self)
        return {
            nodeEventAware  = true,
            transition      = true,
            layout          = "absolute",
            onExit = function(opt, that)
            --cc.Director:getInstance():getTextureCache():removeUnusedTextures()
                if Slot.Configuration.DEBUG == "false" then
                    cc.OASSdk:getInstance():unregisterHandler(Slot.SdkType.LOGIN)
                end

                Slot.SpriteCacheManager:removeSpriteFrameByFile("plist/common/start_page.plist")
                Slot.SpriteCacheManager:removeSpriteFrameByFile("plist/common/common.plist")
                cc.Director:getInstance():getTextureCache():removeTextureForKey(that._options.bg)

                if #self._options.resources > 0 then

                    for i, r in ipairs(self._options.resources) do

                        Slot.SpriteCacheManager:removeImageCache(r)

                    end

                end
            end,
            inset=cc.rect(0,0,0,0),
            bg = "common/start_page_bg.jpg",
            resources = {
                "common/dlg_title_bg.png",
                "common/content_bg.png"
            },
            keyName="common"
        }
    end

})