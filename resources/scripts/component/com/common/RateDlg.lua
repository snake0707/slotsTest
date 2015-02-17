--
-- Created by IntelliJ IDEA.
-- User: xiaofuan
-- Date: 15-1-6
-- Time: 下午3:36
-- To change this template use File | Settings | File Templates.
--

require "component.ui.CCBDialog"
Slot.com = Slot.com or {}
Slot.com.RateDialog = Slot.ui.CCBDialog:extend({
    __className = "Slot.com.RateDialog",

    initWithCode = function(self, options)
        self:_super(options)

    end,

    _setup = function(self)

        self:_super()


        self.rate_tips = self.proxy:getNodeWithName("rate_tips")
        self.rate_btn = self.proxy:getNodeWithName("rate_btn")

        self.rate_tips:setString(U:locale("common", "rate_tips"))

    end,

    _registEvent = function(self)

        self.proxy:handleButtonEvent(self.rate_btn, function()
            print("click rate_btn")

            cc.LeverUtils:getInstance():openUrl("http://www.baidu.com") --todo::
            Slot.DM:setLocalStorage("has_rate", 1)
            self:close()
        end)

        self:_super()

    end,

    getDefaultOptions = function(self)

        return U:extend(false, self:_super(), {
            ccbi = "ccbi/RateDlg.ccbi",
            priority = Slot.TouchPriority.dialog,
            resources = {
                "common/rate_dlg_bg.png",
            }

        })
    end,
})

