--
-- Created by IntelliJ IDEA.
-- User: oas
-- Date: 14-12-21
-- Time: 下午5:46
-- To change this template use File | Settings | File Templates.
--
Slot.hawaii_animation = Slot.hawaii_animation or {}
Slot.hawaii_animation.specailItemIndex=Slot.SpecailItem.hawaii
Slot.hawaii_animation.moduleName="hawaii"

Slot.hawaii_animation.showSpecialItem=function(self,index)

    U:addSpriteFrameResource("plist/modules/hawaii/hawaii.plist")

    local bg_sprite
    local item_sprite

    if index==self.specailItemIndex[1] then

        bg_sprite,item_sprite=self:showSpecialItem_1()

    elseif index==self.specailItemIndex[2] then
        bg_sprite,item_sprite=self:showSpecialItem_2()

    elseif index==self.specailItemIndex[3] then
        bg_sprite,item_sprite=self:showSpecialItem_3()

    elseif index==self.specailItemIndex[4] then

        bg_sprite,item_sprite=self:showSpecialItem_50()

    elseif index==self.specailItemIndex[5] then

        bg_sprite,item_sprite=self:showSpecialItem_100()

    elseif index==self.specailItemIndex[6] then

        bg_sprite,item_sprite=self:showSpecialItem_200()

    end

    return bg_sprite,item_sprite

end

--女人
Slot.hawaii_animation.showSpecialItem_1=function(self,isVisible)

    if isVisible==nil then isVisible=false end

--这个贴图得换 浩哥给的就是整图 序列帧
--    local fileNameBg=string.format("image/modules/hawaii/1.png")
--    local fileNameWoman=string.format("image/modules/hawaii/1.png")
--    local bg_sprite=cc.Sprite:create(fileNameBg)
--
--
--    local item_sprite=cc.Sprite:create(fileNameWoman)


--    local bg_sprite= U:getSpriteByName(self.moduleName.."_1.png")
--    local item_sprite= U:getSpriteByName(self.moduleName.."_1.png")

    local bg_sprite= U:getSpriteByName("1.png")
    local item_sprite= U:getSpriteByName("1.png")

    bg_sprite:setVisible(isVisible)

    --给item精灵增加标签 好获取
    bg_sprite:addChild(item_sprite,30,self.specailItemIndex[1])

    item_sprite:setPosition(cc.p(bg_sprite:getContentSize().width/2,bg_sprite:getContentSize().height/2))
    --bg_sprite:setOpacity(0)

    return bg_sprite,item_sprite


end

Slot.hawaii_animation.showSpecialItem_2=function(self,isVisible)

--这个贴图得换 浩哥给的就是整图 序列帧


--    local fileNameBg=string.format("image/modules/hawaii/2.png")
--    local fileNameWoman=string.format("image/modules/hawaii/2.png")
--    local bg_sprite=cc.Sprite:create(fileNameBg)
--
--
--    local item_sprite=cc.Sprite:create(fileNameWoman)

--    local bg_sprite= U:getSpriteByName(self.moduleName.."_2.png")
--    local item_sprite= U:getSpriteByName(self.moduleName.."_2.png")

    local bg_sprite= U:getSpriteByName("2.png")
    local item_sprite= U:getSpriteByName("2.png")

    bg_sprite:setVisible(isVisible)

    --给item精灵增加标签 好获取
    bg_sprite:addChild(item_sprite,30,self.specailItemIndex[2])


    item_sprite:setPosition(cc.p(bg_sprite:getContentSize().width/2,bg_sprite:getContentSize().height/2))

    return bg_sprite,item_sprite

end

Slot.hawaii_animation.showSpecialItem_3=function(self,isVisible)

--这个贴图得换 浩哥给的就是整图 序列帧

--    local fileNameBg=string.format("image/modules/hawaii/3.png")
--    local fileNameWoman=string.format("image/modules/hawaii/3_1.png")
--    local bg_sprite=cc.Sprite:create(fileNameBg)
--
--
--    local item_sprite=cc.Sprite:create(fileNameWoman)

--    local bg_sprite= U:getSpriteByName(self.moduleName.."_3.png")
--    local item_sprite= U:getSpriteByName(self.moduleName.."_3_1.png")


    local bg_sprite= U:getSpriteByName("3.png")
    local item_sprite= U:getSpriteByName("3_1.png")

    bg_sprite:setVisible(isVisible)

    --给item精灵增加标签 好获取
    bg_sprite:addChild(item_sprite,30,self.specailItemIndex[3])


    item_sprite:setPosition(cc.p(bg_sprite:getContentSize().width/2+1.7,3))

    return bg_sprite,item_sprite



