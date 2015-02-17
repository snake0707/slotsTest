--
-- Created by IntelliJ IDEA.
-- User: oas
-- Date: 14-12-21
-- Time: 下午5:19
-- To change this template use File | Settings | File Templates.
--

Slot.girl_animation = Slot.girl_animation or {}


Slot.girl_animation.specailItemIndex=Slot.SpecailItem.girl

Slot.girl_animation.moduleName="girl"
--
Slot.girl_animation.showSpecialItem=function(self,index)

    U:addSpriteFrameResource("plist/modules/girl/girl.plist")

    local bg_sprite
    local item_sprite

    if index==self.specailItemIndex[1] then

        bg_sprite,item_sprite=self:showSpecialItem_1()

    elseif index==self.specailItemIndex[2] then
        bg_sprite,item_sprite=self:showSpecialItem_2()

    elseif index==self.specailItemIndex[3] then
        bg_sprite,item_sprite=self:showSpecialItem_50()

    elseif index==self.specailItemIndex[4] then

        bg_sprite,item_sprite=self:showSpecialItem_100()

    elseif index==self.specailItemIndex[5] then

        bg_sprite,item_sprite=self:showSpecialItem_200()

    end

    return bg_sprite,item_sprite

end


--女人
Slot.girl_animation.showSpecialItem_1=function(self,isVisible)

    if isVisible==nil then isVisible=false  end

--这个贴图得换 浩哥给的就是整图 序列帧
--    local fileNameBg=string.format("image/modules/girl/1.png")
--    local fileNameWoman=string.format("image/modules/girl/1.png")
--    local bg_sprite=cc.Sprite:create(fileNameBg)
--
--
--    local item_sprite=cc.Sprite:create(fileNameWoman)
--
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

Slot.girl_animation.showSpecialItem_2=function(self,isVisible)

--这个贴图得换 浩哥给的就是整图 序列帧
    if isVisible==nil then isVisible=false end


--    local fileNameBg=string.format("image/modules/girl/2.png")
--    local fileNameWoman=string.format("image/modules/girl/2.png")
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



Slot.girl_animation.showSpecialItem_50=function(self,isVisible)

    if isVisible==nil then isVisible=false end

--    local fileNameBg=string.format("image/modules/girl/50_bg.png")
--    local fileNameWild=string.format("image/modules/girl/50_wild.png")
--
--    local bg_sprite=cc.Sprite:create(fileNameBg)
--    local item_sprite=cc.Sprite:create(fileNameWild)


--    local bg_sprite= U:getSpriteByName(self.moduleName.."_50_bg.png")
--    local item_sprite= U:getSpriteByName(self.moduleName.."_50_wild.png")

    local bg_sprite= U:getSpriteByName("50_bg.png")
    local item_sprite= U:getSpriteByName("50_wild.png")

    bg_sprite:setVisible(isVisible)

    bg_sprite:addChild(item_sprite,30,self.specailItemIndex[3])

    --这个就是调整位置吧
    item_sprite:setPosition(cc.p(bg_sprite:getContentSize().width/2+2.5,60.5))
    return bg_sprite,item_sprite

end

Slot.girl_animation.showSpecialItem_100=function(self,isVisible)

    if isVisible==nil then isVisible=false end

--    local fileNameBg=string.format("image/modules/girl/100_bg.png")
--    local fileNameScatter=string.format("image/modules/girl/100_scatter.png")
--
--    local bg_sprite=cc.Sprite:create(fileNameBg)
--    local item_sprite=cc.Sprite:create(fileNameScatter)

--    local bg_sprite= U:getSpriteByName(self.moduleName.."_100_bg.png")
--    local item_sprite= U:getSpriteByName(self.moduleName.."_100_scatter.png")

    local bg_sprite= U:getSpriteByName("100_bg.png")
    local item_sprite= U:getSpriteByName("100_scatter.png")

    bg_sprite:setVisible(isVisible)

    bg_sprite:addChild(item_sprite,30,self.specailItemIndex[4])

    --这个就是调整位置吧
    item_sprite:setPosition(cc.p(bg_sprite:getContentSize().width/2+1,59.5))
    return bg_sprite,item_sprite

end

Slot.girl_animation.showSpecialItem_200=function(self,isVisible)

    if isVisible==nil then isVisible=false end

--    local fileNameBg=string.format("image/modules/girl/200_bg.png")
--    local fileNameBonus=string.format("image/modules/girl/200_bonus.png")
--
--    local bg_sprite=cc.Sprite:create(fileNameBg)
--    local item_sprite=cc.Sprite:create(fileNameBonus)


