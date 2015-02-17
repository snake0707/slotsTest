

Slot = Slot or {}

Slot.com = Slot.com or {}

Slot.com.BlackHandCard = Slot.ui.UIComponent:extend({
    __className = "Slot.com.BlackHandCard",

    initWithCode = function(self, options)

        self:_super(options)

        self:_getDataFromDB()

        self:_resertAllData()
        self:_setup()

        --随机结果的设计
        self:_InitializationData()

        --触摸事件的设计

        self:_registEvent()

        self:_onEvent()

    end,

    saveClickedCardTab={},
    saveCardTab={},
    savePosTab={},
    prizeTab={},
    sameKindCardTab={},

    textTure=nil,
    textTag=1000,
    itemTag=1000,
    prizeTag=1001,
    isEndGame=false,

    _setup = function(self)

        local pagePara = self._options.pagePara or {}
        self.totalbet=pagePara.totalbet or 0
        self.prewin=pagePara.win or 0

        --获取背景


        local  textSprite=cc.LabelBMFont:create("0","image/font/common/font-issue1343-hd.fnt")
        --textSprite:setScale(0.6)
        local textNode=self.proxy:getNodeWithName("text_Node")

        print("type(textNode):"..type(textNode))


        textNode:addChild(textSprite,1,self.textTag)

        local total_prize=self.proxy:getNodeWithName("total_prize")

        textSprite:setPosition(total_prize:getPosition())
    end,

    _getDataFromDB=function(self)

        local sq = Slot.sqlite:new()
        sq:create("storage/blackhanddata.db")

        self.awardTab={}
        self.cardKindTab={}
        self.cardNumTab={}

        local data= {}
        data=sq:readRows("tbl_bonus_game")

        for i, v in pairs(data) do
            self.awardTab[i] =v.prize
            self.cardKindTab[i] =v.type
            self.cardNumTab[i] =v.number

        end

        U:debug("self.awardTab==================")
        U:debug(self.awardTab)
        U:debug("self.awardTab==================")
        sq:close()


    end,

    _onEvent=function(self)


        self:onEvent("switch_end",function()

            Slot.Audio:playMusic("sound/modules/blackhand/"..Slot.MusicResources["blackhand"].blackhand_bgame_begin)

            self:_startGameAction()

        end)

        self:onEvent("WillEnterForeground",function()
            Slot.Audio:stopMusic(true)
            Slot.Audio:playMusic("sound/modules/blackhand/"..Slot.MusicResources["blackhand"].blackhand_bgame_begin)

        end)


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
    _getSpriteByColAndRow=function(self, pos)

        local tempSpriteName=string.format("card_col"..pos.y.."_row"..pos.x)
        local card_sprite=self.proxy:getNodeWithName(tempSpriteName)

        card_sprite:setTag((pos.x-1)*6+pos.y)

        return card_sprite
    end,


    --通过类型生成相应的道具 金袋或者
    _getItemsByType=function(self, type)

        local itemSprite


        if type==1 then


            itemSprite=U:getSpriteByName("prize50.png")


        elseif type==2 then

            itemSprite=U:getSpriteByName("prize100.png")

        elseif type==3 then

            itemSprite=U:getSpriteByName("prize150.png")

        elseif type==4 then

            itemSprite=U:getSpriteByName("prize200.png")

        elseif type==5 then
            itemSprite=U:getSpriteByName("prize400.png")

        end

        return itemSprite


    end,

    _getWorldPoint=function(self,parentNode,nodePoint)

        local worldPos = cc.p(parentNode:convertToWorldSpace(nodePoint))
        local nodePos = cc.p(self.blackHand_bg:convertToNodeSpace(worldPos))

        return nodePos


    end,

    _getItemSprite=function(self,parentNode,index,posId)

        local itemSprite
        local prizeValue
        local pos=cc.p(parentNode:getContentSize().width/2,parentNode:getContentSize().height/2)

        if index<=6 then

            --封装一个函数 根据类型产生不同的item以及对应奖金值
            itemSprite=self:_getItemsByType(self.cardKindTab[1])
            prizeValue=self.awardTab[self.cardKindTab[1]]

        elseif index<=10 then

            itemSprite=self:_getItemsByType(self.cardKindTab[2])
            prizeValue=self.awardTab[self.cardKindTab[2]]

        elseif index<=14 then

            itemSprite=self:_getItemsByType(self.cardKindTab[3])
            prizeValue=self.awardTab[self.cardKindTab[3]]

        elseif index<=16 then

            itemSprite=self:_getItemsByType(self.cardKindTab[4])
            prizeValue=self.awardTab[self.cardKindTab[4]]

        elseif index<=18 then

            itemSprite=self:_getItemsByType(self.cardKindTab[5])
            prizeValue=self.awardTab[self.cardKindTab[5]]

        end



        if parentNode:getChildByTag(self.prizeTag) then

            parentNode:getChildByTag(self.itemTag):removeFromParent()
            parentNode:addChild(itemSprite,10,self.itemTag)
            itemSprite:setPosition(pos)
            itemSprite:setVisible(false)


            parentNode:getChildByTag(self.prizeTag):setString(tostring(prizeValue))
            self.prizeTab[posId]=prizeValue

            --test

            local testPrizeLabel = cc.LabelTTF:create(tostring(prizeValue), "Marker Felt",50)
            parentNode:addChild(testPrizeLabel,100)
            testPrizeLabel:setPosition(cc.p(pos.x,pos.y+75))
            testPrizeLabel:setColor(cc.c3b(0,255,0))

            return

        end


        parentNode:addChild(itemSprite,10,self.itemTag)
        itemSprite:setPosition(pos)

        --产生奖金精灵 不显示



        local prizeLabel = cc.LabelTTF:create(tostring(prizeValue), "Marker Felt",50)
        parentNode:addChild(prizeLabel,100,self.prizeTag)
        prizeLabel:setPosition(cc.p(pos.x,pos.y-75))
        prizeLabel:setColor(cc.c3b(255,0,0))

        --test
        itemSprite:setVisible(false)
        prizeLabel:setVisible(false)

        self.prizeTab[posId]=prizeValue

        return itemSprite,prizeValue

    end,





    _moveAction=function(self,time,distance)
        if time==nil then time=0.2 end
        if distance==nil then distance=200 end

        local moveUp=cc.MoveBy:create(time,cc.p(0,distance))
        local moveRight=cc.MoveBy:create(time,cc.p(distance,0))
        local moveDown=cc.MoveBy:create(time,cc.p(0,-distance))
        local moveLeft=cc.MoveBy:create(time,cc.p(-distance,0))
        local seq=cc.Sequence:create(moveUp,moveRight,moveDown,moveLeft)

        local ratote=cc.RotateBy:create(1,720*2)
        local spaw=cc.Spawn:create(ratote,seq)
        return spaw

    end,


    _moveToCenterAction=function(self)


        for i=1,#self.saveCardTab do

            local delay=cc.DelayTime:create(0.01*i)


            local centerPos=cc.p(self.banzi:getContentSize().width/2,self.banzi:getContentSize().height/2)

            local moveToCenter=cc.MoveTo:create(0.1,centerPos)

            local seq=cc.Sequence:create(delay,moveToCenter)
            self.saveCardTab[i]:runAction(seq)

        end


    end,


    _xipaiAction=function(self)

        print("_xipaiAction============11")
        for i=1,#self.saveCardTab do

            --#self.saveCardTab
            --这里设置zorder
            --self.saveCardTab[i]:setLocalZOrder(1000+i)
            if i==5 then return end
            --if i~=1  then

                local delay=cc.DelayTime:create(0.2*i)
                local xipai= self:_moveAction(0.1,self.saveCardTab[i]:getContentSize().height/3)
                local seq=cc.Sequence:create(delay,xipai)
                self.saveCardTab[i]:runAction(seq)
            --end

        end

    end,

    _moveBack=function(self)

        for i=1,#self.saveCardTab do

            local delay=cc.DelayTime:create(0.02*i)
            local moveBack=cc.MoveTo:create(0.1,self.savePosTab[i])
            local seq=cc.Sequence:create(delay,moveBack)
            self.saveCardTab[i]:runAction(seq)

        end

    end,


    --翻转到正面 显示2秒 再翻转回去
    _startAction=function(self,time)



        print("_startAction==========1")

        if time==nil then time=1 end

        local action1=cc.CallFunc:create(function()

            self:_turnAllCardStart()

        end)

        local delayStand=cc.DelayTime:create(time/2)
        local delay=cc.DelayTime:create(time)

        local action2=cc.CallFunc:create(function()

            self:_turnAllCardStart("back")

        end)

        --local delay1=cc.DelayTime:create(1)
        local seq=cc.Sequence:create(delayStand,action1,delay,action2)


        print("_startAction==========2")

        return seq




    end,

    _resertAllData=function(self)

        self.randomTab={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18 }
        self.saveClickedCardTab={}
        self.saveCardTab={}
        self.savePosTab={}
        self.prizeTab={}
        self.sameKindCardTab={}
        self.postPOSTAB={}

        self.isEndGame=false



    end,

    _postStr=function(self,seed,index,num)
        if num~=#self.posTab then
            self.random= self.random..seed..","..index..";"
        else
            self.random= self.random..seed..","..index
        end


    end,


    _randomInitial=function(self)

        local count=#self.posIdTab
        local id
        local seed1 = Slot.DM:getLocalStorage("seed")
        local seed2
--        if not seed1 then
--            seed1 = os.time()
--            Slot.DM:setLocalStorage("seed", seed1)
--        end
--        math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))

        for i=1,count do

            --local id=math.random(1,count)

            id,seed2 = U:randforgame(seed1, 1, count)

            --判断是否重复产生
            local isRepeat= self:_isRepeat(self.randomTab,id)

            while isRepeat do
                seed1 = seed2
                id,seed2 = U:randforgame(seed1, 1, count)

                isRepeat= self:_isRepeat(self.randomTab,id)
            end

            --post data

            if self.flag then
                self:_postStr(seed1,id,i)
            end

            seed1 = seed2

            --把相应的位置标记为0 表示已经产生过了
            self.randomTab[id]=0

            --获取到位置
            local pos=self.posTab[id]

            --print("_InitializationData=====================2")

            --封装一个函数 传入一个位置 返回一个卡牌精灵 而且把每个位置保存下 并把每个卡牌存到表里 方便做动作
            local cardSprite=self:_getSpriteByColAndRow(pos)
            table.insert(self.saveCardTab,cardSprite)

            --把获取的节点坐标转换成世界坐标 写一个函数 返回一个相对于背景的坐标 方便后面做返回动作
            local nodePos=cc.p(cardSprite:getPosition())
            --local worldPos=self:_getWorldPoint(parentNode,nodePos)
            table.insert(self.savePosTab,nodePos)


            --封装一个函数产生特定数量的图标 并显示隐藏

            local prizeValue
            local itemSprite

            --这个疑问一定要解决  为什么外面接到的是空表
            itemSprite,prizeValue=self:_getItemSprite(cardSprite,i,id)

        end


        self.flag=true



    end,

    _startGameAction=function(self)

        local actionCallBack=cc.CallFunc:create(function()


        --执行动作之后都设置可点击
            self.isClickedTab={1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 }


        end)

    --执行开场动作 翻转到正面 显示2秒 再翻转回去
        local action=self:_startAction()

        --模拟洗牌的动作

        --移到中点
        local moveToCenter=cc.CallFunc:create(function()


            self:_moveToCenterAction()

        end)


        --回到原处


        local moveBack=cc.CallFunc:create(function()

            self:_moveBack()


        end)


        local callBack=cc.CallFunc:create(function()
        --再次随机一次
            self:_resertAllData()
            --self:_getDataFromDB()
            self:_randomInitial()

            print("self.prizeTab11111++++++++++++++++++++++++++++++++++++++++++++")
            U:debug(self.prizeTab)
            print("self.prizeTab11111++++++++++++++++++++++++++++++++++++++++++++")

        end)


        local delay=cc.DelayTime:create(0.5)
        local delay2=cc.DelayTime:create(1)
        local delay3=cc.DelayTime:create(0.5)

        local seq=cc.Sequence:create(action,moveToCenter,delay3,moveBack,callBack,delay,actionCallBack)
        self.rootNode:runAction(seq)



    end,

    _InitializationData=function(self)


        --配置信息:位置id表 位置表 随机表 卡牌种类表 数量表 奖励表 点击是否重复表
        self.posIdTab={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18 }

        --cc.p(1,2) 代表第1行第2列位置上的卡牌 从下往上 从左往右
        self.posTab={cc.p(1,1),cc.p(1,2),cc.p(1,3),cc.p(1,4),cc.p(1,5),cc.p(1,6),
                     cc.p(2,1),cc.p(2,2),cc.p(2,3),cc.p(2,4),cc.p(2,5),cc.p(2,6),
                     cc.p(3,1),cc.p(3,2),cc.p(3,3),cc.p(3,4),cc.p(3,5),cc.p(3,6)
        }

        self.randomTab={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18 }


        -- 1代表未点击 0代表已经点击过
        --执行动作之前都不能点击
        self.isClickedTab={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }

        self.flag=false

        --postData
        self.random=""
        self.postPOSTAB={}


        --第一步 产生对应种类的卡牌放到随即抽取的位置上

        --math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))

        self:_randomInitial()




    end,



    -- clean notification on exit
    onExit=function(self)
        Slot.DM:detach('profile',self._onBaseProfileUpdate)
    end,


    _startTurnOverCard=function(self,itemSprite,prizeSprite,time)

        if time==nil then time=3/14 end

