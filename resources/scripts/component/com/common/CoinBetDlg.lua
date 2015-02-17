--
-- Created by IntelliJ IDEA.
-- User: bbf
-- Date: 14-12-2
-- Time: 下午9:49
-- To change this template use File | Settings | File Templates.
--


require "component.ui.CCBDialog"
Slot.com = Slot.com or {}
Slot.com.CoinBetDialog = Slot.ui.CCBDialog:extend({
    __className = "Slot.com.CoinBetDialog",

    initWithCode = function(self, options)
        self:_super(options)

    end,

    _setup = function(self)

        self.title = self.proxy:getNodeWithName("title_text")
        self.win_title = self.proxy:getNodeWithName("win_title")
        self.bonus_text = self.proxy:getNodeWithName("bonus_text")
        self.level_fator_text = self.proxy:getNodeWithName("level_factor_text")
        self.total_win_text = self.proxy:getNodeWithName("total_win_text")

        self.bonus_num = self.proxy:getNodeWithName("bonus_num")
        self.level_factor = self.proxy:getNodeWithName("level_factor")
        self.total_win = self.proxy:getNodeWithName("total_win")
        self.ok_btn = self.proxy:getNodeWithName("ok_btn")

        self.share_layer = self.proxy:getNodeWithName("share_layer")
        self.share_circle = self.proxy:getNodeWithName("share_circle")
        self.share_gou = self.proxy:getNodeWithName("share_gou")
        self.share_text = self.proxy:getNodeWithName("share_text")


        if self._options.type == "collect" then
            self._shareFlag = false
            self.level_fator_text:setString("LEVEL BONUS")
        else
            self.level_fator_text:setString("BET RATE")
        end


        local profile=Slot.DM:getBaseProfile()

        if self._options.share_text then
            self._shareFlag = true
            self.share_layer:setVisible(true)
        else
            self._shareFlag = false
            self.share_layer:setVisible(false)
        end


        self:_initAward()
    end,

    _initAward = function(self)

        local bonusNum=U:formatNumber(self._options.bonus_num)

        local total_win=U:formatNumber(self._options.total_bonus)
        self.bonus_num:setString(bonusNum)
        self.level_factor:setString(tostring(self._options.level_factor))
        self.total_win:setString(total_win)

        U:setTitle(self.ok_btn, U:locale("common","Ok"), "fnt", "font/common/gre.fnt", cc.CONTROL_STATE_NORMAL)


    end,
    open=function(self)

        self:_super()
        Slot.Audio:playEffect("sound/common/"..Slot.MusicResources["common"]["crowdcheers1"])
    end,

    _registEvent = function(self)
        self:_super()

        self.proxy:handleButtonEvent(self.ok_btn, function()
            print("click ok_btn")
            self:close()
        end, self._options.priority-1)

        self.proxy:handleButtonEvent(self.share_layer, function()
            print("click share_layer")
            self._shareFlag = not self._shareFlag

            self.share_gou:setVisible(self._shareFlag)
--            if self._shareFlag then
--                self.share_gou:setVisible(true)
--            else
--                self.share_gou:setVisible(false)
--            end
        end, self._options.priority-1)
    end,

    close = function(self)

        if self._shareFlag and Slot.Configuration.DEBUG == "false" then

            print("is sharing=====")
            local parm = {}
            if self._options.type == "bet" then
                parm = {
                    name = U:locale("share", "bonus_name"),
                    caption = U:locale("share", "bonus_caption"),
                    description = U:locale("share", "bonus_description", {coin = self._options.total_bonus}),
                    link = Slot.shareLink,
                    picture = Slot.shareIcon,
                }
            end

            cc.OASSdk:getInstance():share(parm)

        end

        self:_super()

    end,

    getDefaultOptions = function(self)

        return U:extend(false, self:_super(), {
            ccbi = "ccbi/CoinBetDlg.ccbi",
            priority = Slot.TouchPriority.dialog,
            type = "collect",
            resources = {
                "common/dlg_title_bg.png",
                "common/content_bg.png"
            }
--            share_text = "",
        })
    end,
})