--    local bg_sprite= U:getSpriteByName(self.moduleName.."_200_bg.png")
--    local item_sprite= U:getSpriteByName(self.moduleName.."_200_bonus.png")

    local bg_sprite= U:getSpriteByName("200_bg.png")
    local item_sprite= U:getSpriteByName("200_bonus.png")


    bg_sprite:setVisible(isVisible)

    bg_sprite:addChild(item_sprite,30,self.specailItemIndex[5])

    --这个就是调整位置吧
    item_sprite:setPosition(cc.p(bg_sprite:getContentSize().width/2-2.5,54))
    return bg_sprite,item_sprite

end



-- --------------------------------------------------------------------------
-- Actions
-- --------------------------------------------------------------------------

Slot.girl_animation.showSpecialItemActions=function(self,index,itemSprite,parentNode)



    if index==self.specailItemIndex[1] then

        self:SpecialItem_1_Action(itemSprite)

    elseif index==self.specailItemIndex[2] then

        self:SpecialItem_2_Action(itemSprite,parentNode)

    elseif index==self.specailItemIndex[3] then
        self:SpecialItem_50_Action(itemSprite)

    elseif index==self.specailItemIndex[4] then

        self:SpecialItem_100_Action(itemSprite)

    elseif index==self.specailItemIndex[5] then

        self:SpecialItem_200_Action(itemSprite)

    end


end


Slot.girl_animation.SpecialItem_1_Action=function(self,itemSprite,time,isOrgin)


    if time==nil then time=1/14.8 end
    if isOrgin==nil then isOrgin=true end


    -- -------------------------------------
--    local eyenimation=cc.Animation:create()
    --    local number,name
    --    for i=1,2 do
    --        name=string.format("image/modules/girl/1_"..i..".png")
    --        eyenimation:addSpriteFrameWithFile(name)
    --
    --    end
    --    eyenimation:setDelayPerUnit(0.5)
    --
    --    --设置为false 停止到最后一帧
    --    eyenimation:setRestoreOriginalFrame(isOrgin)

    --眨眼动作
    local animFrames={}
    for i=1,2 do
        --local name=string.format(self.moduleName.."_1_"..i..".png")
        local name=string.format("1_"..i..".png")
        local frame=U:getSpriteFrame(name)
        animFrames[i]=frame

    end

    local eyenimation=cc.Animation:createWithSpriteFrames(animFrames,0.5)
    eyenimation:setRestoreOriginalFrame(isOrgin)

    local eyeAction=cc.Animate:create(eyenimation)

    local repN=cc.Repeat:create(eyeAction,2)

    itemSprite:runAction(repN)




end


Slot.girl_animation.SpecialItem_2_Action=function(self,itemSprite,parentNode)



    itemSprite:setVisible(false)

    local timeTab={1,0.9,1,1.5,0.8,2,3,2.2,0.8,0.6 }
    local count=#timeTab
    math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))

    for i=1,18 do

        local index=i%4
        if index==0 then index=1 end


        --local fileName=string.format("image/modules/girl/2_"..index..".png")


        --local bubble=cc.Sprite:create(fileName)
        --local bubble=U:getSpriteByName(self.moduleName.."_2_"..index..".png")
        local bubble=U:getSpriteByName("2_"..index..".png")

        parentNode:addChild(bubble)

        local width=parentNode:getContentSize().width
        local height=parentNode:getContentSize().height

        local timeIndex=math.random(1,count)
        bubble:setPosition(cc.p(math.random(3,width),math.random(height*4/5,height)))

        local move=cc.MoveBy:create(timeTab[timeIndex],cc.p(0,-parentNode:getContentSize().height+15))
        local rem=cc.RemoveSelf:create()
        local seq=cc.Sequence:create(move,rem)
        bubble:runAction(seq)


    end

    --添加音乐 2015 1.04  test ok
--    Slot.Audio:playEffect("sound/girl/"..Slot.MusicResources["girl"].girl_icon2)


end


Slot.girl_animation.SpecialItem_50_Action=function(self,itemSprite,secs)

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

    --添加音乐 2015 1.04  test ok
--    Slot.Audio:playEffect("sound/girl/"..Slot.MusicResources["girl"].girl_wild)


end


Slot.girl_animation.SpecialItem_100_Action=function(self,itemSprite,secs)

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
        cc.p(173,73), cc.p(56,70), cc.p(79,53), cc.p(59,33),cc.p(199,33)

    }
    --在字上添加发光粒子效果
    Slot.animation:lightAction(itemSprite,posTab)

    itemSprite:runAction(seq)

    --添加音乐 2015 1.04  test ok
--    Slot.Audio:playEffect("sound/girl/"..Slot.MusicResources["girl"].girl_scatter)

end


