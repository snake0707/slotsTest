--
-- Created by IntelliJ IDEA.
-- User: oas
-- Date: 14-12-21
-- Time: 下午8:32
-- To change this template use File | Settings | File Templates.
--

Slot.Call_Animation = Slot.Call_Animation or {}



-- ----------------------------------------------------------

--  经验值动画

-- ----------------------------------------------------------

-- 调用函数
Slot.Call_Animation.ExperenceAction=function(self,rootNode,posTab,secs,delayTime)

--if secs==nil then secs=1.5 end
    U:addSpriteFrameResource("plist/common/common.plist")
    if secs==nil then secs=1.5 end
    if delayTime==nil then delayTime=0 end

    local startPosInWorld=posTab[1]
    local endPosInWorld=posTab[2]

    local tempSprite

    local scaleTab={0.2,0.6,0.8,0.4 }
    math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))

    local createItem=function()

        tempSprite=U:getSpriteByName("xp_icon.png")

        local width=tempSprite:getContentSize().width
        local height=tempSprite:getContentSize().height


        local index=math.random(1,4)

        --print("$$$$$$$$$$$index:"..index)

        tempSprite:setScale(scaleTab[index])
        --在tempSprite上添加粒子

        for i=1,10 do

            local pStar = cc.ParticleSun:create()
            tempSprite:addChild(pStar,100)
            local x,y=math.random(0,width),math.random(0,height)

            pStar:setTexture(cc.Director:getInstance():getTextureCache():addImage("image/common/stars.png"))

            pStar:setTotalParticles(3)
            pStar:setStartSize(10)
            pStar:setStartSizeVar(5)
            pStar:setPosition(cc.p(x,y))

            --pStar:setPosition(cc.p(50,100))
            pStar:setDuration(secs)
            pStar:setSpeed(5)
            pStar:setSpeedVar(10)
            pStar:setPositionType(cc.POSITION_TYPE_RELATIVE)
            pStar:setStartColor(cc.c4b(1,255,255,255))

            --设置角度
            pStar:setAngle(0)
            pStar:setAngleVar(360)

            --设置粒子开始的自旋转速度，开始自旋转速度的变化率
            pStar:setStartSpin(30)
            pStar:setStartSpinVar(60)


        end

        rootNode:addChild(tempSprite,10)
        tempSprite:setPosition(startPosInWorld)

        local action=Slot.animation:ExperenceAdd(startPosInWorld,endPosInWorld,secs,delayTime)

        local rem=cc.RemoveSelf:create()
        local seq=cc.Sequence:create(action,rem)

        tempSprite:runAction(seq)
    --exeprienceSprite:runAction(seq)

    end


    local function scheduleItem(callback, delay)
        local delay = cc.DelayTime:create(delay)
        local sequence = cc.Sequence:create(delay, cc.CallFunc:create(callback))
        local action = cc.Repeat:create(sequence,4)

        local node=cc.Node:create()
        rootNode:addChild(node,10)
        node:runAction(action)

    end

    scheduleItem(createItem,0.1)





end


Slot.Call_Animation.ExperenceFly=function(self,nodeTab,posTab,callBack)


    local callBackAction=cc.CallFunc:create(function ()


        if callBack and type(callBack)=="function" then

            callBack()

        end

    end)


    local action1=cc.CallFunc:create(function()


        Slot.Call_Animation:ExperenceAction(nodeTab[1],posTab)

    end)


    local action2=cc.CallFunc:create(function()

    --添加经验值粒子 移动


        local targetSprite=nodeTab[2]
        local nodePos=cc.p(targetSprite:getPositionX(),targetSprite:getPositionY())
        local startPos=cc.p(nodePos.x,nodePos.y)
        local width=nodeTab[3]:getContentSize().width

        local targetPos=cc.p(startPos.x+width,startPos.y)

        local posTab={startPos,targetPos}
        Slot.animation:LiziMove("image/common/stars.png",nodeTab[3],posTab)

    end)

    local action3=cc.CallFunc:create(function()


        local targetSprite=nodeTab[2]
        local scale=cc.ScaleBy:create(0.3,1.2)
        local ease=cc.EaseIn:create(scale,0.3)
        local easeBack=ease:reverse()

        local scaleBack=cc.ScaleTo:create(0.3,1)

        --local seq=cc.Sequence:create(ease,easeBack)
        local seq=cc.Sequence:create(ease,scaleBack)

        targetSprite:runAction(seq)



    end)

    local delay=cc.DelayTime:create(1.5)
    local seq=cc.Sequence:create(action1,delay,action2,action3,callBackAction)

    return seq


end



-- -----------------------------------------------------------------------------

--  粒子画框动画

-- -----------------------------------------------------------------------------

-- 调用函数
Slot.Call_Animation.ParctiseMove=function(self,pathFile,cellNode,layerNode,targetStartPos,startPointIndex,speed,isModule)

--modules Speed 传进速度
--if speed==nil then speed=500 end

    if startPointIndex==nil then startPointIndex=1 end
    if speed==nil then speed=600 end

    --if speed==nil then speed=1000 end
    if isModule==nil then   isModule=false   end


    local distanceTab={}
    distanceTab[1]=cellNode:getContentSize().width
    distanceTab[2]=cellNode:getContentSize().height








    local startPosition={

        cc.p(0,0),cc.p(0,1),cc.p(0,2),cc.p(1,2),
        cc.p(2,2),cc.p(2,1),cc.p(2,0),cc.p(1,0)
    }



    local PositionArray={


        --up
        {cc.p(0,2),cc.p(2,0),cc.p(0,-2),cc.p(-2,0),cc.p(0,0)},
        {cc.p(0,1),cc.p(2,0),cc.p(0,-2),cc.p(-2,0),cc.p(0,1)},

        --right
        {cc.p(2,0),cc.p(0,-2),cc.p(-2,0),cc.p(0,2),cc.p(0,0)},
        {cc.p(1,0),cc.p(0,-2),cc.p(-2,0),cc.p(0,2),cc.p(1,0)},

        --down
        {cc.p(0,-2),cc.p(-2,0),cc.p(0,2),cc.p(2,0),cc.p(0,0)},
        {cc.p(0,-1),cc.p(-2,0),cc.p(0,2),cc.p(2,0),cc.p(0,-1)},

        --left
        {cc.p(-2,0),cc.p(0,2),cc.p(2,0),cc.p(0,-2),cc.p(0,0)},
        {cc.p(-1,0),cc.p(0,2),cc.p(2,0),cc.p(0,-2),cc.p(-1,0)},



    }


    --local cellImageWidth=distance


    local scheduler=cc.Director:getInstance():getScheduler()
    local schedulerEntry

    local callbackStart=function()


        Slot.Call_Animation:startParctisAction(pathFile,startPointIndex,distanceTab,PositionArray,startPosition,layerNode,targetStartPos,speed,isModule)


    end


    local function scheduleOnce(node, callback, delay)

        if delay==nil then delay=0 end

        local delay = cc.DelayTime:create(delay)
        local sequence = cc.Sequence:create(delay, cc.CallFunc:create(callback))
        local action = cc.Repeat:create(sequence,1)
        node:runAction(action)
        return action
    end



    scheduleOnce(layerNode,callbackStart)



end


-- 调用函数
Slot.Call_Animation.startParctisAction=function(self,pathFile,startPointIndex,distanceTab,PositionArray,startPosition,layerNode,targetPoint,speed,isModule)
--create Parctise

