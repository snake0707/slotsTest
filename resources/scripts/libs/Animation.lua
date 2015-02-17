--
-- by bbf
--


Slot.animation = Slot.animation or {}


Slot.animation.clearCache = function(self)

    cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()
    cc.TextureCache:getInstance():removeUnusedTextures()
end




--存储每条线路

Slot.animation.m_lineTab={}
Slot.animation.isVisible=false
Slot.animation.isDrawAll=true
Slot.animation.DurationTime=0.001
Slot.animation.MatchItemTab={}
Slot.animation.MatchItemBorderTab={}
Slot.animation.ModuleName=nil

Slot.animation.cellPositionTab={}


-- 基础函数
-- 调用函数

-- ----------------------
--ParctiseMove Action
-- ----------------------

--cc.p(1,2)代表 第1列第2行
--Slot.animation.ParctiseMove("modules/west/Fire.png",childrenTab,self["weelnode2"],cc.p(1,2))


-- 基础函数
--粒子移动的开始位置
Slot.animation.getStartPosition=function(self,targetPoint,distanceTab,startPointIndex)




    local startPoint=cc.p(0,0)
    local cellImageWidth=distanceTab[1]
    local cellImageHeight=distanceTab[2]


    if startPointIndex==1 then

        startPoint=cc.p(targetPoint.x-cellImageWidth/2,targetPoint.y-cellImageHeight/2)
        --startPoint=cc.p(temp.x,temp.y)

    elseif startPointIndex==2 then

        startPoint=cc.p(targetPoint.x-cellImageWidth/2,targetPoint.y)

    elseif startPointIndex==3 then

        startPoint=cc.p(targetPoint.x-cellImageWidth/2,targetPoint.y+cellImageHeight/2)

    elseif startPointIndex==4 then

        startPoint=cc.p(targetPoint.x,targetPoint.y+cellImageHeight/2)

    elseif startPointIndex==5 then

        startPoint=cc.p(targetPoint.x+cellImageWidth/2,targetPoint.y+cellImageHeight/2)

    elseif startPointIndex==6 then
        startPoint=cc.p(targetPoint.x+cellImageWidth/2,targetPoint.y)

    elseif startPointIndex==7 then

        startPoint=cc.p(targetPoint.x+cellImageWidth/2,targetPoint.y-cellImageHeight/2)

    elseif startPointIndex==8 then

        startPoint=cc.p(targetPoint.x,targetPoint.y-cellImageHeight/2)

    end

    return startPoint


end

--

-- 基础函数
Slot.animation.createCellParctis=function(self,pathFile,startPointIndex,distanceTab,layerNode,targetPoint,durationTime)


    local director = cc.Director:getInstance()
    local glview = director:getOpenGLView()

    local designSize = director:getWinSize()
    local screenSize = glview:getFrameSize()
    local scale=designSize.width/screenSize.width

    local pSun = cc.ParticleSun:create()

    pSun:setTexture(cc.Director:getInstance():getTextureCache():addImage(pathFile))
    ----
    --pSun:setTotalParticles(300)

    --pSun:setTotalParticles(3000)
    --pSun:setStartSize(7)

    if screenSize.height>768 then
        pSun:setStartSize(25*scale)
    else
        pSun:setStartSize(18*scale)
    end


    pSun:setStartSizeVar(5)

    pSun:setAutoRemoveOnFinish(true)


    --
    pSun:setStartColor(cc.c4b(1,255,255,255))
    --pSun:setEndColor(cc.c4b(0,255,255,255))


    pSun:setPositionType(cc.POSITION_TYPE_RELATIVE)



    pSun:setEmissionRate(80)
    pSun:setSpeed(0)
    --pSun:setDuration(durationTime*4.2) -- 一圈的总时间

    pSun:setDuration(durationTime+0.05) -- 一圈的总时间


    --设置角度
    pSun:setAngle(0)
    pSun:setAngleVar(360)


    --设置粒子开始的自旋转速度，开始自旋转速度的变化率
    pSun:setStartSpin(30);
    pSun:setStartSpinVar(60);


    layerNode:addChild(pSun, 50)

    local startPos=Slot.animation:getStartPosition(targetPoint,distanceTab,startPointIndex)

    --通过传进来框的坐标 以及startPointIndex来确定其实位置

    pSun:setPosition(startPos)

    return pSun

end

-- 基础函数 girl
Slot.animation.createGirlParctis=function(self,pathFile,startPointIndex,distanceTab,layerNode,targetPoint,durationTime)


    local director = cc.Director:getInstance()
    local glview = director:getOpenGLView()

    local designSize = director:getWinSize()
    local screenSize = glview:getFrameSize()
    local scale=designSize.width/screenSize.width

    local pSun = cc.ParticleSun:create()

    pSun:setTexture(cc.Director:getInstance():getTextureCache():addImage(pathFile))
    ----
    pSun:setTotalParticles(10000)

    --pSun:setStartSize(22*scale)

    pSun:setStartSize(20)
    pSun:setStartSizeVar(5)

    pSun:setAutoRemoveOnFinish(true)

    --    pSun:setStartSize(3)
    --
    --    pSun:setEndSize(3)
    --
    pSun:setStartColor(cc.c4b(1,255,255,255))
    --pSun:setEndColor(cc.c4b(0,255,255,255))


    pSun:setPositionType(cc.POSITION_TYPE_RELATIVE)

    pSun:setEmissionRate(2000)
    pSun:setSpeed(20)
    --pSun:setDuration(durationTime*4.2) -- 一圈的总时间

    pSun:setDuration(durationTime+0.1) -- 一圈的总时间


    --设置角度
    pSun:setAngle(0)
    pSun:setAngleVar(360)


    --设置粒子开始的自旋转速度，开始自旋转速度的变化率
    pSun:setStartSpin(30);
    pSun:setStartSpinVar(60);


    layerNode:addChild(pSun, 50)

    local startPos=Slot.animation:getStartPosition(targetPoint,distanceTab,startPointIndex)

    --通过传进来框的坐标 以及startPointIndex来确定其实位置

    pSun:setPosition(startPos)

    return pSun

end





-- 调用函数
Slot.animation.ParctiseMove=function(self,pathFile,cellNode,layerNode,targetStartPos,startPointIndex,speed,isModule)


    require "libs.Call_Animation"

    Slot.Call_Animation:ParctiseMove(pathFile,cellNode,layerNode,targetStartPos,startPointIndex,speed,isModule)

end



Slot.animation.scheduleN=function(node,callback,n,delay)

    if delay==nil then delay=0 end

    local delay = cc.DelayTime:create(delay)
    local sequence = cc.Sequence:create(delay, cc.CallFunc:create(callback))
    local action = cc.Repeat:create(sequence,n)
    node:runAction(action)

end


Slot.animation.scheduleUpdate=function(node,callback,delay)

    if delay==nil then delay=0 end

    local delay = cc.DelayTime:create(delay)
    local sequence = cc.Sequence:create(delay, cc.CallFunc:create(callback))
    local action = cc.RepeatForever:create(sequence)
    node:runAction(action)

end




-- ----------------------
--DrawLine Action
-- ----------------------



-- 基础函数
Slot.animation.getCellPosition=function(self,cellTab)

--cellTab是个二维表 第一维代表列 第二维代表行
    local col=#cellTab
    local row=#cellTab[1]

    --构建一个存储表
    local cellPosition={}

    for i=1,col do

        cellPosition[i]={}
        for j=1,row do

            if self.isDrawAll==false then
                cellPosition[i][3-j+1]=cc.p(cellTab[i][j]:getPositionX(),cellTab[i][j]:getPositionY())
            else
                cellPosition[i][3-j+1]=cc.p(cellTab[i][j]:getPositionX(),self.componentHeight*(2*j+1)/2)
            end




        end

    end



    return cellPosition

end

-- 基础函数
Slot.animation.getRearouceIndex=function(self,ResouceTab,n)

    if n==nil then n=5 end

    local saveResourceTab={}
    for i=1,#ResouceTab do

        saveResourceTab[i]={}
        for j=1,n do

            saveResourceTab[i][j]=ResouceTab[i][j]

        end

    end

    return saveResourceTab


end

-- 基础函数
Slot.animation.getDistanceInTwoPoints=function(self,pointOne,pointTwo)

    local diffX,diffY=pointTwo.x-pointOne.x,pointTwo.y-pointOne.y
    local distance=math.sqrt(diffX*diffX+diffY*diffY)
    return distance

end

-- 基础函数
Slot.animation.getAngleByTwoPoints=function(self,tmpStartPoint,tmpEndPoint)

    local diff=cc.p(tmpEndPoint.x-tmpStartPoint.x,tmpEndPoint.y-tmpStartPoint.y)

    local angle=diff.y/diff.x
    angle=math.atan(angle)/math.pi*180
    return -angle


end

-- 基础函数
Slot.animation.CovertToPoints=function(self,point,nodeTab,colNum,layerNode)

    local worldPos = cc.p(nodeTab[colNum]:convertToWorldSpace(point))
    local nodePos = cc.p(layerNode:convertToNodeSpace(worldPos))

    return nodePos

