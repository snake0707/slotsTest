
--data table

--local prizeTab={200,100,80,70,50,50,30,30,30,0,0,0 }
--local prizeTab
local sumPrize=640

local randomTab

--cc.p(1,2) 代表第1列第2行
local posTab={
              cc.p(1,1),cc.p(1,2),cc.p(1,3),
              cc.p(2,1),cc.p(2,2),cc.p(2,3),
              cc.p(3,1),cc.p(3,2),cc.p(3,3),
              cc.p(4,1),cc.p(4,2),cc.p(4,3)
             }


--local isClickedTab
--
--
--local resultTab



Slot = Slot or {}

Slot.com = Slot.com or {}

Slot.com.HighNoon = Slot.ui.UIComponent:extend({
    __className = "Slot.com.HighNoon",

    initWithCode = function(self, options)



        self:_super(options)

        self:_getDataFromDB()

        self:_resertData()

        self:_setup()

        --随机结果的设计
        self:_InitializationData()

        --触摸事件的设计
        self:_onEvent()
        self:_registEvent()
    end,

    randomTab={},
    isClickedTab={},
    resultTab={},
    doorTab={},
    itemTab={},


    totalPrize=0,
    errorNum=0,
    textTure=nil,
    textTag=1000,
    backButton=nil,



    _getDataFromDB=function(self)

        local sq = Slot.sqlite:new()
        sq:create("storage/westdata.db")
        self.prizeTab={}

        local data= {}
        data=sq:readRows("tbl_bonus_game")

        for i, v in pairs(data) do
            self.prizeTab[i] =v.prize
        end
        sq:close()

    end,

    _onEvent=function(self)


        self:onEvent("switch_end",function()
        --添加音乐

            Slot.Audio:playMusic("sound/modules/west/"..Slot.MusicResources["west"].west_bgame_begin)

        end)

        self:onEvent("WillEnterForeground",function()
            Slot.Audio:stopMusic(true)
            Slot.Audio:playMusic("sound/modules/west/"..Slot.MusicResources["west"].west_bgame_begin)

        end)


    end,

    _resertData = function(self)

        self.randomTab={1,2,3,4,5,6,7,8,9,10,11,12 }

        -- 1代表未点击 0代表已经点击过
        self.isClickedTab={1,1,1,1,1,1,1,1,1,1,1,1 }

        --记录每次随即后每扇门后代表的金币值
        self.resultTab={
           {0,0,0},--第1列
           {0,0,0},--第2列
           {0,0,0},--第3列
           {0,0,0},--第4列
        }

        self.doorTab={}
        self.itemTab={}

        self.random=""
        self.posStr=nil
        self.postPOSTAB={}
    end,

    _setup = function(self)



        local pagePara = self._options.pagePara or {}
        self.totbet=pagePara.totalbet or 0
        self.prewin=pagePara.win or 0

        --local textSprite = cc.LabelTTF:create("0", "Marker Felt", 48)
        local  textSprite=cc.LabelBMFont:create("0","font/common/font-issue1343-hd.fnt")
        --textSprite:setScale(0.8)
        local textNode=self.proxy:getNodeWithName("text_Node")

        print("type(textNode):"..type(textNode))


        textNode:addChild(textSprite,1,self.textTag)

        local total_prize=self.proxy:getNodeWithName("total_prize")

        --local betSprite=self.proxy:getNodeWithName("highNoon_bet")
        self.bet = Slot.DM:getLocalStorage("westbet")
        --betSprite:setString(tostring(self.bet))

        textSprite:setPosition(total_prize:getPosition())
    end,


    --检查是否重复产生 true表示已经随机产生过了 false表示未产生过
     isRepeat=function(self,tab,i)

     if tab[i]==0 then
        return true
     else
        return false
     end

    end,

    --通过坐标值返回一个精灵
    getSpriteByColAndRow=function(self,pos)

       local tempSpriteName=string.format("door_col"..pos.x.."_row"..pos.y)
       local door_sprite=self.proxy:getNodeWithName(tempSpriteName)

        return door_sprite
    end,


    --通过类型生成相应的道具 金袋或者
    getItemsByType=function(self,index,col,row)

            local item
            if index==10 or index==11 or index==12 then

                item=U:getSpriteByName("highnoon_X.png")
            else
                item=U:getSpriteByName("highnoon_gold.png")
            end

            item:setVisible(false)

            local nodeName=string.format("highnoon_col"..col)
            local node=self.proxy:getNodeWithName(nodeName)

            --print("type(node):"..type(node))

            node:addChild(item,1)
            item:setTag(1000+(col-1)*3+row)


--            print("col:"..col.." row:"..row)
--            print("itemTag:"..item:getTag())
            return item

    end,

    _testShow=function(self,prizeValue,doorSprite)

        local showPrize = cc.LabelTTF:create(tostring(prizeValue), "Marker Felt", 80)
        doorSprite:addChild(showPrize,100)
        showPrize:setPosition(cc.p(doorSprite:getContentSize().width/2,doorSprite:getContentSize().height-20))
        showPrize:setColor(cc.c3b(255,0,0))

    end,

    _postStr=function(self,seed,index,num)
        if num~=#posTab then
            self.random= self.random..seed..","..index..";"
        else
            self.random= self.random..seed..","..index
        end


    end,

    _InitializationData=function(self)

--        math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
        local index
        local seed1 = Slot.DM:getLocalStorage("seed")
        local seed2
--           if not seed1 then
--               seed1 = os.time()
--               Slot.DM:setLocalStorage("seed", seed1)
--           end

        local isRepeat

        --循环12次
        for i=1,12 do
           --index=math.random(1,12)
           index,seed2 = U:randforgame(seed1, 1, #posTab)

           --检查是否产生过 若产生过继续随机
           isRepeat= self:isRepeat(self.randomTab,index)

           while  isRepeat do
               --index=math.random(1,12)
               seed1 = seed2
               index ,seed2= U:randforgame(seed1, 1, #posTab)
               isRepeat= self:isRepeat(self.randomTab,index)
           end

           --post data
           self:_postStr(seed1,index,i)

           seed1 = seed2

           --从随机表中获取一个数 并把该数置为0表示已经产生过了
           local a=self.randomTab[index]
           self.randomTab[index]=0

           local pos=posTab[a]

           local doorSprite=self:getSpriteByColAndRow(pos)

           --把所有门加入到表里
           self.doorTab[index]=doorSprite

           local itemSprite=self:getItemsByType(i,pos.x,pos.y)

           itemSprite:setPosition(doorSprite:getPosition())

           self.itemTab[index]=itemSprite

           --存储下摆放的奖励结果表
           self.resultTab[pos.x][pos.y]=self.prizeTab[i]


           --test 1.08

            self:_testShow(self.prizeTab[i],doorSprite)

        end

--        print("self.resultTab++++++++++++++++++++++++++++++++++++++++++++")
--        U:debug(self.resultTab)
--        print("self.resultTab++++++++++++++++++++++++++++++++++++++++++++")




    end,



    -- clean notification on exit
    onExit=function(self)
        Slot.DM:detach('profile',self._onBaseProfileUpdate)



    end,


    startOpenDoor=function(self)



        local animFrames={}
        for i=1,3 do

            local name=string.format("highnoon_door"..i..".png")
            local frame=U:getSpriteFrame(name)
            animFrames[i]=frame

        end

        local animation=cc.Animation:createWithSpriteFrames(animFrames,1/30)
        animation:setRestoreOriginalFrame(false)
        local actionDoor=cc.Animate:create(animation)

        Slot.Audio:playEffect("sound/modules/west/"..Slot.MusicResources["west"].west_bgame_dooropen)

        return actionDoor


    end,

    isClickedRepeat=function(self,col,row)

        local k=(col-1)*3+row
        --(i-1)*3+j

        if self.isClickedTab[k]==0 then
            return true
        else
            return false
        end

    end,



    --false 代表不显示 true代表显示
    isShowItemText=function(self,col,row)

        if self.resultTab[col][row]==0 then

            return false
        else

           return true
        end

    end,

    showItems=function(self,node,col,row)

        --print("startShow******************")
        local tag=(col-1)*3+row
        --print("itemTag:"..1000+tag)
        local itemSprite=node:getChildByTag(1000+tag)
        itemSprite:setVisible(true)

        --显示文字 如果是0就不显示
        if self:isShowItemText(col,row) then


            local tempSpriteName=string.format("door_col"..col.."_row"..row)
            local door_sprite=self.proxy:getNodeWithName(tempSpriteName)


            --用纹理来创建字体

            local prizeString=string.format(""..self.resultTab[col][row])

            --这个蛮好 但有点大 要缩放
            local  textSprite=cc.LabelBMFont:create(prizeString,"font/common/font-issue1343-hd.fnt")
            node:addChild(textSprite,10)
            textSprite:setScale(0.8)
            --textSprite:setColor(cc.c3b(255,0,0))
            textSprite:setPosition(door_sprite:getPosition())

            Slot.Audio:playEffect("sound/modules/west/"..Slot.MusicResources["west"].west_bgame_gold)
        else

            Slot.Audio:playEffect("sound/modules/west/"..Slot.MusicResources["west"].west_bgame_none)
        end

    end,

    _isShare=function(self)


        local data=Slot.DM:getBaseProfile()

        if self.totalPrize>=5*self.totbet and  self.totalPrize>=1000 then

            return true
        else
            return false

        end

    end,

    _handleBonusAction = function(self)

        local bet = Slot.DM:getLocalStorage("westbet")

        local bonus =  self.totalPrize
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


        Slot.http:post(
            "games/west",
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

                                print("back to west============")
                                U:debug(self._options.pagePara)
                                local pagePara = self._options.pagePara
                                Slot.App:switchTo("modules/west",{pagePara = pagePara})

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


    _endGameAction=function(self)

        local delay=cc.DelayTime:create(1)
        local bonusAction=cc.CallFunc:create(function()
            self:_handleBonusAction()

        end)

        local seq=cc.Sequence:create(delay,bonusAction)
        self.rootNode:runAction(seq)

    end,

    _showLight=function(self,parentNode)

        local ligthSprite=U:getSpriteByName("highNoon_light.png")
        local sunSprite=U:getSpriteByName("highNoon_sun.png")
              
        parentNode:addChild(ligthSprite,1)
        parentNode:addChild(sunSprite,2)

        ligthSprite:setPosition(cc.p(parentNode:getContentSize().width/2,parentNode:getContentSize().height/2))
        sunSprite:setPosition(cc.p(parentNode:getContentSize().width/2,parentNode:getContentSize().height/2))

        local rotateLight=cc.RotateBy:create(20,360)
        local repF=cc.RepeatForever:create(rotateLight)
        ligthSprite:runAction(repF)

    end,
    _turnOpenNoClickedDoor=function(self)

        for i=1,#self.doorTab do

            local pos=posTab[i]
            if self.isClickedTab[i]~=0 then

                self.isClickedTab[i]=0
                --门打开

                local actionDoor=self:startOpenDoor()

                --显示金币或X
                local showItem=cc.CallFunc:create(function()

                    self.itemTab[i]:setVisible(true)
                    --self.itemTab[i]:setOpacity(110)



                    --显示分数
                    if self:isShowItemText(pos.x,pos.y) then


                        --添加音乐
                        Slot.Audio:playEffect("sound/modules/west/"..Slot.MusicResources["west"].west_bgame_gold)

                        --用纹理来创建字体

                        local prizeString=string.format(""..self.resultTab[pos.x][pos.y])

                        --这个蛮好 但有点大 要缩放
                        local  textSprite=cc.LabelBMFont:create(prizeString,"font/common/font-issue1343-hd.fnt")
                        self.itemTab[i]:addChild(textSprite,10)
                        textSprite:setScale(0.8)
                        --textSprite:setColor(cc.c3b(255,0,0))
                        textSprite:setPosition(cc.p(self.itemTab[i]:getContentSize().width/2,self.itemTab[i]:getContentSize().height/2))

                    else

                        --添加音乐
                        Slot.Audio:playEffect("sound/modules/west/"..Slot.MusicResources["west"].west_bgame_none)

                    end



                end)


                local seq=cc.Sequence:create(actionDoor,showItem)
                self.doorTab[i]:runAction(seq)



            end

            --点中金币的加添加背景光线
            if self.isClickedTab[i]==0 then

                if self:isShowItemText(pos.x,pos.y) then
                    local tempSpriteName=string.format("door_col"..pos.x.."_row"..pos.y)
                    local door_sprite=self.proxy:getNodeWithName(tempSpriteName)

                    self:_showLight(door_sprite)
                end
            end



        end



    end,


    isEndGame=function(self)

        --如果直接点击了二次人质 推出游戏时给默认奖励30
        if self.errorNum==2 then

            if self.totalPrize==0 then
                self.totalPrize=30

            end

            --结束时要把剩下的门都打开
            --self:_turnOpenNoClickedDoor()
            local delay=cc.DelayTime:create(1)
            local turnNoClickDoor=cc.CallFunc:create(function()
                self:_turnOpenNoClickedDoor()

            end)

            local endBonus=cc.CallFunc:create(function()

                self:_endGameAction()

            end)

            local seq=cc.Sequence:create(turnNoClickDoor,delay,endBonus)

            self.rootNode:runAction(seq)
            --如果推出前总奖励不为0 则直接把总额奖励传给total文本框
            --self:_endGameAction()
            print("totalPrize:".. self.totalPrize)
            print("game over***********")

            --添加音乐
            Slot.Audio:playMusic("sound/modules/west/"..Slot.MusicResources["west"].west_bgame_end)


        end

--        if self.totalPrize==sumPrize
--            --结束时要把剩下的门都打开 奖励翻倍
--
--        end

        --如果金币全部点击完 直接把总额奖励传给total文本框
        if self.totalPrize==sumPrize  then

            if self.errorNum==0 then
                self.totalPrize=self.totalPrize*2
            end

           -- self:_turnOpenNoClickedDoor()
            local delay=cc.DelayTime:create(1)
            local turnNoClickDoor=cc.CallFunc:create(function()
                self:_turnOpenNoClickedDoor()

            end)

            local endBonus=cc.CallFunc:create(function()

                self:_endGameAction()

            end)

            local seq=cc.Sequence:create(turnNoClickDoor,delay,endBonus)
            self.rootNode:runAction(seq)
            --游戏退出
            --print("totalPrize:".. self.totalPrize)

            --self:_endGameAction()
            print("game over***********")

            --添加音乐
            Slot.Audio:playMusic("sound/modules/west/"..Slot.MusicResources["west"].west_bgame_end)

        end





    end,

    setTotalPrize=function(self,totalPrize)


        local totalPrizeString=string.format(""..totalPrize)

        --local  textSprite=cc.LabelBMFont:create(totalPrizeString,"fonts/font-issue1343-hd.fnt")
        local textNode=self.proxy:getNodeWithName("text_Node")
        local textSprite=textNode:getChildByTag(self.textTag)
        textSprite:setString(totalPrizeString)


    end,

    --触摸点的转换 先转换成node的相对坐标 在遍历node看哪个item包含这个触摸点
    startToConverPos=function(self,touchPoint)



        for i=1,4 do

          local nodeName=string.format("highnoon_col"..i)
          local node=self.proxy:getNodeWithName(nodeName)
          local nodePos1=self.banzi:convertToNodeSpace(touchPoint)


          local box=node:getBoundingBox()

          if cc.rectContainsPoint(box,nodePos1) then

              print("the col is ".. i)
              local nodePos=node:convertToNodeSpace(touchPoint)

              for j=1,3 do

                  local tempSpriteName=string.format("door_col"..i.."_row"..j)
                  local door_sprite=self.proxy:getNodeWithName(tempSpriteName)

                  if cc.rectContainsPoint(door_sprite:getBoundingBox(),nodePos) then

                      print("col:"..i.." row:"..j)

                      --检验是否点击过 点击过就返回 不做任何动作
                      if self:isClickedRepeat(i,j) then

                         return

                      end


                      --开始触摸后的动作

                      --执行门打开动作

                      local anctionDoor=self:startOpenDoor()
                      --door_sprite:runAction(anctionDoor)

                      --标记为已经点击过
                      local k=(i-1)*3+j



                      if not self.posStr then self.posStr = "" else self.posStr = self.posStr.."," end
                      self.posStr=self.posStr..k

                      self.isClickedTab[k]=0

                      --显示金袋或X

                      local showAction=cc.CallFunc:create(function ()

                           self:showItems(node,i,j)
                      end)

                      --存储金额总数和错误总数
                      self.totalPrize=self.totalPrize+self.resultTab[i][j]


                      if self.resultTab[i][j]==0 then

                          self.errorNum= self.errorNum+1

                      end

                      local showTotalPrize=cc.CallFunc:create(function ()


                          self:setTotalPrize(self.totalPrize)

                      end)
                      --在文本框中显示获得金额总数

                      local seq=cc.Sequence:create(anctionDoor,showAction,showTotalPrize)
                      door_sprite:runAction(seq)

                      print("##################################")
                      print("totalPrize:".. self.totalPrize)
                      print("errorNum:".. self.errorNum)
                      print("##################################")
                      --判断是否结束小游戏
                      self:isEndGame()



                  end

              end


          end




      end
    end,


    _registEvent = function(self)

        --self:_registDoor()
        -- handing touch events
            local touchBeginPoint = nil
            local function onTouchBegan(touch, event)
                local location = touch:getLocation()
                --print("location:x".. location.x.."  y:"..location.y)
                touchBeginPoint = {x = location.x, y = location.y}

                if self.errorNum==2 then return end

                --转换触摸点

               self:startToConverPos(touchBeginPoint)

                --self:_registDoor()
                return true
            end



            local listener = cc.EventListenerTouchOneByOne:create()
            listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )

            local eventDispatcher = self.rootNode:getEventDispatcher()
            eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.rootNode)

    end,

    getRootNode = function(self)
        if not self.rootNode then

            print("HighNoon.ccbi******************1")


            self.proxy = Slot.CCBProxy:new()
            self.rootNode  = self.proxy:readCCBFile("ccbi/HighNoon.ccbi")

            local bg=self.proxy:getNodeWithName("HighNoon_bg")
            bg:setContentSize(self._winsize)
            self.rootNode:setContentSize(self._winsize)

            self.banzi=self.proxy:getNodeWithName("HighNoon_banzi")
            self.banzi:setPosition(cc.p(self._winsize.width/2,self._winsize.height/2+100))


            self.textNode=self.proxy:getNodeWithName("text_Node")
            self.textNode:setPosition(cc.p(self._winsize.width/2-self.textNode:getContentSize().width/2,30))
            self.rootNode:addChild(self.proxy:getRootNode())

            print("HighNoon.ccbi******************2")

        end

        return self.rootNode
    end,

    getDefaultOptions = function(self)

        return U:extend(false, self:_super(), {
            nodeEventAware=true,

        })
    end,
})