end

Slot.hawaii_animation.showSpecialItem_50=function(self,isVisible)


--    local fileNameBg=string.format("image/modules/hawaii/50_bg.png")
--    local fileNameWild=string.format("image/modules/hawaii/50_wild.png")
--
--    local bg_sprite=cc.Sprite:create(fileNameBg)
--    local item_sprite=cc.Sprite:create(fileNameWild)

--    local bg_sprite= U:getSpriteByName(self.moduleName.."_50_bg.png")
--    local item_sprite= U:getSpriteByName(self.moduleName.."_50_wild.png")

    local bg_sprite= U:getSpriteByName("50_bg.png")
    local item_sprite= U:getSpriteByName("50_wild.png")

    bg_sprite:setVisible(isVisible)

    bg_sprite:addChild(item_sprite,30,self.specailItemIndex[4])

    --这个就是调整位置吧
    item_sprite:setPosition(cc.p(bg_sprite:getContentSize().width/2+0.3,62))
    return bg_sprite,item_sprite

end

Slot.hawaii_animation.showSpecialItem_100=function(self,isVisible)


--    local fileNameBg=string.format("image/modules/hawaii/100_bg.png")
--    local fileNameScatter=string.format("image/modules/hawaii/100_scatter.png")
--
--    local bg_sprite=cc.Sprite:create(fileNameBg)
--    local item_sprite=cc.Sprite:create(fileNameScatter)


--    local bg_sprite= U:getSpriteByName(self.moduleName.."_100_bg.png")
--    local item_sprite= U:getSpriteByName(self.moduleName.."_100_scatter.png")


    local bg_sprite= U:getSpriteByName("100_bg.png")
    local item_sprite= U:getSpriteByName("100_scatter.png")

    bg_sprite:setVisible(isVisible)

    bg_sprite:addChild(item_sprite,30,self.specailItemIndex[5])

    --这个就是调整位置吧
    item_sprite:setPosition(cc.p(bg_sprite:getContentSize().width/2,55))
    return bg_sprite,item_sprite

end

Slot.hawaii_animation.showSpecialItem_200=function(self,isVisible)


--    local fileNameBg=string.format("image/modules/hawaii/200_bg.png")
--    local fileNameBonus=string.format("image/modules/hawaii/200_bonus.png")
--
--    local bg_sprite=cc.Sprite:create(fileNameBg)
--    local item_sprite=cc.Sprite:create(fileNameBonus)

--    local bg_sprite= U:getSpriteByName(self.moduleName.."_200_bg.png")
--    local item_sprite= U:getSpriteByName(self.moduleName.."_200_bonus.png")

    local bg_sprite= U:getSpriteByName("200_bg.png")
    local item_sprite= U:getSpriteByName("200_bonus.png")

    bg_sprite:setVisible(isVisible)

    bg_sprite:addChild(item_sprite,30,self.specailItemIndex[6])

    --这个就是调整位置吧
    item_sprite:setPosition(cc.p(bg_sprite:getContentSize().width/2+1.5,54))
    return bg_sprite,item_sprite

end



-- --------------------------------------------------------------------------
-- Actions
-- --------------------------------------------------------------------------

Slot.hawaii_animation.showSpecialItemActions=function(self,index,itemSprite,parentNode)



    if index==self.specailItemIndex[1] then

        self:SpecialItem_1_Action(itemSprite)

    elseif index==self.specailItemIndex[2] then
        self:SpecialItem_2_Action(itemSprite)

    elseif index==self.specailItemIndex[3] then
        self:SpecialItem_3_Action(itemSprite,parentNode)

    elseif index==self.specailItemIndex[4] then

        self:SpecialItem_50_Action(itemSprite)

    elseif index==self.specailItemIndex[5] then

        self:SpecialItem_100_Action(itemSprite,parentNode)

    elseif index==self.specailItemIndex[6] then

        self:SpecialItem_200_Action(itemSprite)

    end


end

Slot.hawaii_animation.SpecialItem_1_Action=function(self,itemSprite,time,isOrgin)


    if time==nil then time=2/14.8 end
    if isOrgin==nil then isOrgin=true end


    -- -------------------------------------