end


Slot.animation.line_index=1
Slot.animation.cellheight=nil
Slot.animation.num=0

-- 基础函数
Slot.animation.drawLineInTwoPoints=function(self,pointTab,maxLength,layerNode,nodeTab,cellTab,colNumTab,isVisibleYes)

    U:addSpriteFrameResource("plist/common/common.plist")

    local startPos=Slot.animation:CovertToPoints(pointTab[1],nodeTab,colNumTab[1],layerNode)
    local endPos=Slot.animation:CovertToPoints(pointTab[2],nodeTab,colNumTab[2],layerNode)

    local angle=Slot.animation:getAngleByTwoPoints(startPos,endPos)

    --    print("drawLineInTwoPoints@@@@@@@@@@@@@@@@")
    --    print("angle:"..angle)
    --    print("drawLineInTwoPoints@@@@@@@@@@@@@@@@")


    local distance=Slot.animation:getDistanceInTwoPoints(startPos,endPos)
    if distance>maxLength then distance=maxLength end




    --如果画完所有线 就不创建 直接从数组里拿
    local progressTimer
    if self.isDrawAll==true then

        local s=U:getSpriteByName("line1.png")

        s:getTexture():setAntiAliasTexParameters()

        progressTimer=cc.ProgressTimer:create(s)


        layerNode:addChild(progressTimer,10)
        table.insert(self.m_lineTab,progressTimer)
        --progressTimer:retain()
        progressTimer:ignoreAnchorPointForPosition(false)
        progressTimer:setAnchorPoint(cc.p(0,0.5))
        progressTimer:setRotation(angle)
        progressTimer:setBarChangeRate(cc.p(1, 0))
        progressTimer:setMidpoint(cc.p(0, 0.5))
        progressTimer:setType(cc.PROGRESS_TIMER_TYPE_BAR)
        progressTimer:setPosition(cc.p(startPos.x,startPos.y-self.cellheight))

        progressTimer:setVisible(isVisibleYes)


    else


        local count=#self.m_lineTab

        progressTimer=self.m_lineTab[self.line_index]

        progressTimer:setPercentage(0)

        self.line_index=self.line_index+1
        if self.line_index==count+1 then self.line_index=1 end


    end





    if angle<=-60 then

        distance=distance+1.4
    elseif angle>=60 then
        distance=distance+1.1
    elseif angle>=40 then
        distance=distance+1.25
    elseif angle<=-40 then
        distance=distance+1.25
    else
        distance=distance+1.1
    end

    progressTimer:setPosition(cc.p(startPos.x,startPos.y-self.cellheight-4))
    progressTimer:setVisible(isVisibleYes)
    --progressTimer:setVisible(false)


    --1.23

    local progressTo = cc.ProgressTo:create(self.DurationTime,(distance)/maxLength*100)

    progressTimer:runAction(progressTo)


end

-- 基础函数
Slot.animation.HideAllLine=function(self,layerNode)



    for i=1,#self.m_lineTab do

        if self.m_lineTab[i]~=nil then

            self.m_lineTab[i]:setVisible(false)
        end

    end



end

-- 基础函数
Slot.animation.showAllLine=function(self,layerNode)


    for i=1,#self.m_lineTab do

        if self.m_lineTab[i]~=nil then

            self.m_lineTab[i]:setVisible(true)

        end


    end


    --显示所有获奖总额
    if self.totalAwardText~=nil or self.dataTab.awardGold==0 then return end

    
    local str=tostring(self.dataTab.awardGold)
    --local totalAwardText=cc.LabelTTF:create(str, "Marker Felt",200)

    local totalAwardText=cc.LabelBMFont:create(str,"font/common/lineNum.fnt")
    layerNode:addChild(totalAwardText,100)
    totalAwardText:setPosition(cc.p(layerNode:getContentSize().width/2,layerNode:getContentSize().height/2))
    --totalAwardText:setColor(cc.c3b(124,9,105))
    totalAwardText:setScale(2)

    self.totalAwardText=totalAwardText

    --
    Slot.Call_Animation.totalAwardText=self.totalAwardText

    --这里的回调是要知道增长数字的时刻
--    self.DataTab=data
--    self.PosTab=posTab
--    self.NodeTab=nodeTab
--    self.CallbackTab=callbackTab
--    self.LineType=linetype

    require "libs.Call_Animation"
    Slot.Call_Animation:winCoinCommon(self.DataTab,self.PosTab,self.NodeTab,self.CallbackTab.coin_callback)

end

-- 基础函数
Slot.animation.saveAllInformation=function(self,count,col,MatchRouteTab,TotalRouteTab,MatchNumTab,cellPositionTab,saveResourceTab)



    local m_PointArray={}
    local m_MatchReouches={}
    local m_ActionArray={}
    local m_MatchNumItem={}

    --当count==1时 表示只画一条或只有一条匹配
    for m=1,count do

        local i=MatchRouteTab[m]

        m_PointArray[m]={}
        m_MatchReouches[m]={}
        m_ActionArray[m]={}

        --存储画线的点
        for j=1,col do

            local k=TotalRouteTab[i][j]

            --要修改画线只要修改画线的点就好
            table.insert(m_PointArray[m], cellPositionTab[j][k])

        end


        --存储 匹配线路中显示框的数目
        m_MatchNumItem[m]=MatchNumTab[m]


        --存储匹配的图标index

        local p=MatchRouteTab[m]
        for r=1,MatchNumTab[m] do
            local q=TotalRouteTab[p][r] -- q==>行  r==>列
            --table.insert(m_MatchReouches[m], saveResourceTab[3-q+1][r])
            table.insert(m_MatchReouches[m], saveResourceTab[q][r])

        end

    end

    return m_PointArray,m_MatchReouches,m_MatchNumItem

end

-- 调用函数
Slot.animation.saveAllAction=function(self,PointArray,count,col,maxLength,layerNode,nodeTab,cellTab,matchNumTab,matchResourceTab,type)



    local m_ActionArray={}
    --
    -- ---------------------循环画线--------------------------------------------------------------
    for m=1,count do

        m_ActionArray[m]={}

        local tempTab={}

        self.MatchItemTab[m]=self.MatchItemTab[m]or{}
        self.MatchItemBorderTab[m]=self.MatchItemBorderTab[m]or{}

        --调用画框的方法

        local showItems=cc.CallFunc:create(function ()

        --刚开始不显示
            Slot.animation:showMatchItem(m,layerNode,matchNumTab,nodeTab,PointArray,cellTab,matchResourceTab)


        end)

        table.insert(tempTab,showItems)



        for u=1,col+1 do

            local action = cc.CallFunc:create(function ()

            --layerNode:setVisible(true)
            --调用画线方法

                local pointTab
                local colNumTab

                --add 12.21
                if u>col then

                    pointTab={PointArray[m][u-1],cc.p(2*PointArray[m][u-1].x,PointArray[m][u-1].y) }
                    colNumTab={u-1,u-1 }
                elseif u==1 then

                    pointTab={cc.p(0,PointArray[m][u].y),PointArray[m][u] }
                    colNumTab={u,u }
                else
                    pointTab={PointArray[m][u-1],PointArray[m][u] }
                    colNumTab={u-1,u}

                end



                --刚开始不显示

                Slot.animation:drawLineInTwoPoints(pointTab,maxLength,layerNode,nodeTab,cellTab,colNumTab,self.isVisible)


            end)

            local delay= cc.DelayTime:create(self.DurationTime)

            local seq=cc.Sequence:create(action)
            if self.isDrawAll == false then
                --seq=cc.Sequence:create(delay,action,delay)
                seq=cc.Sequence:create(action,delay)
            end



            table.insert(tempTab,seq)

        end



        --local delayStand=cc.DelayTime:create(8*DurationTime)

        --add 11.27
        local delayStand=cc.DelayTime:create(18*self.DurationTime)

        local disppearAction = cc.CallFunc:create(function ()


        --隐藏线
            Slot.animation:HideAllLine(layerNode)

            --item消失
            if self.isDrawAll==false then

                Slot.animation:disspearMatchItemAndBorder(m)
            end


            self.matchSpecialItemTagTab={}

        end)

        local delayhideItems= cc.DelayTime:create(0.5)

        --add
        --local delayhideItems= cc.DelayTime:create(1)


        if not self.isDrawAll or type=="bonus" then
            --if isDrawAll then
            table.insert(tempTab,delayStand)
            table.insert(tempTab,disppearAction)
            table.insert(tempTab,delayhideItems)
        end



        local seqAll=cc.Sequence:create(tempTab)
        m_ActionArray[m]=seqAll

        --这里好像会内存泄漏 要测试下 不加上无法获取动作序列 会消失
        m_ActionArray[m]:retain()

        --self.actionManageTab[m]=m_ActionArray[m]
    end

    return m_ActionArray


end

-- 基础函数
--存储所有匹配线路的起始点
Slot.animation.getStartPosTab=function(self,pointArrayTab)

    local startPosTab={}

    for i, vi in pairs(pointArrayTab) do

        for j, vj in pairs(vi) do

            startPosTab[i]=vj
            break
        end
    end

    return startPosTab
