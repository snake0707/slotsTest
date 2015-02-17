--
-- Created by IntelliJ IDEA.
-- User: oas
-- Date: 14-12-21
-- Time: 下午3:23
-- To change this template use File | Settings | File Templates.
--

Slot.blackhand_animation = Slot.blackhand_animation or {}


Slot.blackhand_animation.specailItemIndex=Slot.SpecailItem.blackhand

Slot.blackhand_animation.moduleName="blackhand"

Slot.blackhand_animation.showSpecialItem=function(self,index)

    U:addSpriteFrameResource("plist/modules/blackhand/blackhand.plist")

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
Slot.blackhand_animation.showSpecialItem_1=function(self,isVisible)

    if isVisible==nil then isVisible=false end

    --    local fileNameBg=string.format("image/modules/blackhand/1_bg.png")
    --    local fileNameWoman=string.format("image/modules/blackhand/1_heart.png")
    --    local bg_sprite=cc.Sprite:create(fileNameBg)
    --    local item_sprite=cc.Sprite:create(fileNameWoman)

    --    local bg_sprite= U:getSpriteByName(self.moduleName.."_1_bg.png")
    --    local item_sprite= U:getSpriteByName(self.moduleName.."_1_heart.png")


    local bg_sprite= U:getSpriteByName("1_bg.png")
    local item_sprite= U:getSpriteByName("1_heart.png")


    bg_sprite:setVisible(isVisible)

    --给item精灵增加标签 好获取
    bg_sprite:addChild(item_sprite,30,self.specailItemIndex[1])

    item_sprite:setPosition(cc.p(bg_sprite:getContentSize().width-item_sprite:getContentSize().width/2-40,item_sprite:getContentSize().height/2+30))

    return bg_sprite,item_sprite


end

Slot.blackhand_animation.showSpecialItem_2=function(self,isVisible)

    if isVisible==nil then isVisible=false end

    --    local fileNameBg=string.format("image/modules/blackhand/2.png")
    --    local fileNameWoman=string.format("image/modules/blackhand/2_glass.png")
    --    local bg_sprite=cc.Sprite:create(fileNameBg)
    --
    --
    --    local item_sprite=cc.Sprite:create(fileNameWoman)

    --    local bg_sprite= U:getSpriteByName(self.moduleName.."_2.png")
    --    local item_sprite= U:getSpriteByName(self.moduleName.."_2_glass.png")

    local bg_sprite= U:getSpriteByName("2.png")
    local item_sprite= U:getSpriteByName("2_glass.png")

    bg_sprite:setVisible(isVisible)

    --给item精灵增加标签 好获取
    bg_sprite:addChild(item_sprite,30,self.specailItemIndex[2])


    item_sprite:setPosition(cc.p(bg_sprite:getContentSize().width/2-12,bg_sprite:getContentSize().width/2-8))

    return bg_sprite,item_sprite

end

Slot.blackhand_animation.showSpecialItem_3=function(self,isVisible)

    if isVisible==nil then isVisible=false end

    --    local fileNameBg=string.format("image/modules/blackhand/3.png")
    --    local fileNameWoman=string.format("image/modules/blackhand/3_1.png")
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


    --item_sprite:setPosition(cc.p(bg_sprite:getContentSize().width/2+1.7,bg_sprite:getContentSize().height/2+3))
    item_sprite:setPosition(cc.p(bg_sprite:getContentSize().width/2,bg_sprite:getContentSize().height/2))

    return bg_sprite,item_sprite



end

