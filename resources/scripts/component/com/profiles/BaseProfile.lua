require "component.ui.Progress"
--require "component.com.profiles.BaseProfileDialog"
Slot = Slot or {}

Slot.com = Slot.com or {}

Slot.com.BaseProfile = Slot.ui.UIComponent:extend({
    __className = "Slot.com.BaseProfile",

    initWithCode = function(self, options)
        self:_super(options)
--        self._data = Slot.DM:getProfile()
--
--        print("---------------------------")
--        print_table(self._data)
        self.spinFlag = false
        self:_initData()

        self:_setup()
        self:_registEvent()
    end,

    _initData = function(self)

        self._commomdata = Slot.DM:getCommonData()
        self.levelup_data = {}
        for i, v in pairs(self._commomdata.levelup_data) do
            self.levelup_data[v.level] = v
        end


    end,

    _setup = function(self)

--[[节点]]--

        self:_addButtons()
        self:createXpProgress()
        self:createCoinProgress()

        local profile = Slot.DM:getBaseProfile()
        self:_onBaseProfileUIUpdate(profile)

        U:addToVCenter(self.exp, self._content, nil, nil, nil, 2)
        U:addToVCenter(self.coin_node, self._content, nil, nil, nil, 2)
        U:addToVCenter(self.settingBtn, self._content, nil, nil, nil, 2)
        U:reLayoutHoriztal(self._content, nil, true)

    end,

    _addButtons = function(self)

        if self._options.show_back_btn then

            self.backBtn = Slot.ui.Button:new({
                bg = self._options.back_btn,
                touchPriority = self._options.priority,
                native = true,
                click = function(that)
                --                    Slot.App:back()

                    U:debug("click back btn")

                    Slot.App:switchTo("GameHome")

                end,
                disableClick = function(that) end,
            })

            U:addToVCenter(self.backBtn, self._content, nil, nil, nil, 2)


        end



        self.settingBtn =  Slot.ui.Button:new({
            bg = self._options.setting_btn,
            touchPriority = self._options.priority,
            native = true,
            click = function(that)

                self.settingsdlg   = Slot.com.SettingsDlg:new({
                    title   = "SETTINGS",
                    modulename = self._options.modulename,
                })
                self.settingsdlg:open()

            end,
            disableClick = function(that) end,
        })
    end,

    _registEvent = function(self)

    --[[事件]]--

    --     Slot.DM:onUpdate("baseprofile",self._onBaseProfileUpdate)

        self:onEvent("profile_update",function(e)

            self:_onBaseProfileUIUpdate(e.attach)

        end)

        self:onEvent("start_spin",function(e)
            self:setAllEnabled(false)
            self.spinFlag = true

            -- 金币
            local profile = Slot.DM:getBaseProfile()
            profile.coin = profile.coin - e.attach.totalbet
            Slot.DM:setBaseProfile(profile)
            self:fireEvent("profile_update", profile)

            -- for exp
            --            self._totalbet = e.attach.totalbet
            --            self.nodePos = e.attach.pos
            local worldPos_spin = e.attach.parentNode:convertToWorldSpace(e.attach.pos)
            local parentNode = e.attach.parentNode

            profile.exp = profile.exp + e.attach.totalbet
            Slot.DM:setBaseProfile(profile)
            if profile.exp >= self._commomdata.levelup_data[profile.level].exp then
--                profile.level = profile.level + 1
                self:fireEvent("level_up")
            end

            --add 11.29 在这里添加经验值函数 写成通用

            --添加经验值飞行动画

            --经验值

            --            if e.attach.freespin then return end

            --            local profile = Slot.DM:getBaseProfile()
            --            profile.exp = profile.exp + e.attach.totalbet -- 经验值增加默认为

            --先获得spin按钮的位置
            local nodePos=e.attach.pos

            --获得经验值图标的位置
            local starSprite=self.exp.icon
            local nodePos_star=cc.p(starSprite:getPositionX(),starSprite:getPositionY())
            local worldPos_star=self.exp.rootNode:convertToWorldSpace(nodePos_star)

            local posTab={worldPos_spin,worldPos_star}
            local nodeTab={self._options.rootNode,self.exp.icon,self.exp.rootNode }

            local seq=Slot.animation:ExperenceFly(nodeTab,posTab,function()

            --                Slot.DM:setBaseProfile(profile)
                self:fireEvent("profile_update", profile)

            end)

            --11.30 添加一个点击的粒子效果
            local spinStar=Slot.animation:ShowSpinStar("plist/common/spin_star.plist")
            parentNode:addChild(spinStar,10)
            spinStar:setPosition(e.attach.pos)
            self.rootNode:runAction(seq)

        end)

        self:onEvent("stop_spin",function(e)

            self:setAllEnabled(true)
            self.spinFlag = false

        end)

        self:onEvent("collect_coin",function(e)

            local profile = Slot.DM:getBaseProfile()
            profile.coin = profile.coin + e.attach.coin
            Slot.DM:setBaseProfile(profile)
            --这里添加收集金币的函数 add 11.29

            local coinIcon=self.icon
            local width=coinIcon:getContentSize().width
            local nodePos_coinIcon=cc.p(coinIcon:getPositionX()+width/2,coinIcon:getPositionY())
            local targetPos=self.coin_node:convertToWorldSpace(nodePos_coinIcon)

            local startPos=e.attach.parentNode:convertToWorldSpace(e.attach.pos)
            local posTab={startPos,targetPos}

            local repN=Slot.animation:collectCoin(posTab,self._options.rootNode,function()

                self:fireEvent("profile_update", profile)

            end)
            print(repN)
            self.rootNode:runAction(repN)

        end)


        --赢得金币
        self:onEvent("win_coin",function(e)

            local baseprofile = Slot.DM:getBaseProfile()
            baseprofile.coin = baseprofile.coin + e.attach.dataTab.awardGold
            Slot.DM:setBaseProfile(baseprofile)

            local startPos=e.attach.startPos  --屏幕中点
            local layerMask=e.attach.layerMask
            local footheight=e.attach.footheight
            --local distancFallDown=layerMask:getContentSize().height/2

            local coinIcon=self.icon
            local width=coinIcon:getContentSize().width
            local nodePos_coinIcon=cc.p(coinIcon:getPositionX()+width/2,coinIcon:getPositionY())
            local targetPos=self.coin_node:convertToWorldSpace(nodePos_coinIcon)

            local posTab={startPos,targetPos,cc.p(0,footheight) }

            --local parentNode
            local nodeTab={self._options.rootNode,layerMask,coinIcon, e.attach.childrenTab, e.attach.nodeTab}

            --local posTab={startPos,cc.p(100,100)}
            Slot.animation:winCoin(e.attach.dataTab, posTab, nodeTab, {
                coin_callback = function()

                    self:fireEvent("profile_update", baseprofile)

                end,
                bonus_callback = function()

                    if e.attach.callback and type(e.attach.callback) == "function" then

                        e.attach.callback()

                    end

                end
            }, e.attach.type)

        end)


        self:onEvent("free_spin",function(e)
            self:setAllEnabled(false)
            self.spinFlag = true

        end)

        self:onEvent("free_spin_stop",function(e)

        --            print("free_spin_stop=============baseProfile")

            self:setAllEnabled(true)
            self.spinFlag = false

        end)

    end,

    _onBaseProfileUIUpdate = function(self, data)

        local profile = data

        -- coin 数字自增

        local coin = U:stringTonum(self._coinValue:getString())
        if coin and not self._coinInterval and coin < tonumber(data.coin) then
            self._coinInterval = U:numAction(self._coinValue, tonumber(data.coin), coin)

            --                self._coinValue:setString(data.coin)
        else
            local coin_str=U:formatNumber(tostring(data.coin))
            self._coinValue:setString(coin_str)

            --self._coinValue:setString(data.coin)

        end


        -- 经验值

        local lastexp = 0
        if self.levelup_data[data.level-1] then
            lastexp = self.levelup_data[data.level-1].exp
        end

        self.exp:max(self.levelup_data[data.level].exp - lastexp)
        self.exp:iconvalue(data.level)
        self.exp:value(data.exp-lastexp, data.exp)

    end,

    actionScale = function(self, node)

    -- 金币动作
        local scale=cc.ScaleBy:create(0.4,1.5)
        local ease=cc.EaseIn:create(scale,0.4)
        local easeBack=ease:reverse()
        local seq=cc.Sequence:create(ease,easeBack)
        node:runAction(seq)
--        node:stopAllActions()

    end,

    setAllEnabled = function(self, enabled)

        if enabled then
            self.backBtn:enable()
            self.settingBtn:enable()
            self.buy_btn:enable()
        else
            self.backBtn:disable()
            self.settingBtn:disable()
            self.buy_btn:disable()

        end

        if self._coinInterval then
            local baseprofile = Slot.DM:getBaseProfile()
            U:clearInterval(self._coinInterval)
            self._coinInterval = nil
            self._coinValue:setString(U:formatNumber(tostring(baseprofile.coin)))
        end

    end,

    -- clean notification on exit
    onExit=function(self)
        Slot.DM:detach('baseprofile',self._onBaseProfileUpdate)

        if self._coinInterval then
            local baseprofile = Slot.DM:getBaseProfile()
            U:clearInterval(self._coinInterval)
            self._coinInterval = nil
            self._coinValue:setString(U:formatNumber(tostring(baseprofile.coin)))
        end

        self:clearEvent("start_spin")
        self:clearEvent("stop_spin")
        self:clearEvent("win_coin")
        self:clearEvent("free_spin")
        self:clearEvent("free_spin_stop")

    end,
    createXpProgress = function(self)

--        local tmpSprite  = cc.Sprite:create(self._options.xp_bg_icon)
--        local size = tmpSprite:getContentSize()

        local baseprofile = Slot.DM:getBaseProfile()

        self.exp = Slot.ui.Progress:new({
            fontColor=self._options.fontColor,
--            width = size.width,
--            height = size.height,
            fontSize = self._options.fontSize,
            labelTemplate = "totalvalue",
            bar = self._options.xp_bar_icon, -- required
            background = self._options.xp_bg_icon,
            icon = self._options.xp_icon,
            icon_value = baseprofile.level,
            enabledClick = true,
            click = function()
                print("click exp")

            end,

        })

    end,

    createCoinProgress = function(self)

        U:addSpriteFrameResource("plist/common/common.plist")
        local sprite = U:getSpriteByName(self._options.coin_bg_icon)


        local size = sprite:getContentSize()
        print("width===========:"..size.width)


        self.coin_node = cc.Node:create()
        self.coin_node:setContentSize(size)

        sprite:setPosition(cc.p(size.width/2, size.height/2))
        self.coin_node:addChild(sprite)

        --self.rootNode:addChild(sprite)

        self.icon = U:getSpriteByName(self._options.coin_icon)

        self.icon:setAnchorPoint(cc.p(0, 0.5))
        self.icon:setPosition(cc.p(0, self.coin_node:getContentSize().height/2))
        self.coin_node:addChild(self.icon)

        self.buy_btn = Slot.ui.Button:new({
            bg = self._options.buy_btn,
--            touchPriority = self._options.priority,
            native = true,
            click = function(that)

                  self:showShopDlg()

            end,
        })
        self.buy_btn:setAnchorPoint(cc.p(1, 0.5))
        self.buy_btn:setPosition(cc.p(self.coin_node:getContentSize().width - Slot.Offset.baseprofile.shadow, self.coin_node:getContentSize().height/2))
        self.coin_node:addChild(self.buy_btn:getRootNode())


        --test ok
        self._coinValue=cc.LabelBMFont:create("","font/common/win_coin_base.fnt")


        self._coinValue:setColor(self._options.fontColor)
        self._coinValue:setPosition(size.width / 2-Slot.Offset.baseprofile.left, size.height / 2)

        self.coin_node:addChild(self._coinValue)


        local sc = Slot.ui.ScriptControl:new({})
        sc:getRootNode():setContentSize(self.coin_node:getContentSize())
        sc:getRootNode():setAnchorPoint(cc.p(0,0))
        sc:getRootNode():setPosition(cc.p(0,0))
        self.coin_node:addChild(sc:getRootNode())
        sc:bind("click",function()
            print("click coin")


            if not self.spinFlag then

                --添加音乐
                U:addTapMusic()

                self:showShopDlg()
            end

        end)


--        self.icon:setVisible(false)
--        self.buy_btn:setVisible(false)
    end,


    showShopDlg = function(self)

--        local content = cc.Sprite:create("common/shopcontent.png")

--        local dlg   = Slot.ui.Dialog:new({
--            title   = "SHOP",
--            content = content,
--        })
--        dlg:open()

        local heaprecharge = Slot.DM:getHeapRecharge()

        U:debug("showshopdlg===========================")
        U:debug(heaprecharge)

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


    end,

    getRootNode = function(self)

        if not self.rootNode then
            U:addSpriteFrameResource("plist/common/common.plist")
            U:extend(false, self._options, self:_getStyleOptions())
--            self.proxy = Slot.CCBProxy:new()
--            self.rootNode  = self.proxy:readCCBFile("ccbi/BaseProfile.ccbi")
--            self.rootNode:addChild(self.proxy:getRootNode())
            self.rootNode = cc.Node:create()
            local bg =U:get9SpriteByName(self._options.profile_bg_icon)
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
                profile_bg_icon = "profile_bg_violet.png",

                back_btn = {
                    normal = "back_btn.png",
                    hightLight = "back_btn.png",
                    selected = "back_btn.png",
                    disabled = "back_btn_disabled.png",
                },

                setting_btn = {
                    normal = "setting_btn.png",
                    hightLight = "setting_btn.png",
                    selected = "setting_btn.png",
                    disabled = "setting_btn_disabled.png",
                },

                xp_bg_icon = "xp_bg_icon_violet.png",
                xp_bar_icon = "xp_bar_icon.png",

                xp_icon = "xp_icon.png",
                coin_bg_icon = "coin_bg_icon_violet.png",

                coin_icon = "coin_icon.png",

                buy_btn = {
                    normal = "buy_btn.png",
                    hightLight = "buy_btn.png",
                    selected = "buy_btn.png",
                    disabled = "buy_btn_disabled.png"
                },
            }

        end

        return {

            profile_bg_icon = "profile_bg_orange.png",

            back_btn = {
                normal = "back_btn.png",
                hightLight = "back_btn.png",
                selected = "back_btn.png",
                disabled = "back_btn_disabled.png",
            },


            setting_btn = {
                normal = "setting_btn.png",
                hightLight = "setting_btn.png",
                selected = "setting_btn.png",
                disabled = "setting_btn_disabled.png",
            },

            xp_bg_icon = "xp_bg_icon.png",
            xp_bar_icon = "xp_bar_icon.png",
            xp_icon = "xp_icon.png",
            coin_bg_icon = "coin_bg_icon.png",
            coin_icon = "coin_icon.png",

            buy_btn = {
                normal = "buy_btn.png",
                hightLight = "buy_btn.png",
                selected = "buy_btn.png",
                disabled = "buy_btn_disabled.png"
            },
        }



    end,


    getDefaultOptions = function(self)

        return U:extend(false, self:_super(), {
            nodeEventAware=true,
            show_back_btn = true,
            fontSize = 60,
            fontColor = Slot.CCC3.white,
            style = "orange",
            priority = Slot.TouchPriority.baseprofile,

        })
    end,
})