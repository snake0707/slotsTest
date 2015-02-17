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

Slot.modules.HawaiiPage = Slot.pages.Page:extend({

    __className = "Slot.modules.HawaiiPage",

    initWithCode = function(self,options)
        Slot.DM:clearModuleData()
        self._data = Slot.DM:getReelData("hawaii",18) -- 18个轮子
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
        self.filePath="sound/modules/hawaii/"
--
         Slot.Audio:preloadMusic(self.filePath..Slot.MusicResources[self._options.modulename].hawaii)
--
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].hawaii_icon1)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].hawaii_icon2)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].hawaii_icon3)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].hawaii_wild)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].hawaii_bonus)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].hawaii_scatter)

        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].hawaii_spin)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].hawaii_reel_roll)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].hawaii_reel_stop)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].hawaii_expect)
--
--
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].hawaii_expect_reel1_stop)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].hawaii_expect_reel2_stop)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].hawaii_expect_reel3_stop)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].hawaii_expect_reel4_stop)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].hawaii_expect_reel5_stop)
--
        Slot.Audio:preloadMusic(self.filePath..Slot.MusicResources[self._options.modulename].hawaii_bgame_begin)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].hawaii_bgame_pick)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].hawaii_bgame_empty1)
        Slot.Audio:preloadEffect(self.filePath..Slot.MusicResources[self._options.modulename].hawaii_bgame_empty2)
        Slot.Audio:preloadMusic(self.filePath..Slot.MusicResources[self._options.modulename].hawaii_bgame_end)

    --这里只是为了测试 后面要分开 playEffect
    --Slot.Audio:playMusic(self.filePath..Slot.MusicResources[self._options.modulename].hawaii)
    --Slot.Audio:playEffect(self.filePath..Slot.MusicResources["common"].crowdcheers1)


    end,

    addContent   = function(self)


        local emptySize = self:getEmptySize()

        self._slotManager = Slot.ui.SlotManager:new({
            ccbFile = "ccbi/Hawaii.ccbi",
            component = self._options.component,
            pagePara = self._options.pagePara,
            frameWidth  = 72,
            frameHeight = 232,
            componentWidth = 72,
            componentHeight = 78,
            modulename = "hawaii",
            emptySize = emptySize,
            footheight=self:getFooterHeight(),

        })
--        self._slotManager:setPosition(cc.p(emptySize.width/2, emptySize.height/2))
--        self.content:getRootNode():addChild(self._slotManager:getRootNode())

        self.content:addChild(self._slotManager)

        self.yeziTab={}
        for i=1,3 do

            local yeziName="hawaii_yezi"..i
            local yeziSprite=self._slotManager.proxy:getNodeWithName(yeziName)
            table.insert(self.yeziTab,yeziSprite)

        end
       
        require "modules.hawaii.hawaiiAnimation"
        Slot.hawaii_animation:resertAllData()


        math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
        self:_hawaiiModulesAction(10)

        self:QAtest()

    end,

    QAtest=function(self)


        local QA_test=Slot.QAtest:new({profile=self.profile})

        print("type(QA_test):"..type(QA_test))
        self.content:addChild(QA_test.rootNode,10000)

        QA_test:setPosition(cc.p(0,0))

    end,

    _hawaiiModulesAction=function(self,secs)


        local yeziId=math.random(1,3)
        self.ScheduleId=U:setTimeoutUnsafe(function()


            Slot.hawaii_animation:hawaiiModuleAction(self.yeziTab,yeziId,function()

                self:_hawaiiModulesAction(math.random(20,200))
            end)


        end,secs)

    end,

    getCommonResources = function(self)
--        U:addSpriteFrameResource("plist/common/common.plist")
--        U:addSpriteFrameResource("plist/common/spinButton.plist")
--        U:addSpriteFrameResource("plist/common/orange.plist")
--        U:addSpriteFrameResource("plist/modules/hawaii/hawaii.plist")
--        U:addSpriteFrameResource("plist/modules/"..self._options.modulename.."/"..self._options.modulename..".plist")

        return {
            "plist/common/common.plist",
--            "plist/common/baseprofile_common.plist",
--            "plist/common/slotbar_common.plist",
            "plist/common/game_common.plist",

            "plist/common/orange_bar.plist",
            "plist/modules/hawaii/hawaii.plist",
            "plist/modules/hawaii/paytable.plist"
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

--            self.rootNode = cc.Sprite:create("modules/hawaii/bg.png")
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
            modulename = "hawaii",
            style = "orange",
            component = {1,2,3,4,5,6,7,8,9,10,50,100,200},
            spin = function(arg)

                self._slotManager:startSpin(arg)

            end,
            onExit = function(opt, that)


                Slot.DM:clearModuleData()

                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(that.ScheduleId)
                --cc.TextureCache:getInstance():removeUnusedTextures()
                --Slot.SpriteCacheManager:removeSpriteFrameByFile("plist/common/common.plist")
                Slot.SpriteCacheManager:removeSpriteFrameByFile("plist/common/orange_bar.plist")
                Slot.SpriteCacheManager:removeSpriteFrameByFile("plist/modules/hawaii/hawaii.plist")
                Slot.SpriteCacheManager:removeSpriteFrameByName("image/modules/hawaii/logo.png")
                Slot.SpriteCacheManager:removeSpriteFrameByName("plist/common/paytable.plist")

                cc.Director:getInstance():getTextureCache():removeTextureForKey(self._options.bg)
                cc.Director:getInstance():getTextureCache():removeTextureForKey("image/modules/hawaii/logo.png")

                Slot.Audio:stopMusic(true)
                Slot.Audio:unloadModuleEffect(Slot.MusicResources[self._options.modulename],self._options.modulename)
            end,

            inset=cc.rect(0,0,0,0),
            bg = "modules/hawaii/bg.png"
        })
    end

})