Slot.blackhand_animation.showSpecialItem_50=function(self,isVisible)

    if isVisible==nil then isVisible=false end

    --    local fileNameBg=string.format("image/modules/blackhand/50_bg.png")
    --    local fileNameWild=string.format("image/modules/blackhand/50_wild.png")
    --
    --    local bg_sprite=cc.Sprite:create(fileNameBg)
    --    local item_sprite=cc.Sprite:create(fileNameWild)

    --    local bg_sprite= U:getSpriteByName(self.moduleName.."_50_bg.png")
    --    local item_sprite= U:getSpriteByName(self.moduleName.."_50_wild.png")

    local bg_sprite= U:getSpriteByName("50_bg.png")
    local item_sprite= U:getSpriteByName("50_wild.png")

    bg_sprite:setVisible(isVisible)

    bg_sprite:addChild(item_sprite,30,self.specailItemIndex[4])
    item_sprite:setPosition(cc.p(bg_sprite:getContentSize().width/2-8,93))
    return bg_sprite,item_sprite

end

Slot.blackhand_animation.showSpecialItem_100=function(self,isVisible)

    if isVisible==nil then isVisible=false end

    --    local fileNameBg=string.format("image/modules/blackhand/100_bg.png")
    --    local fileNameScatter=string.format("image/modules/blackhand/100_scatter.png")
    --
    --    local bg_sprite=cc.Sprite:create(fileNameBg)
    --    local item_sprite=cc.Sprite:create(fileNameScatter)

    --    local bg_sprite= U:getSpriteByName(self.moduleName.."_100_bg.png")
    --    local item_sprite= U:getSpriteByName(self.moduleName.."_100_scatter.png")

    local bg_sprite= U:getSpriteByName("100_bg.png")
    local item_sprite= U:getSpriteByName("100_scatter.png")


    bg_sprite:setVisible(isVisible)

    bg_sprite:addChild(item_sprite,30,self.specailItemIndex[5])
    item_sprite:setPosition(cc.p(bg_sprite:getContentSize().width/2+2,82))
    return bg_sprite,item_sprite

end

Slot.blackhand_animation.showSpecialItem_200=function(self,isVisible)

    if isVisible==nil then isVisible=false end

    --    local fileNameBg=string.format("image/modules/blackhand/200_bg.png")
    --    local fileNameBonus=string.format("image/modules/blackhand/200_bonus.png")
    --
    --    local bg_sprite=cc.Sprite:create(fileNameBg)
    --    local item_sprite=cc.Sprite:create(fileNameBonus)

    --    local bg_sprite= U:getSpriteByName(self.moduleName.."_200_bg.png")
    --    local item_sprite= U:getSpriteByName(self.moduleName.."_200_bonus.png")

    local bg_sprite= U:getSpriteByName("200_bg.png")
    local item_sprite= U:getSpriteByName("200_bonus.png")



    bg_sprite:setVisible(isVisible)

    bg_sprite:addChild(item_sprite,30,self.specailItemIndex[6])
    item_sprite:setPosition(cc.p(bg_sprite:getContentSize().width/2-4,78))
    return bg_sprite,item_sprite

end




-- --------------------------------------------------------------------------
-- Actions
-- --------------------------------------------------------------------------

Slot.blackhand_animation.showSpecialItemActions=function(self,index,itemSprite,parentNode)



    if index==self.specailItemIndex[1] then

        self:SpecialItem_1_Action(itemSprite,parentNode)

    elseif index==self.specailItemIndex[2] then
        self:SpecialItem_2_Action(itemSprite)

    elseif index==self.specailItemIndex[3] then
        self:SpecialItem_3_Action(itemSprite)

    elseif index==self.specailItemIndex[4] then

        self:SpecialItem_50_Action(itemSprite)

    elseif index==self.specailItemIndex[5] then

        self:SpecialItem_100_Action(itemSprite)

    elseif index==self.specailItemIndex[6] then

        self:SpecialItem_200_Action(itemSprite)

    end


end


Slot.blackhand_animation.SpecialItem_1_Action=function(self,itemSprite,parentNode,time,isOrgin)