--    local eyenimation=cc.Animation:create()
--    local number,name
--    for i=1,2 do
--        name=string.format("image/modules/hawaii/1_"..i..".png")
--        eyenimation:addSpriteFrameWithFile(name)
--
--    end
--    eyenimation:setDelayPerUnit(time)
--
--    --设置为false 停止到最后一帧
--    eyenimation:setRestoreOriginalFrame(isOrgin)
--    local eyeAction=cc.Animate:create(eyenimation)


    local animFrames={}
    for i=1,2 do
        --local name=string.format(self.moduleName.."_1_"..i..".png")

        local name=string.format("1_"..i..".png")
        local frame=U:getSpriteFrame(name)
        animFrames[i]=frame

    end

    local animation=cc.Animation:createWithSpriteFrames(animFrames,time)
    animation:setRestoreOriginalFrame(isOrgin)
    local eyeAction=cc.Animate:create(animation)


    local repN=cc.Repeat:create(eyeAction,2)
    --local repN=cc.RepeatForever:create(womanAction)
    --local seq=cc.Sequence:create(womanAction,ey)

    itemSprite:runAction(repN)




end


Slot.hawaii_animation.SpecialItem_2_Action=function(self,itemSprite,time,isOrgin)


    if time==nil then time=4/14.8 end
    if isOrgin==nil then isOrgin=true end


    -- -------------------------------------
--    local eyenimation=cc.Animation:create()
--    local number,name
--    for i=1,2 do
--        name=string.format("image/modules/hawaii/2_"..i..".png")
--        eyenimation:addSpriteFrameWithFile(name)
--
--    end
--    eyenimation:setDelayPerUnit(time)
--
--    --设置为false 停止到最后一帧
--    eyenimation:setRestoreOriginalFrame(isOrgin)
--    local eyeAction=cc.Animate:create(eyenimation)


    local animFrames={}
    for i=1,2 do
        --local name=string.format(self.moduleName.."_2_"..i..".png")

        local name=string.format("2_"..i..".png")
        local frame=U:getSpriteFrame(name)
        animFrames[i]=frame

    end

    local animation=cc.Animation:createWithSpriteFrames(animFrames,time)
    animation:setRestoreOriginalFrame(isOrgin)
    local eyeAction=cc.Animate:create(animation)


    local repN=cc.Repeat:create(eyeAction,1)

    itemSprite:runAction(repN)




end


Slot.hawaii_animation.SpecialItem_3_Action=function(self,itemSprite,parentNode)


    itemSprite:setVisible(false)

    local timeTab={1,0.9,1,1.5,0.8,2,3,2.2,0.8,0.6 }
    local count=#timeTab
    math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
    for i=1,24 do

        --math.randomseed(os.time()*10)
        local index=i%5
        if index==0 then index=1 end
--        local fileName=string.format("image/modules/hawaii/3_"..index..".png")
--
--
--        local bubble=cc.Sprite:create(fileName)
        --local bubble=U:getSpriteByName(self.moduleName.."_3_"..index..".png")
        local bubble=U:getSpriteByName("3_"..index..".png")
        parentNode:addChild(bubble)
        local width=parentNode:getContentSize().width
        local height=parentNode:getContentSize().height

        bubble:setPosition(cc.p(math.random(3,width-10),math.random(0,height/5)))

        local timeIndex=math.random(1,count)
        local move=cc.MoveBy:create(timeTab[timeIndex],cc.p(0,parentNode:getContentSize().height*4/5))
        local rem=cc.RemoveSelf:create()
        local seq=cc.Sequence:create(move,rem)
        bubble:runAction(seq)


    end







end

Slot.hawaii_animation.SpecialItem_50_Action=function(self,itemSprite,secs)

    if secs==nil then secs=0.25 end


    local textScale1=cc.ScaleBy:create(0.2,1.2)
    local textScale2=cc.ScaleBy:create(0.15,1.1)



    local ease1= cc.EaseSineOut:create(textScale1)
    local easeBack1=ease1:reverse()

    local ease2= cc.EaseSineOut:create(textScale2)
    local easeBack2=ease2:reverse()


    local delay=cc.DelayTime:create(0.5)

    --local seq=cc.Sequence:create(ease1,delay,easeBack1,ease2,easeBack2)
    local seq=cc.Sequence:create(delay,ease1,easeBack1,ease2,easeBack2)


    --修改传入位置表格  12.10

    local posTab={
        cc.p(130,20), cc.p(90,60),cc.p(135,63),cc.p(208,70),
        cc.p(68,50),cc.p(82,55),cc.p(205,83),cc.p(44,63),
        cc.p(173,73), cc.p(56,80), cc.p(79,53), cc.p(59,33),cc.p(199,33)

    }
    --在字上添加发光粒子效果
    Slot.animation:lightAction(itemSprite,posTab)

    itemSprite:runAction(seq)



