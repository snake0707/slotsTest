--
-- by bbf
--
Slot = Slot or {}

Slot.ui = Slot.ui or {}

Slot.ui.AbsoluteLayout = Slot.ui.Layout:extend({

    __className = "Slot.ui.AbsoluteLayout",

    init = function(self,options,parent)
        self:_super(options,parent)
    end,

    setChildPosition = function(self,child,constraint)
        constraint:afterLocate(child,constraint.position)
    end,

    getDefaultConstraint = function(self,options,child)
        local ap    = child:getAnchorPoint()
        if child:isIgnoreAnchorPointForPosition() then ap=cc.p(0,0) end

        local px,py = child:getPosition()
        local t     = U:extend(false,
            {
                anchorPoint = ap,
                position    = cc.p(px,py),
                afterLocate = function(cons,ccnode,position)
                    ccnode:setAnchorPoint(cons.anchorPoint)
                    ccnode:setPosition(position)
                end
            },options)

        return t
    end,

    layoutSubviews = function(self)
        local children = self.__parent:getRootNode():getChildren()
        if #children > 0 then
            for i = 1,#children,1 do
                local node = children[i]
                self:setChildPosition(node,self.constraints[node])
            end
        end
    end,

    getDefaultOptions = function(self)
        return {

        }
    end,
})