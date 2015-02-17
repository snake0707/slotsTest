--
-- Created by IntelliJ IDEA.
-- User: xiaofuan
-- Date: 15-1-6
-- Time: 下午3:36
-- To change this template use File | Settings | File Templates.
--

require "component.ui.CCBDialog"
Slot.com = Slot.com or {}
Slot.com.FirstShopDialog = Slot.ui.CCBDialog:extend({
    __className = "Slot.com.FirstShopDialog",

    initWithCode = function(self, options)
        self:_super(options)

    end,

    _setup = function(self)

        self:_super()

        self.title_text = self.proxy:getNodeWithName("title_text")
        self.tips_text = self.proxy:getNodeWithName("tips_text")
        self.content_text = self.proxy:getNodeWithName("content_text")
        self.ok_btn = self.proxy:getNodeWithName("ok_btn")

        self.title_text:setString(U:locale("common", "first_shop_dlg_title"))
        self.tips_text:setString(U:locale("common", "first_shop_dlg_tips"))
        self.content_text:setString(U:locale("common", "first_shop_dlg_content_text"))

        U:setTitle(self.ok_btn, U:locale("common","Ok"), "fnt", "font/common/gre.fnt", cc.CONTROL_STATE_NORMAL)

    end,

    _registEvent = function(self)

        self.proxy:handleButtonEvent(self.ok_btn, function()
            print("click rate_btn")

            self:close()

        end)

        self:_super()

    end,

    getDefaultOptions = function(self)

        return U:extend(false, self:_super(), {
            ccbi = "ccbi/FirstShopDlg.ccbi",
            priority = Slot.TouchPriority.dialog,
            resources = {
                "common/dlg_title_bg.png",
                "common/content_bg.png"
            }

        })
    end,
})

