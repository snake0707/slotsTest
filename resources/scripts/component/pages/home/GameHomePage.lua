--
-- by bbf
--

require "component.ui.SlotManager"

Slot.pages.GameHomePage = Slot.pages.Page:extend({

    __className = "Slot.ui.GameHomePage",

    initWithCode = function(self,options)
        self:_super(options)

        self:_preLoadMusic()

        self:_onEvent()

        self:addContent()

        self:popRateDlg()

        self:touchRegister(self.rootNode)
    end,

    _preLoadMusic=function(self)

        self.filePath="sound/common/"

        local isMusicOn = tonumber(Slot.DM:getLocalStorage("music_on"))

        if isMusicOn~=0 then
            Slot.Audio:preloadMusic(self.filePath..Slot.MusicResources[self._options.modulename].common)
        end



        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].showcoins_small)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].showcoins_mid)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].showcoins_large)
        --
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].coinsget)
        --
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].fiveofakind)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].bigwin)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].hugewin)
        --
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].numberincrease)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].tap)
        --
        --
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].levelup)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].levelup_firework)
        --
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].windowshow)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].windowback)
        --
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].expfly)
        --
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].crowdcheers1)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].crowdcheers2)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].crowdcheers3)

        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].crowdsigh1)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].crowdsigh2)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].crowdsigh3)
        --
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].lobby_coins_collect)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].lobby_coins_fly)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].lobby_wheel)
        --
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].shop_show)


    end,

    _onEvent=function(self)
        
        self:onEvent("WillEnterForeground",function()
            Slot.Audio:stopMusic(true)
            Slot.Audio:playMusic(self.filePath..Slot.MusicResources[self._options.modulename][self._options.modulename])

        end)

    end,

    addContent   = function(self)

        Slot.Audio:playMusic("sound/"..self._options.modulename.."/"..Slot.MusicResources[self._options.modulename][self._options.modulename],true)

        local emptySize = self:getEmptySize()

        self._panel= Slot.com.GameHome:new({},
            {
                --add 11.29
                homeToolBar=self.hometoolbar,
                baseProFile= self.profile,
                emptySize = emptySize,
                pageNode=self.rootNode
            })
        --        self._panel:setPositionX(Slot.Margin.poster.lr)
        self.content:getRootNode():addChild(self._panel:getRootNode(c))


        --      更新版本号：

        local label = cc.LabelTTF:create("版本号：0.99-3-2-15-1", Slot.Font.default, 40)
        label:setPosition(cc.p(self.content:getRootNode():getContentSize().width/2, -20))
        self.content:getRootNode():addChild(label)
    end,


    popRateDlg = function(self)

        local profile = Slot.DM:getBaseProfile()

        local past_time = U:getDayTimeStamp(os.time()) - U:getDayTimeStamp(profile.create_time)

        if past_time == 86400 and not Slot.DM:getLocalStorage("has_rate") and not Slot.DM:getLocalStorage("rate_first_day_has_open") then

            local dlg = Slot.com.RateDialog:new()
            dlg:open()
            Slot.DM:setLocalStorage("rate_first_day_has_open", 1)
        end

        if past_time == 86400 * 3 and not Slot.DM:getLocalStorage("has_rate") and not Slot.DM:getLocalStorage("rate_third_day_has_open") then

            local dlg = Slot.com.RateDialog:new()
            dlg:open()
            Slot.DM:setLocalStorage("rate_third_day_has_open", 1)
        end

        if past_time == 86400 * 7 and not Slot.DM:getLocalStorage("has_rate") and not Slot.DM:getLocalStorage("rate_seventh_day_has_open") then

            local dlg = Slot.com.RateDialog:new()
            dlg:open()
            Slot.DM:setLocalStorage("rate_seventh_day_has_open", 1)
        end

    end,

    getCommonResources = function(self)

--        U:addSpriteFrameResource("plist/common/common.plist")
--        U:addSpriteFrameResource("plist/common/cloud.plist")
--        U:addSpriteFrameResource("plist/common/posterPaper.plist")
--        U:addSpriteFrameResource("plist/common/violet.plist")

        return {
            "plist/common/common.plist",
--            "plist/common/baseprofile_common.plist",
            "plist/common/cloud.plist",
            "plist/common/posterPaper.plist",
            "plist/common/violet_bar.plist"

        }

    end,

    getRootNode = function(self)

        if not self.rootNode then
            local bg=self._options.bg
            local texture = cc.Director:getInstance():getTextureCache():addImage(bg)
            local sprite=cc.Sprite:createWithTexture(texture)
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

        return U:extend(false, self:_super(), {
            nodeEventAware  = true,
            transition   = true,
            baseProfile    = true,
            hometoolbar = true,
            modulename = "common",
            style = "violet",
            show_back_btn = false,
            showMenu = true,
            --            bodyFullScene = true,
            spin = function()
                self._slotManager:startSpin()
            end,

            onExit=function()

--                Slot.SpriteCacheManager:removeSpriteFrameByFile("plist/common/common.plist")
                Slot.SpriteCacheManager:removeSpriteFrameByFile("plist/common/posterPaper.plist")
                Slot.SpriteCacheManager:removeSpriteFrameByFile("plist/common/violet_bar.plist")
--                Slot.SpriteCacheManager:removeSpriteFrameByFile("plist/common/baseprofile_common.plist")

                cc.Director:getInstance():getTextureCache():removeTextureForKey(self._options.bg)

            end,

            stopspin = function()
                self._slotManager:stopSpin({2,5,3},function()
                end)
            end,
            inset=cc.rect(0,0,0,0),
            bg = "common/poster_page_bg.jpg",
        })
    end

})