end


Slot.hawaii_animation.SpecialItem_100_Action=function(self,itemSprite,parentNode,secs)

    if secs==nil then secs=0.25 end


    local textScale1=cc.ScaleBy:create(0.2,1.2)
    local textScale2=cc.ScaleBy:create(0.15,1.1)



    local ease1= cc.EaseSineOut:create(textScale1)
    local easeBack1=ease1:reverse()

    local ease2= cc.EaseSineOut:create(textScale2)
    local easeBack2=ease2:reverse()


    local delay=cc.DelayTime:create(0.5)

    --local seq=cc.Sequence:create(ease1,delay,easeBack1,ease2,easeBack2)
    local seq=cc.Sequence:create(delay,ease1,easeBack1,ease2,easeBack2)


    --修改传入位置表格 12.10

    local posTab={
        cc.p(130,20), cc.p(90,60),cc.p(135,63),cc.p(208,70),
        cc.p(68,50),cc.p(82,55),cc.p(205,73),cc.p(44,63),
        cc.p(173,73), cc.p(56,75), cc.p(79,53), cc.p(59,33),cc.p(199,33)

    }
    --在字上添加发光粒子效果
    Slot.animation:lightAction(itemSprite,posTab)


    --添加音符动作

    local timeTab={2,1.9,2.3,2.5,2.8,2,3,2.2,2.8,2.6 }
    local count=#timeTab
    math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
    for i=1,6 do

        --math.randomseed(os.time()*10)
        local index=i%4
        if index==0 then index=1 end

--        local fileName=string.format("image/modules/hawaii/100_"..index..".png")
--        --local fileName=string.format("modules/hawaii/3_4.png")
--
--        local bubble=cc.Sprite:create(fileName)

        --local bubble=U:getSpriteByName(self.moduleName.."_100_"..index..".png")
        local bubble=U:getSpriteByName("100_"..index..".png")
        parentNode:addChild(bubble,10)
        bubble:setScale(0.5)
        local width=parentNode:getContentSize().width
        local height=parentNode:getContentSize().height

        bubble:setPosition(cc.p(math.random(width/6,width*5/6),30))

        local timeIndex=math.random(1,count)
        local rem=cc.RemoveSelf:create()


        local startPos=cc.p(bubble:getPositionX(),bubble:getPositionY())
        local targetPoint=cc.p(startPos.x,startPos.y+parentNode:getContentSize().height-10)

        local bezir=Slot.animation:CoinMoveToPosition(startPos,targetPoint,timeTab[timeIndex],1,0,20)

        local delay=cc.DelayTime:create(i*0.05)
        local seq=cc.Sequence:create(delay,bezir,rem)

        bubble:runAction(seq)

    end



    itemSprite:runAction(seq)


end


Slot.hawaii_animation.SpecialItem_200_Action=function(self,itemSprite,secs)

    if secs==nil then secs=0.25 end


    local textScale1=cc.ScaleBy:create(0.2,1.2)
    local textScale2=cc.ScaleBy:create(0.15,1.1)



    local ease1= cc.EaseSineOut:create(textScale1)
    local easeBack1=ease1:reverse()

    local ease2= cc.EaseSineOut:create(textScale2)
    local easeBack2=ease2:reverse()


    local delay=cc.DelayTime:create(0.5)

    --local seq=cc.Sequence:create(ease1,delay,easeBack1,ease2,easeBack2)
    local seq=cc.Sequence:create(delay,ease1,easeBack1,ease2,easeBack2)


    --修改传入位置表格

    local posTab={
        cc.p(130,20), cc.p(90,60),cc.p(135,63),cc.p(208,70),
        cc.p(68,50),cc.p(82,55),cc.p(205,73),cc.p(44,63),
        cc.p(173,73), cc.p(56,70), cc.p(79,53), cc.p(59,33),cc.p(199,33)

    }
    --在字上添加发光粒子效果
    Slot.animation:lightAction(itemSprite,posTab)

    itemSprite:runAction(seq)



end


-- -----------------------------------------------------------------------------
--hawaii 主题动画 add 12.26
-- -----------------------------------------------------------------------------

