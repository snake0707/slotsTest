--
-- Created by IntelliJ IDEA.
-- User: xiaofuan
-- Date: 15-1-10
-- Time: 下午5:44
-- To change this template use File | Settings | File Templates.
--

--
-- Created by IntelliJ IDEA.
-- User: xiaofuan
-- Date: 15-1-6
-- Time: 下午3:36
-- To change this template use File | Settings | File Templates.
--

Slot.com = Slot.com or {}
Slot.com.ToastDialog = Slot.ui.CCBDialog:extend({
    __className = "Slot.com.ToastDialog",

    initWithCode = function(self, options)

        self:_super(options)

    end,

    _setup = function(self)

        self.title_text = self.proxy:getNodeWithName("title_text")
        self.title_node = self.proxy:getNodeWithName("title_node")
        self.content_node = self.proxy:getNodeWithName("content_node")
        --        self.ok_btn = self.proxy:getNodeWithName("ok_btn")

        self:_initContent()

        self:_registEvent()

        self:resize()

        self:_super()


    end,

    _initContent = function(self)

        self.title_text:setString(self._options.title)

        self.wait = cc.Sprite:create("common/wait_icon.png")
--        self.wait =U:getSpriteByName("wait_icon.png")

        local size = self.content_node:getContentSize()
        self.wait:setAnchorPoint(cc.p(0.5, 0.5))
        self.wait:setPosition(cc.p(size.width/2, size.height/6))
        self.content_node:addChild(self.wait)

        self.wait:runAction(cc.RepeatForever:create(cc.RotateBy:create(2, 360)))

    end,

    _registEvent = function(self)


    end,

    resize = function(self)

    end,

--    close = function(self)
--
--        if self.wait then
--            --self.wait:stopAllActions()
--            self.wait:removeFromParent()
--            self:_super()
--
--        end
--
--    end,

    getDefaultOptions = function(self)

        return U:extend(false, self:_super(), {
            ccbi = "ccbi/SmallDlg.ccbi",
            priority = Slot.TouchPriority.dialog,
            showClose = false,
            title = U:locale("common", "wait_for_network"),
            overlaycolor = Slot.CCC4.white,
            overlayClick = false,
            resources = {
                "common/dlg_title_bg.png",
                "common/content_bg.png"
            }

        })
    end,
})

