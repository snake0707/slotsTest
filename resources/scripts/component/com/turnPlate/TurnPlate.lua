
--随机表
local randomTab={1,2,3,4,5,6,7,8,9,10 }

--旋转角度表
--local angleTab={36,72,108,144,180,216,252,288,324,360 }

local DuringTime=6


Slot = Slot or {}

Slot.com = Slot.com or {}

Slot.com.TurnPlate = Slot.ui.UIComponent:extend({
    __className = "Slot.com.TurnPlate",

    initWithCode = function(self, options)

        self:_super(options)

        --计算旋转角度表 存储碰撞节点 aim箭头
        self:_setup()

        --点击事件注册
        self:_registEvent()



    end,

    targetAngelTab={},
    collideNodeTab={},
    spinButton=nil,
    turnPlate=nil,
    targetAngle=0,
    prizeValue=0,
    totalPrizeValue=0,

    --for test
    --记录下上次存储的点击结果
    preIndex=0,
    preAngle=0,

    random = nil,
    constAngle=8*360,

    getTargetAngleTab = function(self)

        local angleTab={}
        for i=1,self._options.n do
            angleTab[i]=i*360/self._options.n
        end

        return angleTab

    end,

    getCollideNode = function(self)

        local nodeTab={}
        for i=1,self._options.n do

            local strName=string.format("node_"..i)
            nodeTab[i]=self.proxy:getNodeWithName(strName)
        end

        return nodeTab

    end,


    _setup = function(self)
        self.aim= self.proxy:getNodeWithName("aim")

        --根据被分割的等份 获取相应的旋转角度 test ok
        self.targetAngelTab=self:getTargetAngleTab()

        --存储碰撞node   test ok
        --self.collideNodeTab=self:getCollideNode()

        self.spinButton=self.proxy:getNodeWithName("spin_Button")
        self.spinButtonLayer=self.proxy:getNodeWithName("spin_Button_layer")
        self.turnPlate=self.proxy:getNodeWithName("turn_Plate")
        self._turn_Plate_bg = self.proxy:getNodeWithName("turn_Plate_bg")
        self._tips_node = self.proxy:getNodeWithName("tips_node")

    end,




    getTargetAngleAndPrize = function(self)

        self.preAngle=self.targetAngle --保存前一次的旋转角度 加上了 self.constAngle

        local seed = Slot.DM:getLocalStorage("seed")
        if not self.random then self.random = "" else self.random = self.random..";" end

        self.random = self.random..seed..","

        local index, seed = U:randforgame(seed, 1, self._options.n)
        self.random = self.random..index

        local targetAngle=self.targetAngelTab[index]+self.constAngle


        --计算再次偏转的角度
        local a=360/self._options.n
        local diffIndex=math.floor(targetAngle/a)

        local tempIndex=(self.preIndex+diffIndex%self._options.n)

        local prizeIndex=tempIndex%self._options.n
        if prizeIndex==0 then prizeIndex=self._options.n end

        local prizeValue=self._options.prizeTab[prizeIndex]


        self.targetAngle=targetAngle
        self.prizeValue=prizeValue

        --累计奖励
        self.totalPrizeValue= self.totalPrizeValue+self.prizeValue

        --记录上一次的奖励下标
        self.preIndex=prizeIndex

        print("self.preAngle========:"..self.preAngle)
        print("self.targetAngle========:"..self.targetAngle)
        print("*********************:")



    end,


    --回调函数
    exportTotalPrize = function(self,callback)

        if callback and type(callback)=="function" then

            callback(self.totalPrizeValue)

        end

    end,


    startRorate = function(self)

    --让转盘执行一个旋转动作

    --添加音乐
        Slot.Audio:playEffect("sound/common/"..Slot.MusicResources["common"].lobby_wheel)

        --DuringTime/10,self.targetAngle/4

        local saveData=cc.CallFunc:create(function()

            Slot.http:post(
                "collectcoins/turnPlate",
                {
                    random = self.random,
                    coin = self.totalPrizeValue
                },
                function(data)

                    if data.rc == 0 then

--                        Slot.DM:setLocalStorage("seed", result.seed)

                    end
                end,

                function(data)

                    local rorate1=cc.RotateBy:create(2,360*3)
                    self.turnPlate:stopAllActions()
                    self.turnPlate:runAction(cc.RepeatForeve:create(rorate1))

                end)
        end)


        local rorate1=cc.RotateBy:create(DuringTime/10,self.targetAngle/4)
        local ease1=cc.EaseBounceIn:create(rorate1)

        local spw=cc.Spawn:create(ease1,saveData)

        local rorate2=cc.RotateBy:create(DuringTime/5,self.targetAngle/2)

        local rorate3=cc.RotateBy:create(DuringTime,self.targetAngle/4+0.5)

        local ease2=cc.EaseElasticOut:create(rorate3,DuringTime)


        local callback=cc.CallFunc:create(function()

            self:close()


        end)

        --local seq=cc.Sequence:create(spw,rorate2,ease2, callback)
        local seq=cc.Sequence:create(spw,rorate2,ease2, callback)
       -- local seq=cc.Sequence:create(ease1,rorate2,seq_ease2,callback)

        self.turnPlate:runAction(seq)

--        self.turnPlate:runAction(spw)


    end,


    _registEvent = function(self)

    --给spin按钮添加事件监听

        self.proxy:handleButtonEvent(self.spinButtonLayer, function()

            self.spinButton:setEnabled(false)
            self.spinButtonLayer:setEnabled(false)
            --产生一个随机数 得到一个目标角度和奖励得分
            self:getTargetAngleAndPrize()

            self:startRorate()

        end, self._options.priority-1)

    --
    --        self.proxy:handleButtonEvent(self.spinButtonLayer,
    --            function()
    --
    --
    --            end)

    end,

    _createOverlay = function(self)

        if not self._overlay or tolua.isnull(self._overlay)  then
            local _scene = cc.Director:getInstance():getRunningScene()
            local winsize = cc.Director:getInstance():getWinSize()

            self._overlay= cc.LayerColor:create(cc.c4b(0,0,0, 255*.8), self._winsize.width, self._winsize.height)
            self._overlay:setPosition(cc.p(0,0))

            local onTouch = function(eventType, x, y)
            -- To intercept touch event
                if eventType == "began" then
                    return true
                end
            end

            self._overlay:registerScriptTouchHandler(onTouch, false, self._options.priority , true)
            self._overlay:setTouchEnabled(true)

            _scene:addChild(self._overlay, Slot.ZIndex.showWait)

        else
            self._overlay:setVisible(true)

        end


    end,

    _removeOverlay = function(self)
        if self._overlay==nil or tolua.isnull(self._overlay) then
            self._overlay=nil
            return
        end
        self._overlay:removeFromParent(true)
        self._overlay = nil
    end,

    open = function(self, force)
        self:_createOverlay()

        if not self.rootNode:getParent() then

            --            U:addToCenter(self.rootNode, self._overlay)
            local winsize = cc.Director:getInstance():getWinSize()
            local size = self.rootNode:getContentSize()
            --self.rootNode:setPosition(cc.p(winsize.width/2, winsize.height-size.height/2))

            self.rootNode:setPosition(cc.p(winsize.width/2, winsize.height/2))
            self._overlay:addChild(self.rootNode, Slot.ZIndex.showWait)

            local turn_Plate_bg_pos=cc.p(self._turn_Plate_bg:getPosition())
            local tips_node_pos=cc.p(self._tips_node:getPosition())


            self._turn_Plate_bg:setPositionY(-self._turn_Plate_bg:getContentSize().height/2)
            self._tips_node:setPositionY(size.height)
            --
            --

            --
            --self._turn_Plate_bg:runAction(cc.MoveTo:create(2, cc.p(self._turn_Plate_bg:getPositionX(), self._turn_Plate_bg:getContentSize().height/2)))
            self._turn_Plate_bg:runAction(cc.MoveTo:create(1, turn_Plate_bg_pos))
            self._tips_node:runAction(cc.MoveTo:create(0.5,tips_node_pos ))
        end

    end,

    close = function(self)

        local data = {
            random = self.random,
            bonus_num = self.totalPrizeValue
        }

        if self._options.willClose then self._options:willClose(self, data) end

        U:setTimeout(function()

            self._options:onClose(self, data)
            local winsize = cc.Director:getInstance():getWinSize()

            local action = {}
            --            local moveUp = cc.MoveTo:create(2, cc.p(self._tips_node:getPositionX(), winsize.height + self._tips_node:getContentSize().height/2))

            local callBack = cc.CallFunc:create(function()
                local size = self.rootNode:getContentSize()
                self._turn_Plate_bg:runAction(cc.MoveTo:create(1, cc.p(self._turn_Plate_bg:getPositionX(), -self._turn_Plate_bg:getContentSize().height/2)))

                self._tips_node:runAction(cc.MoveTo:create(0.5, cc.p(self._tips_node:getPositionX(), size.height)))

            end)

            local removeAll = cc.CallFunc:create(function()

                if self._overlay then
                    local _scene = cc.Director:getInstance():getRunningScene()
                    _scene:removeChild(self._overlay, true)
                    self._overlay = nil
                    self._opening = nil
                else
                    self.rootNode:removeFromParent(true)
                end
                Slot.SpriteCacheManager:removeSpriteFrameByFile("plist/common/turnPlate_bg.plist")
                Slot.SpriteCacheManager:removeSpriteFrameByFile("plist/common/turnPlate_wheel.plist")
                self._options:afterClose(self, data)

            end)

            table.insert(action, callBack)
            table.insert(action, cc.DelayTime:create(0.5))
            table.insert(action, removeAll)

            local seq = cc.Sequence:create(action)

            self.rootNode:runAction(seq)

        end, 1)

    end,

    onExit=function(self)
        Slot.DM:detach('profile',self._onBaseProfileUpdate)
    end,


    getRootNode = function(self)
        if not self.rootNode then

            self.proxy = Slot.CCBProxy:new()
            self.rootNode  = self.proxy:readCCBFile(self._options.ccbi)

            self.rootNode:addChild(self.proxy:getRootNode())

        end

        return self.rootNode
    end,

    getDefaultOptions = function(self)

        return U:extend(false, self:_super(), {
            nodeEventAware=true,
            ccbi="ccbi/TurnPlate.ccbi",
            n=10,                                                   --默认圆盘被分割的等份
            prizeTab={350,300,500,300,1000,600,400,350,350,800 },    --奖赏表 若转盘位顺时针旋转 则奖赏表则为逆时针数值
            priority = Slot.TouchPriority.layer,
            willClose = function(opt, that, data) end,
            onClose = function(opt, that, data) end,
            afterClose = function(opt, that, data) end,
        })
    end,
})