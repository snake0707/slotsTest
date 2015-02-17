--
-- by bbf
--
Slot = Slot or {}

Slot.ui = Slot.ui or {}

Slot.ui.Slot = Slot.ui.UIComponent:extend({

    __className = "Slot.ui.Slot",

    initWithCode = function(self,options)
        self:_super(options)

        --[[微调结果]]--
        self._miniOffset = 15 -- 滚动停止前最后向下超出的范围
        self._startUpFactor = 3  -- 速度因子
        self._endUpFactor = 3
        self._endDownFactor = 5

        self._endUpDownOffset = 10  -- 滚动停止时最后上下偏移的范围

        self._tag = 10000

        self._shouldStop = false
        self._result = {}
        self._resIndex = 0
        self.scroview:setTouchEnabled(false)

        Slot.EM:addListener("system.switch.scene", function(e)
            self.rootNode:stopAllActions()
            if self.spin then
                U:clearInterval(self.spin)
                self.spin = nil
            end
        end, true)


        local children = self.scroContainer:getChildren()

        for i, cell in ipairs(children) do
            self.scroContainer:removeChild(cell, true)
        end

        for i = 1, self._options.wheel.row + 2 do

            local num = #self._options.component - 2
            local index = self._options.component[math.random(num)]


            U:addSpriteFrameResource("plist/modules/"..self._options.modulename.."/"..self._options.modulename..".plist")

            --local cell=U:getSpriteByName(self._options.modulename.."_"..index..".png")
            local cell=U:getSpriteByName(index..".png")

            --local cell=cc.Sprite:create("modules/"..self._options.modulename.."/"..index..".png")
            cell:setPosition(cc.p((self._options.frameWidth) / 2, (i-1)*self._options.componentHeight+self._options.componentHeight/2))
            self:addChild(cell)

        end
        local usedChildren = self.scroContainer:getChildren()
        self.scroContainer:setPosition(0, - self._options.componentHeight)
    end,

    deleteEndNode = function(self)

        local children = self.scroContainer:getChildren()
        local cell = children[1]
        self.scroContainer:removeChild(cell, true)
    end,

    addNewNode = function(self, index)

        local usedChildren = self.scroContainer:getChildren()

        if index == nil then
            local num = #self._options.component - 2
            index = self._options.component[math.random(num)]
        end

        U:addSpriteFrameResource("plist/modules/"..self._options.modulename.."/"..self._options.modulename..".plist")

        --local cell=U:getSpriteByName(self._options.modulename.."_"..index..".png")

        local cell=U:getSpriteByName(index..".png")

        --local cell=cc.Sprite:create("modules/"..self._options.modulename.."/"..index..".png")


--        cell:setPosition(cc.p((self._options.frameWidth) / 2, (#usedChildren-1)*self._options.componentHeight+self._options.componentHeight/2))
        cell:setPosition(cc.p((self._options.frameWidth) / 2, usedChildren[#usedChildren]:getPositionY()+self._options.componentHeight))

        cell:setTag(self._tag)
        self:addChild(cell)
        self._tag = self._tag + 1
    end,


    startSpin = function(self,speed,rate)
        self._speed = speed
        self._rate = rate
        self._shouldStop = false

        self.startY = -self._options.componentHeight
        if self.spin then return end

        local upmove = cc.MoveBy:create(3/self._speed, cc.p(0, self._options.componentHeight/3))
        local delay = cc.DelayTime:create(0.1)
        local start =  cc.CallFunc:create(function()
            self.scroContainer:stopAllActions()
            self.spin = U:setIntervalUnsafe(function(dt) self:_spinUpdate(dt) end, 0)
        end)
        local actions = {}
        table.insert(actions, upmove)
        table.insert(actions, delay)
        table.insert(actions, start)

        local sequence = cc.Sequence:create(actions)
        local sRepeat = cc.Repeat:create(sequence,1)
        self.scroContainer:runAction(sRepeat)


    end,

    _spinUpdate = function(self, dt)

--        print(dt)
--        local spf = cc.Director:getInstance():getSecondsPerFrame()

        local offsetY = 0.01 * self._speed * self._options.componentHeight
        self.scroContainer:setPositionY(self.scroContainer:getPositionY() - offsetY)


        if self._resIndex < #self._result + 1 and self.startY  - self.scroContainer:getPositionY() >= self._options.componentHeight then
--            self.scroContainer:setPositionY(self.scroContainer:getPositionY() - offsetY)
            local index
            if self._shouldStop then
                self._resIndex = self._resIndex + 1
                index = self._result[self._resIndex]
            end

            self.startY = self.startY - self._options.componentHeight
            self:deleteEndNode()
            self:addNewNode(index)


--            self:rePosition()
        end

        if self._resIndex >= #self._result + 1 and (self.startY  - self.scroContainer:getPositionY()) >= self._miniOffset then
--            self.scroContainer:setPositionY(self.scroContainer:getPositionY() - offsetY)
            U:clearInterval(self.spin)
            self.spin = nil
            --                local off = 10
            local upmove = cc.MoveBy:create(((self.startY  - self.scroContainer:getPositionY()) + self._endUpDownOffset)/self._options.componentHeight * self._endUpFactor/self._speed, cc.p(0, (self.startY  - self.scroContainer:getPositionY()) + self._endUpDownOffset))
            local downmove = cc.MoveBy:create((self._endUpDownOffset)/self._options.componentHeight* self._endDownFactor/self._speed, cc.p(0, -self._endUpDownOffset))
            local doneSpin =  cc.CallFunc:create(function()
                self:_onDoneSpinning()
            end)
            local actions = {}
            table.insert(actions, upmove)
            table.insert(actions, downmove)
            table.insert(actions, doneSpin)

            local sequence = cc.Sequence:create(actions)
            local sRepeat = cc.Repeat:create(sequence,1)
            self.scroContainer:runAction(sRepeat)
        end

    end,

    _onDoneSpinning = function(self)
        self._shouldStop = false
        self._resIndex = 0
        self._result = {}

        self:rePosition()

        if type(self._options.onDoneSpining) == 'function' then
            self._options.onDoneSpining(self)
        end
    end,

    rePosition = function(self)
        local usedChildren = self.scroContainer:getChildren()
        local offetY = usedChildren[1]:getPositionY()
        for i, cell in ipairs(usedChildren) do
            cell:setPositionY(cell:getPositionY() - offetY + self._options.componentHeight/2)
        end
        self.scroContainer:setPositionY(- self._options.componentHeight)
    end,

    stopSpin = function(self, result, onDoneSpining)
        self._shouldStop = true
        self._result = result
        self._resIndex = 0

        if type(self._result) ~= "table" or #self._result <= 0 then error("========error========") end
        if onDoneSpining and type(onDoneSpining) == 'function' then
            self._options.onDoneSpining = onDoneSpining
        end
    end,

    _createRootNode = function(self)
        self.scroContainer = cc.Layer:create()
        self.scroContainer:setContentSize(cc.size(self._options.frameWidth,self._options.frameHeight))
        ---create the CCScrollView
        self.scroview = cc.ScrollView:create(cc.size(self._options.frameWidth,self._options.frameHeight),self.scroContainer)
--        if self._options.direction == 1 then
--            self.scroview:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
--        elseif self._options.direction == 0 then
--            self.scroview:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
--        else
--            self.scroview:setDirection(cc.SCROLLVIEW_DIRECTION_BOTH)
--        end
        self.scroview:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        self._contentSize = cc.size(self._options.frameWidth,self._options.frameHeight)

        return self.scroview
    end,

    getRootNode = function(self)
        if not self.rootNode then
            self.rootNode = self:_createRootNode()
        end

        return self.rootNode
    end,

    --- add child to scrollview ,maybe an UIComponent or a CCNode
    addChild = function(self, uiOrNode)
        if U:isUI(uiOrNode) then
            self.scroview:addChild(uiOrNode.rootNode,0)
        else
            self.scroview:addChild(uiOrNode,0)
        end
    end,

    removeChild = function(self,uiOrNode, cleanup)
        if U.isUI(uiOrNode) then
            self.scroContainer:removeChild(uiOrNode.rootNode, cleanup)
        else
            self.scroContainer:removeChild(uiOrNode, cleanup)
        end
    end,

    removeAllChildren = function(self)
        self.scroContainer:removeAllChildren(true)
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

    getDefaultOptions = function(self)
        return U:extend(false,self:_super(),{
--            direction   = 1, --- 1 means vertical 0 means  horizinal other  values means both
            component = {1,2,3,4,5,6,7,8,9,10,50,100,200},
            frameWidth  = 72,
            frameHeight = 226,
            componentWidth = 76,
            componentHeight = 76,
            addComponent = function(row)
                return nil
            end,
            onDoneSpining = function()
            end,
            onExit = function(opt)

                self.rootNode:stopAllActions()
                if self.spin then
                    U:clearInterval(self.spin)
                    self.spin = nil
                end

            end,


        })
    end,

    --add by hxp
    getChildrenByParent=function(self)
        local tab={}
        local mm=self.scroContainer:getChildren()

        --U:debug(mm)
        for i=2,4 do

--            mm[i]:setTag(self._tag+i)
            tab[i-1]=mm[i]

        end

        --U:debug(tab)
        return tab
    end,

})
