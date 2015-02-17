--
-- by bbf
--
Slot = Slot or {}

Slot.ui = Slot.ui or {}

Slot.ui.List = Slot.ui.Scroller:extend({
    __className = "Slot.ui.List",
    _isTap=true,
    _lastX=0,
    _lastY=0,
    initWithCode = function(self, options)
        self:_super(options)
        self:_initPrivateData()
        if self._options.onItemClick and type(self._options.onItemClick) == 'function' then
            self:_initTapAwareCell()
        end
    end,

    _initTapAwareCell=function(self)
        local touchfunc=function(eventType,x,y)
                    if eventType=='began' then
                        return self:_onTouchBegan(x,y)
                    elseif eventType=='moved' then
                        return self:_onTouchMoved(x,y)
                    elseif eventType=='ended' then
                        return self:_onTouchEnded(x,y)
                    end
        end

        if self._options.usingNativeScroll then
            self.scroview:setTouchEnabled(true)
            self.scroContainer:setTouchEnabled(true)
            self.scroContainer:registerScriptTouchHandler(touchfunc,false,self._options.priority,self._options.swallow)
        else
            self:addCustomScrollHandler(touchfunc,
                self._options.priority,
                self._options.swallow,true)
        end
    end,

    _onTouchBegan=function(self,x,y)
        local rect=cc.rect(0,0,self._options.frameWidth,self._options.frameHeight)
        if not cc.rectContainsPoint(rect, self.rootNode:convertToNodeSpace(cc.p(x,y))) then -- rect:containsPoint() then
            return false
        end
        self._isTap=true
        self._lastX,self._lastY=x,y
        return true
    end,
    _onTouchMoved=function(self,x,y)
        self._isTap=false
        local dx=x-self._lastX
        local dy=y-self._lastY

        if self._options.ignoremove then
            local framesize =self._contentSize
            if math.abs(dx)<=framesize.width/100 and math.abs(dy)<=framesize.height/100 then
                self._isTap=true
            end
        end

        
        if self._options.usingNativeScroll then return true end
        local tx=self:getContentOffset().x+dx
        local ty=self:getContentOffset().x+dy
        local cx,cy=self.scroview:getContentOffset().x,self.scroview:getContentOffset().y
        if self._options.direction==1 then
            self.scroview:setContentOffset(cc.p(cx,cy+dy),false)
        else
            self.scroview:setContentOffset(cc.p(cx+dx,cy),false)
        end
        self._lastX,self._lastY=x,y
        return true
    end,
    _onTouchEnded=function(self,x,y)
        if self._isTap then
            local p=self.scroview:convertToNodeSpace(cc.p(x,y))
            local offset=self.scroview:getContentOffset()
            local p1=cc.p(p.x-offset.x,p.y-offset.y)
            local index,target=0,nil
            for k,v in pairs(self.children) do
                local node=v
                if U:isUI(v) then node=v:getRootNode() end
                if cc.rectContainsPoint(node:getBoundingBox(), p1) then
                    index,target=k,v
                end
            end
            if index>0 then
                self._options:onItemClick(index,target,x,y)  
            end
            return true
        end
        if self._options.usingNativeScroll then return end
        local cx,cy=self.scroview:getContentOffset().x,self.scroview:getContentOffset().y
        if self._options.direction==1 then
            self:scrollTo(0,-cy,true)
        else
            self:scrollTo(-cx,0,true)
        end
        
    end,


    _initPrivateData = function(self)

        self.children = {}
        self._listHeight = 0
        self._listWidth = 0
        self._numOfCells = 0
        self._cellSize = cc.size(0,0)
--        self._isTap=true
--        self._lastX=0
--        self._lastY=0
    end,

    scrollToTop = function(self)                             -- 将列表滑动到最上面
        if self._options.direction == 1 then
            self:scrollTo(0,self._listHeight)
        else
            self:scrollTo(0,0)
        end

    end,

    scrollToBottom = function(self)                             -- 将列表滑动到最底部

        if self._options.direction == 1 then
            self:scrollTo(0,0)
        else
            self:scrollTo(0,self._listWidth)
        end
    end,

    scrollToNext = function(self, uporleft)
        if self._options.direction == 1 then
            local offset = self._cellSize.height
            if not uporleft then
                offset = -self._cellSize.height
            end
            self:scrollInY(offset)
        else
            local offset = -self._cellSize.width
            if not uporleft then
                offset = self._cellSize.width
            end
            self:scrollInX(offset)
        end

    end,

    load = function(self)
        self._options:loadFunc(self, #self.children, self._options.pageSize)
    end,

    clear = function(self)

        self.children = {}
        self._preHeight = nil
        self._preWidth = nil
        self._listHeight = 0
        self._listWidth = 0
        self._numOfNewData = 0
        self._cellSize = cc.size(0,0)
        self:removeAllChildren()
        self:setContentSize(self._options.frameWidth,self._options.frameHeight)
    end,

    reload = function(self)
        self:clear()
        self:load()
    end,

    appendData = function(self, dataInArray)

        self._numOfNewData = #dataInArray

        if U:equal(self._numOfNewData, 0) then
--            self:nothingToAppend()
        else
            local cell
            for i,data in ipairs(dataInArray) do
                cell = self._options:cellAtIndex(data,i,self)
                local p = cell:getAnchorPoint()
                if cell:isIgnoreAnchorPointForPosition() then p=cc.p(0,0) end

                if self._options.direction == 1 then
                    cell:setPositionX(self._options.frameWidth / 2 + (p.x-0.5) * cell:getContentSize().width)
                else
                    cell:setPositionY(self._options.frameHeight / 2 + (p.y-0.5) * cell:getContentSize().height)
                end

                self:addChild(cell)
                table.insert(self.children,cell)

                local size = cell:getContentSize()
                if self._cellSize.width < size.width then self._cellSize.width = size.width end
                if self._cellSize.height < size.height then self._cellSize.height = size.height end

                --                if i<5 and cell.rootNode and type(cell.rootNode.setOpacity) == "function" then    -- 去掉动画
--                    self:runAnimation(cell, 0.2)
--                end
            end
--            self:_addFooterButtons()
            self:reSize()

            self._contentSize = self.rootNode:getContentSize()
            self._listHeight = self._contentSize.height
            self._listWidth = self._contentSize.width
            self:setContentSize(self._listWidth, self._listHeight)
        end

        if self._options.direction == 1 then
            self:resetScrollInY()
        else
            self:resetScrollInX()
        end

        self:appendDidFinish()
    end,

    runAnimation = function(self, cell, time)
        cell.rootNode:setOpacity(0)
        local fadeAction = cc.FadeIn:create(time)
        cell.rootNode:runAction(fadeAction)
    end,

    reSize = function(self)
        if self._options.direction == 1 then
            U:reLayoutVertical(self.scroContainer, self._options.spacing, 1)
        else
            U:reLayoutHoriztal(self.scroContainer, self._options.spacing, self._options.hasmargin, true)
        end
    end,

    resetScrollInY = function(self)
        if self._preHeight then
            self:scrollInY(self._preHeight - self._listHeight)
        else
            self:scrollInY(-self._listHeight)
        end

        self._preHeight = self._listHeight

    end,

    resetScrollInX = function(self)
        local pre
        if self._preWidth then
            pre = self._preWidth
        else
            pre = 0
        end
        self:scrollInX(pre)

        self._preWidth = pre

    end,

    appendDidFinish = function(self) end,

    getDefaultOptions = function(self)
        return {
            direction = 1,
            frameWidth =  306,
            frameHeight =  280,
            footerWidth = 294,
            pageSize = 10,
            spacing = 4,
            loadFunc = function(that,self,current,page) end,
            cellAtIndex = function(that,data,index,self) end,
            ignoremove=false,
            swallow = false,
            priority = Slot.TouchPriority.list,
        }
    end
})