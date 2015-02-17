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

Slot.modules.GirlPage = Slot.pages.Page:extend({

    __className = "Slot.modules.GirlPage",

    initWithCode = function(self,options)
        Slot.DM:clearModuleData()
        self._data = Slot.DM:getReelData("girl",18) -- 18个轮子
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

        end)

        self:onEvent("WillEnterForeground",function()
            Slot.Audio:stopMusic(true)
            Slot.Audio:playMusic(self.filePath..Slot.MusicResources[self._options.modulename][self._options.modulename])

        end)


    end,

    _preLoadMusic=function(self)

    --test 2015 1.04


        Slot.Audio:preloadMusic(self.filePath..Slot.MusicResources[self._options.modulename].girl)
--
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].girl_icon1)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].girl_icon2)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].girl_wild)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].girl_bonus)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].girl_scatter)

        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].girl_spin)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].girl_reel_roll)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].girl_reel_stop)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].girl_expect)


        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].girl_expect_reel1_stop)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].girl_expect_reel2_stop)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].girl_expect_reel3_stop)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].girl_expect_reel4_stop)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].girl_expect_reel5_stop)

        Slot.Audio:preloadMusic(self.filePath..Slot.MusicResources[self._options.modulename].girl_bgame_begin)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].girl_bgame_wheel_roll)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].girl_bgame_wheel_stop)
        Slot.Audio:preloadMusic(self.filePath..Slot.MusicResources[self._options.modulename].girl_bgame_end)



    end,

    addContent   = function(self)


        local emptySize = self:getEmptySize()

        self._slotManager = Slot.ui.SlotManager:new({
            ccbFile = "ccbi/Girl.ccbi",
            component = self._options.component,
            pagePara = self._options.pagePara,
            frameWidth  = 72,
            frameHeight = 232,
            componentWidth = 72,
            componentHeight = 78,
            modulename = "girl",
            emptySize = emptySize,
            footheight=self:getFooterHeight(),

        })
--        self._slotManager:setPosition(cc.p(emptySize.width/2, emptySize.height/2))
--        self.content:getRootNode():addChild(self._slotManager:getRootNode())
        self.content:addChild(self._slotManager)



        math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
        self:_girlModulesAction(10)


        self:QAtest()
    end,

    QAtest=function(self)


        local QA_test=Slot.QAtest:new({profile=self.profile})

        print("type(QA_test):"..type(QA_test))
        self.content:addChild(QA_test.rootNode,10000)

        QA_test:setPosition(cc.p(0,0))

    end,

    _girlModulesAction=function(self,secs)


        require "modules.girl.girlAnimation"

        self.ScheduleId=U:setTimeoutUnsafe(function()

            Slot.girl_animation:girlModuleAction(self._slotManager,function()

                self:_girlModulesAction(math.random(20,200))

            end)


        end,secs)

    end,

    getCommonResources = function(self)
--        U:addSpriteFrameResource("plist/common/common.plist")
--        U:addSpriteFrameResource("plist/common/spinButton.plist")
--        U:addSpriteFrameResource("plist/common/violet.plist")
--        U:addSpriteFrameResource("plist/modules/girl/girl.plist")
--        U:addSpriteFrameResource("plist/modules/"..self._options.modulename.."/"..self._options.modulename..".plist")

        return {
            "plist/common/common.plist",
--            "plist/common/baseprofile_common.plist",
--            "plist/common/slotbar_common.plist",
            "plist/common/game_common.plist",

            "plist/common/violet_bar.plist",
            "plist/modules/girl/girl.plist",
            "plist/modules/girl/paytable.plist"
        }

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

            --            self.rootNode = cc.Sprite:create("modules/girl/bg.png")
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
            modulename = "girl",
            style = "violet",
            component = {1,2,3,4,5,6,7,8,9,10,50,100,200},
            spin = function(arg)

                self._slotManager:startSpin(arg)

            end,
            onExit = function(opt, that)


                Slot.DM:clearModuleData()
                --cc.TextureCache:getInstance():removeUnusedTextures()
                Slot.SpriteCacheManager:removeSpriteFrameByFile("plist/common/common.plist")
                Slot.SpriteCacheManager:removeSpriteFrameByFile("plist/common/violet_bar.plist")
                Slot.SpriteCacheManager:removeSpriteFrameByFile("plist/modules/girl/girl.plist")
                Slot.SpriteCacheManager:removeSpriteFrameByName("plist/common/paytable.plist")

                cc.Director:getInstance():getTextureCache():removeTextureForKey(self._options.bg)
                cc.Director:getInstance():getTextureCache():removeTextureForKey("image/modules/girl/logo.png")


                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(that.ScheduleId)
                Slot.Audio:stopMusic(true)
                Slot.Audio:unloadModuleEffect(Slot.MusicResources[self._options.modulename],self._options.modulename)
            end,

            inset=cc.rect(0,0,0,0),
            bg = "modules/girl/bg.png"
        })
    end

})

