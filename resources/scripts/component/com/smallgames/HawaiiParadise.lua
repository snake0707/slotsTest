

Slot = Slot or {}

Slot.com = Slot.com or {}

Slot.com.HawaiiParadise = Slot.ui.UIComponent:extend({
    __className = "Slot.com.HawaiiParadise",

    initWithCode = function(self, options)

        self:_super(options)

        self:_getDataFromDB()

        self:_resertAllData()

        self:_setup(self._options.row,self._options.col)
--
        --随机结果的设计
        self:_InitializationData()
--
--        --触摸事件的设计
--
        self:_registEvent()
        self:_onEvent()

    end,

    posTab={}, -- 用于摆放位置
    nodePosTab={}, --用于移动时确定移动到的目标位置
    scaleTab={},
    buttonTab={},
    nodeRowTab={},
    itemTab={},
    itemLabelTab={},
    savePrizeTab={},
    startRow=1,
    zeroValueNum=0,
    totalPrizeValue=0,
    _RepeatTab={},
    posStr="",
    --random="",
    InitializationRow=0,

    _onEvent=function(self)


        self:onEvent("switch_end",function()

        --添加音乐
            Slot.Audio:playMusic("sound/modules/hawaii/"..Slot.MusicResources["hawaii"].hawaii_bgame_begin)

        end)

        self:onEvent("WillEnterForeground",function()
            Slot.Audio:stopMusic(true)
            Slot.Audio:playMusic("sound/modules/hawaii/"..Slot.MusicResources["hawaii"].hawaii_bgame_begin)

        end)


    end,

    _getDataFromDB=function(self)

        local sq = Slot.sqlite:new()
        sq:create("storage/hawaiidata.db")


        local data=sq:readRows("tbl_bonus_game")

        for i=1,4 do
            self._options.prizeTab[i]={}
            for k, v in pairs(data) do
                self._options.prizeTab[i][k] =v["prize"..i]
            end

        end

        sq:close()

    end,

    _getNodeScale = function(self,index)

        local tempNodeName=string.format("row"..index)
        local itemNode=self.proxy:getNodeWithName(tempNodeName)

        local nodePos=cc.p(itemNode:getPosition())
        table.insert(self.nodePosTab,nodePos)
        table.insert(self.nodeRowTab,itemNode)

        local scale=itemNode:getScale()
        return scale

    end,

    _getButtonPos=function(self,i,j)

        local tempButtonName=string.format("row"..i.."_"..j)
        local itemButton=self.proxy:getNodeWithName(tempButtonName)

        self.buttonTab[i][j]=itemButton
        --
        local pos=cc.p(itemButton:getPosition())
        return pos,itemButton

    end,


    --buttonTab应该是个二维表
    _changeButtonState = function(self,buttonTab)

        print("_changeButtonState=========1")
        local rowNum=#buttonTab


        for i=1,rowNum do

            for j=1,#buttonTab[i] do

                if i==1 then
                    buttonTab[i][j]:setEnabled(true)
                else

                    buttonTab[i][j]:setEnabled(false)

                end

            end

        end

    end,


    _changeFirstButtonState = function(self,buttonTab,isShow)

        if isShow==nil then isShow=false end

        if buttonTab==nil then return end

        local count=#buttonTab

        for i=1,count do

            buttonTab[i]:setEnabled(isShow)
            --buttonTab[i]:setVisible(false)

        end

    end,

    _hideAllButton=function(self,buttonTab)

        local count=#buttonTab

        for i=1,count do

            local fadeOut=cc.FadeOut:create(0.3)
            buttonTab[i]:runAction(fadeOut)

        end
    end,


    _setup = function(self,row,col)

        local pagePara = self._options.pagePara or {}
        self.totalbet=pagePara.totalbet or 0
        self.prewin=pagePara.win or 0

        --用一个二维表存储位置坐标 缩放大小 方便做动作
        for i=1,row do

            self.posTab[i]={}
            self.buttonTab[i]={}

            local scale=self:_getNodeScale(i)
            table.insert(self.scaleTab,scale)

            for j=1,col do

                local pos
                local buttonSprite
                pos,buttonSprite=self:_getButtonPos(i,j)

                --这里存储的都是节点坐标 添加新的精灵要加入对应的父节点中
                table.insert(self.posTab[i],pos)


            end

        end

        --这里封装一个函数 每次传入一个button表 把表的第一行设置按钮可用 其他行设置按钮不可用
        self:_changeButtonState(self.buttonTab)

    end,


    --检查是否重复产生 true表示已经随机产生过了 false表示未产生过
    _isRepeat=function(self, tab, i)

        if tab[i]==0 then
            return true
        else
            return false
        end

    end,

    --通过坐标值返回一个精灵
    _getTheFirstRowNode=function(self)

        local tempNodeName=string.format("row"..self.startRow)
        local firstRowNode=self.proxy:getNodeWithName(tempNodeName)

        return firstRowNode
    end,


    _getTheRemainRowNode=function(self)

       local RemainRowNodeTab={}
       for i=self.startRow+1,self._options.row do
           table.insert(RemainRowNodeTab,self.nodeRowTab[i])

       end

        return RemainRowNodeTab
    end,


    _remainRowMove=function(self,remainRowNodeTab)

        --nodePosTab={}, --用于移动时确定移动到的目标位置
        --scaleTab={},

        for i=1,#remainRowNodeTab do

            local targetNode=remainRowNodeTab[i]
            local pos=self.nodePosTab[i]
            local scale=self.scaleTab[i]
            local moveAction=cc.MoveTo:create(1,pos)
            local scaleAction=cc.ScaleTo:create(1,scale)
            local spaw=cc.Spawn:create(moveAction,scaleAction)
            targetNode:runAction(spaw)

        end

    end,


    _clearAllItem=function(self)

        for i=1,#self.itemTab do

            if self.itemTab[i]~=nil then
                self.itemTab[i]=nil
            end

        end

        self.itemTab={}

    end,

    _clearAllItemLabel=function(self)

        for i=1,#self.itemLabelTab do

            if self.itemLabelTab[i]~=nil then
                self.itemLabelTab[i]=nil
            end

        end

        self.itemLabelTab={}

    end,

    _moveForwardAction=function(self,col)



        local showAllItem=cc.CallFunc:create(function()

            self:_showAllItem(col)

            self:_hideAllButton(self.buttonTab[self.startRow])

        end)
        --第一 让第一行 渐隐
        local action1=cc.CallFunc:create(function()


            self:_hideAllItem()
            self:_hideAllItemLabel()

            for i=1,self._options.col do

                local fadeOutAction=cc.FadeOut:create(1)

                self.buttonTab[self.startRow][i]:runAction(fadeOutAction)

            end

        end)

        --第二 让后面的行向前移动
        local action2=cc.CallFunc:create(function()


            local RemainRowNodeTab=self:_getTheRemainRowNode()

            --封装一个函数 传入剩余行的表 都往前移动一行
            self:_remainRowMove(RemainRowNodeTab)

        end)

        local delayAction=cc.DelayTime:create(1)


        --这里需要添加一个回调 当移动结束 把第一行设置恢复点击 进行一次初始化
        local callBackAction=cc.CallFunc:create(function()


            if self.startRow==self._options.row then

                --游戏结束逻辑设计
                self:_endGame()
                print("game is over=============")
                return

            end

            self.startRow=self.startRow+1

            self:_changeFirstButtonState(self.buttonTab[self.startRow],true)


--            --随机结果的设计
            self._RepeatTab={1,1,1,1,1,1 }
            self._isClickedTab={1,1,1,1,1,1}  --1代表未点击 0代表已经点击
            self.zeroValueNum=0
            self:_clearAllItem()
            self:_clearAllItemLabel()

            self:_InitializationData()
--
--            --注册点击事件
            self:_registEvent()

        end)

        local delayStand=cc.DelayTime:create(0.5)
        local delayStand1=cc.DelayTime:create(1)
        local seq=cc.Sequence:create(delayStand,showAllItem,delayStand1,action1,delayAction,action2,delayAction,callBackAction)

        self.rootNode:runAction(seq)


    end,

    _hideAllItem=function(self)

        for i=1,#self.itemTab do

            local itemFade=cc.FadeOut:create(2)
            self.itemTab[i]:runAction(itemFade)

        end

    end,

    _hideAllItemLabel=function(self)

        for i=1,6 do

            local itemFade=cc.FadeOut:create(2)
            if self.itemLabelTab[i] then
                self.itemLabelTab[i]:runAction(itemFade)
            end


        end

    end,

    _showAllItem=function(self,col)

        for i=1,#self.itemTab do

            self.itemTab[i]:setVisible(true)
            if self._isClickedTab[i]==1 then
                self.itemTab[i]:setOpacity(150)
            end

        end

    end,

    _showTheItemByPrize=function(self,prizeValue,col)

        --显示特定的图标
        print("col============:"..col)
        print("prizeValue============:"..prizeValue)

        self.itemTab[col]:setVisible(true)
        local scaleAction=cc.ScaleTo:create(0.5,1.2)
        local ease1= cc.EaseSineOut:create(scaleAction)
        self.itemTab[col]:runAction(ease1)


        --设置其他金币字体
        for i=1,6 do

            if i~=col then
                if  self.itemLabelTab[i] then
                    self.itemLabelTab[i]:setColor(cc.c3b(0,0,0))
                    self.itemLabelTab[i]:setOpacity(150)

                end

            else

                if  self.itemLabelTab[i] then
                    self.itemLabelTab[i]:setColor(cc.c3b(255,0,0))
                    self.itemLabelTab[i]:setOpacity(255)
                end

            end

        end



        if prizeValue~=0 then


            --这里得封装一个函数 让第一行的其他按钮都不可点击
            self:_changeFirstButtonState(self.buttonTab[self.startRow])

            --这里得封装一个函数 判断是否把第一行消除 让后三行前移
            self:_moveForwardAction(col)

            self.posStr=self.posStr..col..";"

            --添加音乐
            Slot.Audio:playEffect("sound/modules/hawaii/"..Slot.MusicResources["hawaii"].hawaii_bgame_pick)
        else



            --如果分值为0 记录该行点击到0的次数
            self.zeroValueNum=self.zeroValueNum+1

            if  self.zeroValueNum==2 then

                self.posStr=self.posStr..col

                --添加音乐
                Slot.Audio:playEffect("sound/modules/hawaii/"..Slot.MusicResources["hawaii"].hawaii_bgame_empty2)

                self:_changeFirstButtonState(self.buttonTab[self.startRow])
                --游戏结束逻辑设计
                self:_endGame()
                print("game is over=============")
            else

                self.posStr=self.posStr..col..","
                --添加音乐
                Slot.Audio:playEffect("sound/modules/hawaii/"..Slot.MusicResources["hawaii"].hawaii_bgame_empty1)
            end

        end

    end,

    _registButtonEvent=function(self,button,prizeValue,col)


        self.proxy:handleButtonEvent(button, function()

            --table.insert(self.postPOSTAB,col)

            --标记位置已经被点击
            self._isClickedTab[col]=0

            print("you win prizeVaue:"..prizeValue)

            self.totalPrizeValue=self.totalPrizeValue+prizeValue
            print("you win TotlalprizeVaue:"..self.totalPrizeValue)

            self:_setTotalPrize(self.totalPrizeValue)

            print("===========================1")
            --先把按钮隐藏
            button:setVisible(false)


            --封装一个函数 传入一个分数值 返回生成的图标类型 金币或空瓶
            self:_showTheItemByPrize(prizeValue,col)

        end)

    end,

    _registEvent=function(self)

        --封装一个函数 传入button 给每个添加button注册事件 每次都给第一行添加

            for j=1,self._options.col do

                local prizeValue=self.savePrizeTab[j]

                --给第一行对应图标添加点击事件
                self:_registButtonEvent(self.buttonTab[self.startRow][j],prizeValue,j)

            end

    end,



    _getItemByPrize=function(self,prizeValue,col)

        local itemSprite
        if prizeValue~=0 then


            itemSprite=U:getSpriteByName("hawaii_coin.png")

            --添加显示分数
            local prizeLabel = cc.LabelTTF:create(tostring(prizeValue), "Helvetica",75)  --"Marker Felt"
            itemSprite:addChild(prizeLabel,10,1000)
            prizeLabel:setPosition(cc.p(itemSprite:getContentSize().width/2,itemSprite:getContentSize().height/2))
            prizeLabel:setColor(cc.c3b(255,0,0))
            self.itemLabelTab[col]=prizeLabel
            --table.insert(self.itemLabelTab,prizeLabel)

        else

            itemSprite=U:getSpriteByName("hawaii_bottle.png")

        end


        --获取对应node  每次都加入到第一行的node中
        local parentNode=self:_getTheFirstRowNode()
        parentNode:addChild(itemSprite)

        --还得知道对应坐标
        local pos=self.posTab[self.startRow][col]
        itemSprite:setPosition(pos)

        --刚开始隐藏
        itemSprite:setVisible(false)


        --只把第一行的item存储
        self.itemTab[col]=itemSprite

    end,

    _postStr=function(self,seed,index,num)


        if not self.random then self.random = "" else self.random = self.random..";" end

        self.random= self.random..seed..","..index

    end,

    _InitializationData=function(self)

        --self._RepeatTab={1,1,1,1,1,1}

        --第一次随机在进入游戏时，以后每次都在执行完移动动作后

        --从位置id表中随机取出一位 把分值表第一位放到随机位置上
--        math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))


        local count=#self._options.posIdTab
        local index
        local seed1 = Slot.DM:getLocalStorage("seed")
        local seed2