end

-- 基础函数
--判断起始点是否重复
Slot.animation.isStartposRepeat=function(self,point,startPosTab,count)


    if count==0 then return  false end

    for i=1,count do

        if point.x==startPosTab[i].x and point.y==startPosTab[i].y then

            return true

        end

    end

    return false


end


-- 调用函数
Slot.animation.changeThePosForDrawAll=function(self,pointArrayTab,CellTab)

    local newPointArrayTab={}
    local startPosTab={}
    math.randomseed(os.time())

    local heitht=CellTab[1][1]:getContentSize().height

    --print("changeThePosForDrawAll=======================:"..heitht)
    local diffHeighOne=heitht*math.random(0,1)/5
    local diffHeighTwo=heitht*math.random(0,1)/5
    startPosTab=Slot.animation:getStartPosTab(pointArrayTab)



    for i, vi in pairs(pointArrayTab) do
        newPointArrayTab[i]={}

        local isAdjust
        local diffDistance=math.random(0,10)*2

        if math.random(0,10)>5 then
            diffDistance=-diffDistance
        end



        for j, vj in pairs(vi) do

            --每次都只要把第一个点传进去判断下就好
            if j==1 then

                isAdjust=Slot.animation:isStartposRepeat(vj,startPosTab,i-1)
            end


            --isAdjust为true表示该条线路的起始点之前有重复 需要调整位置
            if isAdjust==true then

                newPointArrayTab[i][j]=cc.p(vj.x,vj.y+diffDistance)

            else
                if i~=1 and i~=2 then
                    newPointArrayTab[i][j]=vj
                elseif i==1 then
                    newPointArrayTab[i][j]=cc.p(vj.x,vj.y+diffHeighOne)

                elseif i==2 then

                    newPointArrayTab[i][j]=cc.p(vj.x,vj.y-diffHeighTwo)

                end

            end


        end
    end


    return newPointArrayTab

end


-- 基础函数
--让每条匹配线路上的显示图标消失
Slot.animation.disspearMatchItemAndBorder=function(self,routeInex)


    for i=1,#self.MatchItemTab[routeInex] do


        if self.MatchItemTab[routeInex][i]~=nil then

            self.MatchItemTab[routeInex][i]:setVisible(false)
        end



    end

    for i=1,#self.MatchItemBorderTab[routeInex] do

        if self.MatchItemBorderTab[routeInex][i]~=nil then

            self.MatchItemBorderTab[routeInex][i]:setVisible(false)
        end

    end


end

-- 基础函数
Slot.animation.getRowByPoint=function(self,point,height)

    local y=point.y
    local row=math.floor(y/height)
    return row

end


-- --------------------------------------
-- 调用函数
Slot.animation.showSpecialItem=function(self,index)

    local bg_sprite
    local item_sprite


    require "libs.Call_Animation"
    bg_sprite,item_sprite=Slot.Call_Animation:showSpecialItem(index,self.ModuleName)
    return bg_sprite,item_sprite

end

-- 基础函数
Slot.animation.isSpecialItem=function(self,index)

    local SpecialItemIndex=Slot.SpecailItem[self.ModuleName]


    for i = 1,#SpecialItemIndex do

        if SpecialItemIndex[i]==index then

            return true
        end

    end

    return false


end

-- 基础函数
Slot.animation.lightAction=function(self,itemSprite,posTab,scale,secs,isRepeat,num)

--print("lightAction-=============")
    U:addSpriteFrameResource("plist/common/common.plist")

    if secs==nil then secs=0.5 end
    if scale==nil then scale=0.6 end
    if isRepeat==nil then isRepeat=false end

    local starTab={}
    --在itemSprite区域大小内随机表里抽取几个点 随机表中是显示在字上的点


    local count=#posTab
    --在字上添加星星
    for i=1,count do


        local index=math.random(1,count)
        --print("lightAction$$$$$$index:"..index)
        local lightSprite=U:getSpriteByName("light2.png")
        itemSprite:addChild(lightSprite,100)
        lightSprite:setPosition(posTab[index])
        lightSprite:setScale(0.2)

        table.insert(starTab,lightSprite)



        --从小变大 同时渐隐 旋转

        --0.5
        local scale=cc.ScaleTo:create(secs,scale)
        local fade=cc.FadeIn:create(secs)
        local rotate=cc.RotateBy:create(1,90)

        local delay=cc.DelayTime:create(i*0.1)



        if isRepeat==false then


            lightSprite:setOpacity(30)

            local rem=cc.RemoveSelf:create()
            local spa=cc.Spawn:create(scale,fade,rotate)
            local seq=cc.Sequence:create(delay,spa,rem)
            lightSprite:runAction(seq)

        else

            lightSprite:setOpacity(0)
            local rem=cc.RemoveSelf:create()

            local scaleBack=cc.ScaleTo:create(secs,0.2)

            local fadeOut=cc.FadeOut:create(secs)
            local seqScale=cc.Sequence:create(scale,scaleBack)
            local seqFade=cc.Sequence:create(fade,fadeOut)

            local spa=cc.Spawn:create(seqScale,seqFade)
            local seq=cc.Sequence:create(delay,spa)

            local repN
            local seqA
            if num then
                repN=cc.Repeat:create(seq,num)
                seqA=cc.Sequence:create(repN,rem)
                lightSprite:runAction(seqA)
            else

                repN=cc.RepeatForever:create(seq)
                lightSprite:runAction(repN)

            end
            



        end


    end

    return starTab




end

-- 基础函数
Slot.animation.goldStarAction=function(self,itemSprite,posTabR)

    U:addSpriteFrameResource("plist/common/game_common.plist")
--在黄金上添加发光粒子效果

    local count=#posTabR
    for i=1,3 do

        local index=math.random(1,count)
        --print("lightAction$$$$$$index:"..index)
        local lightSprite=U:getSpriteByName("gold_star.png")
        itemSprite:getParent():addChild(lightSprite,100)
        lightSprite:setPosition(posTabR[index])
        lightSprite:setScale(0.2)
        lightSprite:setOpacity(30)

        --从小变大 同时渐隐 旋转

        --0.5
        local scale=cc.ScaleTo:create(0.5,0.6)
        local fade=cc.FadeIn:create(0.5)
        local rotate=cc.RotateBy:create(1.5,90)

        local delay=cc.DelayTime:create(i*0.2)


        local rem=cc.RemoveSelf:create()
        local spa=cc.Spawn:create(scale,fade,rotate)

        local seq=cc.Sequence:create(delay,spa,rem)
        --
        lightSprite:runAction(seq)

    end


end


-- 调用函数
Slot.animation.SpecialItemAction=function(self,itemSprite,index,parentNode)


    require "libs.Call_Animation"
    Slot.Call_Animation:SpecialItemAction(itemSprite,index,parentNode)


end



-- ------------显示特殊图标动画----------------------------------------

-- 基础函数
Slot.animation.showMatchAward=function(self,text,parentNode)

    --local label=cc.LabelTTF:create(text, "Marker Felt", 100)
    local label=cc.LabelBMFont:create(text,"font/common/lineNum.fnt")
    parentNode:addChild(label,100)
    label:setPosition(cc.p(parentNode:getContentSize().width/2,parentNode:getContentSize().height/2))
    --label:setColor(cc.c3b(124,9,105))
    --label:setColor(cc.c3b(255,255,255))

end


Slot.animation.showMatchItem=function(self,routeInex,layerNode,MatchNumTab,NodeTab,PointArray,CellTab,matchResourceTab)

    U:addSpriteFrameResource("plist/modules/"..self.ModuleName.."/"..self.ModuleName..".plist")
