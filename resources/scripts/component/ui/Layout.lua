--
-- by bbf
--

Slot = Slot or {}

Slot.ui = Slot.ui or {}

Slot.ui.Layout = Class:extend({

    __className  = "Slot.ui.Layout",

    init  = function(self,options,parent)
        self._options    = U:extend(false,self:getDefaultOptions(), options)
        self.constraints = {}
        if parent then
            self.__parent  = parent
            self.size    = self.__parent:getContentSize()
            self.rect    = cc.rect(0,0,self.size.width,self.size.height)
        end
    end,

    update = function(self)
        self.size        = self.__parent:getContentSize()
        self.rect        = cc.rect(0,0,self.size.width,self.size.height)
        self:layoutSubviews()
    end,

    setParent = function(self,parent)
        self.__parent      = parent
        self.size        = self.__parent:getContentSize()
        self.rect        = cc.rect(0,0,self.size.width,self.size.height)
    end,

    addChild = function(self,child)
        local constraint        = child:getLayoutConstraint()
        local child             = child:getRootNode()
        self.constraints[child] = self:getDefaultConstraint(constraint,child)
        self:setChildPosition(child,self.constraints[child])
    end,

    addCCChild = function(self,child,constraint)
        self.constraints[child] =  self:getDefaultConstraint(constraint,child)
        self:setChildPosition(child,self.constraints[child])
    end,

    getEmptyRect = function(self)
        return self.rect
    end,

    getHCenterPosition = function(self, child, rect, hightFromBaseLine)
        local p, left = child:getAnchorPoint(), 0
        if child:isIgnoreAnchorPointForPosition() then
            p = cc.p(0,0)
        end
        left = rect.width / 2 + (p.x - 0.5) * child:getContentSize().width + rect.x
        local height = hightFromBaseLine + p.y * child:getContentSize().height
        return cc.p(left,height)
    end,

    getHLeftPosition = function(self, child, rect, hightFromBaseLine)
        local p, left = child:getAnchorPoint(), 0
        if child:isIgnoreAnchorPointForPosition() then
            p = cc.p(0,0)
        end
        left = p.x * child:getContentSize().width  + rect.x
        local height = hightFromBaseLine + p.y * child:getContentSize().height
        return cc.p(left, height)
    end,

    getHRightPosition = function(self, child, rect, hightFromBaseLine)
        local p, left = child:getAnchorPoint(), 0
        if child:isIgnoreAnchorPointForPosition() then
            p = cc.p(0,0)
        end
        left = rect.width - (1 - p.x) * child:getContentSize().width + rect.x
        local height = hightFromBaseLine + p.y * child:getContentSize().height
        return cc.p(left,height)
    end,

    getVCenterPosition = function(self,child,rect,size,left)
        local p,height = child:getAnchorPoint(),0
        if child:isIgnoreAnchorPointForPosition() then
            p = cc.p(0,0)
        end
        height = (rect.height - rect.y) / 2 + (p.y - 0.5) * child:getContentSize().height + rect.y
        left   = left + p.x * child:getContentSize().width
        return cc.p(left,height)
    end,

    getVBottomPosition = function(self,child,rect,left)
        local p,height = child:getAnchorPoint(),0
        if child:isIgnoreAnchorPointForPosition() then
            p = cc.p(0,0)
        end
        height = p.y * child:getContentSize().height + rect.y
        left   = left + p.x * child:getContentSize().width
        return cc.p(left,height)
    end,

    getVTopPosition = function(self,child,rect,left)
        local p,height = child:getAnchorPoint(),0
        if child:isIgnoreAnchorPointForPosition() then
            p = cc.p(0,0)
        end
        height = rect.height - (1 - p.y) * child:getContentSize().height + rect.y
        left   = left + p.x * child:getContentSize().width
        return cc.p(left,height)
    end,

    getCenterPosition = function(self,child,rect)
        local p,height = child:getAnchorPoint(),0
        if child:isIgnoreAnchorPointForPosition() then
            p = cc.p(0,0)
        end
        height = rect.height / 2 + (p.y - 0.5) * child:getContentSize().height + rect.y
        local left   = rect.width / 2 + (p.x - 0.5) * child:getContentSize().width  + rect.x
        return cc.p(left,height)
    end
})

Slot.ui.Layout.getLayout = function(self,layout,layoutOptions,parent)
    local impl
    if layout == "absolute" then
        impl = Slot.ui.AbsoluteLayout:new(layoutOptions , parent)
    elseif layout == "row" then
        impl = Slot.ui.RowLayout:new(     layoutOptions , parent)
    elseif layout == "column" then
        impl = Slot.ui.ColumnLayout:new(  layoutOptions , parent)
    elseif layout == "dock" then
        impl = Slot.ui.DockLayout:new(    layoutOptions , parent)
    end
    if impl == nil then
        return Slot.ui.AbsoluteLayout:new(layoutOptions , parent)
    end
    return impl
end