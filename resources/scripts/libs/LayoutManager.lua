--
-- by bbf
--


Slot.libs = Slot.libs or {}

Slot.libs.LayoutManager = {}

Slot.libs.Layout = Class:extend({

    __className = "Slot.libs.Layout",

    init = function(self,parent)
        self.__parent = parent
        self.children = {}
    end,

    addChild = function(self,child,needLayout,zorder)
        needLayout = needLayout or false
        zorder = zorder or 0
        table.insert(self.children,child)
        self.__parent:addChild(child,zorder)
        if needLayout then  self:layoutSubviews() end
    end,

    removeChild = function(self,child,needLayout)
        needLayout = needLayout or false
        for i,c in ipairs(self.children) do
            if c == child then
                table.remove(self.children,i)
            end
        end

        self.__parent:removeChild(child)
        if needLayout then  self:layoutSubviews() end
    end,

    removeChildren = function(self,needLayout)
        needLayout = needLayout or false
        self.children = {}
        self.__parent:removeAllChildren()
        if needLayout then  self:layoutSubviews() end
    end,

    layoutSubviews = function(self)

    end,

    layoutSubviewsWithAction = function(self)

    end,

    runActions = function(self, actionCreators)

        for i,c in ipairs(self.children) do
            for n,creator in ipairs(actionCreators) do
                c:runAction(creator())
            end
        end
    end
})
--- flow layout in horiztal
Slot.libs.Layout.HFlowLayout = Slot.libs.Layout:extend({

    __className = "Slot.libs.Layout.HFlowLayout",

    init = function(self,parent,spacing)
        self:_super(parent)
        self.spacing  = spacing
        self.startpos = cc.p(0,0)
        self.align    = "left"
    end,

    setStartPosition = function(self,nccp)
        self.startpos = nccp
    end,

    setAlign = function(self,alian) --left right
        self.align = alian
    end,

    layoutSubviews = function(self)
       if self.align  == "left" then
            local offsetX = self.startpos.x
            for i,c in ipairs(self.children) do
                local ap   = c:getAnchorPoint()
                if c:isIgnoreAnchorPointForPosition() then ap=cc.p(0,0) end
                local s    = c:getContentSize()
                local scaleX = c:getScaleX()
                local scaleY = c:getScaleY()
                if scaleX == 0 then scaleX = 1 end
                if scaleY == 0 then scaleY = 1 end
                c:setPosition(cc.p(offsetX + s.width * ap.x * scaleX ,self.startpos.y + s.height * ap.y * scaleY))
                offsetX = offsetX + s.width * scaleX  + self.spacing
            end
        else
            local offsetX = self.startpos.x
            for i,c in ipairs(self.children) do
                local ap   = c:getAnchorPoint()
                if c:isIgnoreAnchorPointForPosition() then ap=cc.p(0,0) end
                local s    = c:getContentSize()
                local scaleX = c:getScaleX()
                local scaleY = c:getScaleY()
                if scaleX == 0 then scaleX = 1 end
                if scaleY == 0 then scaleY = 1 end
                c:setPosition(cc.p(offsetX - s.width * (1 - ap.x) * scaleX ,self.startpos.y + s.height * ap.y * scaleY))
                offsetX = offsetX - s.width * scaleX  - self.spacing
            end
        end
    end
})

--- flow layout in horiztal but it will be in horiztal center position
Slot.libs.Layout.CenterHoriztalLayout = Slot.libs.Layout.HFlowLayout:extend({

    __className = "Slot.libs.Layout.CenterHoriztalLayout",

    init = function(self,parent,spacing)
        if spacing == nil then spacing = 0 end
        self:_super(parent,spacing)
    end,

    layoutSubviews = function(self)
        local width = 0
        for i,c in ipairs(self.children) do
            local s = c:getContentSize()
            width = width + s.width * c:getScaleX() + self.spacing
        end
        local twidth = self.__parent:getContentSize().width
        local marginleft = (twidth  - width)/2
        self.startpos = cc.p(self.startpos.x + marginleft , self.startpos.y)
        self:_super()
    end
})


--- equal layout in horiztal
Slot.libs.Layout.NHoriztalLayout =  Slot.libs.Layout:extend({

    __className = "Slot.libs.Layout.NHoriztalLayout",

    init = function(self,parent)
        self:_super(parent)
        self.startpos = cc.p(0,0)
        self.width = parent:getContentSize().width
    end,

    setStartPosition = function(self,nccp)
        self.startpos = nccp
    end,

    setWidth = function(self,width)
        self.width = width
    end,

    layoutSubviews = function(self)

        local childwidth = 0
        for i,c in ipairs(self.children) do
            childwidth = childwidth +  c:getContentSize().width
        end

        local n = #self.children + 1
        local padding = (self.width - childwidth)/n
        local offsetX = self.startpos.x
        for i,c in ipairs(self.children) do
            offsetX = offsetX + padding

            local size = c:getContentSize()
            local ap   = c:getAnchorPoint()
            if c:isIgnoreAnchorPointForPosition() then ap=cc.p(0,0) end
            c:setPosition(cc.p(offsetX + size.width * ap.x,self.startpos.y + size.height * ap.y))
            local s = c:getContentSize()
            offsetX = offsetX + s.width
        end
    end,

})

--- flow layout in vertical
Slot.libs.Layout.VFlowLayout = Slot.libs.Layout:extend({

    __className = "Slot.libs.Layout.VFlowLayout",

    init = function(self,parent,spacing)
        self:_super(parent)
        self.spacing = spacing
        self.startpos = cc.p(0,self.__parent:getContentSize().height)
    end,

    setStartPosition = function(self,nccp)
        self.startpos = nccp
    end,

    layoutSubviews = function(self)
        local offsetY = self.startpos.y
        for i,c in ipairs(self.children) do
            c:setAnchorPoint(cc.p(0,0))
            local s = c:getContentSize()
            local x = self.startpos.x + self.__parent:getContentSize().width/2 - s.width/2
            offsetY = offsetY - s.height
            c:setPosition(cc.p(x,offsetY))
            offsetY = offsetY  - self.spacing
        end
    end,

    layoutSubviewsWithAction = function(self, action)

    end
})

--- equal layout in vertical
Slot.libs.Layout.NVerticalLayout = Slot.libs.Layout:extend({

    __className = "Slot.libs.Layout.NVerticalLayout",

    init = function(self,parent,marginY)
        self:_super(parent)
        self.marginY = marginY
    end,
})

--- It's a grid layout
Slot.libs.Layout.GridLayout = Slot.libs.Layout:extend({

    __className = "Slot.libs.Layout.GridLayout",

    init = function(self,parent,rows,cols)
        self:_super(parent)
        self.row,self.col = rows,cols
        self.cellSpacing = cc.size(0,0)
    end,

    setCellSpacing = function(self,size)
        self.cellSpacing = size
    end,

    layoutSubviews = function(self)
        local ps   = self.__parent:getContentSize()
        local left = self.cellSpacing.width
        local cellsize = self.children[1]:getContentSize()
        local height = ps.height
        for i,c in ipairs(self.children) do
            if i%self.row == 1 then
                left   = self.cellSpacing.width
                height = height - cellsize.height - self.cellSpacing.height
            end
            local ap = c:getAnchorPoint()
            if c:isIgnoreAnchorPointForPosition() then ap=cc.p(0,0) end
            c:setPosition(cc.p(left+cellsize.width*ap.x,height+cellsize.height*ap.y))

            left = left + cellsize.width + self.cellSpacing.width
        end
    end,

})
--- add shorcut for this Slot.libs.Layout

Slot.Layout = Slot.libs.Layout