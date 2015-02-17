--
-- by bbf
--
Slot = Slot or {}

Slot.ui = Slot.ui or {}

Slot.ui.GridLayout = Class:extend({

    __className = "Slot.ui.GridLayout",

    init = function(self,options,parent)
        self.__parent = parent
        self._options = U:extend(false,self:getDefaultOptions(), options)
        self.count = 0
        self.left  = 0
        self.height = parent:getContentSize().height
    end,

    update = function(self)
        self.height = self.__parent:getContentSize().height
        self.left  = 0
        self.count = 0
        self:layoutSubviews()
    end,

    setChildPosition = function(self,child)
        self.count = self.count + 1
        local options = child:getLayoutOptions()

        if self.count % self._options.row == 1 then
            self.left = self._options.cellspacing.width
            self.height = self.height - self._options.cellsize.height - self._options.cellspacing.height
        end
        child:setAnchorPoint(cc.p(0,0))
        child:setPosition(cc.p(self.left, self.height))

        self.left = self.left + self._options.cellsize.width + self.cellSpacing.width
    end,

    addChild = function(self,child)
        self:setChildPosition(child)
        self.__parent:addChild(child)
    end,

    layoutSubViews = function(self)
        local children = self.__parent:getChildren()
        for i,c in ipairs(children) do
            self:setChildPosition(c)
        end
    end,

    getDefaultOptions = function(self)
        return {
            cols = 1,
            rows = 1,
            cellsize = cc.size(50,50),
            cellspacing = cc.size(0,0)
        }
    end,

})