--test 12.15

    local NUM_W=distanceTab[1]/2
    local NUM_H=distanceTab[2]/2

    --设定一个移动速度
    local moveSpeed=speed

    local time_w=distanceTab[1]/moveSpeed
    local time_h=distanceTab[2]/moveSpeed

    --
    --    print("distanceTab[1]:"..distanceTab[1])
    --    print("distanceTab[2]:"..distanceTab[2])
    --    print("time_w:"..time_w)
    --    print("time_h:"..time_h)

    local totalDurationTime=(time_w+time_h)*2

    local pSun
    if not isModule then

        pSun=Slot.animation:createCellParctis(pathFile,startPointIndex,distanceTab,layerNode,targetPoint,totalDurationTime)
    else

        pSun=Slot.animation:createGirlParctis(pathFile,startPointIndex,distanceTab,layerNode,targetPoint,totalDurationTime)
    end


    --11.26 test for move

    local function isMid(point)

        local tab={}
        tab=point
        if tab.x==1 or tab.y==1 then
            return true
        else
            return false
        end

    end




    local bRef=isMid(startPosition[startPointIndex])





    if bRef==false then


        local moveT
        local moveR
        local moveD
        local moveL

        if startPointIndex==1 or startPointIndex==5 then

            moveT = cc.MoveBy:create(time_h,cc.p(NUM_H*PositionArray[startPointIndex][1].x,NUM_H*PositionArray[startPointIndex][1].y))
            moveR = cc.MoveBy:create(time_w,cc.p(NUM_W*PositionArray[startPointIndex][2].x,NUM_W*PositionArray[startPointIndex][2].y))
            moveD = cc.MoveBy:create(time_h,cc.p(NUM_H*PositionArray[startPointIndex][3].x,NUM_H*PositionArray[startPointIndex][3].y))
            moveL = cc.MoveBy:create(time_w,cc.p(NUM_W*PositionArray[startPointIndex][4].x,NUM_W*PositionArray[startPointIndex][4].y))
        else
            moveT = cc.MoveBy:create(time_w,cc.p(NUM_W*PositionArray[startPointIndex][1].x,NUM_W*PositionArray[startPointIndex][1].y))
            moveR = cc.MoveBy:create(time_h,cc.p(NUM_H*PositionArray[startPointIndex][2].x,NUM_H*PositionArray[startPointIndex][2].y))
            moveD = cc.MoveBy:create(time_w,cc.p(NUM_W*PositionArray[startPointIndex][3].x,NUM_W*PositionArray[startPointIndex][3].y))
            moveL = cc.MoveBy:create(time_h,cc.p(NUM_H*PositionArray[startPointIndex][4].x,NUM_H*PositionArray[startPointIndex][4].y))

        end


        local seq= cc.Sequence:create(moveT,moveR, moveD, moveL)
        pSun:runAction(seq)


    else



        local moveT
        local moveR
        local moveD
        local moveL
        local moveToStart

        if startPointIndex==2 or startPointIndex==6 then

            moveT = cc.MoveBy:create(time_h/2,cc.p(NUM_H*PositionArray[startPointIndex][1].x,NUM_H*PositionArray[startPointIndex][1].y))
            moveR = cc.MoveBy:create(time_w,cc.p(NUM_W*PositionArray[startPointIndex][2].x,NUM_W*PositionArray[startPointIndex][2].y))
            moveD = cc.MoveBy:create(time_h,cc.p(NUM_H*PositionArray[startPointIndex][3].x,NUM_H*PositionArray[startPointIndex][3].y))
            moveL = cc.MoveBy:create(time_w,cc.p(NUM_W*PositionArray[startPointIndex][4].x,NUM_W*PositionArray[startPointIndex][4].y))
            moveToStart = cc.MoveBy:create(time_h/2,cc.p(NUM_H*PositionArray[startPointIndex][5].x,NUM_H*PositionArray[startPointIndex][5].y))

        else

            moveT = cc.MoveBy:create(time_w/2,cc.p(NUM_W*PositionArray[startPointIndex][1].x,NUM_W*PositionArray[startPointIndex][1].y))
            moveR = cc.MoveBy:create(time_h,cc.p(NUM_H*PositionArray[startPointIndex][2].x,NUM_H*PositionArray[startPointIndex][2].y))
            moveD = cc.MoveBy:create(time_w,cc.p(NUM_W*PositionArray[startPointIndex][3].x,NUM_W*PositionArray[startPointIndex][3].y))
            moveL = cc.MoveBy:create(time_h,cc.p(NUM_H*PositionArray[startPointIndex][4].x,NUM_H*PositionArray[startPointIndex][4].y))
            moveToStart = cc.MoveBy:create(time_w/2,cc.p(NUM_W*PositionArray[startPointIndex][5].x,NUM_W*PositionArray[startPointIndex][5].y))

        end


        local seq= cc.Sequence:create(moveT,moveR, moveD, moveL,moveToStart)
        pSun:runAction(seq)

    end


    startPointIndex=startPointIndex+1
    if startPointIndex==9 then startPointIndex=1 end


end



-- -----------------------------------------------------------------------------

--  金币动画

-- -----------------------------------------------------------------------------


-- 调用函数
-- 金币落下
Slot.Call_Animation.FallDownBeriz=function(self,startPos,targetY,secs,delayTime)



-- 默认起始点就是精灵的坐标位置 targetPoint是随机的

    if secs==nil then secs=1 end
    if delayTime==nil then delayTime=0 end
    --local startPos=cc.p(node:getPositionX(),node:getPositionY())

    --在下方产生随机点 y值一样  方向为1代表左下方  方向为2代表右下方
    --math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
    local function getDir()

        local dir
        local num=math.random(1,10)
        if num<=5 then

            dir=1
        else

            dir=2

        end

        return dir

    end




    local diff=math.random(100,600)

    --print("diff==========:"..diff)
    local dir_D=getDir()
    local targetPos


    if dir_D==1 then


        targetPos=cc.p(startPos.x-diff,startPos.y-targetY)
    elseif dir_D==2 then

        targetPos=cc.p(startPos.x+diff,startPos.y-targetY)
    end

    --    print("######################")
    --
    --    print("diff:"..diff)
    --    print("######################")

    --方向向下 不对称抛物线
    local bezir=Slot.animation:CoinMoveToPosition(startPos,targetPos,secs,0,delayTime)

    return bezir,targetPos

end


-- 调用函数
-- 金币向上飞出
Slot.Call_Animation.FlyUpBeriz=function(self,startPos,targetPos,secs,delayTime)

    if secs==nil then secs=0.6 end
    if delayTime==nil then delayTime=0 end

    --    local isSymmetry
    --
    --    math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
    --
    --    if math.random(1,10)>=5 then
    --
    --        isSymmetry=1
    --    else
    --
    --        isSymmetry=0
    --    end


    local flyUpBeriz=Slot.animation:CoinMoveToPosition(startPos,targetPos,secs,0)

    return flyUpBeriz

end


-- 调用函数
--搜集金币
Slot.Call_Animation.collectCoin=function(self,posTab,parentNode,callback,secs,delayTime)
    U:addSpriteFrameResource("plist/common/common.plist")
    if secs==nil then secs=0.6 end
    if delayTime==nil then delayTime=0.1 end

    local num=0

    local delay=cc.DelayTime:create(delayTime)

    local coinAction=cc.CallFunc:create(function()

        local coinSprite= U:getSpriteByName("coin1.png")
        coinSprite:setScale(0.8)
        parentNode:addChild(coinSprite,100)
        coinSprite:setPosition(posTab[1])

        local callBackAction=cc.CallFunc:create(function ()

            if callback and type(callback)=="function" then

                if num==0 then

                    num=num+1
                    callback()

                end

            end

        end)

        local bezierForward=Slot.animation:CoinMoveToPosition(posTab[1],posTab[2],secs,1)
        local rem=cc.RemoveSelf:create()
        local seq=cc.Sequence:create(bezierForward,callBackAction,rem)
        coinSprite:stopAllActions()
        coinSprite:runAction(seq)

    end)

    local seq=cc.Sequence:create(delay,coinAction)
    local repN=cc.Repeat:create(seq,4)

    --添加音乐
    Slot.Audio:playEffect("sound/common/"..Slot.MusicResources["common"].lobby_coins_fly)

    return repN

end


-- ----------------------------------------------------------

--  期待效果动画

-- ----------------------------------------------------------

-- 调用函数
-- m,n 分别为水平和竖直方向被分割成几等份
Slot.Call_Animation.changeStartposAndDirection=function(self,direction,startpos,diffX,diffY,m,n,parentNode)



    if direction=="rightBottom"  then

        Slot.Call_Animation:CreateInRightDirection(startpos,parentNode,diffX,m)

    elseif  direction=="upRight" then


        Slot.Call_Animation:CreateInUpDirection(startpos,parentNode,diffX,diffY,m,n)

    elseif  direction=="leftUp" then


        Slot.Call_Animation:CreateInLeftDirection(startpos,parentNode,diffX,diffY,m,n)

    end



end



