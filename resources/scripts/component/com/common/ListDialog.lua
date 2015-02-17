--
--bbf
--
Slot = Slot or {}
Slot.com = Slot.com or {}
Slot.com.ListDialog = Slot.ui.Dialog:extend({
    __className  = "Slot.com.ListDialog",


    initWithCode = function(self, options, listData)
        self.listData = listData or {}
        self._nodes = {}
        self:_super(options)
    end,


    _setup = function(self)
        self._options.content = self:_createContent()
        self._options.content:setContentSize(self:_getContentSize())
        
        self:_super()

        if self.header then
            local headerSize = cc.size(self.size.width, self.header:getContentSize().height)
            self.headerLabel:setAnchorPoint(cc.p(0,0.5))
            self.headerLabel:setPositionX(5)
            self.header:setContentSize(headerSize)
            self.header:setPosition(cc.p(-5,self:_getContentSize().height - self:_getHeaderHeight() + 5))
        end

        if self.emptyNode then
            self.emptyNode:setPositionY(self:_getContentSize().height - self:_getHeaderHeight() - self.emptyNode:getContentSize().height - 5)
        end

    end,


    _getContentSize = function(self)
        local winsize = cc.Director:getInstance():getWinSize()
        local contentHeight = self._options.dlgHeight or (winsize.height
                - self._options.dlgMarginWin * 2
                - Slot.const.titleboard.titleheight)

        if self._options.header then
            contentHeight = contentHeight - self.header:getContentSize().height
        end

        if self._options.btn then
            contentHeight = contentHeight - self._options.btnsHeight
        end

        if self._options.bottomHeight then
            contentHeight = contentHeight + self._options.bottomHeight
        end

        return cc.size(self._options.dlgWidth, contentHeight)
    end,


    _createContent = function(self)

        if self._options.header then
            table.insert(self._nodes, self:_createHeader())
        end

        if #self.listData <= 0 then
            table.insert(self._nodes, self:_createEmptyLabel())
        end

        local list = self:_createList()
        table.insert(self._nodes, list)

        if self._options.createBottom then
            local bottom = self._options.createBottom()
            table.insert(self._nodes, bottom)
        end
        return U:layerWithChildrenVertical(self._nodes, 10)
    end,


    _createEmptyLabel = function(self)
        self.emptyNode = cc.LabelTTF:create(self._options.emptyLabel, Slot.Font.default, 16, cc.size(self:getContentSize().width, 0), kCCTextAlignmentCenter)
        self.emptyNode:setColor(Slot.CCC3.brown)
        self.emptyNode:setVisible(false)

        return self.emptyNode
    end,


    _createHeader = function(self)
        self.headerLabel = cc.LabelTTF:create(self._options.header, Slot.Font.default, 14)
        self.headerLabel:setColor(Slot.CCC3.dialogHeader)

        self.header = cc.LayerColor:create(Slot.CCC4.gray, 290, self.headerLabel:getContentSize().height + 4)
        U:addToCenter(self.headerLabel, self.header)

        return self.header
    end,


    _getHeaderHeight = function(self)
        if self.header then
            return self.header:getContentSize().height
        else
            return 0
        end
    end,


    _addFooterButtons = function(self)
        -- TODO 此处实现list最底下的buttons
    end,


    _createList = function(self)
        local frameHeight = self:_getContentSize().height - self:_getHeaderHeight()
        if self._options.bottomHeight then
            frameHeight = frameHeight - self._options.bottomHeight
        end

        self._list = Slot.ui.List:new({
            pageSize    = self._options.pageSize,
            showMore    = self._options.showMore,
            frameWidth  = self._options.dlgWidth,
            frameHeight = frameHeight,
            inDlg       = self._options.inDlg,
            cellSize    = function()
            end,
            nothingToAppend = function()
            end,
            cellAtIndex = function(opt,data, index, list)
                return self._options.cellAtIndex(opt,data, index, list)
            end,
            loadFunc    = function(opt, slider, current, page)
                self._options.loadFunc(opt, slider, current, page)
            end
        })
        self._list:appendData(self.listData)

        if #self.listData <= 0 then
            if self.emptyNode then
--                self.emptyNode:setVisible(true)
            end
        end

        self._list:reSize()
--        self._list:setTouchPriority(Slot.TouchPriority.dialog)

        return self._list
    end,


    _nothingToAppend = function(self)
    end,


    appendData = function(self, data)
        if #data > 0 or #self._list.children > 0 then
            if self.emptyNode then
                self.emptyNode:setVisible(false)
            end
            self._list:appendData(data)
        else
            if self.emptyNode then
                self.emptyNode:setVisible(true)
            end
        end

        if self._options.showMore == true then
            if #data < self._options.pageSize then
                self._list:hideMoreBtn()
                self._list:reSize()
            else
                self._list:showMoreBtn()
                self._list:reSize()
            end
        end
    end,


    getDefaultOptions = function(self)
        return U:extend(true, self:_super(), {
            title           = "titles",
            inDlg           = true,
            dlgMarginWin    = 90,
            btnsHeight      = 70,
            dlgWidth        = 300,
            dlgHeight       = nil,
            header          = nil,
            emptyLabel      = "没有找到数据哦~",
            pageSize        = 50,
            showMore        = false,
            createBottom    = nil,    -- 创建弹出框底下内容的方法
            btns            = {}
        })
    end,
})
