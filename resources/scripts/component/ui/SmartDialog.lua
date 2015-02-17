
--
-- by bbf
--
Slot = Slot or {}

Slot.ui = Slot.ui or {}

Slot.ui.SmartDialog = Slot.ui.TitleBoard:extend({
    __className = "Slot.ui.SmartDialog",

    initWithCode = function(self, options)
        self:_super(options)
    end,

    createContent = function(self)
        self:_super()
    end,

    _createOverlay = function(self)
        local scene = cc.Director:getInstance():getRunningScene()

        local winsize = cc.Director:getInstance():getWinSize()
        self.overlay = cc.LayerColor:create(cc.c4b(0,0,0,200), winsize.width, winsize.height)
        local onTouch = function(eventType, x, y)
            if eventType == "began" then
                local box = self.rootNode:getBoundingBox()
                if not cc.rectContainsPoint(box, cc.p(x,y)) then        --box:containsPoint(cc.p(x,y))
                    self:_removeOverlay()
                end
                return true
            end
        end
        scene:addChild(self.overlay, Slot.ZIndex.showWait)
        self.overlay:registerScriptTouchHandler(onTouch, false, -10, true)
        self.overlay:setTouchEnabled(true)
    end,

    _removeOverlay = function(self)
        self.overlay:removeFromParent(true)
        self.overlay = nil
    end,

    open = function(self)
        self:_createOverlay()

        U:addToCenter(self.rootNode, self.overlay)

        --添加音乐
        --Slot.Audio:playEffect("sound/common/"..Slot.MusicResources["common"].windowshow)

    end,

    close = function(self)
        self:_removeOverlay()

    --添加音乐
    --Slot.Audio:playEffect("sound/common/"..Slot.MusicResources["common"].windowback)
    end,
})