-- 调用函数
--right
Slot.Call_Animation.CreateInRightDirection=function(self,rightStartPos,parentNode,diffX,num)

    local i=1


    local function scheduleNum(delay,n)
        local delay = cc.DelayTime:create(delay)
        local sequence = cc.Sequence:create(delay, cc.CallFunc:create(function ()

            if i>=n+1 then return end
            local Pos


            local PosRight=cc.p(rightStartPos.x+diffX*(i-1),rightStartPos.y)
            local PosLeft=cc.p(rightStartPos.x-diffX*(i-1),rightStartPos.y)

            --第一对粒子速度设置为0
            local isSpeed
            if i==1 then
                isSpeed=false
            end

            i=i+1

            local posTab={PosLeft,PosRight }
            local angleTab={0,180 }



            Slot.animation:createParticleAtTwoPos("image/common/stars.png",parentNode,posTab,angleTab,isSpeed)

        end))
        local action = cc.Repeat:create(sequence,n)

        local node=cc.Node:create()
        parentNode:addChild(node,10)
        node:runAction(action)

    end

    scheduleNum(0.1,num-1)

end


-- 调用函数
--up
Slot.Call_Animation.CreateInUpDirection=function(self,upStartPos,parentNode,diffX,diffY,m,n)

    local i=1

    local width=m*diffX

    local function scheduleNum(delay,n)
        local delay = cc.DelayTime:create(delay)
        local sequence = cc.Sequence:create(delay, cc.CallFunc:create(function ()


        --if i>=n+1 then return end
            if i>=n+2 then return end


            local PosRight=cc.p(upStartPos.x+width/2,upStartPos.y+(i-1)*diffY)
            local PosLeft=cc.p(upStartPos.x-width/2,upStartPos.y+(i-1)*diffY)

            i=i+1

            local posTab={PosLeft,PosRight }
            local angleTab
            local isSpeed=true


            --倒数第二对粒子发射速度为0
            if i==n then
                isSpeed=false
            end

            --最后一对粒子
            if i==n+1 then
                angleTab={270,270}
            end

            Slot.animation:createParticleAtTwoPos("image/common/stars.png",parentNode,posTab,angleTab,isSpeed)

        end))
        local action = cc.Repeat:create(sequence,n)

        local node=cc.Node:create()
        parentNode:addChild(node,10)
        node:runAction(action)

    end

    --scheduleNum(0.1,n-1)
    scheduleNum(0.1,n+1)

end


-- 调用函数
--left
Slot.Call_Animation.CreateInLeftDirection=function(self,leftStartPos,parentNode,diffX,diffY,m,n)

    local i=1

    local heitht=n*diffY
    local width=m*diffX
    local function scheduleNum(delay,num)
        local delay = cc.DelayTime:create(delay)
        local sequence = cc.Sequence:create(delay, cc.CallFunc:create(function ()

            if i>=num+1 then return end

            local PosRight=cc.p(leftStartPos.x+width/2-(i-1)*diffX,leftStartPos.y+heitht)
            local PosLeft=cc.p(leftStartPos.x-width/2+(i-1)*diffX,leftStartPos.y+heitht)

            local isSpeed
            if i==n then
                isSpeed=false
            end

            i=i+1

            local posTab={PosLeft,PosRight }
            local angleTab={0,180}
            Slot.animation:createParticleAtTwoPos("image/common/stars.png",parentNode,posTab,angleTab,isSpeed)

        end))
        local action = cc.Repeat:create(sequence,num)

        local node=cc.Node:create()
        parentNode:addChild(node,10)
        node:runAction(action)

    end

    scheduleNum(0.1,m-1)

end


-- 调用函数
Slot.Call_Animation.ExpectAction=function(self,node,m,n)

--print("ExpectAction@@@@@@@@@@@@@@@@@@@@@@@@@")

    if m==nil then m=4 end
    if n==nil then n=15 end



    --这里得注意锚点位置

    local width,height=node:getContentSize().width,node:getContentSize().height
    local startPos=cc.p(width/2,0)


    local diffX=node:getContentSize().width/m
    local diffY=node:getContentSize().height/n

    local directionTab={"rightBottom","upRight","leftUp"}

    local rightBottom=cc.CallFunc:create(function ()

        local direction=directionTab[1]
        Slot.Call_Animation:changeStartposAndDirection(direction,startPos,diffX,diffY,m,n,node)

    end)

    local upRight=cc.CallFunc:create(function ()

        local direction=directionTab[2]
        Slot.Call_Animation:changeStartposAndDirection(direction,startPos,diffX,diffY,m,n,node,self.totalNum)


    end)

    local leftUp=cc.CallFunc:create(function ()

        local direction=directionTab[3]
        Slot.Call_Animation:changeStartposAndDirection(direction,startPos,diffX,diffY,m,n,node,self.totalNum)


    end)


    local delay=cc.DelayTime:create(1.4)
    local delayOne=cc.DelayTime:create(0.3)

    local seq=cc.Sequence:create(rightBottom,delayOne,upRight,delay,leftUp)


    node:runAction(seq)


--print("ExpectAction****************************")
end



-- ----------------------
--Reward Animations Big Win/ Huge Win / 5 of king Animations
-- ----------------------

Slot.Call_Animation.bigWinActionClear=function(self,starTab,paperTab,pFireTab,actionTab,parentNode)

--星星消失
    for i=1,#starTab do


        if starTab[i]~=nil and tolua.cast(starTab[i],"cc.Sprte") then

            starTab[i]:stopAllActions()

            local fadeOut=cc.FadeOut:create(1)
            local rem=cc.RemoveSelf:create()
            local seq=cc.Sequence:create(fadeOut,rem)
            starTab[i]:runAction(seq)
            starTab[i]=nil


        end


    end

    --纸带消失
    for i=1,#paperTab do

        if paperTab[i]~=nil and tolua.cast(paperTab[i],"cc.ParticleSnow") then

            paperTab[i]:removeFromParent(true)
            paperTab[i]=nil

        end


    end


    --礼花消失
    for i=1,#pFireTab do

        if pFireTab[i]~=nil and tolua.cast(pFireTab[i],"cc.ParticleSystemQuad") then

            pFireTab[i]:removeFromParent(true)
            pFireTab[i]=nil

        end

    end

    local seq=cc.Sequence:create(actionTab)

    parentNode:runAction(seq)


end

