--
-- by bbf
--
Slot = Slot or {}

Slot.ui = Slot.ui or {}

Slot.ui.ColumnLayout = Slot.ui.Layout:extend({

    __className = "Slot.ui.ColumnLayout",

    init = function(self,options,parent)
        self:_super(options,parent)
        self.left      = self._options.marginLeft
    end,

    setParent = function(self,parent)
        self:_super(parent)
        self.left      = self._options.marginLeft
    end,

    update = function(self)
        self.size      = self.__parent:getContentSize()
        self.rect      = cc.rect(0,0,self.size.width,self.size.height)
        self.left      = self._options.marginLeft
        self:layoutSubviews()
    end,

    setChildPosition = function(self,child,constraint)
        if self._options.type == "flow" then
            self:setChildFlowPosition(child)
        end
    end,

    setChildFlowPosition = function(self,child)
        if self.constraints[child] then
            self.left   = self.left + self._options.spacing

            local size  = self.__parent:getContentSize()
            local rect  = cc.rect(0,0,size.width,size.height)
            local pos   = self:getVCenterPosition(child,rect,size,self.left)
            self.constraints[child]:afterLocate(child,pos)
            self.left   = self.left + child:getContentSize().width
        end
    end,

    getDefaultConstraint = function(self,options)
        return U:extend(false,
            {
                align    = "center", -- "center" "top" "bottom"
                afterLocate = function(cons,ccnode,pos)
                    ccnode:setPosition(pos)
                end
            },options)
    end,

    layoutSubviews = function(self)
        if self._options.type == "flow" then
            self:layoutFlowSubviews()
        else
            self:layoutEqualSubviews()
        end
    end,

    layoutEqualSubviews = function(self)
        local children = self.__parent:getRootNode():getChildren()
        if #children > 0 then
            local count    = #children
            local width    = self.__parent:getContentSize().width
            width          = width - self._options.marginLeft - self._options.marginRight
            local childwidth = 0
            for i = 1,count,1 do
                local node = children[i]
                childwidth = childwidth + node:getContentSize().width
            end

            local spacing  = (width - childwidth)/(count+1)
            local temp     =  self._options.marginLeft
            for i = 1,count,1 do
                temp       = temp + spacing
                local node = children[i]
                local pos  = self:getVCenterPosition(node,self.rect,self.size,temp)
                self.constraints[node]:afterLocate(node,pos)
                temp       = temp + node:getContentSize().width
            end
        end
    end,

    layoutFlowSubviews = function(self)
        local children = self.__parent:getRootNode():getChildren()
        if #children > 0 then
            local width    = self._options.marginLeft
            for i = 1,#children,1 do
                width      = width + self._options.spacing
                local node = children[i]
                local pos  = self:getVCenterPosition(node,self.rect,self.size,width)
                self.constraints[node]:afterLocate(node,pos)
                width      = width + node:getContentSize().width
            end
        end
    end,

    getDefaultOptions = function(self)
        return {
            type          = "flow", --- flow or equal,equal will ignore the spacing
            marginLeft    = 0,
            marginRight   = 0,
            cols          = 1,
            spacing       = 0
        }
    end,
})