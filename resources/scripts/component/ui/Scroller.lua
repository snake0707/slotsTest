--
-- by bbf
--
--[[
-- Usage:
  local scroll = Slot.ui.Scroller:new()
  scroll:addContent(UIComponent Or CCNode)
  scroll:setContentSize(300,200)
 ]]
Slot = Slot or {}

Slot.ui = Slot.ui or {}

Slot.ui.Scroller = Slot.ui.UIComponent:extend({
	
	__className = "Slot.ui.Scroller",

	initWithCode = function(self,options)
		self:_super(options)
	end,

    _createRootNode = function(self)
        self.scroContainer = cc.Layer:create()
        self.scroContainer:setContentSize(cc.size(self._options.frameWidth,self._options.frameHeight))

        ---create the CCScrollView
        self.scroview = cc.ScrollView:create(cc.size(self._options.frameWidth,self._options.frameHeight),self.scroContainer)
        if self._options.direction == 1 then
            self.scroview:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        elseif self._options.direction == 0 then
            self.scroview:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
        else
            self.scroview:setDirection(cc.SCROLLVIEW_DIRECTION_BOTH)
        end
        self._contentSize = cc.size(self._options.frameWidth,self._options.frameHeight)
        return   self.scroview
    end,

    reOrderChild = function(self,child,order)
        self.scroContainer:reorderChild(child,order)
    end,

    getRootNode = function(self)
        if not self.rootNode then
            self.rootNode = self:_createRootNode()
        end
        return self.rootNode
    end,

    --- add child to scrollview ,maybe an UIComponent or a CCNode
    addChild = function(self, uiOrNode)
        --fix140310:keep child node's tag
       if U:isUI(uiOrNode) then
           self.scroview:addChild(uiOrNode.rootNode,0)
       else
           self.scroview:addChild(uiOrNode,0)
       end
    end,

    setTouchPriority = function(self,intPriority)
        self.scroview:setTouchPriority(intPriority)
    end,

    --- add a custom scroll handler
    addCustomScrollHandler = function(self,func,nPriority,swallow,continuesTracking)
        self.scrollfunc  = function(eventType, x,y)
            if continuesTracking and eventType~='began' then
                return func(eventType, x,y)
            end
            
            if U:isXYInUIRect(x,y,self.scroview) and self:isVisible() and self:hasVisibleParents() then
                return func(eventType, x,y)
            end
            return false  --- don't claimed the touch event
        end
        self.scroview:setTouchEnabled(false)
        self.scroContainer:setTouchEnabled(true)
        self.scroContainer:registerScriptTouchHandler(self.scrollfunc,false,nPriority,swallow)
    end,

    --- remove custom scroll handler
    removeCustomScrollHandler = function(self)
        self.scroview:setTouchEnabled(true)
        self.scroContainer:setTouchEnabled(false)
        self.scroContainer:unregisterScriptTouchHandler()
     end,

    removeChild = function(self,uiOrNode, cleanup)
        if U.isUI(uiOrNode) then
            self.scroContainer:removeChild(uiOrNode.rootNode, cleanup)
        else
            self.scroContainer:removeChild(uiOrNode, cleanup)
        end
    end,

    removeAllChildren = function(self)
        self.scroContainer:removeAllChildren()
    end,

    getContentOffset = function(self)
       return self.scroview:getContentOffset()
    end,

    setContentOffset = function(self,x,y)
        self.scroview:setContentOffset(cc.p(x,y),false)
    end,

    --- set the content size
    setContentSize = function(self,width,height)

        self._contentSize = cc.size(width,height)
        self:refresh()
    end,

    --- reset the scrollview's content size
    refresh = function(self)
       self.scroview:setContentSize(self._contentSize)
    end,

    reset = function(self)
        self:scrollTo(0,0,true)
    end,

    --- a negative means make the content move left, a positive means make the content move right , relative to current position
    scrollInX = function(self,offsetX,animate)
        self:scrollInXY(offsetX,0,animate)
    end,

    --- a negative means make the content move down, a positive means make the content move up  , relative to current position
    scrollInY = function(self,offsetY,animate)
        self:scrollInXY(0,offsetY,animate)
    end,

    ---scroll in both x and y ,of course relative to current position
    scrollInXY = function(self,offsetX,offsetY,animate)
        local point = self.scroview:getContentOffset()
        local newX = point.x + offsetX
        local newY = point.y + offsetY

        self.scroview:setContentOffset(self:_fomartNewPoint(newX,newY),animate)
    end,

    ---scroll to x and y,absolute in the content's world space
    scrollTo = function(self,x,y,animate)
        local newX = 0 - x
        local newY = 0 - y

        self.scroview:setContentOffset(self:_fomartNewPoint(newX,newY),animate)
    end,

    ---ensure the new position is in the area of content,only effect when you control the scroll behaviour in code
    _fomartNewPoint = function(self,newX,newY)

        if newX > 0 then
            newX = 0
        end
        if newX < -(self._contentSize.width-self._options.frameWidth)  then
            newX = -(self._contentSize.width-self._options.frameWidth)
        end
        if newY > 0 then
            newY = 0
        end
        if newY < -(self._contentSize.height-self._options.frameHeight) then
            newY = -(self._contentSize.height-self._options.frameHeight)
        end

        return cc.p(newX,newY)
    end,

    --- if you interest the scroll or zoom event you should set this lisener
    setScrollEventLisener = function(self,lisener)
        self.scroview:setDelegate()
        self.scroview:registerScriptHandler(function(type,view)
            local offset = view:getContentOffset()
            --U:debug("scroll event:"..type.." x="..view:getContentOffset().x.." y="..view:getContentOffset().y)
            if type == "ended" then
                self:_hideInvisibleChild()
            end

            lisener(type,offset.x,offset.y)
        end, cc.SCROLLVIEW_SCRIPT_SCROLL)
    end,

    removeScrollEventLisener = function(self)
--        self.scroview:setDelegate(nil)
        self.scroview:unregisterScriptHandler(cc.SCROLLVIEW_SCRIPT_SCROLL)
    end,

    getDefaultOptions = function(self)
        return U:extend(false,self:_super(),{
            direction   = 1, --- 1 means vertical 0 means  horizinal other  values means both
            frameWidth  = self._winsize.width,
            frameHeight = 200,
        })
    end

})
