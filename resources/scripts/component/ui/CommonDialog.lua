--
-- by bbf
--
require "component.ui.CCBDialog"
Slot = Slot or {}

Slot.ui = Slot.ui or {}

Slot.ui.CommonDialog = Slot.ui.CCBDialog:extend({
    __className = "Slot.ui.CommonDialog",

    initWithCode = function(self, options)

        self:_super(options)
    end,

    _setup = function(self)
        local title = tolua.cast(self.ccbProxy:getNode"title","CCLabelTTF")
        local center = tolua.cast(self.ccbProxy:getNode"center","CCLabelTTF")

        local leftBtnTxt = tolua.cast(self.ccbProxy:getNode"leftBtnTxt","CCLabelTTF")
        local centerBtnTxt = tolua.cast(self.ccbProxy:getNode"centerBtnTxt","CCLabelTTF")
        local rightBtnTxt = tolua.cast(self.ccbProxy:getNode"rightBtnTxt","CCLabelTTF")

        title:setString(self._options.title)
        center:setString(self._options.content)

        if #self._options.buttons == 1 then
            centerBtnTxt:setString(self._options.buttons[1][1])
            leftBtnTxt:setVisible(false)
            rightBtnTxt:setVisible(false)
        else
            leftBtnTxt:setString(self._options.buttons[1][1])
            rightBtnTxt:setString(self._options.buttons[2][1])
            centerBtnTxt:setVisible(false)
        end

    end,

    _registEvent = function(self)

        self:_super()
        local leftBtn = tolua.cast(self.ccbProxy:getNode"leftBtn","CCControlButton")
        U:btnWithSound(self.ccbProxy,leftBtn, function()
            if type(self._options.buttons[1][2]) == 'function' then
                self._options.buttons[1][2](self)
            end
        end, CCControlEventTouchUpInside)
        leftBtn:setTouchPriority(self._options.touchPriority or Slot.TouchPriority.dialog)

        local rightBtn = tolua.cast(self.ccbProxy:getNode"rightBtn","CCControlButton")
        U:btnWithSound(self.ccbProxy,rightBtn, function()
            if type(self._options.buttons[2][2]) == 'function' then
                self._options.buttons[2][2](self)
            end
        end, CCControlEventTouchUpInside)
        rightBtn:setTouchPriority(self._options.touchPriority or Slot.TouchPriority.dialog)

        local centerBtn = tolua.cast(self.ccbProxy:getNode"centerBtn","CCControlButton")
        U:btnWithSound(self.ccbProxy,centerBtn, function()
            if type(self._options.buttons[1][2]) == 'function' then
                self._options.buttons[1][2](self)
            end
        end, CCControlEventTouchUpInside)
        centerBtn:setTouchPriority(self._options.touchPriority or Slot.TouchPriority.dialog)


        if #self._options.buttons == 1 then
            leftBtn:setVisible(false)
            rightBtn:setVisible(false)
        else
            centerBtn:setVisible(false)
        end

    end,


    getDefaultOptions = function(self)

        return U:extend(false, self:_super(), {
            ccbi = "ccbi/MallToyDlg.ccbi"
        })
    end,
})