-- 调用函数
Slot.Call_Animation.bigWinAction=function(self,parentNode,pos,priority,award,callback)

    U:addSpriteFrameResource("plist/common/game_common.plist")
    local touchNum=0

    --添加音乐
    Slot.Audio:playEffect("sound/common/"..Slot.MusicResources["common"].bigwin)

    local isCallBack=true
    local callbackAction=cc.CallFunc:create(function ()

        if isCallBack then

            if callback and type(callback)=="table" then

                callback.coin_callback()

            end
            isCallBack=false

        end

    end)


    --添加一个遮罩 layerColor
    local layerColor=cc.LayerColor:create(cc.c4b(0,0,0,150))

    parentNode:addChild(layerColor,100)

    local bigWinSprite= U:getSpriteByName("big-win.png")

    layerColor:addChild(bigWinSprite,100)

    bigWinSprite:setPosition(pos)

    bigWinSprite:setScale(8)
    local scaleB=cc.ScaleTo:create(0.2,1)
    local huanhu=cc.CallFunc:create(function()
        Slot.Audio:playEffect("sound/common/"..Slot.MusicResources["common"]["crowdcheers1"])
    end)


    local seqAA=cc.Sequence:create(scaleB,huanhu)

    bigWinSprite:runAction(seqAA)


    local width=bigWinSprite:getContentSize().width
    local height=bigWinSprite:getContentSize().height

    local posTabR={
       cc.p(width/6+50,height/3+230),cc.p(width/3+250,height/3+240),cc.p(200,height/2+150),cc.p(50,height/2+150),cc.p(width/2+400,height-30),
       cc.p(width/6+345,height*2/3+80),cc.p(width/2+315,height*2/3+80),cc.p(width-245,height*2/3+70),cc.p(width/6+105,height*2/3+70),cc.p(width/2+60,height*2/3+80),
       cc.p(width/5+415,height/2+100),cc.p(55,height/3+70),cc.p(305,height/2+70),cc.p(width/4+195,height*2/3+80),cc.p(width/2+400,height/3+80),
       cc.p(width/4+405,height/2+90),cc.p(265,height/3+70),cc.p(width/3+500,height/2+90),cc.p(width-255,height/2+60),cc.p(width*2/3-125,height/2+90),
       cc.p(width-50,120),cc.p(width/6+350,80),cc.p(width/2+120,165),cc.p(200,70),

    }


    local starTab=Slot.animation:WinStar(bigWinSprite,posTabR)


    --数字赠张效果
    local numBgSprite=cc.Scale9Sprite:create("image/common/numBg.png")
    local screenSize = cc.Director:getInstance():getWinSize()
    numBgSprite:setPreferredSize(cc.size(screenSize.width,Slot.Height.numberBG_Height))

    layerColor:addChild(numBgSprite,100)
    numBgSprite:setPosition(cc.p(pos.x,pos.y-bigWinSprite:getContentSize().height))
    numBgSprite:setAnchorPoint(cc.p(0.5,0.5))
    
    --U.numAction = function(self, node, end_num, start_num, time)
    local numSprite=cc.LabelBMFont:create("","font/common/goldNum.fnt")
    numBgSprite:addChild(numSprite,100)
    numSprite:setAnchorPoint(cc.p(0.5,0.5))
    --numSprite:setPosition(cc.p(pos.x,pos.y-bigWinSprite:getContentSize().height))
    numSprite:setPosition(cc.p(numBgSprite:getContentSize().width/2,numBgSprite:getContentSize().height/2))
    --
    local numAc=U:numAction(numSprite,award)
    numSprite:setScale(1.5)



    --礼花
    local delay=cc.DelayTime:create(1)
    local pFireTab={}
    local pFireAction=cc.CallFunc:create(function()

        local pFire=Slot.animation:colorfireWork(layerColor,"plist/common/hugeFireWork.plist")
        table.insert(pFireTab,pFire)

    end)

    local seq=cc.Sequence:create(pFireAction,delay)
    local reqN=cc.Repeat:create(seq,5)
    numSprite:runAction(reqN)


    --小纸片效果
    local paperTab=Slot.animation:paperFallDown(layerColor)


    local fadeOutAction=cc.CallFunc:create(function ()


        if layerColor then
            
            local fadeOut1=cc.FadeOut:create(1)
            local fadeOut2=cc.FadeOut:create(1)
            local fadeOut3=cc.FadeOut:create(1)
            local fadeOut4=cc.FadeOut:create(1)

            layerColor:runAction(fadeOut1)
            bigWinSprite:runAction(fadeOut2)
            numSprite:runAction(fadeOut3)
            numBgSprite:runAction(fadeOut4)
        end





    end)

    --动作结束后删除遮罩


    local remLayerColor=cc.CallFunc:create(function ()



        if layerColor then
            layerColor:removeFromParent(true)
        end


        layerColor=nil


    end)

    local delay=cc.DelayTime:create(4)

    local delayStand=cc.DelayTime:create(1)

    local size = layerColor:getContentSize()
    --设置触摸拦截

    layerColor:registerScriptTouchHandler(function(eventType, x, y)
        
        if eventType == "began" then -- touch began

            touchNum=touchNum+1
            local rect=cc.rect(0,0,size.width,size.height)
            if not cc.rectContainsPoint(rect, layerColor:convertToNodeSpace(cc.p(x,y))) then -- rect:containsPoint() then
                return false
            end

            --点击让数字直接停止
            if numAc~=nil and touchNum==1 then
                U:clearInterval(numAc)
                numSprite:setString(U:formatNumber(tostring(award)))
                --bigWinSprite:stopAllActions()
                

            elseif  touchNum==3 then


                local actionTab={fadeOutAction,delayStand,remLayerColor,callbackAction}
                Slot.Call_Animation:bigWinActionClear(starTab,paperTab,pFireTab,actionTab,parentNode)

                local seq=cc.Sequence:create(self._AlllineAction,self._siglelineAction)
                self._layerColor:stopAllActions()
                self._layerColor:runAction(seq)

            end

            print("touchNum========:"..touchNum)

            return true
        end

    end, false,priority, true)
    layerColor:setTouchEnabled(true)

    local seq=cc.Sequence:create(delay,fadeOutAction,delayStand,remLayerColor,callbackAction)


    return seq

end



Slot.Call_Animation.hugeWinActionClear=function(self,starTab,pCoin,fireWorkTab,paperTab,pFireTab,actionTab,parentNode)

--星星消失

    for i=1,#starTab do

        if starTab[i]~=nil and tolua.cast(starTab[i],"cc.Sprte") then

            starTab[i]:stopAllActions()

            local fadeOut=cc.FadeOut:create(1)
            local rem=cc.RemoveSelf:create()
            local seq=cc.Sequence:create(fadeOut,rem)
            starTab[i]:runAction(seq)
            starTab[i]=nil


        end


    end

    --金币消失
    if pCoin~=nil and tolua.cast(pCoin,"cc.ParticleSnow") then

        pCoin:removeFromParent(true)
    end

    --烟花消失
    if tolua.cast(fireWorkTab[1],"cc.ParticleSystemQuad") or
            tolua.cast(fireWorkTab[2],"cc.ParticleSystemQuad") or
            tolua.cast(fireWorkTab[3],"cc.ParticleSystemQuad") then

        fireWorkTab[1]:removeFromParent(true)
        fireWorkTab[2]:removeFromParent(true)
        fireWorkTab[3]:removeFromParent(true)
        fireWorkTab[1]=nil
        fireWorkTab[2]=nil
        fireWorkTab[3]=nil

    end




    --纸带消失
    for i=1,#paperTab do
        if paperTab[i]~=nil and tolua.cast(paperTab[i],"cc.ParticleSnow") then

            paperTab[i]:removeFromParent(true)
            paperTab[i]=nil

        end

    end

    --礼花消失
    for i=1,#pFireTab do

        if pFireTab[i]~=nil and tolua.cast(pFireTab[i],"cc.ParticleSystemQuad") then

            pFireTab[i]:removeFromParent(true)
            pFireTab[i]=nil

        end

    end


    local seq=cc.Sequence:create(actionTab)

    parentNode:runAction(seq)


end