--itemSprite 为心

    local width=parentNode:getContentSize().width
    local height=parentNode:getContentSize().height



    for i=1,2 do
        --        local fileNameWoman=string.format("image/modules/blackhand/1_heart.png")
        --
        --        local xin_sprite=cc.Sprite:create(fileNameWoman)

        --local xin_sprite=U:getSpriteByName(self.moduleName.."_1_heart.png")

        local xin_sprite=U:getSpriteByName("1_heart.png")
        parentNode:addChild(xin_sprite,30)

        --xin_sprite:setPosition(cc.p(math.random(0,width),math.random(0,height)))

        xin_sprite:setPosition(cc.p(40*i,80*i))
        --xin_sprite:setOpacity(0)
        --xin_sprite:setScale(i*0.6)

        local scale=cc.ScaleBy:create(0.3,1.6)
        local ease=cc.EaseIn:create(scale,0.3)
        local easeBack=ease:reverse()

        local scaleBack=cc.ScaleTo:create(0.3,1)

        local seqS=cc.Sequence:create(ease,scaleBack)
        local repN=cc.Repeat:create(seqS,3)

        local rem=cc.RemoveSelf:create()
        local delay=cc.DelayTime:create(0.5)
        local fadeOut=cc.FadeOut:create(0.5)
        local fadaIn=cc.FadeIn:create(0.5)
        local seq1=cc.Sequence:create(repN,fadeOut,rem)
        xin_sprite:runAction(seq1)

    end


    local targetSprite=itemSprite
    itemSprite:setOpacity(0)
    local scale=cc.ScaleBy:create(0.3,1.6)
    local ease=cc.EaseIn:create(scale,0.3)
    local easeBack=ease:reverse()

    local scaleBack=cc.ScaleTo:create(0.3,1)

    local seqS=cc.Sequence:create(ease,scaleBack)
    local repN=cc.Repeat:create(seqS,3)

    local fadeOut=cc.FadeOut:create(0.5)
    local fadaIn=cc.FadeIn:create(0.1)
    local seq=cc.Sequence:create(fadaIn,repN,fadeOut)


    targetSprite:runAction(seq)



end


Slot.blackhand_animation.SpecialItem_2_Action=function(self,itemSprite,time,isOrgin)

    if time==nil then time=2/10 end
    if isOrgin==nil then isOrgin=false end

    --print("blackHand_BossAction@@@@@@@@@@@@@@@@@")
    --itemSprite 就为原图
    --眼镜动作
    --    local glassSprite=cc.Sprite:createWithSpriteFrameName("2_1.png")
    --    itemSprite:addChild(glassSprite,10)
    --    glassSprite:setPositon(cc.p(itemSprite:getContentSize().width/2,itemSprite:getContentSize().height/2))


    local animFrames={}
    for i=1,5 do

        local name=string.format("glass"..i..".png")
        local frame=U:getSpriteFrame(name)
        animFrames[i]=frame

    end

    local animation=cc.Animation:createWithSpriteFrames(animFrames,time)
    animation:setRestoreOriginalFrame(isOrgin)
    local glassAction=cc.Animate:create(animation)

    local repN=cc.Repeat:create(glassAction,1)


    --12.04添加一个眼镜闪光的动画

    local x,y=itemSprite:getContentSize().width-2,itemSprite:getContentSize().height-2
    local posTab={cc.p(x,y)}
    local glassStar=cc.CallFunc:create(function()

    --print("boss glassStar##########")

    --Slot.animation:lightAction(itemSprite,posTab)

        U:addSpriteFrameResource("plist/common/common.plist")

        local lightSprite= U:getSpriteByName("light2.png")
        itemSprite:addChild(lightSprite)
        lightSprite:setPosition(posTab[1])

        lightSprite:setScale(0.2)
        lightSprite:setOpacity(30)

        --从小变大 同时渐隐 旋转

        --0.5
        local scale=cc.ScaleTo:create(0.5,0.6)
        local fade=cc.FadeIn:create(0.5)
        local rotate=cc.RotateBy:create(1,90)

        local rem=cc.RemoveSelf:create()
        local spa=cc.Spawn:create(scale,fade,rotate)

        local seq=cc.Sequence:create(spa,rem)
        --
        lightSprite:runAction(seq)

    end)

    local seq=cc.Sequence:create(repN,glassStar)

    itemSprite:runAction(seq)

