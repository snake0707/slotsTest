--
-- by bbf
--

Slot = Slot or {}

Slot.Event = {
    _handlers = {},
    _events = {},
    --[[
    -- 计算世界是否触发在元素上面
    -- parent 父元素
    -- node 要计算的元素
    -- ]]
    containsTouchLocation = function(self,parent,node, x, y)
        local position = parent:convertToWorldSpace(cc.p(node:getPosition()))    -- todo::需要确定
        U:debug("position\t"..position.x,position.y)
        local s = node:getBoundingBox().size
        local touchRect = cc.rect(position.x, position.y, s.width, s.height)
--        local b = touchRect:containsPoint(cc.p(x, y))
        local b = cc.rectContainsPoint(touchRect, cc.p(x, y))
        return b
    end,
    --[[
    -- 简化事件绑定操作
    ]]
    bindTouchEvent = function(self, node, handler, bIsMultiTouches, nPriority, bSwallowsTouches)

        if not node then  -- node应该是继承自Layer的节点
            error("node is nil")
        end
        local function onTouch(eventType, table)
            if eventType == "began" then
                if type(handler['onTouchBegan']) == 'function' then
                    return handler.onTouchBegan(table[1], table[2], node)
                end
            elseif eventType == "moved" then
                if type(handler['onTouchMoved']) == 'function' then
                    handler.onTouchMoved(table[1], table[2], node)
                end
            elseif eventType == "ended" then
                if type(handler['onTouchEnded']) == 'function' then
                    handler.onTouchEnded(table[1], table[2], node)
                end
            end
        end

        node:registerScriptTouchHandler(onTouch, bIsMultiTouches, nPriority or 0, bSwallowsTouches)
        node:setTouchEnabled(true)
    end,
    --[[
    -- 增加监听
    -- key 标识是否是绑定一次的事件(key="_base_key"
    -- func 为事件处理函数，不能为空，当调用时会有传入event对象(event={key='',data={},name=""}
    -- ]]
    on = function(self, eventName, func, key)
        if not eventName then
            error("eventName is nil")
        end
        if not (func and type(func) == "function") then
            error("func is nil or func not is function")
        end
        local event = U:ArrayContainValue(self._events, eventName) -- 存放事件名称

        if not event then
            self._events[#self._events + 1] = eventName
        end
        local handls = self._handlers[eventName] or {}

        if key then
            local flag = false
            for index, hand in pairs(handls) do
                if hand["key"] == key then
                    flag = true
                    break
                end
            end
            if not flag then
                handls[#handls + 1] = { fun = func, key = key }
            end
        else
            handls[#handls + 1] = { fun = func }
        end


        self._handlers[eventName] = handls
    end,
    --[[
    -- 取消绑定，会清空所有绑定在eventName上面的回调
     ]]
    off = function(self, eventName)
        if not eventName then
            error("eventName is nil")
        end
        local event = U:ArrayContainValue(self._events, eventName)
        if event then
            self._handlers[eventName] = nil
            U:debug("remove event\t" .. eventName)
        end
    end,
    --[[
    -- 触发事件，可以传入多个参数，并且会添加到事件处理函数中
     ]]
    trigger = function(self, eventName, ...)
        if not eventName then
            error("eventName is nil")
        end
        local event = U:ArrayContainValue(self._events, eventName)
        if not event then
            error("event: " .. eventName .. " does not exist")
        end

        local handls = self._handlers[eventName]
        if handls and #handls > 0 then
            for index, hand in ipairs(handls) do
                hand.fun({ name = eventName, data = { ... }, key = hand.key })
            end
        end
    end,
    clear = function(self)
        self._events = nil
        self._handls = nil
    end
}