-- 调用函数
Slot.Call_Animation.hugeWinAction=function(self,parentNode,pos,priority,award,callback)
    U:addSpriteFrameResource("plist/common/game_common.plist")
    local touchNum=0
    --添加音乐
    Slot.Audio:playEffect("sound/common/"..Slot.MusicResources["common"].hugewin)

    local isCallBack=true
    local callbackAction=cc.CallFunc:create(function ()

        if isCallBack then

            if callback and type(callback)=="table" then

                callback.coin_callback()
            end
            isCallBack=false

        end

    end)




    --添加一个遮罩 layerColor
    local layerColor=cc.LayerColor:create(cc.c4b(0,0,0,150))

    parentNode:addChild(layerColor,100)

    local hugeWinSprite= U:getSpriteByName("huge-win.png")

    layerColor:addChild(hugeWinSprite,100)

    hugeWinSprite:setPosition(pos)



    --test2
    --添加hugewin动画
    hugeWinSprite:setScale(8)


    local scaleB=cc.ScaleTo:create(0.3,1)
    local huanhu=cc.CallFunc:create(function()
        Slot.Audio:playEffect("sound/common/"..Slot.MusicResources["common"]["crowdcheers1"])
    end)


    local seqAA=cc.Sequence:create(scaleB,huanhu)
    hugeWinSprite:runAction(seqAA)


    local width=hugeWinSprite:getContentSize().width
    local height=hugeWinSprite:getContentSize().height

    local posTabR={
        cc.p(width/6+50,height/3+230),cc.p(width/3+250,height/3+240),cc.p(200,height/2+150),cc.p(50,height/2+150),cc.p(width/2+400,height-30),
        cc.p(width/6+345,height*2/3+80),cc.p(width/2+315,height*2/3+80),cc.p(width-245,height*2/3+70),cc.p(width/6+105,height*2/3+70),cc.p(width/2+60,height*2/3+80),
        cc.p(width/5+415,height/2+100),cc.p(55,height/3+70),cc.p(305,height/2+70),cc.p(width/4+195,height*2/3+80),cc.p(width/2+400,height/3+80),
        cc.p(width/4+405,height/2+90),cc.p(265,height/3+70),cc.p(width/3+500,height/2+90),cc.p(width-255,height/2+60),cc.p(width*2/3-125,height/2+90),
        cc.p(width-50,120),cc.p(width/6+350,80),cc.p(width/2+120,165),cc.p(200,70),

    }


    local starTab=Slot.animation:WinStar(hugeWinSprite,posTabR)



    --数字滚动
    local numBgSprite=cc.Scale9Sprite:create("image/common/numBg.png")
    local screenSize = cc.Director:getInstance():getWinSize()
    numBgSprite:setPreferredSize(cc.size(screenSize.width,Slot.Height.numberBG_Height))
    layerColor:addChild(numBgSprite,100)
    numBgSprite:setPosition(cc.p(pos.x,pos.y-hugeWinSprite:getContentSize().height))
    numBgSprite:setAnchorPoint(cc.p(0.5,0.5))
    local numSprite=cc.LabelBMFont:create("","font/common/goldNum.fnt")
    numBgSprite:addChild(numSprite,100)
    numSprite:setAnchorPoint(cc.p(0.5,0.5))
    --numSprite:setPosition(cc.p(pos.x,pos.y-bigWinSprite:getContentSize().height))
    numSprite:setPosition(cc.p(numBgSprite:getContentSize().width/2,numBgSprite:getContentSize().height/2))
    --

    local numAc=U:numAction(numSprite,award)
    numSprite:setScale(1.5)

    --烟花效果

    local width=parentNode:getContentSize().width

    local posFireWork={cc.p(width/3,0),cc.p(width*2/3,0),cc.p(width/2,0)}
    local fireWork1=Slot.animation:fireWork(layerColor,posFireWork[1])
    local fireWork2=Slot.animation:fireWork(layerColor,posFireWork[2])
    local fireWork3=Slot.animation:fireWork(layerColor,posFireWork[3])

    fireWork1:setRotation(-20)
    fireWork2:setRotation(20)


    local delay=cc.DelayTime:create(0.5)
    local pFireTab={}
    local pFireAction=cc.CallFunc:create(function()

        local pFire=Slot.animation:colorfireWork(layerColor,"plist/common/hugeFireWork.plist")
        table.insert(pFireTab,pFire)

    end)

    local seq=cc.Sequence:create(pFireAction,delay)
    local reqN=cc.Repeat:create(seq,10)
    numSprite:runAction(reqN)


    --金币散落
    local pCoin=Slot.animation:CoinFallDown(layerColor)

    --print("type(pCoin)=======:"..type(pCoin))

    --小纸片飘落
    local paperTab=Slot.animation:paperFallDown(layerColor)


    local fadeOutAction=cc.CallFunc:create(function ()

        if layerColor then

            local fadeOut1=cc.FadeOut:create(1)
            local fadeOut2=cc.FadeOut:create(1)
            local fadeOut3=cc.FadeOut:create(1)
            local fadeOut4=cc.FadeOut:create(1)

            layerColor:runAction(fadeOut1)
            hugeWinSprite:runAction(fadeOut2)
            numSprite:runAction(fadeOut3)
            numBgSprite:runAction(fadeOut4)
        end


    end)

    --动作结束后删除遮罩
    local delay=cc.DelayTime:create(4) --4
    local remLayerColor=cc.CallFunc:create(function ()

        if layerColor then
            numSprite:stopAllActions()
            layerColor:removeFromParent(true)
        end
        layerColor=nil


    end)

    local delayStand=cc.DelayTime:create(2.5)

    local size = layerColor:getContentSize()
    --设置触摸拦截
    layerColor:registerScriptTouchHandler(function(eventType, x, y)

        if eventType == "began" then -- touch began

            touchNum=touchNum+1
            local rect=cc.rect(0,0,size.width,size.height)
            if not cc.rectContainsPoint(rect, layerColor:convertToNodeSpace(cc.p(x,y))) then -- rect:containsPoint() then
                return false
            end

            --点击让数字直接停止
            if numAc~=nil and touchNum==1 then
                U:clearInterval(numAc)
                numSprite:setString(U:formatNumber(tostring(award)))
                --hugeWinSprite:stopAllActions()


            elseif  touchNum==3 then  --连续点击时 提前退出
                

                local fireWorkTab={fireWork1,fireWork2,fireWork3 }
                local actionTab={fadeOutAction,delayStand,remLayerColor,callbackAction}
                Slot.Call_Animation:hugeWinActionClear(starTab,pCoin,fireWorkTab,paperTab,pFireTab,actionTab,parentNode)

                local seq=cc.Sequence:create(self._AlllineAction,self._siglelineAction)
                self._layerColor:stopAllActions()
                self._layerColor:runAction(seq)

            end

            print("touchNum========:"..touchNum)

            return true
        end

    end, false,priority, true)
    layerColor:setTouchEnabled(true)

    local seq=cc.Sequence:create(delay,fadeOutAction,delayStand,remLayerColor,callbackAction)


    return seq

end


Slot.Call_Animation.fiveofkindActionClear=function(self,starTab,pCoin,fireWorkTab,paperTab,pFireTab,actionTab,parentNode)


    for i=1,#starTab do

        if starTab[i]~=nil and tolua.cast(starTab[i],"cc.Sprte") then

            starTab[i]:stopAllActions()

            local fadeOut=cc.FadeOut:create(1)
            local rem=cc.RemoveSelf:create()
            local seq=cc.Sequence:create(fadeOut,rem)
            starTab[i]:runAction(seq)
            starTab[i]=nil


        end


    end

    --金币消失
    if pCoin~=nil and tolua.cast(pCoin,"cc.ParticleSnow") then

        pCoin:removeFromParent(true)
    end

    --烟花消失
    if tolua.cast(fireWorkTab[1],"cc.ParticleSystemQuad") or
            tolua.cast(fireWorkTab[2],"cc.ParticleSystemQuad") or
            tolua.cast(fireWorkTab[3],"cc.ParticleSystemQuad") then

        fireWorkTab[1]:removeFromParent(true)
        fireWorkTab[2]:removeFromParent(true)
        fireWorkTab[3]:removeFromParent(true)
        fireWorkTab[1]=nil
        fireWorkTab[2]=nil
        fireWorkTab[3]=nil

    end




    --纸带消失
    for i=1,#paperTab do

        if paperTab[i]~=nil and tolua.cast(paperTab[i],"cc.ParticleSnow") then

            paperTab[i]:removeFromParent(true)
            paperTab[i]=nil

        end

    end

    --礼花消失
    for i=1,#pFireTab do


        if pFireTab[i]~=nil and tolua.cast(pFireTab[i],"cc.ParticleSystemQuad") then

            pFireTab[i]:removeFromParent(true)
            pFireTab[i]=nil

        end

    end


    local seq=cc.Sequence:create(actionTab)

    parentNode:runAction(seq)