--        if not seed1 then
--            seed1 = os.time()
--            Slot.DM:setLocalStorage("seed", seed1)
--        end

        local isRepeat

        for i=1,count do

            index,seed2 = U:randforgame(seed1, 1, count)

            --检查是否产生过 若产生过继续随机
            isRepeat= self:_isRepeat(self._RepeatTab,index)

            while isRepeat do
                seed1 = seed2
                index ,seed2= U:randforgame(seed1, 1, count)
                isRepeat= self:_isRepeat(self._RepeatTab,index)
            end

            --post data
            self:_postStr(seed1,index,i)

            seed1 = seed2
            --判断是否重复产生


            --把相应的位置标记为0 表示已经产生过了
            self._RepeatTab[index]=0

            --把分数存储在奖励表里 奖励表的下表为随机抽取的位置id
            local prizeVaue=self._options.prizeTab[self.startRow][i]
            self.savePrizeTab[index]=prizeVaue


            --根据分数值产生相应的奖励图标 下标对应位置id
            self:_getItemByPrize(prizeVaue,index)


            --test 1.08

            local tempNodeName=string.format("row1")
            local parentNode=self.proxy:getNodeWithName(tempNodeName)

            if parentNode:getChildByTag(10000+index) then

                parentNode:getChildByTag(10000+index):setString(tostring(prizeVaue))
            else

                local testPrizeLabel = cc.LabelTTF:create(tostring(prizeVaue), "Helvetica",75)

                parentNode:addChild(testPrizeLabel,10)
                testPrizeLabel:setTag(10000+index)
                local pos=self.posTab[self.startRow][index]
                testPrizeLabel:setPosition(cc.p(pos.x,pos.y-50))
                testPrizeLabel:setColor(cc.c3b(0,0,255))
            end

        end

        self.InitializationRow=self.InitializationRow+1
