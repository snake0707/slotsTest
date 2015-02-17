--
-- by bbf
--
Slot = Slot or {}

Slot.ui = Slot.ui or {}

Slot.ui.Button = Slot.ui.UIComponent:extend({

    __className = "Slot.ui.Button",

    initWithCode = function(self,options)
        self:_super(options)
    end,

    _createLabel = function(self)
        local label

        if self._options.fntFile.normal then

            label = cc.Label:createWithBMFont(self._options.fntFile.normal, self._options.title)

        else
            label = cc.Label:createWithSystemFont(self._options.title, self._options.font, self._options.fontSize)

        end

        return label

    end,

    _createSprite = function(self)

        local sprite

        if self._options.bg.normal then
            U:addSpriteFrameResource("plist/common/common.plist")
            print(self._options.bg.normal)
            sprite=U:get9SpriteByName(self._options.bg.normal)

        end

        return sprite
    end,

    _setButtonState = function(self, btn)

        if not self._options.bg.normal then
            return
        end
        U:addSpriteFrameResource("plist/common/common.plist")
        if self._options.bg.hightLight then

            local sprite=U:get9SpriteByName(self._options.bg.hightLight)
            btn:setBackgroundSpriteForState(sprite, cc.CONTROL_STATE_HIGH_LIGHTED )
        end

        if self._options.bg.disabled then

            local sprite=U:get9SpriteByName(self._options.bg.disabled)
            btn:setBackgroundSpriteForState(sprite, cc.CONTROL_STATE_DISABLED )
        end

        if self._options.bg.selected then

            local sprite=U:get9SpriteByName(self._options.bg.selected)
            btn:setBackgroundSpriteForState(sprite, cc.CONTROL_STATE_SELECTED )
        end

    end,

    _setTitleStateByLabel = function(self, btn)
        if not self._options.title_label.normal then
            return
        else
            btn:setTitleBMFontForState(self._options.title_label.normal, cc.CONTROL_STATE_NORMAL)
        end

        if self._options.fntFile.hightLight then
            btn:setTitleLabelForState(self._options.title_label.hightLight, cc.CONTROL_STATE_HIGH_LIGHTED )
        end

        if self._options.fntFile.disabled then
            btn:setTitleLabelForState(self._options.title_label.disabled, cc.CONTROL_STATE_DISABLED )
        end

        if self._options.fntFile.selected then
            btn:setTitleLabelForState(self._options.title_label.selected, cc.CONTROL_STATE_SELECTED )
        end

    end,

    _setTitleStateByFnt = function(self, btn)

        if self._options.fntFile.normal then
            btn:setTitleBMFontForState(self._options.fntFile.normal, cc.CONTROL_STATE_NORMAL)
        else
            btn:setTitleColorForState(self._options.fontColor,cc.CONTROL_STATE_NORMAL)
            return
        end

        if self._options.fntFile.hightLight then
            btn:setTitleBMFontForState(self._options.fntFile.hightLight, cc.CONTROL_STATE_HIGH_LIGHTED )
        end

        if self._options.fntFile.disabled then
            btn:setTitleBMFontForState(self._options.fntFile.disabled, cc.CONTROL_STATE_DISABLED )
        end

        if self._options.fntFile.selected then
            btn:setTitleBMFontForState(self._options.fntFile.selected, cc.CONTROL_STATE_SELECTED )
        end

    end,

    _createRootNode = function(self)

        --[[ create btn ]]--
        U:addSpriteFrameResource("plist/common/common.plist")
        local label

        if self._options.title_label.normal then
            label = self._options.title_label.normal
        else
            label = self:_createLabel()
        end


        local sprite = self:_createSprite()

        local btn

        if not sprite then
            btn = cc.ControlButton:create()
        elseif not label then
            btn = cc.ControlButton:create(sprite)
        else
            btn = cc.ControlButton:create(label, sprite)
        end

        self:_setButtonState(btn)

        if not self._options.title_label.normal then
            self:_setTitleStateByLabel(btn)
        else
            self:_setTitleStateByFnt(btn)
        end


        --[[ set btn attr]]--
        if self._options.preferredSize then
            btn:setPreferredSize(self._options.preferredSize)
        elseif self._options.bg.normal then     ---if button text is empty we check the bgspitesize

            local sprite = U:get9SpriteByName(self._options.bg.normal)
            btn:setPreferredSize(sprite:getContentSize())
        else
            btn:setMargins(self._options.marginX,self._options.marginY)
        end

--        if self._options.touchPriority then btn:setTouchPriority(self._options.touchPriority) end

        --[[ register click event ]]--
        self:_registerTouchEvent(btn)



--        self.inClick = false    --解决按钮连续点击做多次请求的问题
--        if self._options.touchPriority then
--            btn:registerScriptTouchHandler(function(eventType, x, y)
--                return self:_handleTouchEvent(btn, eventType, x, y)
--            end, false, self._options.touchPriority-1, self._options.swallow)
--            btn:setTouchEnabled(true)
--
--        else
--            btn:registerControlEventHandler(function()
--                if btn:isEnabled() then
--                    self:_click()
--                else
--                    self:_disableClick()
--                end
--
--            end,cc.CONTROL_EVENTTYPE_TOUCH_UP_INSIDE)
--        end

--        btn:registerControlEventHandler(function()
--            if btn:isEnabled() then
--                self:_click()
--            else
--                self:_disableClick()
--            end
--
--        end,cc.CONTROL_EVENTTYPE_TOUCH_UP_INSIDE)

        if self._options.disabled then btn:setEnabled(not self._options.disabled) end

        return btn
    end,

    _registerTouchEvent = function(self, btn)

        if not btn then btn = self.rootNode end
        if self.inClick then return end  --解决按钮连续点击做多次请求的问题

        btn:unregisterScriptTouchHandler()
        btn:unregisterControlEventHandler(cc.CONTROL_EVENTTYPE_TOUCH_UP_INSIDE)
--        local dispatcher = cc.Director:getInstance():getEventDispatcher()
--        dispatcher:removeEventListenersForTarget(btn)

        self.inClick = false
        if not self._options.native then
            btn:registerScriptTouchHandler(function(eventType, x, y)
                return self:_handleTouchEvent(btn, eventType, x, y)
            end, false, self._options.touchPriority, self._options.swallow)
            btn:setTouchEnabled(true)
            btn:setZoomOnTouchDown(false)
        else
            btn:registerControlEventHandler(function()
                if btn:isEnabled() then
                    self:_click()
                else
                    self:_disableClick()
                end

            end,cc.CONTROL_EVENTTYPE_TOUCH_UP_INSIDE)
        end

    end,

    _handleTouchEvent = function(self,btn,eventType,x,y)  -- 不好用了

        if eventType == "began" then -- touch began

            if btn:isEnabled() and self:_isTouchInside(x, y) then -- node is touched 原版的参数应该是touch类型
                self._readyClick = true
                self._holdClick = true
                self:_btnAction(true)

                U:setTimeout(function()

                    if self._holdClick and type(self._options.holdClick) == "function" then

                        self._readyClick = false
                        self._options.holdClick()

                    end

                end, 1)
                return true   --claimed
            end
            return false
        end

        if eventType == "moved" then -- touch moved
            self._holdClick = false
            if not self._options.ignoremove then
                self._readyClick = false
                self:_btnAction(false)
            end

        end
        if eventType == "ended" then -- touch ended
            if self._readyClick and self:_isTouchInside(x, y) then
                self:_btnAction(false)
                if btn:isEnabled() then
                    self:_click()
                else
                    self:_disableClick()
                end

            else
                if self._options.ignoremove then
                    self:_btnAction(false)
                end

            end

            self._readyClick = false
            self._holdClick = false
        end
        return false
    end,

    _btnAction = function(self, isBegin)


        if isBegin then

            local action = cc.ScaleTo:create(0.05, 0.95)
            self.rootNode:runAction(action)

        else
            local action = cc.ScaleTo:create(0.05, 1)
            self.rootNode:runAction(action)
        end

    end,

    _isTouchInside = function(self, x, y)
        local rect = self:getRootNode():getBoundingBox()
        local p = self:getRootNode():getParent():convertToNodeSpace(cc.p(x, y))
        local b = cc.rectContainsPoint(rect, p)
        return b

    end,

    _click = function(self)
        if self.inClick == false then
            self.inClick = true
            self._options:click(self)
            U:setTimeout(function()    --限制按钮连续点击
                self.inClick = false
            end, 0.5)

            --添加音乐
            if self._options.title~="spin" then
                U:addTapMusic()
            end

        end
    end,

    _disableClick = function(self)
        self._options:disableClick(self)
    end,

    setOpacity = function(self,opacity)
        self.rootNode:setOpacity(255 * opacity)
    end,

    setTouchPriority = function(self,int)
        self._options.touchPriority = int
        self:_registerTouchEvent()
    end,

    getRootNode = function(self)
        if not self.rootNode then
            self.rootNode = self:_createRootNode()
        end
        return self.rootNode
    end,

    setTitle = function(self, title, state, type, fntFile)
        if state == nil then  state = cc.CONTROL_STATE_NORMAL end
        local label = title
        if type == "ttf" then
            label = cc.Label:createWithTTF(title,fntFile,self._options.fontSize)
--            self.rootNode:setTitleForState(title,state)
        elseif type == "fnt" then
            label = cc.Label:createWithBMFont(fntFile, title)
--            self.rootNode:setTitleForState(title,state)
        else

            label = cc.Label:createWithSystemFont(title, self._options.font, self._options.fontSize)
--            self.rootNode:setTitleForState(title,state)
        end

        self.rootNode:setTitleLabelForState(label, state)
    end,

    trigger =  function(self,type)
       self:_click()
    end,

    enable = function(self)
        self.rootNode:setEnabled(true)
    end,

    disable = function(self)
        self.rootNode:setEnabled(false)
    end,

    setBg = function(self,img,state)
        local sprite = cc.Scale9Sprite:create(img)
        if state == nil then  state = cc.CONTROL_STATE_NORMAL end
        self.rootNode:setBackgroundSpriteForState(sprite,state)
    end,

    setBgInFrame = function(self, framepath, state)
        U:addSpriteFrameResource("plist/common/common.plist")
        local sprite = U:get9SpriteByName(framepath)
        if state == nil then  state = cc.CONTROL_STATE_NORMAL end
        self.rootNode:setBackgroundSpriteForState(sprite,state)
    end,

    setSelected = function(self, enable)
        self.rootNode:setSelected(enable)
    end,

    getBoundingBox = function(self)
        return self.rootNode:getBoundingBox()
    end,

    getDefaultOptions = function(self)
        return U:extend(false,self:_super(),{
            native = false,
            touchPriority = Slot.TouchPriority.lowest,
            font      = Slot.Font.default,
            title     = "" ,
            title_label = {
                normal = nil,
                hightLight = nil,
                selected = nil,
                disabled = nil
            },
            fontSize  = 60,
            fontColor = Slot.CCC3.black,

            fntFile = {
                normal = nil,
                hightLight = nil,
                selected = nil,
                disabled = nil
            }, --图片文字

            marginX   = 10,
            marginY   = 10,
            click     = function(that,self) U:debug("I am clicked") end,
            disableClick = function(that,self) U:debug("I am disableClicked") end,
            --     norma,    highlighted,    selected,       disabled
            bg        = {
                normal = nil,
                hightLight = nil,
                selected = nil,
                disabled = nil
            },
            preferredSize = nil,
            swallow = false,
            ignoremove = true,

            disabled = false,
            click = function(self) end,
            disableClick = function(self) end,
        })
    end

})