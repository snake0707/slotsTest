--
-- Created by IntelliJ IDEA.
-- User: bbf
-- Date: 14-11-6
-- Time: 下午5:49
-- To change this template use File | Settings | File Templates.
--

require "component.ui.SlotManager"

require "QAtest"


Slot = Slot or {}

Slot.modules = Slot.modules or {}

Slot.modules.westPage = Slot.pages.Page:extend({

    __className = "Slot.modules.westPage",

    initWithCode = function(self,options)
        Slot.DM:clearModuleData()
        self._data = Slot.DM:getReelData("west",18) -- 18个轮子

        self:_super(options)

        self:touchRegister(self.rootNode)

        self:_onEvent()

        --预加载音乐
        self:_preLoadMusic()

        self:addContent()
    end,

    _onEvent=function(self)

        self.filePath="sound/modules/"..self._options.modulename.."/"
        self:onEvent("switch_end",function()

            Slot.Audio:playMusic(self.filePath..Slot.MusicResources[self._options.modulename].west)

        end)


        self:onEvent("WillEnterForeground",function()
            Slot.Audio:stopMusic(true)
            Slot.Audio:playMusic(self.filePath..Slot.MusicResources[self._options.modulename][self._options.modulename])

        end)


    end,

    _preLoadMusic=function(self)

        --test 2015 1.04


        local isMusicOn = tonumber(Slot.DM:getLocalStorage("music_on"))

        if isMusicOn~=0 then
            Slot.Audio:preloadMusic(self.filePath..Slot.MusicResources[self._options.modulename].west)
        end


        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].west_icon1)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].west_icon2)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].west_wild)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].west_bonus)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].west_scatter)

        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].west_spin)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].west_reel_roll)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].west_reel_stop)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].west_expect)


        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].west_expect_reel1_stop)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].west_expect_reel2_stop)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].west_expect_reel3_stop)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].west_expect_reel4_stop)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].west_expect_reel5_stop)

        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].west_bgame_begin)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].west_bgame_dooropen)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].west_bgame_gold)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].west_bgame_none)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].west_bgame_end)


    end,



    addContent   = function(self)

        local emptySize = self:getEmptySize()
        

        self._slotManager = Slot.ui.SlotManager:new({
            ccbFile = "ccbi/WestSlot.ccbi",
            component = self._options.component,
            pagePara = self._options.pagePara,
            frameWidth  = 72,
            frameHeight = 226,
            componentWidth = 72,
            componentHeight = 76,
            modulename = "west",
            emptySize = emptySize,
            footheight=self:getFooterHeight(),


        })


        self.content:addChild(self._slotManager)

        math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
        self:_westModulesAction(10)



        self:QAtest()


    end,

    QAtest=function(self)


        local QA_test=Slot.QAtest:new({profile=self.profile})

        print("type(QA_test):"..type(QA_test))
        self.content:addChild(QA_test.rootNode,10000)

        QA_test:setPosition(cc.p(0,0))

    end,

    _westModulesAction=function(self,secs)



        require "modules.west.westAnimation"
        local height=self:getFooterHeight()

        self.ScheduleId=U:setTimeoutUnsafe(function()


            Slot.west_animation:westModuleAction(self.rootNode,height,function()


                self:_westModulesAction(math.random(20,200))


            end)

        end,secs)


    end,

    getRootNode = function(self)

        if not self.rootNode then
            local bg=self._options.bg

            local texture = cc.Director:getInstance():getTextureCache():addImage(bg)
            local sprite=cc.Sprite:createWithTexture(texture)

            --local sprite=cc.Sprite:create(bg)
            local rect=self._options.inset
            local x,y,x1,y1=rect.x,rect.y,sprite:getTextureRect().width-(rect.x+rect.width),sprite:getTextureRect().height-(rect.y+rect.height)
            self.rootNode = cc.Scale9Sprite:create(cc.rect(x,y,x1,y1),bg)

--            self.rootNode = cc.Sprite:create("common/start_page_bg.jpg")
            self.rootNode:setContentSize(self._winsize)
            self.rootNode:setAnchorPoint(cc.p(0.5,0.5))
            self.rootNode:setPosition(cc.p(self._winsize.width/2,self._winsize.height/2))
        end
        return self.rootNode
    end,

    getCommonResources = function(self)
--        U:addSpriteFrameResource("plist/common/common.plist")
--        U:addSpriteFrameResource("plist/common/spinButton.plist")
--        U:addSpriteFrameResource("plist/common/orange_bar.plist")
--        U:addSpriteFrameResource("plist/modules/west/west.plist")
--        U:addSpriteFrameResource("plist/modules/"..self._options.modulename.."/"..self._options.modulename..".plist")


        return {
            "plist/common/common.plist",
--            "plist/common/baseprofile_common.plist",
--            "plist/common/slotbar_common.plist",
            "plist/common/game_common.plist",

            "plist/common/orange_bar.plist",
            "plist/modules/west/west.plist",
            "plist/modules/west/paytable.plist"
        }

    end,

    getDefaultOptions = function(self)

        return U:extend(false, self:_super(), {
            nodeEventAware  = true,
            transition   = true,
            baseProfile    = true,
            slottoolbar    = true,
--            bodyFullScene = false,
            modulename = "west",
            style = "orange",
            component = {1,2,3,4,5,6,7,8,9,10,50,100,200},
            spin = function(arg)


                self._slotManager:startSpin(arg)
                --print("spin====================")

            end,
            onExit = function(opt, that)


                Slot.DM:clearModuleData()
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(that.ScheduleId)
                --cc.Director:getInstance():getTextureCache():removeUnusedTextures()

--                Slot.SpriteCacheManager:removeSpriteFrameByFile("plist/common/common.plist")
                Slot.SpriteCacheManager:removeSpriteFrameByFile("plist/common/orange_bar.plist")
                Slot.SpriteCacheManager:removeSpriteFrameByFile("plist/modules/west/west.plist")
                Slot.SpriteCacheManager:removeSpriteFrameByName("plist/common/paytable.plist")
                Slot.SpriteCacheManager:removeSpriteFrameByFile("plist/common/game_common.plist")

                cc.Director:getInstance():getTextureCache():removeTextureForKey(self._options.bg)
                cc.Director:getInstance():getTextureCache():removeTextureForKey("image/modules/west/logo.png")
                
                Slot.Audio:stopMusic(true)
                Slot.Audio:unloadModuleEffect(Slot.MusicResources[self._options.modulename],self._options.modulename)
            end,
            inset=cc.rect(0,0,0,0),
            bg = "modules/west/bg.png"
--
--
--            stopspin = function()
----                self._slotManager:stopSpin({2,5,3},function()end)
--            end,
        })
    end

})