--
--        print("self.itemTab++++++++++++++++++++++++++++++++++++++++++++")
--        U:debug(self.itemTab)
--        print("self.itemTab++++++++++++++++++++++++++++++++++++++++++++")


    end,

    _isShare=function(self)


        if self.totalPrizeValue>=5*self.totalbet and  self.totalPrizeValue>=1000 then

            return true
        else
            return false

        end

    end,

    _handleBonusAction = function(self)

        local bet = Slot.DM:getLocalStorage("hawaiibet")

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
        params["pos"]=self.posStr

        U:debug("params=============")
        U:debug(params)
        U:debug("params=============")

        --服务器验证
        Slot.http:post(
            "games/hawaii",
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


                            local profile = Slot.DM:getBaseProfile()
                            profile.coin = profile.coin + total_bonus
                            Slot.DM:setBaseProfile(profile)
                            self.bonusDlg = nil

                            local delay=cc.DelayTime:create(1)
                            local backToWest=cc.CallFunc:create(function()

                                print("back to west============")
                                local pagePara = self._options.pagePara
                                Slot.App:switchTo("modules/hawaii",{pagePara=pagePara})

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

    end,
    _setTotalPrize=function(self,totalPrize)


        --print("setTotalPrize===============")
        local totalPrizeString=string.format(""..totalPrize)

        local textSprite=self.proxy:getNodeWithName("total_prize")
        textSprite:setString(totalPrizeString)


    end,


    _endGameAction=function(self)

        local delay=cc.DelayTime:create(1)
        local bonusAction=cc.CallFunc:create(function()
            self:_handleBonusAction()

        end)

        local seq=cc.Sequence:create(delay,bonusAction)
        self.rootNode:runAction(seq)

    end,

    _endGame=function(self)

        --显示选择轮次 失败图标 总金额
        --弹出bonus 弹框
        --self.totalPrizeValue
        --self.starRow

        print("you win totalPrize:"..self.totalPrizeValue)
        print("the tryNum is:"..self.startRow)

        --添加音乐
        Slot.Audio:playMusic("sound/modules/hawaii/"..Slot.MusicResources["hawaii"].hawaii_bgame_end)

        local endImageSprite=self.proxy:getNodeWithName("hawaii_endGame")
        endImageSprite:setVisible(true)
        self:_endGameAction()


    end,

    -- clean notification on exit
    onExit=function(self)
        Slot.DM:detach('profile',self._onBaseProfileUpdate)
    end,



    _resertAllData=function(self)


        self.posTab={} -- 用于摆放位置
        self.nodePosTab={} --用于移动时确定移动到的目标位置
        self.scaleTab={}
        self.buttonTab={}
        self.nodeRowTab={}
        self.itemTab={}
        self.itemLabelTab={}
        self.savePrizeTab={}
        self.postPOSTAB={}
        self.startRow=1
        self.zeroValueNum=0
        self.totalPrizeValue=0
        self.posStr=""
        --self.random=""
        self._RepeatTab={1,1,1,1,1,1 } --1代表不重复 0代表重复
        self._isClickedTab={1,1,1,1,1,1}  --1代表未点击 0代表已经点击


    end,
    _isClickedRepeat=function(self,col,row)

        local k=(col-1)*3+row

        if self.isClickedTab[k]==0 then
            return true
        else
            return false
        end

    end,

    getRootNode = function(self)
        if not self.rootNode then

            print("HawaiiParadise.ccbi******************1")

            self.proxy = Slot.CCBProxy:new()
            self.rootNode  = self.proxy:readCCBFile("ccbi/HawaiiParadise.ccbi")

            self.rootNode:addChild(self.proxy:getRootNode())

            self.hawaii_bg=self.proxy:getNodeWithName("hawaii_bg")
            self.hawaii_bg:setContentSize(self._winsize)
            self.rootNode:setContentSize(self._winsize)

            self.hawaii_container=self.proxy:getNodeWithName("hawaii_container")
            self.hawaii_container:setPosition(cc.p(self._winsize.width/2,self._winsize.height/2))
            
            print("HawaiiParadise.ccbi******************2")

        end

        return self.rootNode
    end,

    getDefaultOptions = function(self)

        return U:extend(false, self:_super(), {
            nodeEventAware=true,
            row=4,
            col=6,
            posIdTab={1,2,3,4,5,6},
            prizeTab={}
        })
    end,
})