end
-- 调用函数
Slot.Call_Animation.fiveKindWinAction=function(self,parentNode,pos,priority,award,callback)
    U:addSpriteFrameResource("plist/common/game_common.plist")
    local touchNum=0
    --添加音乐
    Slot.Audio:playEffect("sound/common/"..Slot.MusicResources["common"].hugewin)

    local isCallBack=true
    local callbackAction=cc.CallFunc:create(function ()

        if isCallBack then

            if callback and type(callback)=="table" then

                callback.coin_callback()

            end
            isCallBack=false

        end

    end)




    --添加一个遮罩 layerColor
    local layerColor=cc.LayerColor:create(cc.c4b(0,0,0,150))

    parentNode:addChild(layerColor,100)

    local fiveKindWinSprite= U:getSpriteByName("5-of-a-kind.png")

    layerColor:addChild(fiveKindWinSprite,100)

    fiveKindWinSprite:setPosition(pos)



    --test2
    --添加hugewin动画
    fiveKindWinSprite:setScale(8)


    local scaleB=cc.ScaleTo:create(0.3,1)
    local huanhu=cc.CallFunc:create(function()
        Slot.Audio:playEffect("sound/common/"..Slot.MusicResources["common"]["crowdcheers1"])
    end)


    local seqAA=cc.Sequence:create(scaleB,huanhu)
    fiveKindWinSprite:runAction(seqAA)


    local width=fiveKindWinSprite:getContentSize().width
    local height=fiveKindWinSprite:getContentSize().height

    local posTabR={
        cc.p(width/6+50,height/3+130),cc.p(width/3+150,height/3+140),cc.p(200,height/2+150),cc.p(50,height/2+150),cc.p(width/2+400,height-100),
        cc.p(width/6+345,height*2/3+80),cc.p(width/2+315,height*2/3+80),cc.p(width-245,height*2/3+70),cc.p(width/6+105,height*2/3-20),cc.p(width/2+60,height*2/3+80),
        cc.p(width/5+415,height/2+100),cc.p(55,height/3+70),cc.p(205,height/2+70),cc.p(width/4+195,height*2/3+80),cc.p(width/2+400,height/3+80),
        cc.p(width/4+405,height/2+90),cc.p(265,height/3+70),cc.p(width/3+500,height/2+90),cc.p(width-255,height/2+60),cc.p(width*2/3-125,height/2+90),
        cc.p(width-50,120),cc.p(width/6+300,200),cc.p(width/2+120,165),cc.p(200,70),

    }


    local starTab=Slot.animation:WinStar(fiveKindWinSprite,posTabR)



    --数字滚动
    local numBgSprite=cc.Scale9Sprite:create("image/common/numBg.png")
    local screenSize = cc.Director:getInstance():getWinSize()
    numBgSprite:setPreferredSize(cc.size(screenSize.width,Slot.Height.numberBG_Height))
    layerColor:addChild(numBgSprite,100)
    numBgSprite:setPosition(cc.p(pos.x,pos.y-fiveKindWinSprite:getContentSize().height))
    numBgSprite:setAnchorPoint(cc.p(0.5,0.5))


    local numSprite=cc.LabelBMFont:create("","font/common/goldNum.fnt")
    numBgSprite:addChild(numSprite)
    numSprite:setAnchorPoint(cc.p(0.5,0.5))
    --numSprite:setPosition(cc.p(pos.x,pos.y-bigWinSprite:getContentSize().height))
    numSprite:setPosition(cc.p(numBgSprite:getContentSize().width/2,numBgSprite:getContentSize().height/2))
    --

    local numAc=U:numAction(numSprite,award)
    numSprite:setScale(1.5)

    --烟花效果

    local width=parentNode:getContentSize().width

    local posFireWork={cc.p(width/3,0),cc.p(width*2/3,0),cc.p(width/2,0)}
    local fireWork1=Slot.animation:fireWork(layerColor,posFireWork[1])
    local fireWork2=Slot.animation:fireWork(layerColor,posFireWork[2])
    local fireWork3=Slot.animation:fireWork(layerColor,posFireWork[3])

    fireWork1:setRotation(-20)
    fireWork2:setRotation(20)


    local delay=cc.DelayTime:create(0.5)
    local pFireTab={}
    local pFireAction=cc.CallFunc:create(function()

        local pFire=Slot.animation:colorfireWork(layerColor,"plist/common/hugeFireWork.plist")
        table.insert(pFireTab,pFire)

    end)

    local seq=cc.Sequence:create(pFireAction,delay)
    local reqN=cc.Repeat:create(seq,10)
    numSprite:runAction(reqN)


    --金币散落
    local pCoin=Slot.animation:CoinFallDown(layerColor)

    --print("type(pCoin)=======:"..type(pCoin))

    --小纸片飘落
    local paperTab=Slot.animation:paperFallDown(layerColor)


    local fadeOutAction=cc.CallFunc:create(function ()

        if layerColor then

            local fadeOut1=cc.FadeOut:create(1)
            local fadeOut2=cc.FadeOut:create(1)
            local fadeOut3=cc.FadeOut:create(1)
            local fadeOut4=cc.FadeOut:create(1)

            layerColor:runAction(fadeOut1)
            fiveKindWinSprite:runAction(fadeOut2)
            numSprite:runAction(fadeOut3)
            numBgSprite:runAction(fadeOut4)
        end


    end)

    --动作结束后删除遮罩
    local delay=cc.DelayTime:create(4) --4
    local remLayerColor=cc.CallFunc:create(function ()

        if layerColor then
            numSprite:stopAllActions()
            layerColor:removeFromParent(true)
        end
        layerColor=nil


    end)

    local delayStand=cc.DelayTime:create(2.5)

    local size = layerColor:getContentSize()
    --设置触摸拦截
    layerColor:registerScriptTouchHandler(function(eventType, x, y)

        if eventType == "began" then -- touch began

            touchNum=touchNum+1
            local rect=cc.rect(0,0,size.width,size.height)
            if not cc.rectContainsPoint(rect, layerColor:convertToNodeSpace(cc.p(x,y))) then -- rect:containsPoint() then
                return false
            end

            --点击让数字直接停止
            if numAc~=nil and touchNum==1 then
                U:clearInterval(numAc)
                numSprite:setString(U:formatNumber(tostring(award)))
                --fiveKindWinSprite:stopAllActions()


            elseif  touchNum==3 then  --连续点击时 提前退出

                local fireWorkTab={fireWork1,fireWork2,fireWork3 }
                local actionTab={fadeOutAction,delayStand,remLayerColor,callbackAction}
                Slot.Call_Animation:fiveofkindActionClear(starTab,pCoin,fireWorkTab,paperTab,pFireTab,actionTab,parentNode)

                local seq=cc.Sequence:create(self._AlllineAction,self._siglelineAction)
                self._layerColor:stopAllActions()
                self._layerColor:runAction(seq)
            end

            print("touchNum========:"..touchNum)

            return true
        end

    end, false,priority, true)
    layerColor:setTouchEnabled(true)

    local seq=cc.Sequence:create(delay,fadeOutAction,delayStand,remLayerColor,callbackAction)


    return seq



end


-- ----------------------

-- 赢得金币普通效果

-- ----------------------


Slot.Call_Animation.winCoin_Common=function(self,posTab,count,nodeTab,callback)
    U:addSpriteFrameResource("plist/common/common.plist")
    local distance

    distance=posTab[1].y-posTab[3].y-50
    --math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))

    local num=1
    local callBackAction=cc.CallFunc:create(function()


        if callback and type(callback) == "function" then

            if num==1 then

                --添加音乐 1.05 test ok
                Slot.Audio:playEffect("sound/common/"..Slot.MusicResources["common"].coinsget)
                
                callback()
                num=num+1

            end

        end

    end)


    --金币跳出
    local beriz
    local targetPosSand
    --math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
    for i=1,count do

        local coinSprite= U:getSpriteByName("coin1.png")
        math.randomseed(os.time()*i*100)
        local coinPos=cc.p(math.random(posTab[1].x-60,posTab[1].x+60),posTab[1].y)

        coinSprite:setScale(0.9)
        --
        nodeTab[1]:addChild(coinSprite,100)
        coinSprite:setPosition(coinPos)

        local delay=cc.DelayTime:create(math.random()/4)
        beriz,targetPosSand=Slot.Call_Animation:FallDownBeriz(coinPos,distance)

        --金币停留

        local bouce=Slot.animation:coinBounceAction(30)

        --金币飞到金币框

        --0.4
        --local move=cc.MoveTo:create(2,posTab[2])

        --local move=cc.MoveBy:create(2,cc.p(0,200))

        --12.11 修改move动作 改成曲线飞行旋转
        local upBeriz=Slot.Call_Animation:FlyUpBeriz(targetPosSand,posTab[2],1)


        local rem=cc.RemoveSelf:create()

        --添加一个粒子效果
        local targetShowParticle=cc.CallFunc:create(function ()

        --11.25 修改成添加粒子效果

            local pStar=Slot.animation:ShowParticleByPlist("plist/common/stars.plist")
            nodeTab[1]:addChild(pStar,100)
            pStar:setPosition(posTab[2])

            --pStar:setStartColor(cc.c4b(1,255,255,255))


        end)



        local seq=cc.Sequence:create(beriz,bouce,delay,upBeriz,rem,callBackAction,targetShowParticle)

        --test 12.16 把move和精灵帧动画放在一起 用CallFunc
        --local seq=cc.Sequence:create(beriz,bouce,delay,move,rem,callBackAction,targetShowParticle)

        coinSprite:runAction(seq)

        --添加旋转精灵帧
        local framesAction=Slot.animation:coinRorateInLand()
        local repF=cc.RepeatForever:create(framesAction)
        coinSprite:runAction(repF)

    end


