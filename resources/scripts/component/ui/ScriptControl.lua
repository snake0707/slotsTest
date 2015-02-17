--
-- by bbf
--

Slot = Slot or {}

Slot.ui = Slot.ui or {}

Slot.ui.ScriptControl = Slot.ui.UIComponent:extend({

    __className = "Slot.ui.ScriptControl",

    initWithCode = function(self,options)
        self:_super(options)

        self.touchPriority = self._options.touchPriority
        if not self._options.touchPriority then

            self.touchPriority = Slot.TouchPriority.lowest

        end

        self:_registerTouchEvent()
        self.rootNode:setTouchEnabled(true)
        self.__listener =  {}
        self._readyClick = false
    end,

    setTouchEnabled = function(self,canTouch)
        self.rootNode:setTouchEnabled(canTouch)
    end,

    setTouchPriority = function(self,touchPriority)
        self.touchPriority = touchPriority
        self:_registerTouchEvent()
    end,

    _registerTouchEvent = function(self)
        self.rootNode:registerScriptTouchHandler(function(eventType, x, y)
            return self:_handleTouchEvent(eventType, x, y)
        end, false, self.touchPriority, self._options.swallow)
    end,

    _handleTouchEvent = function(self,eventType,x,y)  -- 不好用了
        if eventType == "began" then -- touch began
            if self:_isTouchInside(x, y) then -- node is touched 原版的参数应该是touch类型
                self._readyClick = true
                return true   --claimed
            end
            return false
        end
        if eventType == "moved" then -- touch moved
            if not self._options.ignoremove then
                self._readyClick = false
            end
        end
        if eventType == "ended" then -- touch ended
            if self._readyClick then
--                Slot.Audio:playBtn()
                self:_dispatchEvent("click")
                self._readyClick = false
            end
        end
        return false
    end,

    _isTouchInside = function(self, x, y)
--        local r         = self:getRootNode()
--        local ap        = r:getAnchorPoint()
--        local position  = cc.p(r:getPosition())
--        local s         = r:getContentSize()
--        local scaleX    = r:getScaleX()
--        local scaleY    = r:getScaleY()
--        print("1111111111111111111111111111111111111111111")
--        print_table(ap)
--        print_table(position)
--        print_table(s)
--        print(scaleX)
--        print(scaleY)
--        print("1111111111111111111111111111111111111111111")
--        local touchRect = cc.rect(-s.width * ap.x * scaleX + position.x, -s.height * ap.y * scaleY + position.y, s.width, s.height)
--        local b         = cc.rectContainsPoint(touchRect, cc.p(x,y))
        local rect = self:getRootNode():getBoundingBox()
        local p = self:getRootNode():getParent():convertToNodeSpace(cc.p(x, y))
        local b = cc.rectContainsPoint(rect, p)
        return b

    end,

    _dispatchEvent = function(self,eventType)
        if self.__listener[eventType] == nil then return end
        for f,v in pairs(self.__listener[eventType]) do
            if v then f(self) end
        end
    end,

    bind = function(self,event,func)
        self.__listener[event] = self.__listener[event] or {}
        self.__listener[event][func] = 0
    end,

    unbind = function(self, event , func)
        self.__listener[event][func] = nil
    end,

    getRootNode = function(self)
        if not self.rootNode then
            self.rootNode = cc.Layer:create()
            self.rootNode:ignoreAnchorPointForPosition(false)
            self.rootNode:setAnchorPoint(cc.p(0,0))
        end
        return self.rootNode
    end,

    getDefaultOptions = function(self)
        return U:extend(false, self:_super(),{
            swallow = false,      -- 是否运行吞没，处理滑动与卡牌点击冲突问题
            ignoremove = false
        })
    end,
})