--添加音乐 2015 1.04  test ok
--    Slot.Audio:playEffect("sound/blackhand/"..Slot.MusicResources["blackhand"].blackhand_icon2)



end


Slot.blackhand_animation.SpecialItem_3_Action=function(self,itemSprite,isOrgin)



    if isOrgin==nil then isOrgin=true end

    --itemSprite  应该是那个整图

    --张嘴动作
    --    local mouthAnimation=cc.Animation:create()
    --    local number,name
    --    for i=1,2 do
    --        name=string.format("image/modules/blackhand/3_"..i..".png")
    --        mouthAnimation:addSpriteFrameWithFile(name)
    --
    --    end
    --    mouthAnimation:setDelayPerUnit(0.1)
    --
    --    --设置为false 停止到最后一帧
    --    mouthAnimation:setRestoreOriginalFrame(isOrgin)
    --    local mouthAction=cc.Animate:create(mouthAnimation)

    local animFrames={}
    for i=1,2 do

        --local name=string.format(self.moduleName.."_3_"..i..".png")

        local name=string.format("3_"..i..".png")
        local frame=U:getSpriteFrame(name)
        animFrames[i]=frame

    end

    local mouthAnimation=cc.Animation:createWithSpriteFrames(animFrames,0.1)
    mouthAnimation:setRestoreOriginalFrame(isOrgin)
    local mouthAction=cc.Animate:create(mouthAnimation)

    local repN=cc.Repeat:create(mouthAction,3)
    itemSprite:runAction(repN)


--添加音乐 2015 1.04  test ok
--    Slot.Audio:playEffect("sound/blackhand/"..Slot.MusicResources["blackhand"].blackhand_icon3)


end

Slot.blackhand_animation.SpecialItem_50_Action=function(self,itemSprite,secs)

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
        cc.p(130,20), cc.p(90,60),cc.p(143,63),cc.p(208,70),
        cc.p(68,50),cc.p(82,55),cc.p(217,80),cc.p(44,63),
        cc.p(173,73), cc.p(56,80), cc.p(79,53), cc.p(59,33),cc.p(199,33)

    }
    --在字上添加发光粒子效果
    Slot.animation:lightAction(itemSprite,posTab)

    itemSprite:runAction(seq)

--添加音乐 2015 1.04  test ok
--    Slot.Audio:playEffect("sound/blackhand/"..Slot.MusicResources["blackhand"].blackhand_wild)


end


Slot.blackhand_animation.SpecialItem_100_Action=function(self,itemSprite,secs)

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
        cc.p(130,20), cc.p(90,60),cc.p(143,63),cc.p(208,65),
        cc.p(68,50),cc.p(82,55),cc.p(217,60),cc.p(44,63),
        cc.p(173,63), cc.p(56,60), cc.p(79,53), cc.p(59,33),cc.p(199,33)

    }
    --在字上添加发光粒子效果
    Slot.animation:lightAction(itemSprite,posTab)

    itemSprite:runAction(seq)



end


Slot.blackhand_animation.SpecialItem_200_Action=function(self,itemSprite,secs)

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
        cc.p(130,20), cc.p(90,60),cc.p(143,55),cc.p(208,55),
        cc.p(68,50),cc.p(82,55),cc.p(217,55),cc.p(44,53),
        cc.p(173,60), cc.p(56,55), cc.p(79,53), cc.p(59,33),cc.p(199,33)

    }
    --在字上添加发光粒子效果
    Slot.animation:lightAction(itemSprite,posTab)

    itemSprite:runAction(seq)

--添加音乐 2015 1.04  test ok
--    Slot.Audio:playEffect("sound/blackhand/"..Slot.MusicResources["blackhand"].blackhand_bonus)

end



-- --------------------------------------------------------------------------
-- 主题动画
-- --------------------------------------------------------------------------


