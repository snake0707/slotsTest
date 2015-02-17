--
-- Created by IntelliJ IDEA.
-- User: xiaofuan
-- Date: 15-1-5
-- Time: 下午5:52
-- To change this template use File | Settings | File Templates.
--

Slot = Slot or {}

Slot.ui = Slot.ui or {}

Slot.ui.PageView = Slot.ui.UIComponent:extend({
    __className = "Slot.ui.PageView",

    initWithCode = function(self, options)
        self:_super(options)
        self:clear()
    end,

    load = function(self)
        self._options:loadFunc(self, #self.children)
    end,

    clear = function(self)

        self.children = {}
        self._numOfNewData = 0
        self:removeAllPages()
        self.rootNode:setContentSize(cc.size(self._options.frameWidth,self._options.frameHeight))
    end,

    reload = function(self)
        self:clear()
        self:load()
    end,

    appendData = function(self, dataInArray)

        self._numOfNewData = #dataInArray

        if U:equal(self._numOfNewData, 0) then

        else

            local cell
            for i,data in ipairs(dataInArray) do
                local layout = ccui.Layout:create()
                layout:setContentSize(cc.size(self._options.frameWidth, self._options.frameHeight))

                cell = self._options:cellAtIndex(data,i,self)
                local p = cell:getAnchorPoint()
                if cell:isIgnoreAnchorPointForPosition() then p=cc.p(0,0) end

--                cell:setPosition(cc.p(self._options.frameWidth / 2 + (p.x-0.5) * cell:getContentSize().width, self._options.frameHeight / 2 + (p.x-0.5) * cell:getContentSize().height))
                --cell:setContentSize(cc.size(self._options.frameWidth, self._options.frameHeight))
                cell:setPosition(cc.p(layout:getContentSize().width / 2, layout:getContentSize().height / 2))

                layout:addChild(cell)
                self:addPage(layout)
                table.insert(self.children, layout)
            end
        end

    end,

    removeAllPages = function(self)
       self.rootNode:removeAllPages()
    end,

    removePageAtIndex = function(self, index)
        self.rootNode:removePageAtIndex(index)
    end,

    addPage = function(self, node)
        self.rootNode:addPage(node)
    end,

    getCurPageIndex = function(self)

        return self.rootNode:getCurPageIndex()

    end,

    registEvent = function(self, callback)

        local function pageViewEvent(sender, eventType)
            if eventType == ccui.PageViewEventType.turning then

                if callback and type(callback) == "function" then

                    callback(sender)

                end


            end
        end

        self.rootNode:addEventListener(pageViewEvent)

    end,

    scrollToPage = function(self, index)
        self.rootNode:scrollToPage(index)

    end,
--
    getRootNode = function(self)
        if not self.rootNode then
            self.rootNode = ccui.PageView:create()
            self.rootNode:setTouchEnabled(true)
            self.rootNode:setContentSize(cc.size(self._options.frameWidth, self._options.frameHeight))
        end
        return self.rootNode
    end,

    getDefaultOptions = function(self)
        return {
            frameWidth = 1656,
            frameHeight = 1016,
            loadFunc = function(that,self,current,page) end,
            cellAtIndex = function(that,data,index,self) end,
        }
    end
})
