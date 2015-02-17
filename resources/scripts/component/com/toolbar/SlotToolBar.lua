

Slot = Slot or {}

Slot.com = Slot.com or {}

Slot.com.SlotToolBar = Slot.ui.UIComponent:extend({
    __className = "Slot.com.SlotToolBar",

    initWithCode = function(self, options)
        self:_super(options)

        self._totalBet = {}
        self:_setup()
        self:_initdata()

        self.spinFlag = false
    end,

    _setup = function(self)

        self.pay_table_btn = Slot.ui.Button:new({
            bg = self._options.pay_table_btn,
            touchPriority = self._options.priority,
            native = true,
            click = function(that)
                U:debug("click pay_table_Btn")

                self.paytable_dlg = Slot.com.PaytableDlg:new({
--                    title   = "PAYTABLE",
                    component = self._options.component,
                    paytable = self._options.paytable,
                    payTableOne = self._options.payTableOne,
                    modulename = self._options.modulename,
                })

--                self.paytable_dlg = Slot.ui.Dialog:new({
--                    title   = "PAYTABLE",
--                    content = self.paytable_content,
--                })
                self.paytable_dlg:open(true)


            end,
            disableClick = function(that) end,
        })

        self.max_bet_btn = Slot.ui.Button:new({
            bg = self._options.max_bet_btn,
            touchPriority = self._options.priority,
            native = true,
            click = function(that)
                U:debug("click max_bet_Btn")
                local profile = Slot.DM:getBaseProfile()

                local level = profile.level
                if profile.level > #self.commondata["levelup_data"] then level = #self.commondata["levelup_data"] end
                local maxbet =  tonumber(self.commondata["levelup_data"][level]["bet"])


                if profile.coin - maxbet * #(self.reeldata.lines) < 0 then

                    self.msgDlg   = Slot.com.MessageDialog:new({
                        title   = U:locale("common", "no_enough_coin_title"),
                        message = U:locale("common", "no_enough_coin_message"),

                        leftText = U:locale("common","Shop"),

                        leftBtn = {
                            normal = "ok_btn.png",
                            hightLight = "ok_btn.png",
                            selected = "ok_btn.png",
                            disabled = "ok_btn.png",
                        },

                        leftBtnClick = function(opt)

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

                            self.msgDlg :close()

                        end,

                        rightText = U:locale("common","Ok"),

                        rightBtn = {

                            normal = "ok_btn.png",
                            hightLight = "ok_btn.png",
                            selected = "ok_btn.png",
                            disabled = "ok_btn.png",

                        },

                        rightBtnClick = function(opt)

                            self.msgDlg :close()

                        end,

                    })
                    self.msgDlg :open()

                    return

                end

                if not self.spinFlag then
                    self:setAllEnabled(false)
                    if type(self._options.spin) == "function" then


                        self:setTotalBet(maxbet)

                        self:fireEvent("start_spin", {
                            totalbet = maxbet * #(self.reeldata.lines),
                            pos=cc.p(self.max_bet_btn:getPosition()),
                            parentNode=self.max_bet_btn:getParent()
                        })

                        self._options.spin(
                            {
                                bet = maxbet,
                                profile = profile
                            })
                    end
                    self.spinFlag = true
                end

            end,
            disableClick = function(self) end,
        })

        self.left_node = U:layerWithChildrenVertical({self.pay_table_btn, self.max_bet_btn}, Slot.Height.margin_top)
--        self.left_node:setAnchorPoint(cc.p(0,0))

        self.total_bet_btn = Slot.ui.Button:new({
            bg = self._options.total_bet_btn,
            touchPriority = self._options.priority,
            native = true,
            click = function(that)
                U:debug("click total_bet_btn")
                if not self._smartlist then
                    self:_createTotalbetList()
                    return
                end

                self._smartlist:close()
                self._smartlist=nil
            end,
            disableClick = function(that) end,
        })

        --self.total_bet_text = cc.LabelTTF:create("0", Slot.Font.default, 60)

        self.total_bet_text=cc.LabelBMFont:create("","font/common/totalBetNum.fnt")

       --self.total_bet_text:getTexture():setAliasTexParameters()

        self.total_bet_bg = U:getSpriteByName(self._options.total_bet_bg)

        local bet_bg_size = self.total_bet_bg:getContentSize()
        self.total_bet_text:setAnchorPoint(cc.p(0.5, 0.5))


        self.total_bet_text:setPosition(cc.p(bet_bg_size.width/2, bet_bg_size.height /2))

        self.total_bet_btn:setAnchorPoint(cc.p(0.5,0))
        self.total_bet_btn:setPosition(cc.p(bet_bg_size.width/2, Slot.Offset.totolbelbtn["shadow"]))

        self.total_bet_bg:addChild(self.total_bet_text)
        self.total_bet_bg:addChild(self.total_bet_btn:getRootNode())

        local sc = Slot.ui.ScriptControl:new()
        sc:getRootNode():setContentSize(cc.size(bet_bg_size.width, bet_bg_size.height - self.total_bet_btn:getContentSize().height))
        sc:getRootNode():setAnchorPoint(cc.p(0, 1))
        sc:getRootNode():setPosition(cc.p(0,bet_bg_size.height))
        self.total_bet_bg:addChild(sc:getRootNode())
        sc:bind("click",function()
            U:debug("click total_bet_btn")
            if not self.spinFlag and not self._smartlist then

                self:_createTotalbetList()
                return
            end

            if self._smartlist then
                self._smartlist:close()
                self._smartlist=nil
            end

        end)


        self.win = U:getSpriteByName(self._options.win_icon)

        self.win_text=cc.LabelBMFont:create("0","font/common/win_SlotToll.fnt")



        self.win_text:setPosition(cc.p(self.win:getContentSize().width/2, self.win:getContentSize().height/3))
        self.win:addChild(self.win_text)

        self.spin_btn = Slot.ui.Button:new({
            bg = self._options.spin_btn,
            touchPriority = self._options.priority,
            native = true,
            fontSize = 100,
            click = function(that)
                print("click spin_btn")
                local profile = Slot.DM:getBaseProfile()
                if profile.coin - self.totalbet < 0 then

                    self.msgDlg   = Slot.com.MessageDialog:new({
                        title   = U:locale("common", "no_enough_coin_title"),
                        message = U:locale("common", "no_enough_coin_message"),

                        leftText = U:locale("common","Shop"),

                        leftBtn = {
                            normal = "ok_btn.png",
                            hightLight = "ok_btn.png",
                            selected = "ok_btn.png",
                            disabled = "ok_btn.png",
                        },

                        leftBtnClick = function(opt)

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

                            self.msgDlg :close()

                        end,

                        rightText = U:locale("common","Ok"),

                        rightBtn = {

                            normal = "ok_btn.png",
                            hightLight = "ok_btn.png",
                            selected = "ok_btn.png",
                            disabled = "ok_btn.png",

                        },

                        rightBtnClick = function(opt)

                            self.msgDlg :close()

                        end,

                    })
                    self.msgDlg :open()

                    return

                end

                if not self.spinFlag then

                    self:setAllEnabled(false)
                    if type(self._options.spin) == "function" then

                        --这里
                        --add 11.29
                        self:fireEvent("start_spin", {
                            totalbet = self.totalbet,
                            --totalbet=self._options.testExp, test ok
                            pos=cc.p(self.spin_btn:getPosition()),
                            parentNode=self.spin_btn:getParent()
                        })

                        --self._options.spin({bet = self.bet})

                        --test
                        self._options.spin(
                            {
                                bet = self.bet,
                                profile = profile
                            })
                    end
                    self.spinFlag = true
                end
            end,
            disableClick = function(that) end,
        })

        U:addToVCenter(self.left_node, self._content, nil, nil, Slot.Offset.slottoolbar.shadow)
        U:addToVCenter(self.total_bet_bg, self._content, nil, nil, Slot.Offset.slottoolbar.shadow, 1)
        U:addToVCenter(self.win, self._content, nil, nil,  Slot.Offset.slottoolbar.shadow)
        U:addToVCenter(self.spin_btn, self._content, nil, nil,  Slot.Offset.slottoolbar.shadow)

        U:reLayoutHoriztal(self._content, nil, true)

        --[[事件]]--

        self._onSlotToolBarUpdate=function(data)
            if self.win_text then
                self.win_text:setString(data.win)
            end
        end

        Slot.DM:onUpdate("slotbar",self._onSlotToolBarUpdate)

        self:onEvent("close_All",function(e)

            if self._smartlist  then

                local size=self._smartlist:getContentSize()
                local rect=cc.rect(0,0,size.width,size.height)
                if not cc.rectContainsPoint(rect,  self._smartlist.rootNode:convertToNodeSpace(e.attach.pos)) then
                    self._smartlist:close()
                    self._smartlist=nil

                end
            end

        end)

        self:onEvent("start_spin",function(e)

            local slotbar = Slot.DM:getSlotBarData()
            slotbar.win = 0

            Slot.DM:setSlotBarData(slotbar)
        end)

        self:onEvent("stop_spin",function(e)
            self:setAllEnabled(true)
            self.spinFlag = false
        end)


        self:onEvent("free_spin",function(e)
            self:setAllEnabled(false)
            self.spinFlag = true
            if self._options.style == "violet" then
                U:addSpriteFrameResource("plist/common/violet_bar.plist")
            else
                U:addSpriteFrameResource("plist/common/orange_bar.plist")
            end

            self.spin_btn:setBgInFrame(self._options.freeSpin_btn_bg, cc.CONTROL_STATE_DISABLED)


            --add 1.12
            self.spin_btn:setTitle(e.attach.num, cc.CONTROL_STATE_DISABLED,"fnt",self._options.freeSpinFont)

            local slotbar = Slot.DM:getSlotBarData()
            slotbar.win = e.attach.win

            Slot.DM:setSlotBarData(slotbar)

        end)

        self:onEvent("free_spin_stop",function(e)


            self:setAllEnabled(true)
            self.spinFlag = false
            if self._options.style == "violet" then
                U:addSpriteFrameResource("plist/common/violet_bar.plist")
            else
                U:addSpriteFrameResource("plist/common/orange_bar.plist")
            end

            self.spin_btn:setBgInFrame(self._options.spin_btn.disabled, cc.CONTROL_STATE_DISABLED)
            self.spin_btn:setTitle("", cc.CONTROL_STATE_DISABLED,"fnt",self._options.freeSpinFont)
            self.spin_btn:setTitle("")

        end)

    end,

    _initdata = function(self)
        self.bet = Slot.DM:getLocalStorage(self._options.modulename.."bet")
        local profile = Slot.DM:getBaseProfile()
        self.commondata = Slot.DM:getCommonData()
        local level = profile.level
        if profile.level > #self.commondata["levelup_data"] then level = #self.commondata["levelup_data"] end
        local maxbet =  tonumber(self.commondata["levelup_data"][level]["bet"])

        if not self.bet or tonumber(self.bet) > maxbet then
            self.bet = Slot.Bet[#Slot.Bet]
            Slot.DM:setLocalStorage(self._options.modulename.."bet", self.bet)
        end

        self.reeldata =  Slot.DM:getCurrentReelData()
        self.totalbet = self.bet * #(self.reeldata.lines)
        self.total_bet_text:setString(""..self.totalbet)

        self.win_text:setString(0)
        if self._options.win then

            self.win_text:setString(self._options.win)

        end



    end,

    _createTotalbetList = function(self)

        local sprite = U:getSpriteByName(self._options.total_bet_list_btn.normal)
        local size = sprite:getContentSize()

        self._smartlist = Slot.ui.SmartList:new(Slot.Bet,{
            bg = "total_bet_bg.png",
            frameWidth =  size.width,
            frameHeight =  size.height*3,
            onItemClick = function(opt,index,target,x,y)
                if target and U:isUI(target) then target=target:getRootNode() end
                if type(target.isEnabled)~= "function" or target:isEnabled() then
                    self._smartlist:close()
                    self._smartlist=nil
                    self:setTotalBet(Slot.Bet[index])
                end

            end,
            cellAtIndex = function(opt, data, index, _list)
                return self:_createTotalBetBtn(data)
            end,
            createHeader = function(opt)
                local header_btn = Slot.ui.Button:new({
                    bg = self._options.total_bet_up_btn,
                    touchPriority = Slot.TouchPriority.dialog_list_item,
                    swallow = true,
                    title = "",
                    click = function(that)
                        self._smartlist._list:scrollToNext(true)
                    end,
                })
                return header_btn
            end,
            createFooter = function(opt)
                local footer_btn = Slot.ui.Button:new({
                    bg = self._options.total_bet_down_btn,
                    touchPriority = Slot.TouchPriority.dialog_list_item,
                    swallow = true,
                    title = "",
                    click = function(that)
                        self._smartlist._list:scrollToNext(false)
                    end,
                })
                return footer_btn
            end,
            close = function(opt, data)


            end,

        })

        self._smartlist._list:scrollToBottom()


        local size = self.total_bet_bg:getContentSize()
        local p = cc.p(self.total_bet_bg:getPosition())

        self._smartlist:getRootNode():setPosition(cc.p(p.x - size.width/2 - Slot.Offset.smartlist.shadow, p.y - size.height/2))

        self._content:addChild(self._smartlist:getRootNode())

    end,

    _createTotalBetBtn = function(self, data)

--        self.reeldata =  Slot.DM:getCurrentReelData()
        local totalbet = data * #(self.reeldata.lines)

        local profile = Slot.DM:getBaseProfile()
        local level = profile.level
        if profile.level > #self.commondata["levelup_data"] then level = #self.commondata["levelup_data"] end
        local maxbet =  tonumber(self.commondata["levelup_data"][level]["bet"])

        local btn = Slot.ui.Button:new({
            bg = self._options.total_bet_list_btn,
            touchPriority = Slot.TouchPriority.list_item,
            title = totalbet,
            fontSize = 60,
            disabled = data > maxbet,
            --test
            fntFile={
                normal="font/common/win_coin_base.fnt"

            },

            click = function(that)
            end,
            disableClick = function(that) end,
        })

        if data > maxbet then

            local lock = U:getSpriteByName("lock.png")

            local size = btn:getContentSize()
            lock:setAnchorPoint(cc.p(0,0.5))
            lock:setPosition(cc.p(30, size.height/2))
            btn:addChild(lock)


        end -- 加锁

        return btn
    end,

    setTotalBet = function(self, bet)
        Slot.DM:setLocalStorage(self._options.modulename.."bet", bet)
        self.bet = bet
        self.totalbet = bet * #(self.reeldata.lines)
        self.total_bet_text:setString(""..self.totalbet)
    end,


    setAllEnabled = function(self, enabled)

        if enabled then
            self.pay_table_btn:enable()
            self.max_bet_btn:enable()
            self.total_bet_btn:enable()
            self.spin_btn:enable()
        else
            self.pay_table_btn:disable()
            self.max_bet_btn:disable()
            self.total_bet_btn:disable()
            self.spin_btn:disable()
        end

        if self._smartlist then
            self._smartlist:close()
            self._smartlist=nil
        end

    end,

    -- clean notification on exit
    onExit=function(self)
        Slot.DM:detach('slotbar',self._onSlotToolBarUpdate)

        self:clearEvent("start_spin")
        self:clearEvent("stop_spin")
        self:clearEvent("free_spin")
        self:clearEvent("free_spin_stop")

    end,

    getRootNode = function(self)
        if not self.rootNode then
            U:addSpriteFrameResource("plist/common/common.plist")
            U:extend(false, self._options, self:_getStyleOptions())
--            self.proxy = Slot.CCBProxy:new()
--            self.rootNode  = cc.Sprite:create(self._options.slotbar_bg_icon) --self.proxy:readCCBFile("ccbi/SlotToolBar.ccbi")
--            self.rootNode:addChild(self.proxy:getRootNode())

--            self.rootNode:setContentSize(cc.size(self._options.width, self.rootNode:getContentSize().height))
--            self.rootNode:ignoreAnchorPointForPosition(false)

            self.rootNode = cc.Node:create()
            local bg = U:get9SpriteByName(self._options.slotbar_bg_icon)
            self._content = cc.Node:create()

            local size = bg:getContentSize()
            self.rootNode:setContentSize(cc.size(self._winsize.width, size.height))
            bg:setContentSize(cc.size(self._winsize.width, size.height))
            self._content:setContentSize(cc.size(self._winsize.width, size.height))


            bg:setPosition(cc.p(self._winsize.width/2, size.height/2))
            --            self._content:setPosition(cc.p(self._winsize.width/2, size.height/2))

            self.rootNode:addChild(bg)
            self.rootNode:addChild(self._content)

        end

        return self.rootNode
    end,

    _getStyleOptions = function(self)

        if self._options.style == "violet" then
            return {
                slotbar_bg_icon = "slotbar_bg_violet.png",
                pay_table_btn = {
                    normal = "pay_table_btn.png",
                    hightLight = "pay_table_btn.png",
                    selected = "pay_table_btn.png",
                    disabled = "pay_table_btn_disabled.png",
                },
                pay_table_btn_fnt = nil,

                max_bet_btn = {
                    normal = "max_bet_btn.png",
                    hightLight = "max_bet_btn.png",
                    selected = "max_bet_btn.png",
                    disabled = "max_bet_btn_disabled.png",
                },
                max_bet_btn_fnt = nil,

                total_bet_btn = {
                    normal = "total_bet_btn.png",
                    hightLight = "total_bet_btn.png",
                    selected = "total_bet_btn.png",
                    disabled = "total_bet_btn_disabled.png",
                },

                total_bet_num_fnt = "",
                total_bet_text_fnt = "",

                win_icon = "win_icon.png",
                win_text_fnt = "",
                win_num_fnt = "",

                spin_btn = {
                    normal = "spin_btn_violet.png",
                    hightLight = "spin_btn_violet.png",
                    selected = "spin_btn_violet.png",
                    disabled = "spin_btn_disabled_violet.png",
                },

                total_bet_list_btn = {
                    normal = "total_bet_item_normal.png",
                    hightLight = "total_bet_item_highlight.png",
                    selected = "total_bet_item_highlight.png",
                    disabled = "total_bet_item_normal.png",
                },

                total_bet_up_btn = {
                    normal = "total_bet_up.png",
                    hightLight = "total_bet_up.png",
                    selected = "total_bet_up.png",
                    disabled = "total_bet_up.png",
                },
                total_bet_down_btn = {
                    normal = "total_bet_down.png",
                    hightLight = "total_bet_down.png",
                    selected = "total_bet_down.png",
                    disabled = "total_bet_down.png",
                },
                total_bet_bg = "total_bet_btn_icon.png",
                freeSpin_btn_bg = "spin_btn_freespin_violet.png",

                freeSpinFont="font/common/freeSpin_violet.fnt"
            }
        end

        return {
            slotbar_bg_icon = "slotbar_bg_orange.png",
            pay_table_btn = {
                normal = "pay_table_btn.png",
                hightLight = "pay_table_btn.png",
                selected = "pay_table_btn.png",
                disabled = "pay_table_btn_disabled.png",
            },
            pay_table_btn_fnt = nil,

            max_bet_btn = {
                normal = "max_bet_btn.png",
                hightLight = "max_bet_btn.png",
                selected = "max_bet_btn.png",
                disabled = "max_bet_btn_disabled.png",
            },
            max_bet_btn_fnt = nil,

            total_bet_btn = {
                normal = "total_bet_btn.png",
                hightLight = "total_bet_btn.png",
                selected = "total_bet_btn.png",
                disabled = "total_bet_btn_disabled.png",
            },

            total_bet_num_fnt = "",
            total_bet_text_fnt = "",

            win_icon = "win_icon.png",
            win_text_fnt = "",
            win_num_fnt = "",

            spin_btn = {
                normal = "spin_btn_orange.png",
                hightLight = "spin_btn_orange.png",
                selected = "spin_btn_orange.png",
                disabled = "spin_btn_disabled_orange.png",

            },

            total_bet_list_btn = {
                normal = "total_bet_item_normal.png",
                hightLight = "total_bet_item_highlight.png",
                selected = "total_bet_item_highlight.png",
                disabled = "total_bet_item_normal.png",
            },

            total_bet_up_btn = {
                normal = "total_bet_up.png",
                hightLight = "total_bet_up.png",
                selected = "total_bet_up.png",
                disabled = "total_bet_up.png",
            },
            total_bet_down_btn = {
                normal = "total_bet_down.png",
                hightLight = "total_bet_down.png",
                selected = "total_bet_down.png",
                disabled = "total_bet_down.png",
            },
            total_bet_bg = "total_bet_btn_icon.png",
            freeSpin_btn_bg = "spin_btn_freespin_orange.png",
            freeSpinFont="font/common/freeSpin_orange.fnt"

        }

    end,

    getDefaultOptions = function(self)

        return U:extend(false, self:_super(), {
            nodeEventAware=true,
            component = {1,2,3,4,5,6,7,8,9,10,50,100,200},
            paytable = {1,2,3},
            payTableOne = "ccbi/PayTableOne.ccbi",
            style = "orange",
            priority = Slot.TouchPriority.toolbar

        })
    end,
})