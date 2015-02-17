
local DuringTime=6

Slot = Slot or {}

Slot.com = Slot.com or {}

Slot.com.GirlLuckyPlate = Slot.ui.UIComponent:extend({
    __className = "Slot.com.GirlLuckyPlate",

    initWithCode = function(self, options)

        self:_super(options)

        self:_getDataFromDB()

        --计算旋转角度表  aim箭头
        self:_setup()

        self:_InitializationData()

        self:_registEvent()

        self:_onEvent()

    end,

    targetAngelTab={},
    targetAngle=0,
    prizeValue=0,
    totalPrizeValue=0,
    spinNum=0,
    totalBet=0,
    _isGameOver=false,

    --for test
    --记录下上次存储的点击结果
    preIndex=0,
    nextAngle=0,

    _InitializationData=function(self)
        self:_changePrizeValue(1)
    end,

    _getDataFromDB=function(self)

        local sq = Slot.sqlite:new()
        sq:create("storage/girldata.db")


        local data=sq:readRows("tbl_bonus_game")

        for i=1,4 do
            self._options.prizeTab[i]={}
            for k, v in pairs(data) do
                self._options.prizeTab[i][k] =v["prize"..i]
            end

        end

        U:debug("=====================")
        U:debug(self._options.prizeTab)
        U:debug("=====================")

        sq:close()


    end,

    _onEvent=function(self)

        self:onEvent("switch_end",function()
        --添加音乐
            Slot.Audio:playMusic("sound/modules/girl/"..Slot.MusicResources["girl"].girl_bgame_begin)

        end)

        self:onEvent("WillEnterForeground",function()
            Slot.Audio:stopMusic(true)
            Slot.Audio:playMusic("sound/modules/girl/"..Slot.MusicResources["girl"].girl_bgame_begin)
        end)


    end,

    getTargetAngleTab = function(self)

        local angleTab={}
        for i=1,self._options.n do
            angleTab[i]=i*360/self._options.n
        end

        return angleTab

    end,

    _setup = function(self)


        local pagePara = self._options.pagePara or {}
        self.totalbet=pagePara.totalbet or 0
        self.prewin=pagePara.win or 0

        self.aim= self.proxy:getNodeWithName("aim")

        --根据被分割的等份 获取相应的旋转角度 test ok
        self.targetAngelTab=self:getTargetAngleTab()

        self.spinButton=self.proxy:getNodeWithName("spin_Button")
        self.spinButtonLayer=self.proxy:getNodeWithName("spin_Button_layer")
        self.turnPlate=self.proxy:getNodeWithName("turn_Plate")

    end,





    getTargetAngleAndPrize = function(self)

        local seed = Slot.DM:getLocalStorage("seed")
--        if not seed then
--            seed = os.time()
--            Slot.DM:setLocalStorage("seed", seed)
--        end

        if not self.random then self.random = "" else self.random = self.random..";" end

        self.random = self.random..seed..","

        local index, seed = U:randforgame(seed, 1, self._options.n)

        self.random = self.random..index

        local targetAngle=self.targetAngelTab[index]+8*360


        --计算再次偏转的角度
        local a=360/self._options.n

        local diffIndex=math.floor(targetAngle/a)

        local tempIndex=(self.preIndex+diffIndex)%self._options.n

        local prizeIndex=tempIndex%self._options.n
        if prizeIndex==0 then prizeIndex=self._options.n end

        local prizeValue=self._options.prizeTab[self.spinNum][prizeIndex]

        self.targetAngle=targetAngle
        self.prizeValue=prizeValue
        --累计奖励
        self.totalPrizeValue= self.totalPrizeValue+self.prizeValue

        --记录上一次的奖励下标
        self.preIndex=prizeIndex
        U:debug("self.totalPrizeValue=========")
        U:debug(self.totalPrizeValue)


    end,

    startRorate = function(self)

    --让转盘执行一个旋转动作

        --旋转过程中不能再次点击 并且模拟指标左右动
        local spinButtonState=cc.CallFunc:create(function()

            self:_spinButtonState(false)

        end)


        local rorate1=cc.RotateBy:create(DuringTime/10,self.targetAngle/4)


        --EaseExponentialOut
        local ease1=cc.EaseBounceIn:create(rorate1)


        local rorate2=cc.RotateBy:create(DuringTime/5,self.targetAngle/2)

        local rorate3=cc.RotateBy:create(DuringTime,self.targetAngle/4+0.5)

        local ease2=cc.EaseElasticOut:create(rorate3,DuringTime)


        --每次转完再更新总奖金＝赔率＊对应分数值
        local showTotalPrize=cc.CallFunc:create(function()

            --self.aim:stopAllActions()
        --添加音乐

        Slot.Audio:playEffect("sound/modules/girl/"..Slot.MusicResources["girl"].girl_bgame_wheel_stop)

            --如果转到0的分数值 就结束游戏 弹出bonus弹框

            if  self.prizeValue==0 or self.spinNum==4 then

                self:_spinButtonState(false)
                self:isEndGame()

                return

            end

            local totalPrize=self.totalPrizeValue
            self:setTotalPrize(totalPrize)


        end)

        local changePrize=cc.CallFunc:create(function()

            if  self.prizeValue~=0 then

                --这里添加一个函数 替换转盘上的分数值

                self:_changePrizeValue(self.spinNum+1)

                --旋转结束 恢复可再次点击按钮

                self:_spinButtonState(true)
            end


        end)
        local delay=cc.DelayTime:create(1.5)

        local seq=cc.Sequence:create(spinButtonState,ease1,rorate2,ease2,showTotalPrize,delay,changePrize)


        self.turnPlate:runAction(seq)

    --添加音乐
    Slot.Audio:playEffect("sound/modules/girl/"..Slot.MusicResources["girl"].girl_bgame_wheel_roll)


    end,

    _spinButtonState = function(self,state)

        self.spinButton:setEnabled(state)
        self.spinButtonLayer:setTouchEnabled(state)

     end,


    _getThePrizeNodeTab = function(self)

        local PrizeNodeTab={}
        for i=1,self._options.n do

            local fileName=string.format("text_"..i)
            local textNode=self.proxy:getNodeWithName(fileName)
            table.insert(PrizeNodeTab,textNode)

        end

        return PrizeNodeTab

    end,


    _changeValue = function(self,value,node)

        local strValue=tostring(value)
        if value~=0 then

            node:setString(strValue)
            node:setScale(1.0)
        else
            node:setString("collect")
            node:setScale(0.75)

        end

    end,

    _startChangeValue = function(self,prizeTab,nodeTab)

        if not prizeTab or type(prizeTab)==nil then return end
        for i=1,#nodeTab do

            if prizeTab[i]~=nil and nodeTab[i]~=nil then
                self:_changeValue(prizeTab[i],nodeTab[i])
            end


        end

    end,

    _changePrizeValue = function(self,index)

        local tempTargetTab=self._options.prizeTab[index]

        --封装一个函数 获取所有的textNode
        local prizeNodeTab=self:_getThePrizeNodeTab()


        --这里封装一个函数 传入分值表 和 textNode表
        self:_startChangeValue(tempTargetTab,prizeNodeTab)



    end,

    _registEvent = function(self)

    --给spin按钮添加事件监听

        self.proxy:handleButtonEvent(self.spinButtonLayer, function()

            if self.spinNum>=4 or self._isGameOver then return end

            --记录点击次数
            --self:_buttonAction(self.spinButton)
            self.spinNum=self.spinNum+1

            --产生一个随机数 得到一个目标角度和奖励得分
            self:getTargetAngleAndPrize()

            self:startRorate()



        end,self._options.priority)


    end,

    _buttonAction=function(self,node)

        local action_begin = cc.ScaleTo:create(0.05, 0.95)
        local action_end = cc.ScaleTo:create(0.05, 1)
        local seq=cc.Sequence:create(action_begin,action_end)
        node:runAction(seq)
    end,




    -- clean notification on exit
    onExit=function(self)
        Slot.DM:detach('profile',self._onBaseProfileUpdate)
    end,


    _isShare=function(self)

        local data=Slot.DM:getBaseProfile()

        if self.totalPrizeValue>=5*self.totalbet and  self.totalPrizeValue>=1000 then

            return true
        else
            return false

        end

    end,

    _handleBonusAction = function(self)

        print("_handleBonusAction===========1")

        local bet = Slot.DM:getLocalStorage("girlbet")

        local bonus = self.totalPrizeValue
        local total_bonus=bonus*bet
        local share_text
        if self:_isShare() then
            share_text="Are you share to FaceBook or others?"
        end


        local params={}
        params["random"]=self.random
        params["coins"]=total_bonus
        params["bet"]=bet

        U:debug("params=============")
        U:debug(params)
        U:debug("params=============")

        Slot.http:post(
            "games/girl",
            params,
            function(data)
                if data.rc == 0 then

                    self.bonusDlg = Slot.com.CoinBetDialog:new({
                        type = "bet",
                        share_text=share_text,
                        bonus_num = tostring(bonus),
                        level_factor = tostring(bet),
                        total_bonus=total_bonus,

                        afterClose = function(opt)

                            self:_spinButtonState(false)

                            local profile = Slot.DM:getBaseProfile()
                            profile.coin = profile.coin+params["coins"]
                            Slot.DM:setBaseProfile(profile)
                            self.bonusDlg = nil

                            local delay=cc.DelayTime:create(1)
                            local backToWest=cc.CallFunc:create(function()

                                print("back to west============")
                                local pagePara = self._options.pagePara
                                Slot.App:switchTo("modules/girl",{pagePara=pagePara})

                            end)

                            local seq=cc.Sequence:create(delay,backToWest)

                            self.rootNode:runAction(seq)




                        end,
                    })

                    self.bonusDlg:open()

                else
                    Slot.Error:openDlg(data.rc)
                end
            end)


        print("_handleBonusAction===========2")

    end,



    _endGameAction=function(self)

        local delay=cc.DelayTime:create(1)
        local bonusAction=cc.CallFunc:create(function()
            self:_handleBonusAction()

        end)

        local seq=cc.Sequence:create(delay,bonusAction)
        self.rootNode:runAction(seq)

    end,

    isEndGame=function(self)

        self._isGameOver=true
        self:_endGameAction()

    --添加音乐
    Slot.Audio:playMusic("sound/modules/girl/"..Slot.MusicResources["girl"].girl_bgame_end)

    end,

    setTotalPrize=function(self,totalPrize)



        local totalPrizeString=string.format(""..totalPrize)

        local textSprite=self.proxy:getNodeWithName("total_prize")
        textSprite:setString(totalPrizeString)


    end,


    getRootNode = function(self)
        if not self.rootNode then
            self.proxy = Slot.CCBProxy:new()
            self.rootNode  = self.proxy:readCCBFile("ccbi/GirlTurnPlate.ccbi")

            self.rootNode:addChild(self.proxy:getRootNode())

            self.gril_bg=self.proxy:getNodeWithName("girl_bg")
            self.gril_bg:setContentSize(self._winsize)
            self.rootNode:setContentSize(self._winsize)


            self.gril_man=self.proxy:getNodeWithName("girl_man")

            self.gril_man:setPositionX(self._winsize.width-self.gril_man:getContentSize().width/2)

            self.gril_container=self.proxy:getNodeWithName("gril_container")
            self.gril_container:setPositionX(self._winsize.width/2)

        end

        return self.rootNode
    end,

    getDefaultOptions = function(self)

        return U:extend(false, self:_super(), {
            nodeEventAware=true,
            n=10,
                                                              --默认圆盘被分割的等份
--            prizeTab={                                              --奖赏表 若转盘位顺时针旋转 则奖赏表则为逆时针数值
--                {50,30,100,80,50,80,30,100,50,80},
--                {100,0,150,120,100,120,0,150,0,120},
--                {0,300,0,300,0,200,0,400,0,200},
--                {0,0,0,0,0,0,0,800,0,0},
--
--            },
            prizeTab={},
            priority = Slot.TouchPriority.layer,
        })
    end,
})