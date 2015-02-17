Slot = Slot or {}

Slot.libs = Slot.libs or {}

Slot.libs.CCBProxy = Slot.ui.UIComponent:extend({

    __className = "Slot.libs.CCBProxy",
    initWithCode = function(self,options)
--        self.proxy = cc.CCBProxy:create()
--        self:getRootNode()
        self:_super(options)
        self.nodes = {}
    end,

--    initWithCode = function(self, options)
--    --        self.proxy = cc.CCBProxy:create()
--    --        self:getRootNode()
--
--        self:_super(options)
--        self.nodes = {}
--    end,

    create = function (self)
        self:initWithCode()
    end,

    readCCBFile = function (self, strFilePath)
        local ccbReader = self.proxy:createCCBReader()
        local node = self.proxy:readCCBFromFile(strFilePath, ccbReader)

        --Variables
        local ownerOutletNames = ccbReader:getOwnerOutletNames()
        local ownerOutletNodes = ccbReader:getOwnerOutletNodes()

        for i = 1, table.getn(ownerOutletNames) do
--            print("ownerOutletName======="..ownerOutletNames[i])
            self.nodes[ownerOutletNames[i]] = ownerOutletNodes[i]
        end

        return node
    end,

    getNodeWithName = function (self, name, nodetype)
--        print("name============="..name)
        if nodetype == nil then nodetype = self.proxy:getNodeTypeName(self.nodes[name]) end
--        print("nodetype============="..nodetype)
        return tolua.cast(self.nodes[name] ,nodetype)
    end,


    handleButtonEvent = function (self, node, func, touchPriority, swallow, controlEvents)

        if self.inClick then return end
        self.inClick = false
        if touchPriority then
            if not swallow then swallow = false end
            node:registerScriptTouchHandler(function(eventType, x, y)
                return self:_handleTouchEvent(node, function()
                    U:addTapMusic()
                    if self.inClick == false then
                        self.inClick = true
                        func()

                        U:setTimeout(function()    --限制按钮连续点击
                            self.inClick = false
                        end, 0.5)

                    end

                end,
                    eventType, x, y)
            end, false, touchPriority, swallow)
            node:setTouchEnabled(true)

        else
            if controlEvents == nil then controlEvents = cc.CONTROL_EVENTTYPE_TOUCH_UP_INSIDE end --Slot.ControlType.TOUCH_UP_INSIDE
            self.proxy:setCallback(node, function()
                U:addTapMusic()
                if self.inClick == false then
                    self.inClick = true
                    func()

                    U:setTimeout(function()    --限制按钮连续点击
                        self.inClick = false
                    end, 0.5)

                end

            end, controlEvents)

        end



    end,

    unHandleButtonEvent = function(self, node)

        if type(node.unregisterScriptTouchHandler) == "function" then node:unregisterScriptTouchHandler() end
        if type(node.unregisterControlEventHandler) == "function" then node:unregisterControlEventHandler(cc.CONTROL_EVENTTYPE_TOUCH_UP_INSIDE) end


    end,

    _handleTouchEvent = function(self,node, func, eventType,x,y)  -- 不好用了

        if eventType == "began" then -- touch began

            self._lastX=x
            self._lastY=y
            if self:_isTouchInside(node, x, y) and node:isVisible() and (type(node.isEnabled)~= "function" or node:isEnabled()) then -- node is touched 原版的参数应该是touch类型

                self._readyClick = true
                self:_btnAction(true, node)
                return true   --claimed
            end
            return false
        end

        if eventType == "moved" then -- touch moved
            if not self._options.ignoremove then

                local dx=x-self._lastX
                local dy=y-self._lastY
                local framesize =self.rootNode:getContentSize()

                if math.abs(dx)<=framesize.width/100 or math.abs(dy)<=framesize.height/100 then
                    self._readyClick = true
                    self:_btnAction(true, node)
                else
                    self._readyClick = false
                    self:_btnAction(false, node)
                end
            end
        end

        if eventType == "ended" then -- touch ended

            if self._readyClick and self:_isTouchInside(node, x, y) then

                self:_btnAction(false, node)

                if type(node.isEnabled)~= "function" or node:isEnabled() then
                    func()
                end

            else
                if self._options.ignoremove then
                    self:_btnAction(false, node)
                end
            end
            self._readyClick = false

        end
        return false
    end,

    _btnAction = function(self, isBegin, node)

        if isBegin then

            local action = cc.ScaleTo:create(0.05, 0.95)
            node:runAction(action)

        else
            local action = cc.ScaleTo:create(0.05, 1)
            node:runAction(action)
        end

    end,

    _isTouchInside = function(self,btn, x, y)
        local rect = btn:getBoundingBox()
        local p = btn:getParent():convertToNodeSpace(cc.p(x, y))
        local b = cc.rectContainsPoint(rect, p)
        return b

    end,

    getRootNode = function(self)

        if not self.rootNode then
            self.proxy = cc.CCBProxy:create()
            self.rootNode = self.proxy
        end
        return self.rootNode
    end,

    getDefaultOptions = function(self)
        return U:extend(false,self:_super(),{

            ignoremove = true
        })

    end

})

Slot.CCBProxy = Slot.libs.CCBProxy