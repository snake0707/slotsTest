

require "component.ui.SlotManager"
require "component.com.smallgames.HawaiiParadise"

Slot = Slot or {}

Slot.modules = Slot.modules or {}

Slot.modules.HawaiiParadisePage = Slot.pages.Page:extend({

    __className = "Slot.modules.HawaiiParadisePage",

    initWithCode = function(self,options)

        self:_super(options)
        self:addContent()
    end,

    addContent   = function(self)
    --        self.version = cc.LabelTTF:create("欢迎来到Slots,这是一个主题页面",Slot.Font.default,20)
    --        self.version:setAnchorPoint(cc.p(0.5,0))
    --        self.version:setPosition(cc.p(self._winsize.width/2,self._winsize.height/2))
    --        self.version:setColor(Slot.CCC3.black)
    --        self:getRootNode():addChild(self.version)
    --
    --        self.tip = cc.LabelTTF:create("点击主题进入对应游戏",Slot.Font.default,20)
    --        self.tip:setColor(Slot.CCC3.black)
    --        self.tip:setPosition(cc.p(self._winsize.width/2,40))
    --        self.rootNode:addChild(self.tip,1)


        local emptySize = self.content:getContentSize()


        self._slotManager = Slot.com.HawaiiParadise:new({
            pagePara = self._options.pagePara

        })
        self._slotManager:setPosition(cc.p(emptySize.width/2, emptySize.height/2))
        self.content:getRootNode():addChild(self._slotManager:getRootNode())

    end,

    getCommonResources = function(self)

--        U:addSpriteFrameResource("plist/modules/hawaii/hawaii.plist")

        return {
            "plist/modules/hawaii/hawaii.plist"
        }

    end,

    getRootNode = function(self)
        if not self.rootNode then
            self.rootNode = cc.Node:create()
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
            --baseProfile    = true,
            -- slottoolbar    = true,
            bodyFullScene = true,
            modulename="hawaii",
            onExit = function(opt, that)

                --cc.TextureCache:getInstance():removeUnusedTextures()
                Slot.SpriteCacheManager:removeSpriteFrameByFile("plist/modules/hawaii/hawaii.plist")
                Slot.Audio:stopMusic(true)
                Slot.Audio:stopAllEffects()
            end,

        })
    end

})

