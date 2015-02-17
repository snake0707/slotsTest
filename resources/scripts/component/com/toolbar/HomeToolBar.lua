--
-- Created by IntelliJ IDEA.
-- User: bbf
-- Date: 14-11-26
-- Time: 下午4:30
-- To change this template use File | Settings | File Templates.
--

--require "component.com.profiles.BaseProfileDialog"
Slot = Slot or {}

Slot.com = Slot.com or {}

Slot.com.HomeToolBar = Slot.ui.UIComponent:extend({
    __className = "Slot.com.HomeToolBar",

    initWithCode = function(self, options)
        self:_super(options)
        self:_setup()
        self:_registEvent()
    end,

    _setup = function(self)

        self.facebook_btn = self.proxy:getNodeWithName("facebook_btn")
        --self.collect_node = self.proxy:getNodeWithName("collect_node")

        self.collect_layer = self.proxy:getNodeWithName("collect_layer")


        self.collect_spin_btn = self.proxy:getNodeWithName("collect_spin_btn")
        self.collect_btn = self.proxy:getNodeWithName("collect_btn")
        self.coin_text = self.proxy:getNodeWithName("coin_text")
        self.collect_btn_title = self.proxy:getNodeWithName("collect_btn_title")
        self.collect_spin_btn_title = self.proxy:getNodeWithName("collect_spin_btn_title")
        self.collect_btn_text = self.proxy:getNodeWithName("collect_btn_text")
        self.shop_layer = self.proxy:getNodeWithName("shop_layer")
        self.shop_girl_close = self.proxy:getNodeWithName("shop_girl_close")
        self.shop_girl_open = self.proxy:getNodeWithName("shop_girl_open")

        self.collect_progress_node = self.proxy:getNodeWithName("collect_progress_node")
        self.collect_progress_1 = self.proxy:getNodeWithName("collect_progress_1")
        self.collect_progress_2 = self.proxy:getNodeWithName("collect_progress_2")
        self.collect_progress_3 = self.proxy:getNodeWithName("collect_progress_3")
        self.collect_progress_4 = self.proxy:getNodeWithName("collect_progress_4")

        self.collect_btn_text:setString("")
        self.coin_text:setString("")


        U:reLayoutHoriztal(self.ccbnode, nil, true)

        -- shopgirl animation
        self.shop_girl_close:setVisible(false)
        self:_shopGirlEye()

        --collect coin
        self:_showCollect()

        self.isShowStar=false


    end,

    -- clean notification on exit
    onExit=function(self)
    --        Slot.DM:detach('hometoolbar',self._onBaseProfileUpdate)
        if self._interval then U:clearInterval(self._interval) end
    end,

    _shopGirlEye = function(self)
        local actions = {}
        table.insert(actions,cc.DelayTime:create(5))
        local closeeye = cc.CallFunc:create(function() self.shop_girl_close:setVisible(true) self.shop_girl_open:setVisible(false) end)
        local openeye = cc.CallFunc:create(function() self.shop_girl_open:setVisible(true) self.shop_girl_close:setVisible(false) end)
        table.insert(actions,closeeye)
        table.insert(actions,cc.DelayTime:create(0.2))
        table.insert(actions,openeye)
        table.insert(actions,cc.DelayTime:create(0.2))
        table.insert(actions,closeeye)
        table.insert(actions,cc.DelayTime:create(0.2))
        table.insert(actions,openeye)
        local seq    = cc.Sequence:create(actions)
        self.shop_layer:runAction(cc.RepeatForever:create(seq))

    end,


    _showStart = function(self,node)

        local width=node:getContentSize().width
        local height=node:getContentSize().height

        math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
        local posTab={}
        for i=1,20 do
            posTab[i]=cc.p(math.random(0,width),math.random(height/2,height*4/3))

        end

        self.starTab=Slot.animation:lightAction(node,posTab,0.3,1,true)

    end,

    _showCollect = function(self)

        self:_unregistCollectBtnEvent()

        local coin_last_time = Slot.DM:getLocalStorage("collect_coin_last_time")

        if not coin_last_time then
            Slot.DM:setLocalStorage("collect_coin_last_time", os.time())
            coin_last_time = Slot.DM:getLocalStorage("collect_coin_last_time")
        end

        --test
        --        coin_last_time = 0

        -- 文字显示"COLLECT" OR TIME
        if Slot.Collect.time > os.time() - tonumber(coin_last_time) then
            self.collect_btn_text:setVisible(true)
            self._interval = U:setInterval(function()
                local reamin_time = Slot.Collect.time - (os.time() - tonumber(coin_last_time))

                U:debug("reamin_time========"..reamin_time.."   reamin_time======="..U:formatTime(reamin_time))

                if reamin_time>=0 then
                    self.collect_btn_text:setString(U:formatTime(reamin_time))
                else
                    self:_showCollect()
                    U:clearInterval(self._interval)
                end

            end,1)
        else
            self.collect_btn_text:setVisible(false)
        end


        -- button 显示
        local collect_coin_times = Slot.DM:getLocalStorage("collect_coin_times")
        if not collect_coin_times then collect_coin_times = 0 end

        --test
        --        collect_coin_times = 4

        local normal_bonus = Slot.DM:getCommonDataByKey("timebonus_normal")

        if tonumber(collect_coin_times) >= #normal_bonus then

            self.collect_progress_node:setVisible(false)
            --self:_showOrHideAllProgress(false)

            self.coin_text:setVisible(false)
            self.collect_btn:setVisible(false)
            self.collect_btn_title:setVisible(false)
            self.collect_spin_btn:setVisible(true)

            --            self.collect_btn_text:setPositionX(self.collect_spin_btn:getPositionX())

            if Slot.Collect.time <= os.time() - tonumber(coin_last_time) then
                self:_registCollectBtnEvent(true)
                self.collect_spin_btn_title:setVisible(true)

                self:_showStart(self.collect_layer)
            else
                --                self.collect_spin_btn:setEnabled(false)
                self.collect_spin_btn_title:setVisible(false)
            end

            --            self.collect_btn_text:setString("")
        else

            --init
            self.collect_progress_node:setVisible(true)
            --self:_showOrHideAllProgress(true)

            for i = 1, #normal_bonus do
                self["collect_progress_"..i]:setVisible(false)
            end
            --

            self.coin_text:setVisible(true)
            self.collect_btn:setVisible(true)
            self.collect_spin_btn:setVisible(false)
            --            self.collect_btn_text:setPositionX(self.collect_btn:getPositionX())

            local profile = Slot.DM:getBaseProfile()

            local next_times = tonumber(collect_coin_times)+1
            if next_times > #normal_bonus then next_times = #normal_bonus end
            self.coin_text:setString(normal_bonus[next_times]["coins"] * U:collectCoinFactor())

            for i = 1, collect_coin_times do
                self["collect_progress_"..i]:setVisible(true)
            end

            if Slot.Collect.time <= os.time() - tonumber(coin_last_time) then
                self:_registCollectBtnEvent()
                self.collect_btn_title:setVisible(true)
            else
                --                self.collect_btn:setEnabled(false)
                self.collect_btn_title:setVisible(false)
            end

        end

    end,

    _registCollectBtnEvent = function(self, isSpinCollect)


        self.proxy:handleButtonEvent(self.collect_layer, function()

            self.collect_layer:setTouchEnabled(false)

            --删除所有星星提示
            U:clearAllNode(self.starTab)

            local collect_coin_times = Slot.DM:getLocalStorage("collect_coin_times")
            if not collect_coin_times then collect_coin_times = 0 end
            local normal_bonus = Slot.DM:getCommonDataByKey("timebonus_normal")

            --print("normal_bonus===========:"..normal_bonus)

            if tonumber(collect_coin_times) >= #normal_bonus then

                --                if not self.collect_spin_btn_title:isVisible()  then
                --
                --                    self.isShowTurnPlate=false
                --                    return
                --                end
                --add 11.29 添加转盘
                print("click collect_spin_btn")
                local emptySize=self._winsize

                self._turnPlate = Slot.com.TurnPlate:new({
                    frameWidth = emptySize.width,
                    frameHeight = emptySize.height,
                    onClose = function(opt, that, data)

                        local bonus_num = data.bonus_num

                        local profile = Slot.DM:getBaseProfile()
                        local levelFactor = U:collectCoinFactor(profile.level)
                        local total_bonus = bonus_num * levelFactor

                        self.collectDlg = Slot.com.CoinBetDialog:new({
                            bonus_num = bonus_num,
                            level_factor = levelFactor,
                            total_bonus = total_bonus,

                            afterClose = function(opt)


                                local profile = Slot.DM:getBaseProfile()

                                profile.coin = profile.coin + tonumber(total_bonus)

                                Slot.DM:setBaseProfile(profile)

                                self:fireEvent("profile_update", profile)


                                local collectInfo = data.collectInfo

                                Slot.DM:setLocalStorage("collect_coin_times", 0)

                                local last_collect_time = os.time()

                                Slot.DM:setLocalStorage("collect_coin_last_time", last_collect_time)

                                self:_showCollect()

                                --推送时间设置
                                --Slot.NM:removeNotification("collectwheel")
                                Slot.NC:fireEvent_CollectCoins(Slot.Collect.time)
                            end,
                        })

                        self.collectDlg:open()

                    end})

                self._turnPlate:open()


                --                self.isShowTurnPlate=true

                return


            end


            --            if not self.collect_btn_title:isVisible()  then
            --
            --                self.isCollectCoin=false
            --                return
            --            end

            print("click collect_btn")
            local coins = tonumber(self.coin_text:getString())

            Slot.http:post(
                "collectcoins/collect",
                {
                    coins = coins
                },
                function(data)

                    if data.rc == 0 then
                        --add 11.29
                        self:fireEvent("collect_coin", {
                            coin = coins,
                            pos = cc.p(self.collect_btn:getPosition()),
                            parentNode=self.collect_btn:getParent()
                        })

                        local collectInfo = data.collectInfo

                        Slot.DM:setLocalStorage("collect_coin_times", collectInfo.collect_times)

                        local last_collect_time = os.time() - collectInfo.past_time

                        Slot.DM:setLocalStorage("collect_coin_last_time", last_collect_time)

                        --collect coin
                        self:_showCollect()

                        --推送时间设置
                        --Slot.NM:removeNotification("collect_coins")

                        local normal_bonus = Slot.DM:getCommonDataByKey("timebonus_normal")
                        if tonumber(collect_coin_times) >= #normal_bonus then
                            Slot.NC:fireEvent_CollectWheel(Slot.Collect.time)
                        else
                            Slot.NC:fireEvent_CollectCoins(Slot.Collect.time)
                        end
                    end
                end)

        --            if not self.isCollectCoin then
        --
        --
        --
        --
        --                self.isCollectCoin=true
        --
        --            end

        end,self._options.priority-1,true)

    end,


    _unregistCollectBtnEvent = function(self)
    --        self.proxy:unHandleButtonEvent(self.collect_spin_btn)
    --        self.proxy:unHandleButtonEvent(self.collect_btn)
        self.proxy:unHandleButtonEvent(self.collect_layer)
    end,

    _registEvent = function(self)
    --        self.proxy:handleButtonEvent(self.facebook_btn, function()
    --            print("click facebook_btn")
    --
    --
    --        end)

        self.proxy:handleButtonEvent(self.shop_layer, function()


            print("click shop_layer")


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

        end, self._options.priority-1)
    end,

    getRootNode = function(self)
        if not self.rootNode then

            self.rootNode = cc.Layer:create()
            self.proxy = Slot.CCBProxy:new()
            self.ccbnode  = self.proxy:readCCBFile("ccbi/ToolBar.ccbi")
            self.ccbnode:setContentSize(cc.size(self._winsize.width, self.ccbnode:getContentSize().height))

            local size = self.ccbnode:getContentSize()
            self.rootNode:setContentSize(size)

            self.ccbnode:setPosition(cc.p(size.width/2, size.height/2))
            self.rootNode:addChild(self.proxy:getRootNode())
            self.rootNode:addChild(self.ccbnode)


            self.rootNode:registerScriptTouchHandler(function(eventType, x, y)
                if eventType == "began" then -- touch began

                    local rect=cc.rect(0,0,size.width,size.height)
                    if not cc.rectContainsPoint(rect, self.rootNode:convertToNodeSpace(cc.p(x,y))) then -- rect:containsPoint() then
                        return false
                    end
                    return true
                end

            end, false, self._options.priority, true)
            self.rootNode:setTouchEnabled(true)
        end

        return self.rootNode
    end,

    getDefaultOptions = function(self)

        return U:extend(false, self:_super(), {
            nodeEventAware=true,
            priority = Slot.TouchPriority.toolbar
        })
    end,
})