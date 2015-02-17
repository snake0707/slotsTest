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

Slot.modules.BlackHandPage = Slot.pages.Page:extend({

    __className = "Slot.modules.BlackHandPage",

    initWithCode = function(self,options)
        Slot.DM:clearModuleData()
        self._data = Slot.DM:getReelData("blackhand",18) -- 18个轮子
        self:_super(options)

        self:_onEvent()

        self:_preLoadMusic()
        
        self:addContent()

        self:touchRegister(self.rootNode)
    end,

    _onEvent=function(self)

        self.filePath="sound/modules/"..self._options.modulename.."/"

        self:onEvent("switch_end",function()

            Slot.Audio:playMusic(self.filePath..Slot.MusicResources[self._options.modulename][self._options.modulename])

            local delay=cc.DelayTime:create(11)
            local showRainSound=cc.CallFunc:create(function()
                Slot.Audio:playMusic("sound/modules/blackhand/"..Slot.MusicResources["blackhand"].blackhand_rain,true)
            end)

            local seq=cc.Sequence:create(delay,showRainSound)
            self.rootNode:runAction(seq)

        end)

        self:onEvent("WillEnterForeground",function()
            Slot.Audio:stopMusic(true)
            Slot.Audio:playMusic(self.filePath..Slot.MusicResources[self._options.modulename][self._options.modulename])

        end)



    end,
    _preLoadMusic=function(self)

    --test 2015 1.04

--
        Slot.Audio:preloadMusic(self.filePath..Slot.MusicResources[self._options.modulename].blackhand)
        Slot.Audio:preloadMusic(self.filePath..Slot.MusicResources[self._options.modulename].blackhand_rain)


        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].blackhand_light)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].blackhand_icon1)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].blackhand_icon2)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].blackhand_icon3)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].blackhand_wild)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].blackhand_bonus)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].blackhand_scatter)
--
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].blackhand_spin)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].blackhand_reel_roll)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].blackhand_reel_stop)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].blackhand_expect)

--
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].blackhand_expect_reel1_stop)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].blackhand_expect_reel2_stop)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].blackhand_expect_reel3_stop)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].blackhand_expect_reel4_stop)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].blackhand_expect_reel5_stop)

        Slot.Audio:preloadMusic(self.filePath..Slot.MusicResources[self._options.modulename].blackhand_bgame_begin)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].blackhand_bgame_pickcard)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].blackhand_bgame_cardmatch)
        Slot.Audio:preloadMusic(self.filePath..Slot.MusicResources[self._options.modulename].blackhand_bgame_end)





    end,

    addContent   = function(self)


        local emptySize = self:getEmptySize()

        self._slotManager = Slot.ui.SlotManager:new({
            ccbFile = "ccbi/BlackHand.ccbi",
            component = self._options.component,
            pagePara = self._options.pagePara,
            frameWidth  = 72,
            frameHeight = 232,
            componentWidth = 72,
            componentHeight = 78,
            modulename = "blackhand",
            emptySize = emptySize,
            footheight=self:getFooterHeight(),

        })


        self.content:addChild(self._slotManager)

        self.rainMask=self._slotManager.proxy:getNodeWithName("blackhand_rainMask")
        self.lightMask=self._slotManager.proxy:getNodeWithName("blackhand_lightMask")


        require "modules.blackhand.blackhandAnimation"
        --添加雨点  水雾 12.31
        Slot.blackhand_animation:blackRainAction(self.rainMask)
        Slot.blackhand_animation:blackFogAction(self.rainMask)

        math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
        self:_blackhandModulesAction(10)


        self:QAtest()

    end,

    QAtest=function(self)


        local QA_test=Slot.QAtest:new({profile=self.profile})

        print("type(QA_test):"..type(QA_test))
        self.content:addChild(QA_test.rootNode,10000)

        QA_test:setPosition(cc.p(0,0))

    end,

    _blackhandModulesAction=function(self,secs)



        self.ScheduleId=U:setTimeoutUnsafe(function()

            Slot.blackhand_animation:blackLightningAction(self.lightMask,function()

                self:_blackhandModulesAction(math.random(20,200))
            end)


        end,secs)

    end,

    getCommonResources = function(self)
--        U:addSpriteFrameResource("plist/common/common.plist")
--        U:addSpriteFrameResource("plist/common/spinButton.plist")
--        U:addSpriteFrameResource("plist/common/violet.plist")
--        U:addSpriteFrameResource("plist/modules/blackhand/blackhand.plist")
--        U:addSpriteFrameResource("plist/modules/"..self._options.modulename.."/"..self._options.modulename..".plist")

        return {
            "plist/common/common.plist",
            -- "plist/common/baseprofile_common.plist",
            --  "plist/common/slotbar_common.plist",
            --  "plist/common/game_common.plist",

            "plist/common/violet_bar.plist",
            "plist/modules/blackhand/blackhand.plist",
            --"plist/modules/blackhand/paytable.plist"
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

--            self.rootNode = cc.Sprite:create("modules/blackhand/bg.png")
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
            slottoolbar    = true,
--            bodyFullScene = false,
            modulename = "blackhand",
            style = "violet",
            component = {1,2,3,4,5,6,7,8,9,10,50,100,200},
            spin = function(arg)

                self._slotManager:startSpin(arg)

            end,
            onExit = function(opt, that)


                Slot.DM:clearModuleData()

                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(that.ScheduleId)
                --Slot.SpriteCacheManager:removeSpriteFrameByFile("plist/common/common.plist")
                Slot.SpriteCacheManager:removeSpriteFrameByFile("plist/common/violet_bar.plist")
                Slot.SpriteCacheManager:removeSpriteFrameByFile("plist/modules/blackhand/blackhand.plist")
                Slot.SpriteCacheManager:removeSpriteFrameByName("plist/common/paytable.plist")

                cc.Director:getInstance():getTextureCache():removeTextureForKey(self._options.bg)
                cc.Director:getInstance():getTextureCache():removeTextureForKey("image/modules/blackhand/logo.png")

                Slot.Audio:stopMusic(true)
                Slot.Audio:unloadModuleEffect(Slot.MusicResources[self._options.modulename],self._options.modulename)
            end,

            inset=cc.rect(0,0,0,0),
            bg = "modules/blackhand/bg.png"
        })
    end

})

