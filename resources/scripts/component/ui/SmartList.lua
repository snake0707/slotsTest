--
-- Created by IntelliJ IDEA.
-- User: bbf
-- Date: 14-11-27
-- Time: 下午9:04
-- To change this template use File | Settings | File Templates.
--

Slot = Slot or {}

Slot.ui = Slot.ui or {}

Slot.ui.SmartList = Slot.ui.UIComponent:extend({
    __className = "Slot.ui.SmartList",

    initWithCode = function(self, data, options)
        self:_super(options)

        self._data = data
--        self._headerSize = cc.size(0,0)
--        self._footerSize = cc.size(0,0)

        self:_createHeader()
        self:_createList()
        self:_createFooter()

        self:_setPos()

    end,

    _setPos = function(self)
        local t = {self._header, self._list, self._footer}
        local layer
        if self._options.direction == 1 then
            layer = U:layerWithChildrenVertical(t, self._options.spacing)
        else
            layer = U:layerWithChildrenVertical(t, self._options.spacing)
        end

        -- need make load after setting position, because it return container size
        self._list:load()

        local size = self.rootNode:getContentSize()
        local layerSize = layer:getContentSize()
        layer:setPosition((size.width-layerSize.width)/2, size.height-layerSize.height - Slot.Offset.totalbetlist.shadow) --

        self.rootNode:addChild(layer)

    end,

    _createHeader = function(self)
        self._header = self._options:createHeader()

--        local header = self._header
--        if U:isUI(self._header) then
--            header = self._header:getRootNode()
--        end
--        local size = self.rootNode:getContentSize()
--        self._headerSize = header:getContentSize()
--        local p = header:getAnchorPoint()
--        local x = size.width/2 + (p.x - 0.5) * self._headerSize.width
--        local y = size.height + (p.y - 1) * self._headerSize.height - self._options.margin.t
--
--        if self._options.direction == 0 then
--            x = p.x * self._headerSize.width + self._options.margin.l
--            y = p.y * self._headerSize.height
--        end

    end,


    _createFooter = function(self)
        self._footer = self._options:createFooter()

--        local footer = self._footer
--        if U:isUI(self._footer) then
--            footer = self._footer:getRootNode()
--        end
--        local size = self.rootNode:getContentSize()
--        self._footerSize = footer:getContentSize()
--        local p = footer:getAnchorPoint()
--        local x = size.width/2 + (p.x - 0.5) * self._footerSize.width
--        local y = p.y * self._footerSize.height + self._options.margin.b
--
--        if self._options.direction == 0 then
--
--            x = size.width + (p.x - 1) * self._footerSize.width - self._options.margin.r
--            y = p.y * self._footerSize.height
--
--        end

    end,


    _createList = function(self)

        self._list = Slot.ui.List:new({
            direction = self._options.direction,
            priority = self._options.priority,
            pageSize = self._options.pageSize,
            spacing = self._options.listSpacing,
            frameWidth = self._options.frameWidth,
            frameHeight = self._options.frameHeight,
            onItemClick=self._options.onItemClick,
            usingNativeScroll = self._options.usingNativeScroll,
            cellSize = function()
            end,
            cellAtIndex = function(opt, data, index, _list)
                return self._options:cellAtIndex(data, index, _list)
            end,
            loadFunc = function(opt, slider, current, page)
                self._list:appendData(self._data)
            end
        })


--        if self._options.direction == 1 then
--            self._list:getRootNode():setPosition(cc.p(0, self._footerSize.height))
--        else
--            self._list:getRootNode():setPosition(cc.p(0, self._headerSize.width))
--        end

    end,

    close = function(self)

        self.rootNode:removeFromParent(true)

        self._options:close()

    end,

    getRootNode = function(self)
        if not self.rootNode then

            self.rootNode = cc.Node:create()
            local sprite

            local size = cc.size(self._options.frameWidth, self._options.frameHeight)
            if self._options.bg then
                U:addSpriteFrameResource("plist/common/common.plist")
                sprite = U:getSpriteByName(self._options.bg)

                size = sprite:getContentSize()
                sprite:setPosition(cc.p(size.width/2, size.height/2))
                self.rootNode:addChild(sprite)
            end

            if not self._options.frameWidth then self._options.frameWidth = size.width end
            if not self._options.frameHeight then self._options.frameHeight = size.height end

            self.rootNode:setContentSize(size)

--            self.rootNode:registerScriptTouchHandler(function(eventType, x, y)
--                if eventType == "began" then -- touch began
--                    local rect = self:getRootNode():getBoundingBox()
----                    local rect=cc.rect(0,0,size.width,size.height)
--                    if not cc.rectContainsPoint(rect, self.rootNode:convertToNodeSpace(cc.p(x,y))) then -- rect:containsPoint() then
--                        return false
--                    end
--                    return true
--                end
--
--            end, false, self._options.priority, true)
--            self.rootNode:setTouchEnabled(true)
        end

        return self.rootNode
    end,

    getDefaultOptions = function(self)
        return {
            bg = nil,
            direction = 1,
            frameWidth =  nil,
            frameHeight =  nil,
            pageSize = 10,
            listSpacing = 0,
            spacing = 0,
            align = "top",
            priority = Slot.TouchPriority.dialog_list,
            margin = {l=0,t=0, r=0, b=0},
            cellAtIndex = function(opt, data, index, _list) return cc.Node:create() end,
            createHeader = function(opt) return cc.Node:create() end,
            createFooter = function(opt) return cc.Node:create() end,
            close = function(opt) end,
        }
    end
})