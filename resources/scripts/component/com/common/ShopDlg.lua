--
-- Created by IntelliJ IDEA.
-- User: xiaofuan
-- Date: 15-1-6
-- Time: 下午3:36
-- To change this template use File | Settings | File Templates.
--

require "component.ui.CCBDialog"
Slot.com = Slot.com or {}
Slot.com.ShopDialog = Slot.ui.CCBDialog:extend({
    __className = "Slot.com.ShopDialog",

    initWithCode = function(self, options)
        self:_super(options)

    end,

    _setup = function(self)

        local shop_data = Slot.DM:getCommonDataByKey("shop")
        for i, v in pairs(shop_data) do

            self["orgin_buy_coin_"..i] = self.proxy:getNodeWithName("orgin_buy_coin_"..i)
            self["percent_text_"..i] = self.proxy:getNodeWithName("percent_text_"..i)
            self["buy_coin_"..i] = self.proxy:getNodeWithName("buy_coin_"..i)
            self["buy_btn_"..i] = self.proxy:getNodeWithName("buy_btn_"..i)
            local btn_bg = self.proxy:getNodeWithName("button_bg_layer"..i)


            local baseCoinStr=U:formatNumber(tostring(v.basecoins))
            self["orgin_buy_coin_"..i]:setString(baseCoinStr)

                U:setTitle(self["buy_btn_"..i], v.price, "fnt", "font/common/buyNum.fnt", cc.CONTROL_STATE_NORMAL)

--            local per = Slot.DM:getLocalStorage(v.basecoins.."_bonus_times")

            local heaprecharge = Slot.DM:getHeapRecharge()


            if not next(heaprecharge) then
                self["percent_text_"..i]:setString(v.firstbonus.."%")

                local CoinStr=U:formatNumber(tostring(v.basecoins * (1 + v.firstbonus/100)))

                
                self["buy_coin_"..i]:setString(CoinStr)
--                Slot.DM:setLocalStorage(v.basecoins.."_first_bonus", 0)
            else
                self["percent_text_"..i]:setString(v.bonus.."%")

                self["buy_coin_"..i]:setString(U:formatNumber(v.basecoins * (1 + v.bonus/100)))
            end

--            self.proxy:handleButtonEvent(btn_bg,function()
--
--
--            end,Slot.TouchPriority.dialog_list_item,false)

            self.proxy:handleButtonEvent(self["buy_btn_"..i],function()

                U:debug("click buy_btn_"..i)
                local profile = Slot.DM:getBaseProfile()
                if Slot.Configuration.DEBUG == "false" then

                    self:close()

                    cc.OASSdk:getInstance():registerHandler(Slot.SdkType.PAY, function(data)

                        cc.OASSdk:getInstance():unregisterHandler(Slot.SdkType.PAY)

                        if tonumber(data) == 1 then
                            Slot.DM:sync(function(profile) end)
                        else
                            self.msgDlg = Slot.com.MessageDialog:new({
                                title   = U:locale("common", "pay_fail_dlg_title"),
                                message = U:locale("common", "pay_fail_dlg_content"),
                                ccbi = "ccbi/SmallDlg.ccbi",
                                overlayClick = false,
                                midText = U:locale("common", "Ok"),

                                midBtn = {

                                    normal = "green_long_btn.png",
                                    hightLight = "green_long_btn.png",
                                    selected = "green_long_btn.png",
                                    disabled = "green_long_btn.png",

                                },

                                midBtnClick = function(opt)
                                    opt.afterClose = function(that)
                                        self.msgDlg = nil
                                    end

                                    self.msgDlg:close()

                                end,
                            })
                            self.msgDlg:open()
                        end

                    end, nil, false)
                    U:debug(v.productID)
                    U:debug(v.price)
                    U:debug(v.productID)
                    cc.OASSdk:getInstance():pay(v.productID, v.price * 100, "1", ""..profile.player_id, "")

                end


            end)



        end
        self:_super()

        self:_registEvent()
    end,


    _registEvent = function(self)

        self:_super()



    end,

    open = function(self)

        self:_super()
        Slot.Audio:playEffect("sound/common/"..Slot.MusicResources["common"].shop_show)

    end,

    getDefaultOptions = function(self)

        return U:extend(false, self:_super(), {
            ccbi = "ccbi/ShopDlg.ccbi",
            priority = Slot.TouchPriority.dialog,
            showClose = true,
            --            share_text = "",
            isShopDlg=true,
            resources = {
                "common/titleboard_bg.png",
                "common/content_bg.png",
            }
        })
    end,
})

