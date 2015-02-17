--
-- by bbf
--
Slot = Slot or {}

Slot.ui = Slot.ui or {}

Slot.ui.DockLayout = Slot.ui.Layout:extend({

    __className = "Slot.ui.DockLayout",

    init = function(self,options,parent)
        self:_super(options,parent)
        self.area        = {}
    end,

    setChildPosition = function(self,child,constraint)
        if constraint.type == "top" then
            self:_addTopArea(child,constraint)
        end

        if constraint.type == "bottom" then
            self:_addBottomArea(child,constraint)
        end

        if constraint.type == "left" then
            self:_addLeftArea(child,constraint)
        end

        if constraint.type == "right" then
            self:_addRightArea(child,constraint)
        end

        if constraint.type == "center" then
            self:_addCenterArea(child,constraint)
        end
    end,

    _addTopArea  = function(self,child)
        if self.area["top"] and self.area["top"]:isRunning() then
            error("")
        else
            local pos = self:getHCenterPosition(child,self.rect,self.size.height - child:getContentSize().height)
            self.rect.height =  self.rect.height  - child:getContentSize().height
            self.constraints[child]:afterLocate(child,pos)
        end
    end,

    _addLeftArea = function(self,child)
        if self.area["left"] and self.area["left"]:isRunning() then
            error("")
        else
            local pos = self:getVCenterPosition(child, self.rect, self.size,0)
            self.rect.x  =  child:getContentSize().width
            self.rect.width = self.rect.width - child:getContentSize().width
            self.constraints[child]:afterLocate(child,pos)
        end
    end,

    _addRightArea = function(self,child)
        if self.area["right"] and self.area["right"]:isRunning() then
            error("")
        else
            local pos = self:getVCenterPosition(child, self.rect, self.size,self.size.height - child:getContentSize().width)
            self.rect.width = self.rect.width - child:getContentSize().width
            self.constraints[child]:afterLocate(child,pos)
        end
    end,

    _addBottomArea = function(self,child)    -- 修改为底部居左
        if self.area["bottom"] and self.area["bottom"]:isRunning() then
            error("")
        else
            local pos = self:getHLeftPosition(child,self.rect,0)
            self.rect.y = child:getContentSize().height
            self.rect.height =  self.rect.height  - child:getContentSize().height
            self.constraints[child]:afterLocate(child,pos)
        end
    end,

    _addCenterArea  = function(self,child,constraint)
        if self.area["center"] and self.area["center"]:isRunning() then
            error("")
        else
            if     constraint.align == "bottom" then
                local pos = self:getHCenterPosition(child,self.rect,self.rect.y)
                self.constraints[child]:afterLocate(child,pos)
            elseif constraint.align == "center" then

                local ap     = child:getAnchorPoint()
                if child:isIgnoreAnchorPointForPosition() then ap=cc.p(0,0) end
                local pos = self:getHCenterPosition(child,self.rect,0)
                pos.y =  self.rect.height * 0.5 + (ap.y - 0.5) * child:getContentSize().height + self.rect.y

                self.constraints[child]:afterLocate(child,pos)
            elseif constraint.align == "top"    then
                local pos = self:getHCenterPosition(child,self.rect,self.size.height - child:getContentSize().height )
                self.constraints[child]:afterLocate(child,pos)
            end
        end
    end,

    getDefaultConstraint = function(self,options)
        return U:extend(false,
            {
                type    = "center",  -- "center" "left" "right"  "top" "bottom"
                align   = "bottom",  -- "center" "top"  "bottom"
                afterLocate = function(cons,ccnode,pos)
                            ccnode:setPosition(pos)
                        end
            },options)
    end,

    layoutSubviews    = function(self)
        local children = self.__parent:getRootNode():getChildren()
        if #children > 0 then
            for i = 1,#children,1 do
                local node = children[i]
                if  self.constraints[node] then
                    self:setChildPosition(node,self.constraints[node])
                end
            end
        end
    end,

    getDefaultOptions = function(self)
        return { }
    end,
})