--        local animation=cc.Animation:create()
--        local number,name
--        for i=1,4 do
--            name=string.format("image/modules/blackhand/poke"..i ..".png")
--            animation:addSpriteFrameWithFile(name)
--        end
--
--        animation:setDelayPerUnit(time)
--
--        --设置为false 停止到最后一帧
--        animation:setRestoreOriginalFrame(false)

        local animFrames={}
        for i=1,4 do

            local name=string.format("poke"..i..".png")
            local frame=U:getSpriteFrame(name)
            animFrames[i]=frame

        end

        local animation=cc.Animation:createWithSpriteFrames(animFrames,time)
        animation:setRestoreOriginalFrame(false)


        local actionDoor=cc.Animate:create(animation)

        local showItem=cc.CallFunc:create(function()

            prizeSprite:setVisible(true)
            itemSprite:setVisible(true)

        end)

        local seq=cc.Sequence:create(actionDoor,showItem)


        return seq


    end,

    _startTurnOverCardBack=function(self,itemSprite,prizeSprite,time)

        if time==nil then time=3/14 end

        local animFrames={}
        for i=4,1,-1 do

            local name=string.format("poke"..i..".png")
            local frame=U:getSpriteFrame(name)
            animFrames[5-i]=frame

        end

        local animation=cc.Animation:createWithSpriteFrames(animFrames,time)
        animation:setRestoreOriginalFrame(false)

        local actionDoor=cc.Animate:create(animation)


        local showItem=cc.CallFunc:create(function()

            prizeSprite:setVisible(false)
            itemSprite:setVisible(false)

        end)

        local seq=cc.Sequence:create(showItem,actionDoor)


        return seq


    end,

    _isClickedRepeat=function(self,col,row)

        local k=(col-1)*3+row

        if self.isClickedTab[k]==0 then
            return true
        else
            return false
        end

    end,




    _setTotalPrize=function(self,totalPrize)


        local totalPrizeString=string.format(""..totalPrize)

        local textNode=self.proxy:getNodeWithName("text_Node")
        local textSprite=textNode:getChildByTag(self.textTag)
        textSprite:setString(totalPrizeString)


    end,


    --根据分数值判断是否类型相同
    _isTheSameKind=function(self,tab,cardSprite)

        local count=#tab

        if count==0 then return false end

        local prizeValue=cardSprite:getChildByTag(self.prizeTag):getString()
        for i=1,count do

            local tempSprite=tab[i]
            local prizePre=tempSprite:getChildByTag(self.prizeTag):getString()
            if prizeValue==prizePre then

                table.insert(self.sameKindCardTab,tab[i])


                --存取上一个位置
                self.postPOSTAB[1]=tab[i]:getTag()
                self.postPOSTAB[2]=cardSprite:getTag()
                return true

            end

        end

        return false



    end,

    _turnAllCardEnd=function(self)



        for i=1,6 do

            for j=1,3 do

                local k=(i-1)*3+j
                local tempSpriteName=string.format("card_col"..i.."_row"..j)
                local card_sprite=self.proxy:getNodeWithName(tempSpriteName)


                if self.isClickedTab[k]~=0 then
                    self.isClickedTab[k]=0
                    local itemSprite=card_sprite:getChildByTag(self.itemTag)
                    local prizeSprite=card_sprite:getChildByTag(self.prizeTag)

                    local anctionCard=self:_startTurnOverCard(itemSprite,prizeSprite,1/30)
                    card_sprite:runAction(anctionCard)

                end


            end

        end


    end,

    _turnAllCardStart=function(self,type)


        local cardTab=self.saveCardTab
        local count=#cardTab

        for i=1,count do


            local itemSprite=cardTab[i]:getChildByTag(self.itemTag)
            local prizeSprite=cardTab[i]:getChildByTag(self.prizeTag)
            local anctionCard
            if type~="back" then
                anctionCard=self:_startTurnOverCard(itemSprite,prizeSprite,1/30)
            else
                anctionCard=self:_startTurnOverCardBack(itemSprite,prizeSprite,1/30)
            end

            cardTab[i]:runAction(anctionCard)

        end
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

        local bet = Slot.DM:getLocalStorage("blackhandbet")

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
        params["pos"]=self.postPOSTAB[1]..","..self.postPOSTAB[2]

        Slot.http:post(
            "games/blackhand",
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
                            profile.coin = profile.coin+params["coins"]
                            Slot.DM:setBaseProfile(profile)
                            self.bonusDlg = nil

                            local delay=cc.DelayTime:create(1)
                            local backToWest=cc.CallFunc:create(function()

                                print("back to blackhand============")
                                local pagePara = self._options.pagePara

                                U:debug(pagePara)

                                Slot.App:switchTo("modules/blackhand",{pagePara=pagePara})

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

    --self.totalPrizeValue


    _showTheSameCard=function(self)

        for i=1,#self.sameKindCardTab do


            self.sameKindCardTab[i]:setLocalZOrder(1000+i)

            self.sameKindCardTab[i]:setScale(1.5)


            local cardPosX=self.sameKindCardTab[i]:getPositionX()
            local centerPos=cc.p(self.banzi:getPosition())

            local nodeCenterPos=self.sameKindCardTab[i]:getParent():convertToNodeSpace(centerPos)
            local targetPos
            if i==1 then

                targetPos=cc.p(nodeCenterPos.x-250,nodeCenterPos.y)

            else

                targetPos=cc.p(nodeCenterPos.x+250,nodeCenterPos.y)

            end

            local moveAction=cc.MoveTo:create(0.2,targetPos)

            local ligthAction=cc.CallFunc:create(function()

--
--                local light=cc.Sprite:create("image/modules/blackhand/blackhand_light.png")
--                local sun=cc.Sprite:create("image/modules/blackhand/blackhand_sun.png")

                local light=U:getSpriteByName("blackhand_light.png")
                local sun=U:getSpriteByName("blackhand_sun.png")


                local parentNode=self.sameKindCardTab[i]:getParent()

                parentNode:addChild(light,1)
                parentNode:addChild(sun,2)

                --self.sameKindCardTab[i]:setLocalZOrder(10)

                local pos=cc.p(self.sameKindCardTab[i]:getPosition())
                light:setPosition(pos)
                sun:setPosition(pos)

                local rotateLight=cc.RotateBy:create(20,360)
                local repF=cc.RepeatForever:create(rotateLight)
                light:setScale(2)
                light:runAction(repF)
            end)


            local seq=cc.Sequence:create(moveAction,ligthAction)
            --local seq=cc.Sequence:create(moveAction)
            self.sameKindCardTab[i]:runAction(seq)

            --回调

        end
    end,

    _endGameAction=function(self)

        local delay=cc.DelayTime:create(1)

        local showLight=cc.CallFunc:create(function()

               --标示两张匹配的牌
            self:_showTheSameCard()


        end)
        local bonusAction=cc.CallFunc:create(function()
            self:_handleBonusAction()

        end)

        local delayStand=cc.DelayTime:create(3)
        local seq=cc.Sequence:create(delay,showLight,delayStand,bonusAction)
        --local seq=cc.Sequence:create(delay,showLight)
        self.rootNode:runAction(seq)

    --添加音乐
    Slot.Audio:playMusic("sound/modules/blackhand/"..Slot.MusicResources["blackhand"].blackhand_bgame_end)

    end,

    _isEndGame=function(self)


        self:_endGameAction()

    end,

    --触摸点的转换 先转换成node的相对坐标 在遍历node看哪个card包含这个触摸点
    _startToConverPos=function(self,touchPoint)

        if self.isEndGame then return end

        for i=1,6 do


                for j=1,3 do
                    local tempSpriteName=string.format("card_col"..i.."_row"..j)
                    local card_sprite=self.proxy:getNodeWithName(tempSpriteName)
                    local nodePos1=self.banzi:convertToNodeSpace(touchPoint)

                    if cc.rectContainsPoint(card_sprite:getBoundingBox(),nodePos1) then

                        print("col:"..i.." row:"..j)

                        --检验是否点击过 点击过就返回 不做任何动作
                        if self:_isClickedRepeat(i,j) then

                            print("clickRepeat.......")
                            return

                        end

                        --添加音乐
                        Slot.Audio:playEffect("sound/modules/blackhand/"..Slot.MusicResources["blackhand"].blackhand_bgame_pickcard)

                        --开始触摸后的动作

                        --标记为已经点击过
                        local k=(i-1)*3+j
                        self.isClickedTab[k]=0

                        --执行翻牌动作
                        local itemSprite=card_sprite:getChildByTag(self.itemTag)
                        local prizeSprite=card_sprite:getChildByTag(self.prizeTag)
                        local anctionCard=self:_startTurnOverCard(itemSprite,prizeSprite,1/60)
                        card_sprite:runAction(anctionCard)

                        --这里要封装一个函数,传进一个卡牌的分数值，判断是否有一样的 有的话返回true 否则返回false
                        local isSameKind=self:_isTheSameKind(self.saveClickedCardTab,card_sprite)

                        if isSameKind then

                            --postdata
                            --self.postPOSTAB[2]=(j-1)*6+i

                            --添加音乐
                            Slot.Audio:playEffect("sound/modules/blackhand/"..Slot.MusicResources["blackhand"].blackhand_bgame_cardmatch)

                            --获取两张相同的牌
                            table.insert(self.sameKindCardTab,card_sprite)

                            --这里首先得让所有牌都无法点击
                            self.isEndGame=true

                            local retPrize=prizeSprite:getString()
                            self.totalPrizeValue=tonumber(retPrize)

                            --显示在显示框里 传进一个奖励值让他显示
                            self:_setTotalPrize(retPrize)

                            --游戏结束 把所有没有翻转的卡牌全部翻转  写一个函数
                            local dely=cc.DelayTime:create(1)
                            local endAction=cc.CallFunc:create(function()
                                self:_turnAllCardEnd()
                            end)

                            local backToBlackHand=cc.CallFunc:create(function()

                                self:_isEndGame()
                            end)

                            local seq=cc.Sequence:create(dely,endAction,backToBlackHand)
                            self.rootNode:runAction(seq)


                            print("you win the prize is "..retPrize)
                            print("the game is over====================")
                        else

                            --把已经翻过的卡牌存到一张表里
                            table.insert(self.saveClickedCardTab,card_sprite)



                        end


                    end

                end
        end

    end,

    _registEvent = function(self)


    -- handing touch events
        local touchBeginPoint = nil
        local function onTouchBegan(touch, event)
            local location = touch:getLocation()
            print("location:x".. location.x.."  y:"..location.y)
            --touchBeginPoint = {x = location.x, y = location.y}
--
            --转换触摸点
            self:_startToConverPos(location)


            return true
        end



        local listener = cc.EventListenerTouchOneByOne:create()
        listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )

        local eventDispatcher = self.rootNode:getEventDispatcher()
        eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.rootNode)

    end,

    getRootNode = function(self)
        if not self.rootNode then

            print("BlackHandCard.ccbi******************1")

            self.proxy = Slot.CCBProxy:new()
            self.rootNode  = self.proxy:readCCBFile("ccbi/BlackHandCard.ccbi")

            self.rootNode:addChild(self.proxy:getRootNode())

            self.blackHand_bg=self.proxy:getNodeWithName("blackhand_bg")
            self.blackHand_bg:setContentSize(self._winsize)
            self.rootNode:setContentSize(self._winsize)


            self.banzi=self.proxy:getNodeWithName("blackhand_banzi")
            self.banzi:setPosition(cc.p(self._winsize.width/2,self._winsize.height/2+80))


            self.textNode=self.proxy:getNodeWithName("text_Node")
            self.textNode:setPositionX(self._winsize.width/2)
            print("BlackHandCard.ccbi******************2")

        end

        return self.rootNode
    end,

    getDefaultOptions = function(self)

        return U:extend(false, self:_super(), {
            nodeEventAware=true,

        })
    end,
})