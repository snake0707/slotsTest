--
-- Created by IntelliJ IDEA.
-- User: xiaofuan
-- Date: 15-1-4
-- Time: 下午4:47
-- To change this template use File | Settings | File Templates.
--

Slot = Slot or {}

Slot.Error = {

    ERR_SERVER_INTERNAL = 50001,
    ERR_MOD_NOT_FOUND = 50002,
    ERR_ACTION_NOT_SUPPORTED = 50003,
    ERR_MSG_NOT_SIGNED = 50004,
    ERR_TOKEN_EXPIRED = 50005,
    ERR_TOKEN_INVALID = 50006,
    ERR_REQ_ERROR = 50009,
    ERR_TOKEN_MISMATCH = 50013,

    ERR_PLAYER_NOT_EXIST = 10001,
    ERR_PLAYER_AUTH_FAILED = 10003,

    ERR_SLOTCHECK_EXP_NOT_MATCH = 30001,
    ERR_SLOTCHECK_LEVEL_NOT_MATCH = 30002,
    ERR_SLOTCHECK_RANDOM_NOT_MATCH = 30003,
    ERR_SLOTCHECK_RANDOM_NOT_MATCH = 30004,
    ERR_SLOTCHECK_COIN_NOT_MATCH = 30005,

    ERR_NOT_ENOUGH_COIN = 20001,

    NETWORK_STATUS_ERROR = 1,


    ERR_GAME_RANDOM_NOT_MATCH = 80001,
    ERR_GAME_AWARD_NOT_MATCH = 80002,
    ERR_GAME_NOT_CORRECT = 80003,


    -- collect coins
    ERR_COLLECT_COINS_TIME = 40001,
    ERR_COLLECT_COINS_NOT_COINS = 40002,


    --debug
    ERR_DEBUG = 60001,


    -- shop
    ERR_PROFUCT_NOT_FOUND = 70001,

--    MULTI_LOGIN = -1,

    ERR_CONFIG = -1000000

}


Slot.Error.openDlg = function(self, rc, click)

    local t = ""
    local m = ""
    local ccbi
    local leftText
    local rightText
    local rightBtn
    local midText
    local midBtn
    local leftBtnClick = function() end
    local rightBtnClick = function() end
    local midBtnClick = function() end

    if rc == Slot.Error.ERR_NOT_ENOUGH_COIN then

        t = U:locale("common", "no_enough_coin_title")
        m = U:locale("common", "no_enough_coin_message")
        leftText = U:locale("common", "Shop")
        rightText = U:locale("common", "Ok")

        leftBtnClick = function()

            opt.afterClose = function(that)

                local heaprecharge = Slot.DM:getHeapRecharge()
                if not next(heaprecharge) then

                    self.first_shop_dlg = Slot.com.FirstShopDialog:new({

                        afterClose = function(self)

                            self.dlg = Slot.com.ShopDialog:new()
                            self.dlg:open()

                        end
                    })
                    self.first_shop_dlg:open()
                else

                    self.dlg = Slot.com.ShopDialog:new()
                    self.dlg:open()

                end

            end

        end

        rightBtn = {

            normal = "green_common_btn.png",
            hightLight = "green_common_btn.png",
            selected = "green_common_btn.png",
            disabled = "green_common_btn.png",

        }


    elseif  rc == Slot.Error.ERR_SLOTCHECK_EXP_NOT_MATCH or
            rc == Slot.Error.ERR_SLOTCHECK_LEVEL_NOT_MATCH or
            rc == Slot.Error.ERR_SLOTCHECK_RANDOM_NOT_MATCH or
            rc == Slot.Error.ERR_SLOTCHECK_RANDOM_NOT_MATCH or
            rc == Slot.Error.ERR_SLOTCHECK_COIN_NOT_MATCH or

            rc == Slot.Error.ERR_GAME_RANDOM_NOT_MATCH or
            rc == Slot.Error.ERR_GAME_AWARD_NOT_MATCH or
            rc == Slot.Error.ERR_GAME_NOT_CORRECT or
            rc == Slot.Error.ERR_COLLECT_COINS_NOT_COINS or
            rc == Slot.Error.ERR_COLLECT_COINS_TIME
    then

        t = U:locale("common", "wrong_data_title")
        m = U:locale("common", "wrong_data_message")
--        ccbi = "ccbi/SmallDlg.ccbi"
        midText = U:locale("common", "Restart")
        midBtnClick = function()
            opt.afterClose = function(that)
                Slot.App:load()
            end
        end

    elseif rc == Slot.Error.ERR_PLAYER_AUTH_FAILED then

        t = U:locale("common", "player_auth_error_title")
        m = U:locale("common", "player_auth_error_message")
        ccbi = "ccbi/SmallDlg.ccbi"
        midText = U:locale("common", "Restart")
        midBtnClick = function()
            opt.afterClose = function(that)
                Slot.App:load()
            end
        end

    elseif rc == Slot.Error.ERR_PLAYER_NOT_EXIST then

        t = U:locale("common", "player_exist_error_title")
        m = U:locale("common", "player_exist_error_message")
        ccbi = "ccbi/SmallDlg.ccbi"
        midText = U:locale("common", "Restart")
        midBtnClick = function()
            opt.afterClose = function(that)
                Slot.App:load()
            end
        end

    elseif rc == Slot.Error.NETWORK_STATUS_ERROR then

        t = U:locale("common", "network_delay_title")
        m = U:locale("common", "network_delay_message")
        leftText = U:locale("common", "Wait")
        rightText = U:locale("common", "Restart")

        rightBtnClick = function()
            opt.afterClose = function(that)
                Slot.App:load()
            end
        end

    elseif rc == Slot.Error.ERR_TOKEN_MISMATCH then

        t = U:locale("common", "multi_login_title")
        m = U:locale("common", "multi_login_message")
        midText = U:locale("common", "Ok")
        midBtnClick = function()
            opt.afterClose = function(that)
                Slot.App:load()
            end
        end

    else

        t = U:locale("common", "system_error_title")
        m = U:locale("common", "system_error_message")
        ccbi = "ccbi/SmallDlg.ccbi"
        midText = U:locale("common", "Restart")
        midBtnClick = function()
            opt.afterClose = function(that)
                Slot.App:load()
            end
        end

    end

    if self.msgDlg then return end

    self.msgDlg = Slot.com.MessageDialog:new({
        title   = t,
        message = m,
        ccbi = ccbi or "ccbi/LargeDlg.ccbi",
        overlayClick = false,
        leftText = leftText,

        leftBtnClick = function(opt)
            U:debug("for game update5555555=====================================")
            leftBtnClick()

            if click and type(click.left) == "function" then
                click.left()

            end
            self.msgDlg:close()

            self.msgDlg = nil




        end,

        rightText = rightText,

        rightBtn = rightBtn or {

            normal = "green_long_btn.png",
            hightLight = "green_long_btn.png",
            selected = "green_long_btn.png",
            disabled = "green_long_btn.png",

        },

        rightBtnClick = function(opt)


            rightBtnClick()

            if click and type(click.right) == "function" then

                click.right()

            end

            self.msgDlg:close()

            self.msgDlg = nil

        end,

        midText = midText,

        midBtn = midBtn or {

            normal = "green_long_btn.png",
            hightLight = "green_long_btn.png",
            selected = "green_long_btn.png",
            disabled = "green_long_btn.png",

        },

        midBtnClick = function(opt)

            midBtnClick()

            if click and type(click.mid) == "function" then

                click.mid()

            end

            self.msgDlg:close()

            self.msgDlg = nil

        end,

    })
    self.msgDlg:open()
    
end