--每条线路的显示item个数

    if not routeInex then return end
    
    local count=MatchNumTab[routeInex]

    --当只画bonus的线时 MatchNumTab中只有一个0元素 图标的匹配依靠锋哥返回的数据
    if count==0 then return end

    --放到数组里 下次不用创建直接利用
    if self.isDrawAll==true then

        for i=1,count do

            --根据匹配index 生成不同item

            -- 11.25
            --在这里添加一个函数 如果为特殊图标就在特殊图标上添加动画 特殊图标下标  1 2 50 100 200

            local bg_sprite
            local item_sprite
            local isSpecialItem=Slot.animation:isSpecialItem(matchResourceTab[routeInex][i])
            if isSpecialItem==true then

                bg_sprite,item_sprite=Slot.animation:showSpecialItem(matchResourceTab[routeInex][i])


                --把item名称下标作为标签
                layerNode:addChild(bg_sprite,40,matchResourceTab[routeInex][i])

                table.insert(self.MatchItemTab[routeInex],bg_sprite)

            else

                bg_sprite=U:getSpriteByName(matchResourceTab[routeInex][i]..".png")
                bg_sprite:setVisible(self.isVisible)
                layerNode:addChild(bg_sprite,40)
                table.insert(self.MatchItemTab[routeInex],bg_sprite)


            end



            --如果要添加框的话 在这里添加

            local border=U:getSpriteByName("border.png")
            bg_sprite:addChild(border)
            border:setPosition(cc.p(bg_sprite:getContentSize().width/2,bg_sprite:getContentSize().height/2))
            --table.insert(self.MatchItemBorderTab[routeInex],border)


            self.matchSpecialItemTagTab={}

        end

        --这里添加每条线路的分数值 并放在第几个item上

        local award=tostring(self.dataTab.payBackIds[routeInex].award)
        local itemNode=self.MatchItemTab[routeInex][count]

        Slot.animation:showMatchAward(award,itemNode)


    else

        --从数组里拿出来

        local count=#self.MatchItemTab[routeInex]

        for i=1,count do


            -- MatchItemTab 里存放着特殊图标
            local s=self.MatchItemTab[routeInex][i]
            s:setVisible(true)

            --            --获取item标签 判断是否位特殊图标
            local itemTag=s:getTag()
            local isSpecialItem=Slot.animation:isSpecialItem(itemTag)

            if isSpecialItem==true then

                --执行特殊图标动画

                --获取itemSpite  itemSprite的标签和特殊图标标签一样 只不过itemSprite是特殊图标的子节点
                local itemSprite=s:getChildByTag(itemTag)

                --把特殊图表的下标放到一张表里
                table.insert(self.matchSpecialItemTagTab,itemTag)

                Slot.animation:SpecialItemAction(itemSprite,itemTag,s)


            end

--            local b=self.MatchItemBorderTab[routeInex][i]
--            b:setVisible(true)
                        --b:setVisible(false)


            --重新摆放位置
            local startPos=Slot.animation:CovertToPoints(PointArray[routeInex][i],NodeTab,i,layerNode)

            s:setPosition(cc.p(startPos.x,startPos.y-self.cellheight))
            --b:setPosition(cc.p(startPos.x,startPos.y-self.cellheight))


            --调用粒子移动方法

            local targetStartPos=cc.p(startPos.x,startPos.y-self.cellheight)

            local startPointIndex=routeInex%8
            if startPointIndex==0 then startPointIndex=1 end


            Slot.animation:ParctiseMove("image/common/stars.png",CellTab[1][1],layerNode,targetStartPos,startPointIndex)



        end


        --播放开始图标音乐
        require "libs.Call_Animation"
        Slot.Call_Animation:SpecialItemActionMusic(self.matchSpecialItemTagTab,self.ModuleName)
    end




end

-- 基础函数
Slot.animation.removeAllAction=function(self,layerNode,height,moduleName)

    self.ModuleName=moduleName
    self.cellheight=height
    self.ParticleTab={}

    --重置初始条件
    self.isVisible=false
    self.isDrawAll=true
    self.line_index=1
    --self.isFreeSpin=false

    self.totalAwardText=nil
    layerNode:setOpacity(0)

    -- 每次spin时 重新删除子节点并清空表 取消定时器

    layerNode:setVisible(false)
    layerNode:stopAllActions()

    --清空 line数组
    for i=1,#self.m_lineTab do

        if self.m_lineTab[i]~=nil then

            self.m_lineTab[i]:setVisible(false)
            self.m_lineTab[i]:stopAllActions()
            self.m_lineTab[i]=nil
        end

    end


    --清空 item数组
    for i=1,#self.MatchItemTab do

        for j=1,#self.MatchItemTab[i] do

            if self.MatchItemTab[i][j]~=nil then
                self.MatchItemTab[i][j]:setVisible(false)

                self.MatchItemTab[i][j]=nil

            end


        end


    end

    --清空 border数组
    for i=1,#self.MatchItemBorderTab do

        for j=1,#self.MatchItemBorderTab[i] do

            if self.MatchItemBorderTab[i][j]~=nil then
                self.MatchItemBorderTab[i][j]:setVisible(false)


                self.MatchItemBorderTab[i][j]=nil

            end


        end


    end

    layerNode:removeAllChildren()



end

-- 基础函数
Slot.animation.getTheTabByIndex=function(self,dataTab,Index)



--匹配线路表
    local MatchRouteTab={}

    --匹配线路显示item个数表
    local MatchNumTab={}

    MatchRouteTab[1]=Index
    --MatchNumTab[1]=dataTab.payBackIds[i].num
    MatchNumTab[1]=0
    return MatchRouteTab,MatchNumTab



end

-- 调用函数
Slot.animation.getTheTabs=function(self,dataTab,type)


--匹配线路表
    local MatchRouteTab={}

    --匹配线路显示item个数表
    local MatchNumTab={}

    if type=="bonus" then


        MatchRouteTab,MatchNumTab=Slot.animation:getTheTabByIndex(dataTab,dataTab.bonus)
        return MatchRouteTab,MatchNumTab

    end



    local i=1
    for k, v in pairs(dataTab.payBackIds) do
        local lineNum=v.line
        local matchNum=v.num
        MatchRouteTab[i]=lineNum
        MatchNumTab[i]=matchNum

        i=i+1
    end

    return MatchRouteTab,MatchNumTab

end

-- 调用函数
Slot.animation.showAndHideAllLine=function(self,layerNode)

    local count=#layerNode:getChildren()

    if count==0 then
        return
    end


    -- 第二步 全部显示 并停顿2秒  全部消失
    local action2=cc.CallFunc:create(function ()


        Slot.animation:showAllLine(layerNode)

    end)



    --第三步 全部消失
    local action3=cc.CallFunc:create(function ()


        Slot.animation:HideAllLine(layerNode)


    end)




    local delayStand=cc.DelayTime:create(0.5)
    local delayStand1=cc.DelayTime:create(0.3)
    local delay=cc.DelayTime:create(0.5)


    local awardDiss=cc.CallFunc:create(function()

        if not self.totalAwardText then return end
        self.totalAwardText:removeFromParent()


    end)

    local seq = cc.Sequence:create(delay,action2,delayStand,action3,delay,action2,delayStand,awardDiss,action3,delayStand1)

    return seq

end


