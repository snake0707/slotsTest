--
-- by bbf
--
Slot = Slot or {}

Slot.ui = Slot.ui or {}

Slot.ui.CCBDialog = Slot.ui.UIComponent:extend({
    __className = "Slot.ui.CCBDialog",

    initWithCode = function(self, options)

        self:_super(options)
        self:_setup()
        self._canClose = false
        self:_createButtons()
        self:_registEvent()

        Slot.EM:addListener("system.switch.scene", function(e)
            Slot.ui.Dialog._instances={}
            Slot.ui.Dialog._opening=nil
--            self:_removeOverlay()
        end, true)

    end,

    _setup = function(self)

    end,


    _createButtons = function(self)

        if self._options.leftText then
            local left_btn_node = self.proxy:getNodeWithName("left_btn_node")
            self.leftBtn = Slot.ui.Button:new({
                title = self._options.leftText,
                bg = self._options.leftBtn,
                touchPriority = self._options.btnPriority,
                native = self._options.native,
                click = function(that)

                    self._options:leftBtnClick()

                end,
                disableClick = function(that) end,


                --add 1.21
                fntFile={
                      normal="font/common/red.fnt"

                },
            })
            local size = left_btn_node:getContentSize()
            self.leftBtn:setPosition(cc.p(size.width/2, size.height/2))
            left_btn_node:addChild(self.leftBtn:getRootNode())
        end


        if self._options.rightText then
            local right_btn_node = self.proxy:getNodeWithName("right_btn_node")
            self.rightBtn = Slot.ui.Button:new({
                title = self._options.rightText,
                bg = self._options.rightBtn,
                touchPriority = self._options.btnPriority,
                native = self._options.native,
                click = function(that)
                    self._options:rightBtnClick()
                end,
                disableClick = function(that) end,

                --add 1.21
                fntFile={
                    normal="font/common/gre.fnt"

                },

            })
            local size = right_btn_node:getContentSize()
            self.rightBtn:setPosition(cc.p(size.width/2, size.height/2))
            right_btn_node:addChild(self.rightBtn:getRootNode())

        end


        if self._options.midText then
            local mid_btn_node = self.proxy:getNodeWithName("mid_btn_node")
            self.midBtn = Slot.ui.Button:new({
                title = self._options.midText,
                bg = self._options.midBtn,
                touchPriority = self._options.btnPriority,
                native = self._options.native,
                click = function(that)
                    self._options:midBtnClick()
                end,
                disableClick = function(that) end,

                fntFile={
                    normal="font/common/gre.fnt"

                },
            })
            local size = mid_btn_node:getContentSize()
            self.midBtn:setPosition(cc.p(size.width/2, size.height/2))
            mid_btn_node:addChild(self.midBtn:getRootNode())

        end


    end,

    _registEvent = function(self)

        if not self._options.showClose then
            return
        end
        local closeBtn = self.proxy:getNodeWithName("btnClose")
        if closeBtn == nil then
            return
        end
        self.proxy:handleButtonEvent(closeBtn, function()
            print("click closeBtn")
            self:close()
        end)

    end,

    _createOverlay = function(self)

        if not Slot.ui.Dialog._overlay or tolua.isnull(Slot.ui.Dialog._overlay)  then
            local _scene = cc.Director:getInstance():getRunningScene()
            local winsize = cc.Director:getInstance():getWinSize()

            Slot.ui.Dialog._overlay= cc.LayerColor:create(self._options.overlaycolor, self._winsize.width, self._winsize.height)
            Slot.ui.Dialog._overlay:setPosition(cc.p(0,0))

            local onTouch = function(eventType, x, y)
            -- To intercept touch event
                if eventType == "began" then
--                    local box = self.rootNode:getBoundingBox()
--                    local pos = self.rootNode:getParent():convertToNodeSpace(cc.p(x,y))
--                    if not cc.rectContainsPoint(box, pos) then  --box:containsPoint(pos) then
--                        self:close()
--                    end
                    return true
                end

                if eventType == "ended" then
                    local box = self.rootNode:getBoundingBox()
                    local pos = self.rootNode:getParent():convertToNodeSpace(cc.p(x,y))
                    if not cc.rectContainsPoint(box, pos) then  --box:containsPoint(pos) then
                        U:debug("ccbdialog open222222222======================")
                        if self._options.overlayClick and self._canClose then
                            self:close()
                        end
                    end
                end
            end

            Slot.ui.Dialog._overlay:registerScriptTouchHandler(onTouch, false, self._options.priority , true)
            Slot.ui.Dialog._overlay:setTouchEnabled(true)

            _scene:addChild(Slot.ui.Dialog._overlay, Slot.ZIndex.Dialog)

        else
            Slot.ui.Dialog._overlay:setVisible(true)

        end


    end,

    _removeOverlay = function(self)
        if Slot.ui.Dialog._overlay==nil or tolua.isnull(Slot.ui.Dialog._overlay) then
            Slot.ui.Dialog._overlay=nil
            return
        end
        Slot.ui.Dialog._overlay:removeFromParent(true)
        Slot.ui.Dialog._overlay = nil
    end,

    open = function(self, force)
        U:debug("ccbdialog open======================")
        if not self._options.isShopDlg then
            Slot.Audio:playEffect("sound/common/"..Slot.MusicResources["common"].windowshow)
        end

        if Slot.ui.Dialog._opening then

            table.insert(Slot.ui.Dialog._instances, self)

            return

        end

        Slot.ui.Dialog._opening = self

        self:_createOverlay()

        if not self.rootNode:getParent() then

            self.rootNode:setAnchorPoint(cc.p(0.5,0.5))
            self.rootNode:setScale(0.2)
            U:addToCenter(self.rootNode, Slot.ui.Dialog._overlay)

            local fadeIn = cc.FadeIn:create(0.1)
            --local scale_begin = cc.EaseIn:create(cc.ScaleTo:create(0.3, 1.1), 2)
            local scale_begin = cc.EaseIn:create(cc.ScaleTo:create(0.3, 1.3), 2)

            local scale_end = cc.EaseOut:create(cc.ScaleTo:create(0.2, 1), 1)

            local sp = cc.Spawn:create(fadeIn, scale_begin)

            local callBack = cc.CallFunc:create(function()
                U:debug("ccbdialog open1111111111======================")
                self._canClose = true
            end)

            local seq = cc.Sequence:create(sp, scale_end, callBack)
            self.rootNode:runAction(seq)

        end

--        if force == nil then
----            if Slot.ui.Dialog._opening ~= nil then
----                table.insert(Slot.ui.Dialog._instances, self)
----                self.rootNode:setVisible(false)
----            else
----                Slot.ui.Dialog._opening = self
----            end
--            Slot.ui.Dialog._opening = self
--        else
--            if Slot.ui.Dialog._opening ~= nil then
--                table.insert(Slot.ui.Dialog._instances,1, Slot.ui.Dialog._opening)
--                Slot.ui.Dialog._opening:setVisible(false)
--                Slot.ui.Dialog._opening = self
--            end
--        end

    end,

    close = function(self)

        Slot.Audio:playEffect("sound/common/"..Slot.MusicResources["common"].windowback)

        U:debug("ccbdialog close======================")

        if not self._canClose then return end
        U:debug("ccbdialog close11111======================")
        self._canClose = false
        U:debug("ccbdialog close22222======================")
        if self._options.willClose then self._options:willClose(self) end

--        if #Slot.ui.Dialog._instances > 0 then
--            self.rootNode:removeFromParent(true)
--            local dlg = table.remove(Slot.ui.Dialog._instances, 1)
--            dlg:setVisible(true)
--            Slot.ui.Dialog._opening = dlg
--        else
--
--
--
--        end

        local func

        if Slot.ui.Dialog._overlay then

            func = function()
                self._options:onClose()
                Slot.ui.Dialog._overlay:unregisterScriptTouchHandler()
                Slot.ui.Dialog._overlay:setTouchEnabled(false)
                local _scene = cc.Director:getInstance():getRunningScene()
                _scene:removeChild(Slot.ui.Dialog._overlay, true)
                U:setTimeoutUnsafe(function()
                    self:afterClose()
                end, 0.5)
            end
        else

            func = function()
                self._options:onClose()
                self.rootNode:removeFromParent(true)
                U:setTimeoutUnsafe(function()
                    self:afterClose()
                end, 0.5)
            end
        end

        --local scale_begin = cc.EaseIn:create(cc.ScaleTo:create(0.2, 1.1), 1)
        local scale_begin = cc.EaseIn:create(cc.ScaleTo:create(0.2, 1.3), 1)
        local scale_end = cc.EaseOut:create(cc.ScaleTo:create(0.2, 0.2), 2)
        local fadeOut = cc.FadeOut:create(0.1)
        local sp = cc.Spawn:create(scale_end, fadeOut)
        local callBack = cc.CallFunc:create(function()
            func()


        end)
        local seq = cc.Sequence:create(scale_begin, sp, callBack)
        self.rootNode:runAction(seq)

    end,

    afterClose = function(self)

        Slot.ui.Dialog._overlay = nil
        Slot.ui.Dialog._opening = nil

        if #Slot.ui.Dialog._instances > 0 then

            local dlg = table.remove(Slot.ui.Dialog._instances, 1)
            dlg:open()

        else

            if #self._options.resources > 0 then

                for i, r in ipairs(self._options.resources) do

                    Slot.SpriteCacheManager:removeImageCache(r)

                end

            end

        end

        self._options:afterClose(self)

    end,

    hide = function(self)
        Slot.ui.Dialog._overlay:setVisible(false)
        self.rootNode:setVisible(false)
    end,

    show = function(self)
        Slot.ui.Dialog._overlay:setVisible(true)
        self.rootNode:setVisible(true)
    end,

    getRootNode = function(self)
        if not self.rootNode then

            if #self._options.resources > 0 then

                for i, r in ipairs(self._options.resources) do

                    Slot.SpriteCacheManager:preloadImageCache(r)

                end

            end

            self.proxy = Slot.CCBProxy:new()
            self.rootNode = self.proxy:readCCBFile(self._options.ccbi)
            self.rootNode:addChild(self.proxy:getRootNode())
        end

        return self.rootNode
    end,

    getDefaultOptions = function(self)

        return U:extend(false, self:_super(), {
            ccbi = "LargeDlg.ccbi",
            type = "cc.Node",
            fullscreen = true,
            showClose = false,
            willClose = function(opt, that) end,
            onClose = function(opt, that) end,
            afterClose = function(opt, that)

                print("***********afterClose******************")
            end,
            priority = Slot.TouchPriority.dialog,
            overlaycolor = Slot.CCC4.overlay,
            overlayClick = true,

            native = true,
            btnPriority = Slot.TouchPriority.dialog,
            leftText = nil,
            leftBtn = {
                normal = "orange_common_btn.png",
                hightLight = "orange_common_btn.png",
                selected = "orange_common_btn.png",
                disabled = "orange_common_btn.png",
            },
            leftBtnClick = function(opt) U:debug("click leftBtn") end,
            rightText = nil,
            rightBtn =  {
                normal = "green_long_btn.png",
                hightLight = "green_long_btn.png",
                selected = "green_long_btn.png",
                disabled = "green_long_btn.png",
            },
            rightBtnClick = function(opt) U:debug("click rightBtn") end,
            midText = nil,
            midBtn  =  {
                normal = "green_common_btn.png",
                hightLight = "green_common_btn.png",
                selected = "green_common_btn.png",
                disabled = "green_common_btn.png",
            },
            midBtnClick = function(opt) U:debug("click midBtn") end,

            resources = {}

        })
    end,
})

Slot.ui.Dialog = Slot.ui.Dialog or {}
Slot.ui.Dialog._opening = Slot.ui.Dialog._opening
Slot.ui.Dialog._instances = Slot.ui.Dialog._instances
Slot.ui.Dialog._overlay = Slot.ui.Dialog._overlay or {}