end

-- 调用函数
Slot.Call_Animation.winCoin=function(self,data,posTab,nodeTab,callbackTab,linetype,ModuleName)

    
    local callback = {
        coin_callback = function() end,
        bonus_callback = function() end
    }

    U:extend(false, callback, callbackTab)

    if linetype==nil then linetype="common" end

    local count=#data.scatterPos


    local winType=data["winType"]
    local award=data["awardGold"]
    self._isFreeSpin=data["freeSpin"]
    self._layerColor=nodeTab[2]

    print("award===1====:"..award)

    --先出现bigWin
    local action1=Slot.Call_Animation:winCoinSpecail(winType,nodeTab,award,callback)


    --显示所有线  这里如果没有线则直接返回
    local action2=Slot.animation:showAndHideAllLine(nodeTab[2])
    self._AlllineAction=action2


    --普通金币效果 这里如果没有线则直接返回
    local action3=cc.CallFunc:create(function()

    --这里的回调是要知道增长数字的时刻
        Slot.Call_Animation:winCoinCommon(data,posTab,nodeTab,callback.coin_callback)


    end)

    --根据类型画线

    local action4=cc.CallFunc:create(function()

    --普通画线下 如果没有线则直接返回
        Slot.animation:DrawLineByType(linetype,nodeTab[4],nodeTab[5],nodeTab[2],data,ModuleName,callback.bonus_callback)

    end)

    self._siglelineAction=action4
    local seq

    if winType=="small" then

        print("winType1:"..winType)
        local delay=cc.DelayTime:create(1)
        --seq=cc.Sequence:create(action2,action3,delay,action4)
        seq=cc.Sequence:create(action2,delay,action4)
    else

        print("winType2:"..winType)
        seq=cc.Sequence:create(action1,action2,action4)

    end

    self._winCoinAction=seq



    nodeTab[2]:runAction(seq)



end



-- 调用函数
Slot.Call_Animation.winCoinSpecail=function(self,winType,nodeTab,award,callback)



    local action

    local pos=cc.p(nodeTab[1]:getContentSize().width/2,nodeTab[1]:getContentSize().height*2/3)
    if winType=="big" then

        --print("big==========================")
        action=Slot.Call_Animation:bigWinAction(nodeTab[1],pos,-100,award,callback)

    elseif winType=="huge" then

        action=Slot.Call_Animation:hugeWinAction(nodeTab[1],pos,-100,award,callback)

    elseif winType=="5ofkind" then

        action=Slot.Call_Animation:fiveKindWinAction(nodeTab[1],pos,-100,award,callback)

    end

    return action


end



-- 调用函数
Slot.Call_Animation.winCoinCommon=function(self,data,posTab,nodeTab,callback)



    local totalBet=data["totalBet"]
    local awardGold=data["awardGold"]
    local winType=data["winType"]
    local ratio=awardGold/totalBet


    if ratio==0 then return end

    local numTab={3,10,20 }


    if ratio>0 and ratio<=0.5 then

        --弹出3个金币



        Slot.Call_Animation:winCoin_Common(posTab,numTab[1],nodeTab,callback)

        --添加音乐 1.05
        Slot.Audio:playEffect("sound/common/"..Slot.MusicResources["common"].showcoins_small)


    elseif ratio>0.5 and ratio<=1 then

        --弹出10个金币

        Slot.Call_Animation:winCoin_Common(posTab,numTab[2],nodeTab,callback)

        --添加音乐 1.05
        Slot.Audio:playEffect("sound/common/"..Slot.MusicResources["common"].showcoins_mid)

    elseif ratio>1 and ratio<=2 then

        --弹出20个金币

        Slot.Call_Animation:winCoin_Common(posTab,numTab[3],nodeTab,callback)

        --添加音乐 1.05
        Slot.Audio:playEffect("sound/common/"..Slot.MusicResources["common"].showcoins_large)

    end


end





-- --------------------------------------------------------------------

-- 升级弹框效果

-- --------------------------------------------------------------------

-- 调用函数
Slot.Call_Animation.levelUpAction=function(self,nodeTab)

    local layerColor=nodeTab[1]

    local width=layerColor:getContentSize().width
    local height=layerColor:getContentSize().height

    --烟花效果
    local posFireWork={cc.p(width/3,0),cc.p(width*2/3,0)}
    local fireWork1=Slot.animation:fireWork(layerColor,posFireWork[1],-1)
    local fireWork2=Slot.animation:fireWork(layerColor,posFireWork[2],-1)

    --
    fireWork1:setRotation(-20)
    fireWork2:setRotation(20)

    -- 彩带
    Slot.animation:paperFallDown(layerColor)

    --升级的星星要动
    local levelStar=nodeTab[2]

    local textScale1=cc.ScaleBy:create(0.5,3)
    local textScale2=cc.ScaleBy:create(0.2,2)


    local ease1= cc.EaseSineOut:create(textScale1)
    local easeBack1=ease1:reverse()

    local ease2= cc.EaseSineOut:create(textScale2)
    local easeBack2=ease2:reverse()


    local delay=cc.DelayTime:create(0.5)

    --local seq=cc.Sequence:create(ease1,delay,easeBack1,ease2,easeBack2)
    local seq=cc.Sequence:create(delay,ease1,easeBack1,ease2,easeBack2)
    levelStar:runAction(seq)

    --闪光效果 白光和金光
    local base_X1=width/6
    local base_Y1=height*3/4+20

    local posTab1={
        cc.p(base_X1,base_Y1), cc.p(base_X1-100,base_Y1+160), cc.p(base_X1-42,base_Y1+200), cc.p(base_X1,base_Y1+150),
        cc.p(base_X1+55,base_Y1+115), cc.p(base_X1+93,base_Y1+155), cc.p(base_X1-102,base_Y1-155), cc.p(base_X1-85,base_Y1-85),
        cc.p(base_X1+28,base_Y1-58), cc.p(base_X1+61,base_Y1-75), cc.p(base_X1-72,base_Y1+90), cc.p(base_X1-55,base_Y1-80),
        cc.p(base_X1,base_Y1-80), cc.p(base_X1-45,base_Y1-40), cc.p(base_X1-152,base_Y1+52), cc.p(base_X1-20,base_Y1-58),

    }


    local base_X2=width/2
    local base_Y2=height*3/4+20


    local posTab2={
        cc.p(base_X2,base_Y2), cc.p(base_X2-100,base_Y2+160), cc.p(base_X2-42,base_Y2+200), cc.p(base_X2,base_Y2+150),
        cc.p(base_X2+55,base_Y2+115), cc.p(base_X2+93,base_Y2+155), cc.p(base_X2-42,base_Y2-155), cc.p(base_X2-85,base_Y2-85),
        cc.p(base_X2+28,base_Y2-58), cc.p(base_X2+61,base_Y2-75), cc.p(base_X2-22,base_Y2+90), cc.p(base_X2-55,base_Y2-80),
        cc.p(base_X2,base_Y2-80), cc.p(base_X2-45,base_Y2-40), cc.p(base_X2-52,base_Y2+52), cc.p(base_X2-20,base_Y2-58),

    }

    local base_X3=width*5/6
    local base_Y3=height*3/4+20
    local posTab3={
        cc.p(base_X3,base_Y3), cc.p(base_X3-80,base_Y3+160), cc.p(base_X3-42,base_Y3+200), cc.p(base_X3-10,base_Y3+150),
        cc.p(base_X3+55,base_Y3+115), cc.p(base_X3+83,base_Y3+155), cc.p(base_X3-42,base_Y3-155), cc.p(base_X3-95,base_Y3-15),
        cc.p(base_X3+28,base_Y3-28), cc.p(base_X3+11,base_Y3-75), cc.p(base_X3-122,base_Y3+90), cc.p(base_X3-55,base_Y3-80),
        cc.p(base_X3,base_Y3-80), cc.p(base_X3-145,base_Y3), cc.p(base_X3-22,base_Y3+52), cc.p(base_X3-20,base_Y3-58),


    }




    Slot.animation:lightAction(layerColor,posTab1,1.2,1,true)
    Slot.animation:lightAction(layerColor,posTab2,1.2,1,true)
    Slot.animation:lightAction(layerColor,posTab3,1.2,1,true)



    --添加礼花粒子效果

    --local pFire=Slot.animation:ShowParticleByPlist("plist/levelUp.plist")
    local leftPos=cc.p(nodeTab[4]:getPositionX(),nodeTab[4]:getPositionY())
    local rightPos=cc.p(nodeTab[5]:getPositionX(),nodeTab[5]:getPositionY())

    local posTab={leftPos,rightPos}
    math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))

    local pFireAction=cc.CallFunc:create(function()

        Slot.animation:levelUpFireWork(nodeTab[3],posTab)

    end)

    local delay=cc.DelayTime:create(1)

    local seq=cc.Sequence:create(delay,pFireAction)
    local repF=cc.Repeat:create(seq,30)
    layerColor:runAction(repF)

    --添加音乐
    Slot.Audio:playEffect("sound/common/"..Slot.MusicResources["common"].levelup)


