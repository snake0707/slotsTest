--
-- by bbf
--

Slot = Slot or {}

Slot.ui = Slot.ui or {}

Slot.ui.UIComponent = Class:extend({

    __className = "Slot.ui.UIComponent",

    -------Refrence Count----------

    retain = function(self)
        self.rootNode:retain()
    end,

    release = function(self)
        self.rootNode:release()
    end,


    ------ Create and Init --------

    ---
    -- TODO overwite the new method ,add _director and _winsize property
    new = function(self, ...)
        self._director = Slot.App.director
        self._winsize  = Slot.App.visibleSize
        self._framesize = Slot.App.framesize
        return self:_super(...)
    end,
    scaleToFixWidth=function(self,sprite)
        local dw=self:getDeltaWidth()
        local t=tolua.type(sprite) 
        if t =='cc.Scale9Sprite' then
            local w,h=sprite:getContentSize().width,sprite:getContentSize().height
            sprite:setPreferredSize(cc.SizeMake(w+dw,h))
        elseif sprite.getContentSize and sprite.setContentSize then
            local w,h=sprite:getContentSize().width,sprite:getContentSize().height
            sprite:setContentSize(cc.SizeMake(w+dw,h))
        else
            assert(false,'Unsupport type of '..t)
        end
    end,
    getDeltaWidth=function(self)
        if not Slot.ui.UIComponent._deltaWidth then
            Slot.ui.UIComponent._deltaWidth=self._winsize.width-480 --TODO
        end
        return Slot.ui.UIComponent._deltaWidth
    end,
    rePositionX=function(self,node,factor)
        factor=factor or 1.0
        node:setPositionX(node:getPositionX()+self:getDeltaWidth()*factor)
    end,
    newWithCCB = function(self,...)
        self._director = Slot.App.director
        self._winsize  = Slot.App.visibleSize
        self._framesize = Slot.App.framesize
        local instance = { __type = 'object' }
        setmetatable(instance,{ __index = self })
        instance:initWithCCB(unpack({ ... }))
        return instance
    end,

    ---
    -- TODO initialize method
    init = function(self, options, ...)
        self.event = Slot.Event
        self:initWithCode(options, unpack({ ... }))
    end,

    ----
    -- TODO when initialize with code ,overwrite this method and call self:_super() before render the ui
    initWithCode = function(self, options, ...)
        self._options  = U:extend(false,self:getDefaultOptions(), options)

--        self.layout    = Slot.ui.Layout:getLayout(self._options.layout,self._options.layoutOptions,self)
--        self:setLayoutConstraint(self._options.constraint)
        self.rootNode  = self:getRootNode()
        if self._options.nodeEventAware then
            self.rootNode:registerScriptHandler(function(eventType)
                if eventType     == 'enter' then
                    self:onEnter()
                elseif eventType == 'exit' then
                    self:onExit()
                elseif eventType == 'enterTransitionFinish' then
                    self:onEnterTransitionDidFinish()
                elseif eventType == 'exitTransitionStart' then
                    self:onExitTransitionDidStart()
                end
            end)
        end
    end,

    ---
    -- TODO in the future
    initWithCCB = function(self, options, ...)            --TODO::
        self._options = U:extend(false,self:getDefaultOptions(), options)
        self.ccbProxy = cc.CCBProxy:create()
        self.rootNode = tolua.cast(self.ccbProxy:readCCBFromFile(self._options.ccbFile), self._options.nodeClass)
        self.rootNode:addChild(self.ccbProxy)
        if self._options.nodeEventAware then
            self.rootNode:registerScriptHandler(function(eventType)
                if eventType     == 'enter' then
                    self:onEnter()
                elseif eventType == 'exit' then
                    self:onExit()
                elseif eventType == 'enterTransitionFinish' then
                    self:onEnterTransitionDidFinish()
                elseif eventType == 'exitTransitionStart' then
                    self:onExitTransitionDidStart()
                end
            end)
        end
    end,

    ------ Root and Children--------

    ---
    -- TODO return the CCNode represent  the UIComponent
    getRootNode = function(self)
        if not self.rootNode then
            self.rootNode = cc.Node:create()
        end
        return self.rootNode
    end,

	---
	-- TODO Add child
	addChild = function(self, child,constraint,zorder)
        zorder = zorder or 0
		if U:isUI(child) then
            child.__parent = self
--            self.layout:addChild(child)
            self:getRootNode():addChild(child:getRootNode(),zorder)
        else
--            self.layout:addCCChild(child,constraint)
            self:getRootNode():addChild(child,zorder)
		end
	end,

    removeChild = function(self, child, isCleanUp)
        self:getRootNode():removeChild(child, isCleanUp)
    end,

    ---
    -- TODO Remove from parent
    removeFromParent = function(self,isCleanUp)
        self:getRootNode():removeFromParent(isCleanUp)
    end,

    ------ Visible and Invisible -------

    ---
    -- TODO is this visible
    isVisible = function(self)
        return self:getRootNode():isVisible()
    end,

    ---
    -- TODO is this have a visible parent
    hasVisibleParents = function(self)
        local parent = self:getRootNode():getParent()
        while parent do
             if not parent:isVisible() then
                 return false
             end
             parent = parent:getParent()
        end
        return true
    end,

    ---
    -- TODO set the visible
    setVisible = function(self,isVisible)
        self:getRootNode():setVisible(isVisible)
    end,

    setOpacity = function(self,iopacity)
        self:getRootNode():setOpacity(iopacity)
    end,

    ------ Size and Position and AnchorPoint------
    ---
    -- TODO Set ui content scale
    setScale      = function(self,scale)
        self:getRootNode():setScale(scale)
    end,

    ---
    -- TODO Get ui content size
    setContentSize = function(self, size)
        self:getRootNode():setContentSize(size)
--        self:needLayout()
    end,

    ---
    -- TODO Get ui content size
    getContentSize = function(self)
        return self:getRootNode():getContentSize()
    end,

    ---
	-- TODO Set ui position
	setPosition = function(self,p)
		self:getRootNode():setPosition(p)
	end,

    ---
    -- TODO Set ui positin in X
    setPositionX = function(self, x)
        self:getRootNode():setPositionX(x)
    end,
    ---
    -- TODO Set ui positin in Y
    setPositionY = function(self, y)
        self:getRootNode():setPositionY(y)
    end,
	---
	-- TODO Get ui position
	getPosition = function(self)
		return cc.p(self:getRootNode():getPosition())
	end,
    getPositionX = function(self)
        return self:getRootNode():getPositionX()
    end,
    getPositionY = function(self)
        return self:getRootNode():getPositionY()
    end,
    ---
	-- TODO Set ui anchor point
	setAnchorPoint = function(self,point)
		self:getRootNode():setAnchorPoint(point)
	end,

    ---
    -- TODO Get ui anchor point
    getAnchorPoint = function(self)

        if self:getRootNode():isIgnoreAnchorPointForPosition() then return cc.p(0,0) end

        return self:getRootNode():getAnchorPoint()
    end,

    ---
    -- TODO Is this node is ignore anchorpoint when position
    isIgnoreAnchorPointForPosition = function(self)
        self:getRootNode():isIgnoreAnchorPointForPosition()
    end,

    ------------- Layout --------------

    ---
    -- TODO Set the layout constraint
	setLayoutConstraint = function(self,constraint)
        self.layoutConstraint = constraint
    end,

    ---
    -- TODO Get the layout constraint
    getLayoutConstraint = function(self)
        return self.layoutConstraint
    end,

    ---
    -- TODO Set the Layout the current UIComponent
    setLayout = function(self,layout)
        self.layout = layout
        self.layout:setParent(self)
    end,

    ---
    -- TODO Get the Layout
    getLayout = function(self)
        return self.layout
    end,

    ---
    -- TODO Relayout the current UI Component
    needLayout = function(self)
        self.layout:update()
        if self.__parent then
            self.__parent:needLayout()
        end
    end,

    -------- Enter Action and Exit Action -------------

    ---
    -- TODO ccnode run some action
    runAction     = function(self,action)
        self.rootNode:runAction(action)
    end,

    ---
    -- TODO Set the enter action
    setEnterAction = function(self,action)
        self.rootNode:getActionManager():addAction(action,self.rootNode,true)
        self.enterAction = action
    end,

    ---
    -- TODO Set the exit action
    setExitAction = function(self,action)
        self.rootNode:getActionManager():addAction(action,self.rootNode,true)
        self.exitAction = action
    end,

    setLocalZOrder = function(self, zorder)
        return self.rootNode:setLocalZOrder(zorder)
    end,

    getLocalZOrder = function(self)
        return self.rootNode:getLocalZOrder()
    end,

    getParent = function(self)
        return self.rootNode:getParent()
    end,

    ------ Default option --------

    getDefaultOptions = function(self)
        return {
            nodeEventAware = false,
            layout         = "absolute", --- { "absolute" , "dock" , "row" , "column" , "grid" }
            layoutOptions  = {},
            constraint     = {},
        }
    end,

    ------ UI Event Callback --------

    onEnter = function(self)
        if self._options.onEnter then self._options:onEnter(self) end
    end,

    onEnterTransitionDidFinish = function(self)
        if self.enterAction then
            self.rootNode:getActionManager():resumeTarget(self.rootNode)
        end
    end,

    onExit = function(self)
        if self._options.onExit then self._options:onExit(self) end
    end,

    onPostExit = function(self)
        if self.exitAction then
            self.rootNode:getActionManager():resumeTarget(self.rootNode)
        end
        if self._options.onPostExit then self._options:onPostExit(self) end
    end,

    onExitTransitionDidStart = function(self) end,

    -------- Event ---------
    onEvent = function(self,t,c,triggerOnce,g)
        Slot.libs.EventManager:addListener(t,c,triggerOnce,g)
    end,

    fireEvent = function(self,t,a)
        local event = Slot.libs.Event:new(t,a)
        event:fire()
    end,

    unEvent = function(self,t,c)
        Slot.libs.EventManager:removeListener(t,c)
    end,

    clearEvent = function(self,t)
        Slot.libs.EventManager:removeAllListener(t)
    end
})

