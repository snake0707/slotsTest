

require "component.ui.SlotManager"
require "component.com.smallgames.HighNoon"

Slot = Slot or {}

Slot.modules = Slot.modules or {}

Slot.modules.HighNoonPage = Slot.pages.Page:extend({

    __className = "Slot.modules.HighNoonPage",

    initWithCode = function(self,options)

        self:_super(options)
        self:addContent()
    end,

    addContent   = function(self)


        local emptySize=self._winsize



        self._slotManager = Slot.com.HighNoon:new({
            pagePara = self._options.pagePara

        })

        self._slotManager:setPosition(cc.p(emptySize.width/2, emptySize.height/2))
        self.content:getRootNode():addChild(self._slotManager:getRootNode())




    end,

    getCommonResources = function(self)

--        U:addSpriteFrameResource("plist/modules/west/west.plist")

        return {
            "plist/modules/west/west.plist"
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

            modulename="west",
            onExit = function(opt, that)

                --cc.TextureCache:getInstance():removeUnusedTextures()
                Slot.SpriteCacheManager:removeSpriteFrameByFile("plist/modules/west/west.plist")
                Slot.Audio:stopMusic(true)
                Slot.Audio:stopAllEffects()
            end,


        })
    end

})