Slot.hawaii_animation.getTreeAndYezi=function(self,parentNode)
--先存储所有节点
    local treeTab={}
    local yeziTab={}

--    for i=1,2 do
--
--        local treeName="hawaii_tree"..i
--        local treeSprite=parentNode.proxy:getNodeWithName(treeName)
--        table.insert(treeTab,treeSprite)
--
--    end

    for i=1,3 do

        local yeziName="hawaii_yezi"..i
        local yeziSprite=parentNode.proxy:getNodeWithName(yeziName)
        table.insert(yeziTab,yeziSprite)

    end

    --return treeTab,yeziTab
    return yeziTab

end

Slot.hawaii_animation.isRepeat=function(self,tab,index)


    if tab[index]==0 then

        return true
    else
        return false

    end


end

Slot.hawaii_animation.hawaiiModuleAction=function(self,yeziNodeTab,index,callback)

    --先存储所有节点
--    local treeTab={}
--    local yeziTab={}
    --local repeatTab={1,1,1}

   -- treeTab,yeziTab=self:getTreeAndYezi(parentNode)

    --math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
--    --树叶动
--    local treeId=math.random(1,2)
--    local treeSprite=treeTab[treeId]
--    local treeAction=Slot.animation:moveLeftAndRight()
--
--    local ease=cc.EaseInOut:create(treeAction,2)
--    treeSprite:runAction(ease)
--    --Slot.animationmoveLeftAndRight=function(self,node,secs,distance,num)

    --椰子动

    if self.yeziModeDownNum>=3 then return end

    local isRepeat= self:isRepeat(self.yeziRepeatTab,index)

    while  isRepeat do
        index=math.random(1,3)
        isRepeat= self:isRepeat(self.yeziRepeatTab,index)
    end

    print("index===========:"..index)
    local yeziSprite=yeziNodeTab[index]
    self.yeziRepeatTab[index]=0

    
    local winsize = cc.Director:getInstance():getWinSize()
    local yeziMove=Slot.animation:moveLeftAndRight()
    local yeziModeDown=cc.MoveBy:create(1,cc.p(0,-winsize.height))
    local rem=cc.RemoveSelf:create()
    local yeziAction=cc.Sequence:create(yeziMove,yeziModeDown,rem)
    yeziSprite:runAction(yeziAction)
    --椰子落下
    self.yeziModeDownNum=self.yeziModeDownNum+1

    if callback and type(callback)=="function" then

        callback()
    end


end

Slot.hawaii_animation.resertAllData=function(self)
    self.yeziRepeatTab={1,1,1 }
    self.yeziModeDownNum=0

end


--播放特殊图表音乐
Slot.hawaii_animation.hawaiiSpecailItemMusic = function(self,index)



    if index==self.specailItemIndex[1] then

        Slot.Audio:playEffect("sound/modules/hawaii/"..Slot.MusicResources["hawaii"].hawaii_icon1)

    elseif index==self.specailItemIndex[2] then

        Slot.Audio:playEffect("sound/modules/hawaii/"..Slot.MusicResources["hawaii"].hawaii_icon2)

    elseif index==self.specailItemIndex[3] then

        Slot.Audio:playEffect("sound/modules/hawaii/"..Slot.MusicResources["hawaii"].hawaii_icon3)

    elseif index==self.specailItemIndex[4] then

        Slot.Audio:playEffect("sound/modules/hawaii/"..Slot.MusicResources["hawaii"].hawaii_wild)

    elseif index==self.specailItemIndex[5] then

        Slot.Audio:playEffect("sound/modules/hawaii/"..Slot.MusicResources["hawaii"].hawaii_scatter)

    elseif index==self.specailItemIndex[6] then

        Slot.Audio:playEffect("sound/modules/hawaii/"..Slot.MusicResources["hawaii"].hawaii_bonus)

    end

end

Slot.hawaii_animation.isHaveTargetIndex=function(self,index)

    for k,v in pairs(self.specailTagTab) do

        if index==v then

            return true
        end

    end

    return false

end


Slot.hawaii_animation.getHawaiiPriorityTag=function(self,specailTagTab)

    self.specailTagTab=specailTagTab

    if self:isHaveTargetIndex(self.specailItemIndex[1]) then

        return self.specailItemIndex[1]
    elseif self:isHaveTargetIndex(self.specailItemIndex[2]) then

        return self.specailItemIndex[2]

    elseif self:isHaveTargetIndex(self.specailItemIndex[3]) then

        return self.specailItemIndex[3]

    end


end