-- 调用函数
Slot.animation.DrawAllLine=function(self, CellTab,NodeTab,layerNode,dataTab,moduleName,componentHeight)
--
--    print("start DrawAll@@@@@@@@@@@@@@@@@@")
    U:addSpriteFrameResource("plist/common/common.plist")
    self.dataTab=dataTab
    self.awardTextTab={}
    self.componentHeight=componentHeight

    --总路线表
    local TotalRouteTab=dataTab["LinesData"]

    --item 下标表
    local ResouceTab=dataTab["resultMatrix"]



    --    print("ResouceTab@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
    --
    --    U:debug(ResouceTab)
    --    print("ResouceTab@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")

    --匹配线路表
    local MatchRouteTab={}

    --匹配线路显示item个数表
    local MatchNumTab={}

    MatchRouteTab,MatchNumTab=Slot.animation:getTheTabs(dataTab)


    layerNode:setVisible(true)


    --确定每个cell的位置
    self.cellPositionTab=Slot.animation:getCellPosition(CellTab)

    --确定每个cell的图标
    local saveResourceTab=Slot.animation:getRearouceIndex(ResouceTab)
    local lineSprite= U:getSpriteByName("line1.png")
    local TOTAL_LENTH=lineSprite:getContentSize().width


    --匹配总线路
    local count=#MatchRouteTab
    print("count:"..count)
    print("#m_lineTab:"..#self.m_lineTab)

    self.ModuleName=moduleName


    --包含模块动作文件
    require ("modules."..self.ModuleName.."."..self.ModuleName.."Animation")

    --
    if count==0 then

        return

    end

    --确定主题名称 显示不同主题下的item


    --存储所有信息

    --m_PointArray 代表每条线路的点
    local m_PointArray={}

    local m_NewPointArray={}

    --m_MatchReouches 代表每条线路上匹配图标index
    local m_MatchResource={}

    --m_ActionArray 代表每条线路的动作序列
    local m_ActionArray={}

    --m_matchNumTab 代表每条线路的显示item的个数
    local m_matchNumTab={}



    --save ok
    m_PointArray,m_MatchResource,m_matchNumTab=Slot.animation:saveAllInformation(count,#NodeTab,MatchRouteTab,TotalRouteTab,MatchNumTab,self.cellPositionTab,saveResourceTab)

    --给m_PointArray添加向下的偏移量 修改每个坐标的位置

    m_NewPointArray=Slot.animation:changeThePosForDrawAll(m_PointArray,CellTab)

    m_ActionArray=Slot.animation:saveAllAction(m_NewPointArray,count,#NodeTab,TOTAL_LENTH,layerNode,NodeTab,CellTab,MatchNumTab,m_MatchResource)


    -- 第一步 先画线 但不显示
    local action1=cc.CallFunc:create(function ()

        layerNode:stopAllActions()

        local seq=cc.Sequence:create(m_ActionArray)
        layerNode:runAction(seq)


    end)



    local delay1=cc.DelayTime:create(1)

    local seq=cc.Sequence:create(delay1,action1,delay1)


    layerNode:runAction(seq)


end

-- 调用函数
Slot.animation.DrawLineOneByOne=function(self, CellTab,NodeTab,layerNode,dataTab,moduleName,type)

    U:addSpriteFrameResource("plist/common/common.plist")
    if type==nil then type="common" end

    --总路线表
    local TotalRouteTab=dataTab["LinesData"]

    --item 下标表
    local ResouceTab=dataTab["resultMatrix"]

    --匹配线路表
    local MatchRouteTab={}

    --匹配线路显示item个数表
    local MatchNumTab={}


    if type=="common" then

        MatchRouteTab,MatchNumTab=Slot.animation:getTheTabs(dataTab)
    else
        MatchRouteTab,MatchNumTab=Slot.animation:getTheTabs(dataTab,type)

    end



    layerNode:setVisible(true)


    --确定每个cell的位置
    self.cellPositionTab=Slot.animation:getCellPosition(CellTab)

    --确定每个cell的图标
    local saveResourceTab=Slot.animation:getRearouceIndex(ResouceTab)
    local lineSprite=U:getSpriteByName("line1.png")
    local TOTAL_LENTH=lineSprite:getContentSize().width


    --匹配总线路
    local count=#MatchRouteTab
    print("count:"..count)
    print("#m_lineTab:"..#self.m_lineTab)
    --


    --确定主题名称 显示不同主题下的item
    self.ModuleName=moduleName

    --存储所有信息

    --m_PointArray 代表每条线路的点
    local m_PointArray={}

    local m_NewPointArray={}

    --m_MatchReouches 代表每条线路上匹配图标index
    local m_MatchResource={}

    --m_ActionArray 代表每条线路的动作序列
    local m_ActionArray={}

    --m_matchNumTab 代表每条线路的显示item的个数
    local m_matchNumTab={}


    --save ok
    m_PointArray,m_MatchResource,m_matchNumTab=Slot.animation:saveAllInformation(count,#NodeTab,MatchRouteTab,TotalRouteTab,MatchNumTab,self.cellPositionTab,saveResourceTab)





    --第四步 永远重复执行画线动作 但这里要设置可见


    self.action4=cc.CallFunc:create(function ()

        self.isVisible=true
        self.isDrawAll=false

        if type=="bonus" then

            self.isDrawAll=true

        end




        --重新设置时间 重新存储动作
        self.DurationTime=0.1

        m_ActionArray=Slot.animation:saveAllAction(m_PointArray,count,#NodeTab,TOTAL_LENTH,layerNode,NodeTab,CellTab,MatchNumTab,m_MatchResource,type)


        local delayStand=cc.DelayTime:create(1)
        local seq=cc.Sequence:create(m_ActionArray)
        local doneCallBack = cc.CallFunc:create(function()
            layerNode:stopAllActions()

            --print("bonus+++++++++++=================")

            if type=="common" then



                layerNode:runAction(self.action4)

            end



        end)

        local action = {}
        table.insert(action, seq)
        table.insert(action, delayStand)
        table.insert(action, doneCallBack)
        local seq1=cc.Sequence:create(action)
        layerNode:runAction(seq1)


    end)


    self.action4:retain()

    local delayStand2=cc.DelayTime:create(0.2)

    local seq=cc.Sequence:create(delayStand2,self.action4)
    local repF=cc.Repeat:create(seq, 1)


    return repF


end

-- 调用函数
--普通画线
Slot.animation.DrawLineCommon=function(self,CellTab,NodeTab,layerNode,dataTab,moduleName)

--显示 隐藏 再重复单个画线

--    local layerMaskAction=cc.CallFunc:create(function ()
--
--        layerNode:setOpacity(110)
--
--    end)

    local action=Slot.animation:DrawLineOneByOne(CellTab,NodeTab,layerNode,dataTab,moduleName)

    return action

end

-- 调用函数
--scatter动画
Slot.animation.DrawLineScatter=function(self,CellTab,NodeTab,layerNode,dataTab,moduleName)


--scatter动画
    local scatterPostab=dataTab.scatterPos
    if #scatterPostab <= 0 then  return end


    local layerMaskAction=cc.CallFunc:create(function ()

        layerNode:setOpacity(0)

    end)

    local scatter_Action=cc.CallFunc:create(function()

        Slot.animation:scatterFreeSpinAction(scatterPostab,layerNode,CellTab,NodeTab)

    end)


    --local delay=cc.DelayTime:create(1)
    local seq=cc.Sequence:create(layerMaskAction,scatter_Action)

    return seq

end



-- 调用函数
--Bonus画线
Slot.animation.DrawLineBonus=function(self,CellTab,NodeTab,layerNode,dataTab,moduleName)


--只画bonus的线

    local layerMaskAction=cc.CallFunc:create(function ()

        layerNode:setOpacity(0)

    end)

    local action1=Slot.animation:DrawLineOneByOne(CellTab,NodeTab,layerNode,dataTab,moduleName,"bonus")



    --bonus图标动画

    local bonus_Action=cc.CallFunc:create(function()

        Slot.animation:bonusSmallGameAction(dataTab.bonusPos,layerNode,CellTab,NodeTab)

    end)


    local delay=cc.DelayTime:create(5)
    local seq=cc.Sequence:create(layerMaskAction,action1,bonus_Action)
    --local seq=cc.Sequence:create(layerMaskAction,scatter_Action)

    return seq

end


-- 调用函数
Slot.animation.DrawLineByType=function(self,Linetype,CellTab,NodeTab,layerNode,dataTab,moduleName,callBack)


    local actionCallBack=cc.CallFunc:create(function()



        if callBack and type(callBack)=="function" then

            callBack()

        end

    end)


    --local action1=Slot.animation:showAndHideAllLine(layerNode)

    local action2
    local seq

    if Linetype=="common" then

        --普通画线
        --        if not action1 then return end

        --如果没有线直接返回
        local payBackIdsTab=dataTab.payBackIds

        if #payBackIdsTab ==0 then

            return  layerNode:runAction(actionCallBack)
        end

        local layerMaskAction=cc.CallFunc:create(function ()

            --layerNode:setOpacity(110)

            layerNode:setOpacity(0)


        end)

        action2=Slot.animation:DrawLineCommon(CellTab,NodeTab,layerNode,dataTab,moduleName)
        --seq=cc.Sequence:create(action1, layerMaskAction,action2)

        seq=cc.Sequence:create(layerMaskAction, action2, actionCallBack)

    elseif Linetype=="scatter" then

        --Scatter画线＋scatter动画
        --print("Scatter==================================")
        local delay
        local scatterPostab=dataTab.scatterPos

        if #scatterPostab > 0 then
            delay=cc.DelayTime:create(3)

        end

        action2=Slot.animation:DrawLineScatter(CellTab,NodeTab,layerNode,dataTab,moduleName)

        --seq=cc.Sequence:create(action1, action2, delay,actionCallBack)

        --add 12.11
        seq=cc.Sequence:create(action2, delay,actionCallBack)

    elseif Linetype=="bonus" then

        --Bonus画线＋Bonus动画
        --print("Bonus==================================")

        action2=Slot.animation:DrawLineBonus(CellTab,NodeTab,layerNode,dataTab,moduleName)


        local delay=cc.DelayTime:create(3)
        --seq=cc.Sequence:create(action1, action2, delay, actionCallBack)

        --add 12.11
        seq=cc.Sequence:create(action2, delay, actionCallBack)


    end

    layerNode:runAction(seq)



end



-- ----------------------
--coin Animations
-- ----------------------

-- 基础函数
Slot.animation.CoinStandRotate=function(self,secs,isRepeat)

--local rote = cc.RotateBy:create(secs, cc.p(0, 720 * 4,0))
--local rote = cc.RotateBy:create(secs, cc.p(720 * 4, 0,0))
    local rote = cc.RotateBy:create(secs, cc.p(0,720 * 4,0))

    --local rote = cc.RotateBy:create(secs,360*2)

    local rep
    if isRepeat==true then

        rep=cc.RepeatForever:create(rote)

    else

        rep=cc.Repeat:create(rote,1)
    end

    return rep


end

-- 基础函数
Slot.animation.CoinScale=function(self,secs,scale)


    local scale=cc.ScaleTo:create(secs,scale)
    local ease=cc.EaseIn:create(scale,secs)
    local scaleBack=cc.ScaleTo:create(secs,1)
    local easeBack=cc.EaseOut:create(scaleBack,secs)
    --local seq=cc.Sequence:create(scale,scaleBack)
    local seq=cc.Sequence:create(ease,easeBack)

    return seq

end

-- 基础函数
Slot.animation.ShowSpinStar=function(self,fileName)

    local pStar=cc.ParticleSystemQuad:create(fileName)

    return pStar


end

--金币喷射

-- 11.21

-- 基础函数
--根据两个点确定移动方向
Slot.animation.getTargetDir=function(self,starPos,targetPos)

    local diff=cc.p(targetPos.x-starPos.x,targetPos.y-starPos.y)

    local dir
    if diff.x>=0 and diff.y>=0 then

        --第一象限
        dir=1

    elseif diff.x>=0 and diff.y<0 then
        --第二象限
        dir=2

    elseif diff.x<0 and diff.y<0 then
        --第三象限
        dir=3

    elseif diff.x<0 and diff.y>0 then
        --第四象限
        dir=4

    end

    return dir


end


-- 基础函数
Slot.animation.createRandomContrlPoint=function(self,startPoint,targetPoint,direction,distance)

--distance尽量小点 确保控制点都在相应的象限内
    if distance==nil then distance=20 end

    --math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
    local control_pointTab={}
    local diffX=math.abs(targetPoint.x-startPoint.x)
    local diffY=math.abs(targetPoint.y-startPoint.y)

    local num=math.random(1,10)
    local m=math.random(2,5)/2

    --print("createRandomContrlPoint$$$$$$")

    --print("m:"..m)
    --print("createRandomContrlPoint$$$$$")

    if direction==1 then




        --test 12.16
        --print("1===========================")
        control_pointTab[1]=cc.p(diffX/3-distance,0)
        control_pointTab[2]=cc.p(diffX/3-distance,0)


    elseif direction==2 then


        --向下要模拟抛物线 只选一条

        --print("@@@@@@@@@@@@@@@@@2")
        --12.04 test
        control_pointTab[1]=cc.p(diffX/3+distance,diffY/3+m*distance)
        --control_pointTab[2]=cc.p(diffX,-diffY)

        control_pointTab[2]=cc.p(diffX*2/3+distance,diffY)


    elseif direction==3 then

        --向下要模拟抛物线 只选一条


        --12.04 test
        control_pointTab[1]=cc.p(-diffX/3-distance,diffY/3+m*distance)

        control_pointTab[2]=cc.p(-diffX*2/3-distance,diffY)

    elseif direction==4 then


        --print("3===========================")
        control_pointTab[1]=cc.p(-diffX/3-distance,0)
        control_pointTab[2]=cc.p(-diffX/3-distance,0)


    end

    return control_pointTab

end

-- 基础函数
--返回贝塞尔结构体 这里只添加方向向上曲线  添加四条对称
Slot.animation.getTheBezir=function(self,startPos,targetPos,diffDistance)

    if diffDistance==nil then diffDistance=50 end

    local diffX=math.abs(targetPos.x-startPos.x)
    local diffY=math.abs(targetPos.y-startPos.y)

    local diff=cc.p(targetPos.x-startPos.x,targetPos.y-startPos.y)

    local Bezir

    local num=math.random(1,10)

    --先根据起始点和目标点确定方向

    local dir=Slot.animation:getTargetDir(startPos,targetPos)

    if dir==1 then

        if num>=5 then

            --print("++++++++++++++++++++++++++++++1")


            Bezir = {
                cc.p(0-2*diffDistance, diffY/6),
                cc.p(diffX+2*diffDistance, diffY/6),
                diff
            }

        else

            --print("++++++++++++++++++++++++++++++2")
            Bezir = {
                cc.p(0+2*diffDistance, diffY/6),
                cc.p(diffX-diffDistance, diffY/6),
                diff
            }

        end

    elseif dir==4 then

        --print("++++++++++++++++++++++++++++++3")
        Bezir = {
            cc.p(0-2*diffDistance, diffY/6),
            cc.p(-diffX+2*diffDistance, diffY/6),
            diff
        }

    end

    return Bezir


end


--标准是按世界坐标来计算 默认为对称S型曲线 1为对称 0为不对称
Slot.animation.CoinMoveToPosition=function(self,startPos,targetPoint,secs,isSymmetry,delayTime,diffDistance)

    if isSymmetry==nil then isSymmetry=0 end
    if delayTime==nil then delayTime=0 end
    if diffDistance==nil then diffDistance=80 end

    --local startPos=cc.p(node:getPositionX(),node:getPositionY())
    local diff=cc.p(targetPoint.x-startPos.x,targetPoint.y-startPos.y)
    local midPoint=cc.p((targetPoint.x+startPos.x)/2,(targetPoint.y+startPos.y)/2)

    local targetDir=Slot.animation:getTargetDir(startPos,targetPoint)
    local bezier

    --如果是对称型飞出
    if isSymmetry==1 then

        --这里添加四种飞行曲线

        bezier=Slot.animation:getTheBezir(startPos,targetPoint,diffDistance)

    elseif isSymmetry==0 then


        --随机产生两个控制点 如果目标点方向向下 控制点一个在上方 一个在下方 模拟抛物线
        local control_pointTab=Slot.animation:createRandomContrlPoint(startPos,targetPoint,targetDir,diffDistance)

        bezier = {
            control_pointTab[1],
            control_pointTab[2],
            diff
        }


    end

    --local bezierForward = cc.BezierBy:create(secs,bezier)
    local bezierForward = cc.BezierBy:create(secs,bezier)

    return bezierForward

end

-- 基础函数
--金币弹起
Slot.animation.coinBounceAction=function(self,height,secs)

    if secs==nil then secs=1 end
    if height==nil then height=50 end



    --test 12.04
    local jumpUp=cc.JumpBy:create(0.6,cc.p(0,0),height,1)

    local jumpUp1=cc.JumpBy:create(0.5,cc.p(0,0),height/3,1)
    local jumpUp2=cc.JumpBy:create(0.3,cc.p(0,0),height/6,1)

    local easeBounce=cc.EaseIn:create(jumpUp,0.6)
    local easeBounce1=cc.EaseIn:create(jumpUp1,0.5)
    local easeBounce2=cc.EaseIn:create(jumpUp2,0.3)

    local easeBouceBack=easeBounce1:reverse()
    local easeBouceBack1=easeBounce1:reverse()

    local seq=cc.Sequence:create(easeBounce,easeBounce1)
    return seq

end

-- 基础函数
--金币落地旋转 帧动画 默认回到初始帧
Slot.animation.coinRorateInLand=function(self,time,isOrgin)

    U:addSpriteFrameResource("plist/common/common.plist")

    if isOrgin==nil then isOrgin=true end
    if time==nil then time=1/50 end


    local animFrames={}
    for i=1,5 do

        local name=string.format("coin"..i..".png")
        local frame=U:getSpriteFrame(name)
        animFrames[i]=frame

    end

    local animation=cc.Animation:createWithSpriteFrames(animFrames,time)
    animation:setRestoreOriginalFrame(false)

    local actionCoin=cc.Animate:create(animation)

    return actionCoin

end




-- ----------------------
--experience Animations
-- ----------------------

-- 基础函数
Slot.animation.ExperenceAdd=function(self,startPoint,targetPoint,secs,delayTime)

    if secs==nil then secs=10 end
    if delayTime==nil then delayTime=0 end


    local midPos=cc.p((startPoint.x+targetPoint.x)/2,(startPoint.y+targetPoint.y)/2)

    local diff=cc.p(targetPoint.x-startPoint.x,targetPoint.y-startPoint.y)
    --local diff=cc.p(targetPoint.x-startPoint.x-60,targetPoint.y-startPoint.y)


    -- -800 600
    local bezier = {
        cc.p(150, 50),
        cc.p(-530,50),
        diff,
    }

    local scaleTab={0.4,0.6,0.8,1.0,0.8,0.6,1.0,0.5,0.6,0.8 }

    --local scaleTab={2,6,8,4 }

    local index= math.random(1,#scaleTab)

    --print("@@@@@@@index:"..index)

    local delay=cc.DelayTime:create(delayTime)
    local bezierForward = cc.BezierBy:create(secs, bezier)

    --local scale=cc.ScaleBy:create(secs, 0.5)
    local scale=cc.ScaleTo:create(secs, 0.5)

    --local scale=cc.ScaleBy:create(secs, scaleTab[index])

    local rotate=cc.RotateBy:create(1.5,360*2)

    local playMusicAction=cc.CallFunc:create(function()

    --添加音乐
        Slot.Audio:playEffect("sound/common/"..Slot.MusicResources["common"].expfly)

    end)

    local spa=cc.Spawn:create(bezierForward, scale,rotate,playMusicAction)



    --local scale=cc.ScaleBy:create(0.2,2.5)

    local scale=cc.ScaleTo:create(2,1.5)
    local ease= cc.EaseInOut:create(scale,2)


    local seq=cc.Sequence:create(delay,spa)

    return seq



end

-- 基础函数
Slot.animation.LiziMove=function(self,pathFile,parentNode,posTab,secs,delayTime)

    if secs==nil then secs=0.5 end
    if delayTime==nil then delayTime=0.5 end


    --print("type(parentNode):"..type(parentNode))

    local pStar = cc.ParticleSun:create()
    parentNode:addChild(pStar,100)


    pStar:setTexture(cc.Director:getInstance():getTextureCache():addImage("image/common/stars.png"))
    pStar:setEmissionRate(300)
    pStar:setStartSize(20)
    pStar:setStartSizeVar(5)
    pStar:setPosition(posTab[1])

    --pStar:setPosition(cc.p(50,100))
    pStar:setDuration(secs)
    pStar:setSpeed(15)
    pStar:setSpeedVar(10)
    pStar:setPositionType(cc.POSITION_TYPE_RELATIVE)
    pStar:setStartColor(cc.c4b(255,255,255,255))

    --设置角度
    pStar:setAngle(0)
    pStar:setAngleVar(360)

    --设置粒子开始的自旋转速度，开始自旋转速度的变化率
    pStar:setStartSpin(30)
    pStar:setStartSpinVar(60)


    local move=cc.MoveTo:create(secs,posTab[2])

    pStar:runAction(move)





end



-- 调用函数
Slot.animation.ExperenceFly=function(self,nodeTab,posTab,callBack)

    require "libs.Call_Animation"

    local seq=Slot.Call_Animation:ExperenceFly(nodeTab,posTab,callBack)

    return seq


end



-- ----------------------
--Expect Animations
-- ----------------------


Slot.animation.scheduleRepeatN=function(callback,delay,n)
    local delay = cc.DelayTime:create(delay)
    local sequence = cc.Sequence:create(delay, cc.CallFunc:create(callback))
    local action = cc.Repeat:create(sequence,n)
    return action

end


--修改被分割等份后 就得修改粒子总数 默认是宽4等份 高15等份 考虑到重合 right 3 up 14 left 3 totalNum=3+14+3=20

--
----总时间可以自己微调下 中间有停顿时间1.7秒 最好大于这个
--local totalTime=2
--
----单个粒子的持续时间
--local index=totalTime/totalNum
--
----持续时间
--local diffTime=3

Slot.animation.totalNum=22
Slot.animation.totalTime=2
Slot.animation.index=Slot.animation.totalTime/Slot.animation.totalNum
Slot.animation.diffTime=3

--基础函数
--封装一个函数传入一个位置 再该位置上产生粒子效果 生命周期暂时不考虑
Slot.animation.createParticleAtTwoPos=function(self,fileName,node,posTab,angleTab,isSpeed)

    if angleTab==nil  then angleTab={90,90} end
    if isSpeed==nil then isSpeed=true end


    --12.11创建一个表 存放粒子发射器
    self.ParticleTab=self.ParticleTab or {}

    --if totalNum<=0 then totalNum=20 end
    if self.totalNum<=0 then self.totalNum=22 end


    for i=1,2 do
        --local pSun = cc.ParticleFlower :create()
        local pSun = cc.ParticleSun :create()
        table.insert(self.ParticleTab,pSun)
        pSun:setTexture(cc.Director:getInstance():getTextureCache():addImage(fileName))

        pSun:setEmissionRate(50)
        --pSun:setTotalParticles(300)

        --pSun:setStartColor(cc.c4b(255,255,255,1))
        pSun:setAngle(angleTab[i])
        pSun:setAngleVar(0)
        pSun:setAutoRemoveOnFinish(true)

        --test 12.16
        pSun:setStartSize(30)


--        --pSun:setStartSize(2)
        pSun:setEndSize(30)

        --test 1.19
        pSun:setStartSpin(90)
        pSun:setStartSpinVar(90)
        if isSpeed then

            --12.12
            pSun:setSpeed(90)
        else
            pSun:setSpeed(55)

        end

        pSun:setSpeedVar(0)
        node:addChild(pSun)
        pSun:setPosition(posTab[i])
        pSun:setDuration(self.index*self.totalNum+self.diffTime)

    end


    self.totalNum=self.totalNum-1



end



--基础函数
Slot.animation.clearAllParticles=function(self)



    for i=1,#self.ParticleTab do

        if self.ParticleTab[i]~=nil then

            self.ParticleTab[i]:setDuration(0)

        end

    end


end

-- 调用函数
Slot.animation.ExpectAction=function(self,node,m,n)

    require "libs.Call_Animation"
    Slot.Call_Animation:ExpectAction(node,m,n)


--print("ExpectAction****************************")
end





-- ----------------------
--Reward Animations Big Win/ Huge Win / 5 of king Animations
-- ----------------------

--不同数量 显示不同效果  可以从金币飞行动画里拆分几个动作


--基础函数
Slot.animation.CoinFallDown=function(self,parenNode,secs,speed)

--if secs==nil then secs=3 end
    if secs==nil then secs=3 end
    if speed==nil then speed=600 end
    --if speed==nil then speed=33 end



    local pCoin=cc.ParticleSnow:create()

    pCoin:setEmissionRate(30)

    --不要设置zOrder
    parenNode:addChild(pCoin)
    pCoin:setTexture(cc.Director:getInstance():getTextureCache():addImage("image/common/coin_win.png"))

    --设置粒子总数
    pCoin:setTotalParticles(500)

    --设置重力
    --pCoin:setGravity(cc.p(0,-200))
    --pCoin:setGravity(cc.p(0,-200))

    --调整下落的速度
    pCoin:setSpeed(speed)
    pCoin:setSpeedVar(50)

    --下雪效果只持续5秒
    pCoin:setDuration(secs)


    pCoin:setStartSize(80)
    pCoin:setStartSizeVar(10)

    pCoin:setGravity(cc.p(0,-20))

    return pCoin



end

--基础函数
--big win
Slot.animation.WinText=function(self,isflag)
    if isflag==nil  then isflag=true end

    local textScale1=cc.ScaleBy:create(0.2,1.2)
    local textScale2=cc.ScaleBy:create(0.15,1.1)
    --local ease= cc.EaseIn:create(textScale,secs)

    --感觉有冲击力 EaseSineIn
    --    local ease1= cc.EaseExponentialOut:create(textScale1)
    --    local easeBack1=ease1:reverse()
    --
    --    local ease2= cc.EaseExponentialOut:create(textScale2)
    --    local easeBack2=ease2:reverse()


    local ease1= cc.EaseSineOut:create(textScale1)
    local easeBack1=ease1:reverse()

    local ease2= cc.EaseSineOut:create(textScale2)
    local easeBack2=ease2:reverse()

    --local ease= cc.EaseSineIn:create(textScale)

    --个人感觉这个蛮好
    --local ease= cc.EaseElasticIn:create(textScale)


    local delay
    if isflag then
        delay=cc.DelayTime:create(0.5)
    else
        delay=cc.DelayTime:create(0)
    end

    local rem=cc.RemoveSelf:create()
    --local seq=cc.Sequence:create(ease1,delay,easeBack1,ease2,easeBack2)
    local seq=cc.Sequence:create(delay,ease1,easeBack1,ease2,easeBack2)


    return seq

end

--基础函数
Slot.animation.WinStar=function(self,bigWinSprite,posTabR)

    U:addSpriteFrameResource("plist/common/game_common.plist")
    math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
    local count=#posTabR

    local startTab={}
    for i=1,count do


        local index=math.random(1,count)
        --print("lightAction$$$$$$index:"..index)
        local lightSprite=U:getSpriteByName("gold_star.png")
        bigWinSprite:addChild(lightSprite)

        lightSprite:setPosition(posTabR[index])

        --从小变大 同时渐隐 旋转


        local secs=0.2
        local scale=cc.ScaleBy:create(secs,2)
        local scaleBack=scale:reverse()


        local fade=cc.FadeIn:create(secs)
        local fadeBack=fade:reverse()
        local rotate=cc.RotateBy:create(secs,90)

        local seq1=cc.Sequence:create(scale,scaleBack)
        local seq2=cc.Sequence:create(fade,fadeBack)

        local reN1=cc.Repeat:create(seq1,10)
        local reN2=cc.Repeat:create(seq2,10)



        local delay=cc.DelayTime:create(i*0.2)


        local spa=cc.Spawn:create(reN1,reN2)

        local rem=cc.RemoveSelf:create()

        --local seq=cc.Sequence:create(delay,spa,rem)
        local seq=cc.Sequence:create(spa,rem)

        startTab[i]=lightSprite

        lightSprite:runAction(seq)

    end

    return startTab

end

--基础函数
Slot.animation.fireWork=function(self,parentNode,pos,secs)
    if secs==nil then secs=5 end

    local pFireWork=cc.ParticleSystemQuad:create("plist/common/fireWork.plist")
    parentNode:addChild(pFireWork,100)
    pFireWork:setPosition(pos)
    pFireWork:setDuration(secs)
    pFireWork:setAutoRemoveOnFinish(true)

    return pFireWork

end

--基础函数
Slot.animation.paperFallDown=function(self,parentNode,secs,speed)

    if secs==nil then secs=3 end
    if speed==nil then speed=300 end

    local PaperTab={}
    for i=1,7 do

        local Paper=cc.ParticleSnow:create()
        table.insert(PaperTab,Paper)

        --每秒发射2个 3秒的时间 产生6个
        Paper:setEmissionRate(2)

        --不要设置zOrder
        parentNode:addChild(Paper)
        Paper:setTexture(cc.Director:getInstance():getTextureCache():addImage("image/common/paper_"..i..".png"))

        --设置粒子总数
        --Paper:setTotalParticles(100)

        --设置重力
        --Paper:setGravity(cc.p(-4,0))
        --pCoin:setGravity(cc.p(0,-200))

        --调整下落的速度
        Paper:setSpeed(speed)
        Paper:setSpeedVar(10)

        --下雪效果只持续5秒
        Paper:setDuration(secs)


        Paper:setStartSize(30)
        Paper:setStartSizeVar(5)

        --Paper:setEndColor(cc.c4b(255,255,255,0))


    end

    return PaperTab




end


--基础函数
Slot.animation.ShowParticleByPlist=function(self,fileName)

    local Particle=cc.ParticleSystemQuad:create(fileName)

    return Particle

end



-- 调用函数
Slot.animation.winCoin=function(self,data,posTab,nodeTab,callbackTab,linetype)


    require "libs.Call_Animation"

    self.DataTab=data
    self.PosTab=posTab
    self.NodeTab=nodeTab
    self.CallbackTab=callbackTab
    self.LineType=linetype



    Slot.Call_Animation:winCoin(data,posTab,nodeTab,callbackTab,linetype,self.ModuleName)


end



Slot.animation.collectCoin=function(self,posTab,parentNode,callback,secs,delayTime)

    require "libs.Call_Animation"
    return Slot.Call_Animation:collectCoin(posTab,parentNode,callback,secs,delayTime)


end

-- ----------------------
-- --Reward Animations Big Win/ Huge Win / 5 of king Animations
-- ----------------------

--big win 两个文字图片 弹性放大缩小
--基础函数
Slot.animation.winTextScaleAction=function(self,scale,secs)

    if secs==nil then secs=1 end


    local textScale=cc.ScaleBy:create(secs,scale)
    --local ease= cc.EaseIn:create(textScale,secs)

    --感觉有冲击力 EaseSineIn
    --local ease= cc.EaseExponentialIn:create(textScale)


    --local ease= cc.EaseSineIn:create(textScale)

    --个人感觉这个蛮好
    local ease= cc.EaseElasticIn:create(textScale)

    local easeBack=ease:reverse()

    local seq=cc.Sequence:create(ease,easeBack)

    return seq


end


--level up Action
--基础函数
Slot.animation.levelUpFireWork=function(self,parentNode,posTab)

    local pFire1=Slot.animation:ShowParticleByPlist("plist/common/levelUp1.plist")
    local pFire2=Slot.animation:ShowParticleByPlist("plist/common/levelUp1.plist")


    local pos1=cc.p(posTab[1].x+math.random(-200,200),posTab[1].y+math.random(-200,200))
    local pos2=cc.p(posTab[2].x+math.random(-200,200),posTab[2].y+math.random(-200,200))

    parentNode:addChild(pFire1,100)
    parentNode:addChild(pFire2,100)
    pFire1:setPosition(pos1)
    pFire2:setPosition(pos2)

    --添加音乐
    Slot.Audio:playEffect("sound/common/"..Slot.MusicResources["common"].levelup_firework)

end


Slot.animation.colorfireWork=function(self,node,file)



    local width=node:getContentSize().width
    local height=node:getContentSize().height

    local pFire=Slot.animation:ShowParticleByPlist(file)
    local pos=cc.p(math.random(0,width),math.random(0,height))
    node:addChild(pFire,100)
    pFire:setPosition(pos)

    Slot.Audio:playEffect("sound/common/"..Slot.MusicResources["common"].levelup_firework)

    return pFire


end

-- 调用函数
Slot.animation.levelUpAction=function(self,nodeTab)

    require "libs.Call_Animation"
    Slot.Call_Animation:levelUpAction(nodeTab)


end



--scatter Action
--调用函数
Slot.animation.scaAction=function(self,itemSprite)


    require "libs.Call_Animation"
    local seq=Slot.Call_Animation:scaAction(itemSprite,self.ModuleName)
    return seq

end


--bonus Action
-- 调用函数
Slot.animation.bonAction=function(self,itemSprite)


    require "libs.Call_Animation"
    local seq=Slot.Call_Animation:bonAction(itemSprite,self.ModuleName)
    return seq


end

-- 调用函数
Slot.animation.bonusSmallGameAction=function(self,bonusPostab,parentNode,CellTab,nodeTab)


    --播放音乐

    U:addSpriteFrameResource("plist/common/common.plist")


    local count=#bonusPostab

    print("count:"..count)

    for i=1,count do

        local bgSprite
        local itemSprite
        local action
        local seq
        if self.ModuleName=="west" then


            bgSprite,itemSprite=Slot.west_animation:showSpecialItem(200)

        elseif self.ModuleName=="blackhand" then

            bgSprite,itemSprite=Slot.blackhand_animation:showSpecialItem(200)

        elseif self.ModuleName=="hawaii" then

            bgSprite,itemSprite=Slot.hawaii_animation:showSpecialItem(200)

        elseif self.ModuleName=="girl" then

            bgSprite,itemSprite=Slot.girl_animation:showSpecialItem(200)

        end

        --调用bonus动画
        local posTab=bonusPostab[i]

        local rowNum=posTab[1]
        local colNum=posTab[2]
        local nodePoint=self.cellPositionTab[colNum][rowNum]

        local worldPoint=Slot.animation:CovertToPoints(nodePoint,nodeTab,colNum,parentNode)


        bgSprite:setPosition(cc.p(worldPoint.x,worldPoint.y-self.cellheight))
        bgSprite:setVisible(true)
        parentNode:addChild(bgSprite,100)


        --添加框 add 1.23
        local border = U:getSpriteByName("border.png")
        --local border=cc.Sprite:create("image/modules/"..self.ModuleName.."/border.png")
        parentNode:addChild(border)
        --border:setPosition(cc.p(bgSprite:getContentSize().width/2,bgSprite:getContentSize().height/2))
        border:setPosition(bgSprite:getPosition())


        --执行动画
        action=Slot.animation:bonAction(itemSprite)


        local repN=cc.Repeat:create(action,3)
        parentNode:runAction(repN)


        --添加粒子移动


        --调用粒子移动方法

        local targetStartPos=cc.p(worldPoint.x,worldPoint.y-self.cellheight)


        Slot.animation:ParctiseMove("image/common/stars.png",CellTab[1][1],parentNode,targetStartPos,1)



    end


    --test
    require "libs.Call_Animation"
    Slot.Call_Animation:SpecialItemActionMusic({200},self.ModuleName)

end

-- 调用函数
Slot.animation.scatterFreeSpinAction=function(self,scatterPostab,parentNode,CellTab,nodeTab)

--



--print("scatterFreeSpinAction=================")
    local count=#scatterPostab

    for i=1,count do

        local bgSprite
        local itemSprite
        local action
        local seq
        if self.ModuleName=="west" then

            bgSprite,itemSprite=Slot.west_animation:showSpecialItem(100)

        elseif self.ModuleName=="blackhand" then

            bgSprite,itemSprite=Slot.blackhand_animation:showSpecialItem(100)

        elseif self.ModuleName=="hawaii" then

            bgSprite,itemSprite=Slot.hawaii_animation:showSpecialItem(100)

        elseif self.ModuleName=="girl" then

            bgSprite,itemSprite=Slot.girl_animation:showSpecialItem(100)

        end

        --调用scatter动画
        local posTab=scatterPostab[i]

        local rowNum=posTab[1]
        local colNum=posTab[2]
        local nodePoint=self.cellPositionTab[colNum][rowNum]

        local worldPoint=Slot.animation:CovertToPoints(nodePoint,nodeTab,colNum,parentNode)


        bgSprite:setPosition(cc.p(worldPoint.x,worldPoint.y-self.cellheight))
        bgSprite:setVisible(true)
        parentNode:addChild(bgSprite,10)

        --执行动画
        action=Slot.animation:scaAction(itemSprite,parentNode)

        local repN=cc.Repeat:create(action,3)
        parentNode:runAction(repN)


        --添加粒子移动


        --调用粒子移动方法

        local targetStartPos=cc.p(worldPoint.x,worldPoint.y-self.cellheight)


        Slot.animation:ParctiseMove("image/common/stars.png",CellTab[1][1],parentNode,targetStartPos,1)



    end


    --播放音乐
    require "libs.Call_Animation"

    Slot.Call_Animation:SpecialItemActionMusic({100},self.ModuleName)



end


--左右摇摆动作
Slot.animation.moveLeftAndRight=function(self,secs,distance,num)

    if secs==nil then secs=0.2 end
    if distance==nil then distance=5 end
    if num==nil then num=2 end

    local moveLeft=cc.MoveBy:create(secs,cc.p(-distance,0))
    local moveBack1=moveLeft:reverse()
    local moveRight=cc.MoveBy:create(secs,cc.p(distance,0))
    local moveBack2=moveRight:reverse()
    local seq=cc.Sequence:create(moveLeft,moveBack1,moveRight,moveBack2)
    local repN=cc.Repeat:create(seq,num)

    return repN
--node:runAction(repN)



end




Slot.animation.clearAll = function(self)


    self.m_lineTab={}
    self.isVisible=false
    self.isDrawAll=true
    self.DurationTime=0.001
    self.MatchItemTab={}
    self.MatchItemBorderTab={}
    self.cellPositionTab={}
    self.ParticleTab={}

    self.ModuleName = nil
end





















