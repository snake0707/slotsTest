--
-- by bbf
--
Slot = Slot or {}

Slot.ui = Slot.ui or {}

Slot.ui.RowLayout = Slot.ui.Layout:extend({

    __className = "Slot.ui.RowLayout",

    init = function(self,options,parent)
        self:_super(options,parent)
        if parent then
            self.height  = self.__parent:getContentSize().height - self._options.marginTop - self._options.marginBottom
        end
    end,

    setParent = function(self,parent)
        self:_super(parent)
        self.height      = self.__parent:getContentSize().height - self._options.marginTop - self._options.marginBottom
    end,

    update = function(self)
        self.size        = self.__parent:getContentSize()
        self.rect        = cc.rect(0,0,self.size.width,self.size.height)
        self.height      = self.size.height - self._options.marginTop - self._options.marginBottom
        self:layoutSubviews()
    end,

    setChildPosition = function(self,child,constraint)
        if self._options.type == "flow" then
            self:setChildFlowPosition(child)
        end
    end,

    setChildFlowPosition = function(self,child)
        if self.constraints[child] then
            if child:isVisible() then
                local children = self.__parent:getRootNode():getChildren()

                if #children == 0 and self._options.headspacing then
                    self.height = self.height - self._options.spacing
                elseif #children > 0 then
                    self.height = self.height - self._options.spacing
                end
                self.height = self.height - child:getContentSize().height
                local size  = self.__parent:getContentSize()
                local rect  = cc.rect(0,0,size.width,size.height)
                local pos   = self:getHCenterPosition(child,rect,self.height)
                self.constraints[child]:afterLocate(child,pos)
            end
        end
    end,

    getDefaultConstraint = function(self,options)
        return U:extend(false,
            {
                align    = "center", -- "center" "left" "right"
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
            local height   = self.__parent:getContentSize().height
            height         = height - self._options.marginTop - self._options.marginBottom

            local childheight = 0
            for i = 1,count,1 do
                local node  = children[i]
                childheight = childheight + node:getContentSize().height
            end
            local spacingcount = count - 1
            if self._options.headspacing then
                spacingcount = spacingcount + 1
            end
            if self._options.tailspacing then
                spacingcount = spacingcount + 1
            end

            local spacing = (height- childheight)/spacingcount

            for i = 1,count,1 do
                if self._options.headspacing and i == 1 then
                    height     = height - spacing
                end

                local node = children[i]
                height     = height - node:getContentSize().height
                local pos  = self:getHCenterPosition(node,self.rect,height)
                self.constraints[node]:afterLocate(node,pos)

                if i ~= count then
                    height     = height - spacing
                else
                    if self._options.tailspacing then
                        height     = height - spacing
                    end
                end
            end
        end
    end,

    layoutFlowSubviews = function(self)
        local children = self.__parent:getRootNode():getChildren()
        if #children > 0 then
            local count    = #children
            local height   = self.__parent:getContentSize().height
            height         = height - self._options.marginTop - self._options.marginBottom
            for i = 1,count,1 do
                local node = children[i]
                if node:isVisible() then
                    if self._options.headspacing then
                       height     = height - self._options.spacing
                    end
                    height     = height - node:getContentSize().height
                    local pos  = self:getHCenterPosition(node,self.rect,height)
                    self.constraints[node]:afterLocate(node,pos)
                    height     = height - self._options.spacing
                end
            end
        end
    end,

    getDefaultOptions = function(self)
        return {
                    spacing      = 0,
                    type         = "flow", --- flow or equal,equal will ignore the spacing
                    marginTop    = 0,
                    marginBottom = 0,
                    rows         = 1,
                    headspacing  = true,
                    tailspacing  = true
               }
    end,
})