Slot.girl_animation.SpecialItem_200_Action=function(self,itemSprite,secs)

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
        cc.p(68,50),cc.p(82,55),cc.p(205,78),cc.p(44,63),
        cc.p(173,73), cc.p(56,75), cc.p(79,53), cc.p(59,33),cc.p(199,33)

    }
    --在字上添加发光粒子效果
    Slot.animation:lightAction(itemSprite,posTab)

    itemSprite:runAction(seq)

    --添加音乐 2015 1.04  test ok
--    Slot.Audio:playEffect("sound/girl/"..Slot.MusicResources["girl"].girl_bonus)

end


-- -----------------------------------------------------------------------------
--girl 主题动画 add 12.18
-- -----------------------------------------------------------------------------

--基础函数
Slot.girl_animation.cameoRotate = function(self,cameoTab,secs)

    if secs==nil then secs=2 end

--    local count1=#cameoTab1
--    local count2=#cameoTab2
--
--    for i=1,count1 do
--
--        local rotateAction1=cc.RotateBy:create(secs,360*6)
--        local rotateAction2=cc.RotateBy:create(secs,360*6)
--        local delay=cc.DelayTime:create(0.05*i)
--        local seq1=cc.Sequence:create(delay,rotateAction1)
--        local seq2=cc.Sequence:create(delay,rotateAction2)
--
--        cameoTab1[i]:runAction(seq1)
--        cameoTab2[i]:runAction(seq2)
--
--    end

    --添加闪光
    for i=1,#cameoTab do

        local posTab={
            cc.p(10,20), cc.p(20,30),cc.p(5,5),cc.p(15,10),
            cc.p(20,10),cc.p(33,20),cc.p(35,23),cc.p(21,43),


        }
        --在字上添加发光粒子效果
        Slot.animation:lightAction(cameoTab[i],posTab,0.6,0.25,true,5)


    end





end


Slot.girl_animation.girlModuleAction = function(self,slotManager,callback,secs)

    print("girlModuleAction=========================")
    if secs==nil then secs=2 end

    local layerColorMask = slotManager.layerColorMask

    local width=layerColorMask:getContentSize().width
    local height=layerColorMask:getContentSize().height
    local targetStartPos=cc.p(width/2,height/2)

    local cameoNode=slotManager.proxy:getNodeWithName("cameo_node")

    local count=#cameoNode:getChildren()

    --print("type(cameoNode):"..type(cameoNode))


    local cameoTab={}

    for i=1,count do


        local strName=string.format("cameo_"..i)
        local cameo=slotManager.proxy:getNodeWithName(strName)


        table.insert(cameoTab,cameo)

    end


    local action1=cc.CallFunc:create(function()
        Slot.animation:ParctiseMove("image/common/stars.png",layerColorMask,layerColorMask,targetStartPos,1,1000,true)

    end)
    local action2=cc.CallFunc:create(function()
        --Slot.girl_animation:cameoRotate(cameoTab1,cameoTab2)
        Slot.girl_animation:cameoRotate(cameoTab)

    end)

    local seq=cc.Sequence:create(action1,action2)

    layerColorMask:runAction(seq)


    if callback and type(callback)=="function" then

        callback()
    end



end

--    girl={1,2,50,100,200},
--播放特殊图表音乐
Slot.girl_animation.girlSpecailItemMusic = function(self,index)



    if index==self.specailItemIndex[1] then

        Slot.Audio:playEffect("sound/modules/girl/"..Slot.MusicResources["girl"].girl_icon1)

    elseif index==self.specailItemIndex[2] then

        Slot.Audio:playEffect("sound/modules/girl/"..Slot.MusicResources["girl"].girl_icon2)


    elseif index==self.specailItemIndex[3] then

        Slot.Audio:playEffect("sound/modules/girl/"..Slot.MusicResources["girl"].girl_wild)

    elseif index==self.specailItemIndex[4] then

        Slot.Audio:playEffect("sound/modules/girl/"..Slot.MusicResources["girl"].girl_scatter)

    elseif index==self.specailItemIndex[5] then

        Slot.Audio:playEffect("sound/modules/girl/"..Slot.MusicResources["girl"].girl_bonus)

    end

end

Slot.girl_animation.isHaveTargetIndex=function(self,index)

    for k,v in pairs(self.specailTagTab) do

        if index==v then

            return true
        end

    end

    return false

end


Slot.girl_animation.getGirlPriorityTag=function(self,specailTagTab)

    self.specailTagTab=specailTagTab

    if self:isHaveTargetIndex(self.specailItemIndex[1]) then

        return self.specailItemIndex[1]

    elseif self:isHaveTargetIndex(self.specailItemIndex[2]) then

        return self.specailItemIndex[2]


    end


end