end


-- --------------------------------------------------------------------

-- 显示特殊图标动画

-- --------------------------------------------------------------------


-- 调用函数
Slot.Call_Animation.showSpecialItem=function(self,index,ModuleName)

    local bg_sprite
    local item_sprite
    self.ModuleName=ModuleName

    require ("modules."..self.ModuleName.."."..self.ModuleName.."Animation")

    if self.ModuleName=="west" then

        bg_sprite,item_sprite=Slot.west_animation:showSpecialItem(index)

    elseif self.ModuleName=="blackhand" then

        bg_sprite,item_sprite=Slot.blackhand_animation:showSpecialItem(index)

    elseif self.ModuleName=="girl" then

        bg_sprite,item_sprite=Slot.girl_animation:showSpecialItem(index)

    elseif self.ModuleName=="hawaii" then

        bg_sprite,item_sprite=Slot.hawaii_animation:showSpecialItem(index)

    end



    return bg_sprite,item_sprite

end

-- 调用函数
Slot.Call_Animation.SpecialItemAction=function(self,itemSprite,index,parentNode)

    if self.ModuleName=="west" then

        Slot.west_animation:showSpecialItemActions(index,itemSprite,parentNode)

    elseif self.ModuleName=="blackhand" then

        Slot.blackhand_animation:showSpecialItemActions(index,itemSprite,parentNode)

    elseif self.ModuleName=="girl" then

        Slot.girl_animation:showSpecialItemActions(index,itemSprite,parentNode)

    elseif self.ModuleName=="hawaii" then

        Slot.hawaii_animation:showSpecialItemActions(index,itemSprite,parentNode)

    end


end


-- --------------------------------------------------------------------

-- freeSpin scatter动画
-- bonus小游戏 bonus动画

-- --------------------------------------------------------------------


--scatter Action
-- 调用函数
Slot.Call_Animation.scaAction=function(self,itemSprite,ModuleName)

    local index=itemSprite:getTag()
    local parentNode=itemSprite:getParent()
    local action=cc.CallFunc:create(function ()



    if ModuleName=="west" then

        Slot.west_animation:showSpecialItemActions(index,itemSprite)

    elseif ModuleName=="blackhand" then

        Slot.blackhand_animation:showSpecialItemActions(index,itemSprite)

    elseif ModuleName=="hawaii" then

        Slot.hawaii_animation:showSpecialItemActions(index,itemSprite,parentNode)

    elseif ModuleName=="girl" then

        Slot.girl_animation:showSpecialItemActions(index,itemSprite)

    end



    end)

    local delay=cc.DelayTime:create(0.5)
    local seq=cc.Sequence:create(action,delay)

    return seq


end




--bonus Action
-- 调用函数
Slot.Call_Animation.bonAction=function(self,itemSprite,ModuleName)

    local index=itemSprite:getTag()

    local action=cc.CallFunc:create(function ()

        if ModuleName=="west" then

            Slot.west_animation:showSpecialItemActions(index,itemSprite)
        elseif ModuleName=="blackhand" then

            Slot.blackhand_animation:showSpecialItemActions(index,itemSprite)

        elseif ModuleName=="hawaii" then

            Slot.hawaii_animation:showSpecialItemActions(index,itemSprite)


        elseif ModuleName=="girl" then

            Slot.girl_animation:showSpecialItemActions(index,itemSprite)


        end


    end)

    local delay=cc.DelayTime:create(0.5)
    local seq=cc.Sequence:create(action,delay)



    return seq


end


--Slot.SpecailItem={
--
--    west={1,2,50,100,200},
--    blackhand={1,2,3,50,100,200},
--    girl={1,2,50,100,200},
--    hawaii={1,2,3,50,100,200 },
--
--
--}

Slot.Call_Animation.SpecialItemActionMusic=function(self,specailTagTab,moduleName)



   --根据优先级判断播放哪个图标的音乐
    local moduleName=moduleName
    local targetTag=self:selectSpecailTag(specailTagTab)

    if moduleName=="west" then

        Slot.west_animation:westSpecailItemMusic(targetTag)

    elseif moduleName=="blackhand" then
        Slot.blackhand_animation:blackhandSpecailItemMusic(targetTag)

    elseif moduleName=="girl" then
        Slot.girl_animation:girlSpecailItemMusic(targetTag)

    elseif moduleName=="hawaii" then
        Slot.hawaii_animation:hawaiiSpecailItemMusic(targetTag)
        --return targetTag

    end

end


Slot.Call_Animation.selectSpecailTag=function(self,specailTagTab)

    if not specailTagTab then return end
     --只有一个特殊图标
    if #specailTagTab==1 then return specailTagTab[1] end

     --如果所有的图表都是同一个
    local isAllSame=U:isAllSame(specailTagTab)

    local targetTag
    if isAllSame==true then

        return specailTagTab[1]
    else

         --根据优先级选择等级最高的那个图标播放

        targetTag=self:getThePriorityTag(specailTagTab)

    end

    return targetTag

end

Slot.Call_Animation.getThePriorityTag=function(self,specailTagTab)

    local moduleName=self.ModuleName
    local targetTag
    if moduleName=="west" then

        targetTag=Slot.west_animation:getWestPriorityTag(specailTagTab)

    elseif   moduleName=="blackhand" then

        targetTag=Slot.blackhand_animation:getBlackhandPriorityTag(specailTagTab)
    elseif   moduleName=="girl" then

        targetTag=Slot.girl_animation:getGirlPriorityTag(specailTagTab)

    elseif   moduleName=="hawaii" then

        targetTag=Slot.hawaii_animation:getHawaiiPriorityTag(specailTagTab)

    end

    return targetTag

end


Slot.Call_Animation.StartlightAction=function(self,itemSprite,loopNum)

    local width=itemSprite:getContentSize().width
    local height=itemSprite:getContentSize().height

    local baseX1=width/4
    local baseX2=width/2
    local baseX3=width*3/4

    local baseY1=height*5/6
    local baseY2=height/2
    local baseY3=height*2/3



    --选中一些点
    local posTab={
        cc.p(baseX1,baseY1),cc.p(baseX2,baseY1),cc.p(baseX3,baseY1),
        cc.p(baseX1-100,baseY1+50),cc.p(baseX2-100,baseY1+100),cc.p(baseX3-100,baseY1+80),
        cc.p(baseX3+100,baseY1+50),cc.p(baseX2-80,baseY1-50),cc.p(baseX1-150,baseY1-100),


        cc.p(baseX3,baseY2+150),cc.p(baseX1-250,baseY1-200),cc.p(baseX3+210,baseY2+130),
        cc.p(baseX1+200,baseY2+50),cc.p(baseX3-100,baseY3+100),cc.p(baseX1,baseY2+250),
        cc.p(baseX2-100,baseY1-100),cc.p(baseX3-200,baseY3+300),

        cc.p(baseX1+100,baseY1),cc.p(baseX3,baseY3+100),cc.p(baseX2,baseY1-100),


        cc.p(baseX3+50,baseY1+50),cc.p(baseX2+130,baseY1-50),cc.p(baseX3,baseY1-100),
        cc.p(baseX3+100,baseY2+150),cc.p(baseX3-100,baseY1-200),cc.p(baseX3+210,baseY2+130),

    }

    math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
    for i=1,loopNum do
        Slot.animation:lightAction(itemSprite,posTab,0.5,1,true)
    end


end