--添加闪电动画
Slot.blackhand_animation.blackLightningAction=function(self,lightningNode,callback,secs)

    if secs==nil then secs=0.5 end

    local showDelay=cc.DelayTime:create(secs/5)
    local showAction=cc.Show:create()

    local hideDelay=cc.DelayTime:create(secs/5)
    local hideAction=cc.Hide:create()

    local seq1=cc.Sequence:create(showDelay,showAction,hideDelay,hideAction)
    local repN_1=cc.Repeat:create(seq1,2)

    local delay=cc.DelayTime:create(secs)
    local delayStand=cc.DelayTime:create(4)
    local seq2=cc.Sequence:create(delay,showAction,delayStand,hideAction)

    local callbackAction=cc.CallFunc:create(function()

        if callback and type(callback)=="function" then

            callback()
        end
    end)
    local seqA=cc.Sequence:create(repN_1,seq2,callbackAction)
    lightningNode:runAction(seqA)

    Slot.Audio:playEffect("sound/modules/blackhand/"..Slot.MusicResources["blackhand"].blackhand_light)

end

--添加雨点动画
Slot.blackhand_animation.blackRainAction=function(self,rainNode)

    Slot.Audio:playMusic("sound/modules/blackhand/"..Slot.MusicResources["blackhand"].blackhand_rain)

    local RainParticle=Slot.animation:ShowParticleByPlist("plist/common/blackhand_Rain.plist")
    rainNode:addChild(RainParticle,1)

end

--添加水蒸汽动画
Slot.blackhand_animation.blackFogAction=function(self,rainNode)


    local ForkyParticle1=Slot.animation:ShowParticleByPlist("plist/common/blackhand_Forky.plist")
    local ForkyParticle2=Slot.animation:ShowParticleByPlist("plist/common/blackhand_Forky.plist")
    rainNode:addChild(ForkyParticle1,1)
    rainNode:addChild(ForkyParticle2,1)

    local width=rainNode:getContentSize().width
    local height=rainNode:getContentSize().height
    ForkyParticle1:setPosition(cc.p(0,100))
    ForkyParticle2:setPosition(cc.p(width*6/7,100))

end



--播放特殊图表音乐
Slot.blackhand_animation.blackhandSpecailItemMusic = function(self,index)



    if index==self.specailItemIndex[1] then

        Slot.Audio:playEffect("sound/modules/blackhand/"..Slot.MusicResources["blackhand"].blackhand_icon1)

    elseif index==self.specailItemIndex[2] then

        Slot.Audio:playEffect("sound/modules/blackhand/"..Slot.MusicResources["blackhand"].blackhand_icon2)

    elseif index==self.specailItemIndex[3] then

        Slot.Audio:playEffect("sound/modules/blackhand/"..Slot.MusicResources["blackhand"].blackhand_icon3)

    elseif index==self.specailItemIndex[4] then

        Slot.Audio:playEffect("sound/modules/blackhand/"..Slot.MusicResources["blackhand"].blackhand_wild)

    elseif index==self.specailItemIndex[5] then

        Slot.Audio:playEffect("sound/modules/blackhand/"..Slot.MusicResources["blackhand"].blackhand_scatter)

    elseif index==self.specailItemIndex[6] then

        Slot.Audio:playEffect("sound/modules/blackhand/"..Slot.MusicResources["blackhand"].blackhand_bonus)

    end

end

Slot.blackhand_animation.isHaveTargetIndex=function(self,index)

    for k,v in pairs(self.specailTagTab) do

        if index==v then

            return true
        end

    end

    return false

end

--blackhand={1,2,3,50,100,200},  Slot.west_animation.specailItemIndex
Slot.blackhand_animation.getBlackhandPriorityTag=function(self,specailTagTab)


    self.specailTagTab=specailTagTab

    if self:isHaveTargetIndex(self.specailItemIndex[1]) then

        return self.specailItemIndex[1]
    elseif self:isHaveTargetIndex(self.specailItemIndex[2]) then

        return self.specailItemIndex[2]

    elseif self:isHaveTargetIndex(self.specailItemIndex[3]) then

        return self.specailItemIndex[3]

    end


end