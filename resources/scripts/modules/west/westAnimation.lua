--
-- Created by IntelliJ IDEA.
-- User: oas
-- Date: 14-12-21
-- Time: 下午2:42
-- To change this template use File | Settings | File Templates.
--
--require "libs.Constant"


Slot.west_animation = Slot.west_animation or {}


Slot.west_animation.specailItemIndex=Slot.SpecailItem.west

Slot.west_animation.moduleName="west"

--
Slot.west_animation.showSpecialItem=function(self,index)

    U:addSpriteFrameResource("plist/modules/west/west.plist")

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


Slot.west_animation.showSpecialItem_1=function(self,isVisible)

    if isVisible==nil then isVisible=false  end

--    local fileNameBg=string.format("image/modules/west/1_1.png")
--    local fileNameWoman=string.format("image/modules/west/1_1.png")
--
--    local bg_sprite=cc.Sprite:create(fileNameBg)
--    local item_sprite=cc.Sprite:create(fileNameWoman)


--    local bg_sprite= U:getSpriteByName(self.moduleName.."_1_1.png")
--    local item_sprite= U:getSpriteByName(self.moduleName.."_1_1.png")

    local bg_sprite= U:getSpriteByName("1_1.png")
    local item_sprite= U:getSpriteByName("1_1.png")


    bg_sprite:setVisible(isVisible)

    --给item精灵增加标签 好获取
    bg_sprite:addChild(item_sprite,30,self.specailItemIndex[1])

    item_sprite:setPosition(cc.p(bg_sprite:getContentSize().width/2,bg_sprite:getContentSize().height/2))

    return bg_sprite,item_sprite




end

--
--男人
Slot.west_animation.showSpecialItem_2=function(self,isVisible)

    if isVisible==nil then isVisible=false end

--    local fileNameBg=string.format("image/modules/west/2.png")
--    local fileNameMan=string.format("image/modules/west/2.png")
--
--    local bg_sprite=cc.Sprite:create(fileNameBg)
--    local item_sprite=cc.Sprite:create(fileNameMan)

--    local bg_sprite= U:getSpriteByName(self.moduleName.."_2.png")
--    local item_sprite= U:getSpriteByName(self.moduleName.."_2.png")

    local bg_sprite= U:getSpriteByName("2.png")
    local item_sprite= U:getSpriteByName("2.png")


    bg_sprite:setVisible(isVisible)

    bg_sprite:addChild(item_sprite,30,self.specailItemIndex[2])
    item_sprite:setPosition(cc.p(bg_sprite:getContentSize().width/2,bg_sprite:getContentSize().height/2))
    return bg_sprite,item_sprite

end

--wild
Slot.west_animation.showSpecialItem_50=function(self,isVisible)

    if isVisible==nil then isVisible=false end

--    local fileNameBg=string.format("image/modules/west/50_bg.png")
--    local fileNameWild=string.format("image/modules//west/50_wild.png")
--
--    local bg_sprite=cc.Sprite:create(fileNameBg)
--    local item_sprite=cc.Sprite:create(fileNameWild)

--    local bg_sprite= U:getSpriteByName(self.moduleName.."_50_bg.png")
--    local item_sprite= U:getSpriteByName(self.moduleName.."_50_wild.png")

    local bg_sprite= U:getSpriteByName("50_bg.png")
    local item_sprite= U:getSpriteByName("50_wild.png")

    bg_sprite:setVisible(isVisible)

    bg_sprite:addChild(item_sprite,30,self.specailItemIndex[3])
    item_sprite:setPosition(cc.p(bg_sprite:getContentSize().width/2-7,66))
    return bg_sprite,item_sprite

end

--scatter
Slot.west_animation.showSpecialItem_100=function(self,isVisible)

    if isVisible==nil then isVisible=false end

--    local fileNameBg=string.format("image/modules/west/100_bg.png")
--    local fileNameScatter=string.format("image/modules/west/100_scatter.png")
--
--
--    local bg_sprite=cc.Sprite:create(fileNameBg)
--    local item_sprite=cc.Sprite:create(fileNameScatter)


--    local bg_sprite= U:getSpriteByName(self.moduleName.."_100_bg.png")
--    local item_sprite= U:getSpriteByName(self.moduleName.."_100_scatter.png")

    local bg_sprite= U:getSpriteByName("100_bg.png")
    local item_sprite= U:getSpriteByName("100_scatter.png")

    bg_sprite:setVisible(isVisible)


    bg_sprite:addChild(item_sprite,30,self.specailItemIndex[4])
    item_sprite:setPosition(cc.p(bg_sprite:getContentSize().width/2+3.5,50))

    return bg_sprite,item_sprite

end

--bonus
Slot.west_animation.showSpecialItem_200=function(self,isVisible)

    if isVisible==nil then isVisible=false end

--    local fileNameBg=string.format("image/modules/west/200_bg.png")
--    local fileNameBonus=string.format("image/modules/west/200_bonus.png")
--
--    local bg_sprite=cc.Sprite:create(fileNameBg)
--    local item_sprite=cc.Sprite:create(fileNameBonus)

--    local bg_sprite= U:getSpriteByName(self.moduleName.."_200_bg.png")
--    local item_sprite= U:getSpriteByName(self.moduleName.."_200_bonus.png")

    local bg_sprite= U:getSpriteByName("200_bg.png")
    local item_sprite= U:getSpriteByName("200_bonus.png")

    bg_sprite:setVisible(isVisible)

    bg_sprite:addChild(item_sprite,30,self.specailItemIndex[5])
    item_sprite:setPosition(cc.p(bg_sprite:getContentSize().width/2+3,62))

    return bg_sprite,item_sprite

end





-- --------------------------------------------------------------------------
-- Actions
-- --------------------------------------------------------------------------

Slot.west_animation.showSpecialItemActions=function(self,index,itemSprite)



    if index==self.specailItemIndex[1] then

        self:SpecialItem_1_Action(itemSprite)

    elseif index==self.specailItemIndex[2] then
        self:SpecialItem_2_Action(itemSprite)

    elseif index==self.specailItemIndex[3] then
        self:SpecialItem_50_Action(itemSprite)

    elseif index==self.specailItemIndex[4] then

        self:SpecialItem_100_Action(itemSprite)

    elseif index==self.specailItemIndex[5] then

        self:SpecialItem_200_Action(itemSprite)

    end


end


Slot.west_animation.SpecialItem_1_Action=function(self,itemSprite,time,isOrgin)

    if time==nil then time=2/14.8 end
    if isOrgin==nil then isOrgin=true end

--    --眼珠转动
--    local eyenimation=cc.Animation:create()
--    local number,name
--    for i=1,2 do
--        name=string.format("image/modules/west/1_"..i..".png")
--        eyenimation:addSpriteFrameWithFile(name)
--
--    end
--    eyenimation:setDelayPerUnit(0.5)
--
--    --设置为false 停止到最后一帧
--    eyenimation:setRestoreOriginalFrame(isOrgin)
--    local eyeAction=cc.Animate:create(eyenimation)
--
--    -- -------------------------------------
--    --眨眼动作
--    local cache=cc.SpriteFrameCache:getInstance()
--    local animFrames={}
--    for i=1,4 do
--
--        local name=string.format("1_"..i..".png")
--        local frame=cache:getSpriteFrame(name)
--        animFrames[i]=frame
--
--    end
--
--    local animation=cc.Animation:createWithSpriteFrames(animFrames,time)
--    animation:setRestoreOriginalFrame(isOrgin)
--    local womanAction=cc.Animate:create(animation)
--
--    local seq=cc.Sequence:create(womanAction,eyeAction)
--
--    itemSprite:runAction(seq)

    --眼珠转动
    local eye_animFrames={}
    for i=1,2 do

        --local name=string.format(self.moduleName.."_1_"..i..".png")
        local name=string.format("1_"..i..".png")
        local frame=U:getSpriteFrame(name)
        eye_animFrames[i]=frame

    end

    local eyenimation=cc.Animation:createWithSpriteFrames(eye_animFrames,0.5)

    --设置为false 停止到最后一帧
    eyenimation:setRestoreOriginalFrame(isOrgin)
    local eyeAction=cc.Animate:create(eyenimation)

    -- -------------------------------------
    --眨眼动作
    local animFrames={}
    for i=1,4 do
--        local name=string.format(self.moduleName.."_1_"..i..".png")
        local name=string.format("1_"..i..".png")
        local frame=U:getSpriteFrame(name)
        animFrames[i]=frame

    end

    local animation=cc.Animation:createWithSpriteFrames(animFrames,time)
    animation:setRestoreOriginalFrame(isOrgin)
    local womanAction=cc.Animate:create(animation)

    local seq=cc.Sequence:create(womanAction,eyeAction)

    itemSprite:runAction(seq)


end


--男人图标动画
Slot.west_animation.SpecialItem_2_Action=function(self,itemSprite,num,secs)

    if num==nil then num=3 end
    if secs==nil then secs=0.2 end

--    local moveUp=cc.MoveBy:create(secs,cc.p(0,0.8))
--    local ease=cc.EaseIn:create(moveUp,secs)
--    local easeBack=ease:reverse()
--
--    local seq=cc.Sequence:create(ease,easeBack)
--    local repN=cc.Repeat:create(seq,num)
--
--    itemSprite:runAction(repN)


--    local moveUpAnimation=cc.Animation:create()
--    local number,name
--    for i=1,2 do
--        name=string.format("image/modules/west/2_"..i..".png")
--        moveUpAnimation:addSpriteFrameWithFile(name)
--
--    end
--    moveUpAnimation:setDelayPerUnit(secs)
--
--    --设置为false 停止到最后一帧
--    moveUpAnimation:setRestoreOriginalFrame(true)
--    local moveUpAction=cc.Animate:create(moveUpAnimation)

    local animFrames={}
    for i=1,4 do
       -- local name=string.format(self.moduleName.."_2_"..i..".png")

        local name=string.format("2_"..i..".png")
        local frame=U:getSpriteFrame(name)
        animFrames[i]=frame

    end

    local moveUpAnimation=cc.Animation:createWithSpriteFrames(animFrames,secs)
    moveUpAnimation:setRestoreOriginalFrame(true)
    local moveUpAction=cc.Animate:create(moveUpAnimation)




    local repN=cc.Repeat:create(moveUpAction,num)
    itemSprite:runAction(repN)

    --添加音乐 2015 1.04  test ok
    --Slot.Audio:playEffect("sound/west/"..Slot.MusicResources["west"].west_icon2)


end



--wild图标动画
Slot.west_animation.SpecialItem_50_Action=function(self,itemSprite,secs)


    if secs==nil then secs=0.25 end


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


    local delay=cc.DelayTime:create(0.5)

    local seq=cc.Sequence:create(delay,ease1,easeBack1,ease2,easeBack2)



    local posTab={
        cc.p(30,100),cc.p(120,100),cc.p(242,93),cc.p(208,100),cc.p(160,100),
        cc.p(7,80),cc.p(122,83),cc.p(214,63),cc.p(133,53),cc.p(156,70),
        cc.p(59,30),cc.p(209,33),cc.p(169,33)

    }
    --在字上添加发光粒子效果
    Slot.animation:lightAction(itemSprite,posTab)

    itemSprite:runAction(seq)

    --添加音乐 2015 1.04  test ok
    --Slot.Audio:playEffect("sound/west/"..Slot.MusicResources["west"].west_wild)




end


--scatter图标动画
Slot.west_animation.SpecialItem_100_Action=function(self,itemSprite,scale,secs)


    if scale==nil then scale=1.2 end
    if secs==nil then secs=0.25 end

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


    local delay=cc.DelayTime:create(0.5)


    local seq=cc.Sequence:create(delay,ease1,easeBack1,ease2,easeBack2)
    --local seq=cc.Sequence:create(ease1,easeBack1)

    --local repN=cc.Repeat:create(seq,2)


    --在字上添加发光粒子效果

    local posTab={
        cc.p(30,70),cc.p(120,70),cc.p(225,70),cc.p(208,60),cc.p(160,70),
        cc.p(7,60),cc.p(122,53),cc.p(204,63),cc.p(133,53),cc.p(156,70),
        cc.p(59,20),cc.p(209,23),cc.p(169,23)

    }

    Slot.animation:lightAction(itemSprite,posTab)

    itemSprite:runAction(seq)


    --叠加一张发光图片看下
    local lightSprite=cc.Sprite:create("image/common/light.png")


    lightSprite:setScale(2)
    lightSprite:setOpacity(0)

    local parentNode=itemSprite:getParent()
    local pos=cc.p(parentNode:getContentSize().width/2,parentNode:getContentSize().height/2+40)
    parentNode:addChild(lightSprite)
    lightSprite:setPosition(pos)


    local fade=cc.FadeIn:create(1.5)
    local fadeBack=fade:reverse()

    local seq=cc.Sequence:create(fade,fadeBack)

    local rep=cc.Repeat:create(seq,2)
    lightSprite:runAction(rep)


    local posTabR={
        cc.p(124,227),cc.p(185,215),cc.p(85,180),
        cc.p(155,180),cc.p(70,182),cc.p(200,195)
    }

    Slot.animation:goldStarAction(itemSprite,posTabR)


end

--bonus动画
Slot.west_animation.SpecialItem_200_Action=function(self,itemSprite,scale,secs)


    if scale==nil then scale=1.2 end
    if secs==nil then secs=0.25 end

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


    local delay=cc.DelayTime:create(0.5)


    local seq=cc.Sequence:create(delay,ease1,easeBack1,ease2,easeBack2)
    --local seq=cc.Sequence:create(ease1,easeBack1)

    --local repN=cc.Repeat:create(seq,2)


    --在字上添加发光粒子效果

    local posTab={
        cc.p(30,70),cc.p(120,70),cc.p(232,63),cc.p(208,70),cc.p(160,70),
        cc.p(7,80),cc.p(122,83),cc.p(210,63),cc.p(133,53),cc.p(156,70),
        cc.p(59,30),cc.p(209,33),cc.p(169,33)

    }
    Slot.animation:lightAction(itemSprite,posTab)

    itemSprite:runAction(seq)



    --叠加一张发光图片看下
    local lightSprite=cc.Sprite:create("image/common/light.png")
    lightSprite:setScale(2)
    lightSprite:setOpacity(0)

    local parentNode=itemSprite:getParent()
    local pos=cc.p(parentNode:getContentSize().width/2,parentNode:getContentSize().height/2)
    parentNode:addChild(lightSprite)
    lightSprite:setPosition(pos)


    local fade=cc.FadeIn:create(1.5)
    local fadeBack=fade:reverse()

    local seq=cc.Sequence:create(fade,fadeBack)

    local rep=cc.Repeat:create(seq,2)
    lightSprite:runAction(rep)


    local posTabR={
        cc.p(124,172),cc.p(200,128), cc.p(85,150),
        cc.p(155,160),cc.p(70,132),cc.p(200,125)
    }


    Slot.animation:goldStarAction(itemSprite,posTabR)

    --添加音乐 2015 1.04  test ok
--    Slot.Audio:playEffect("sound/west/"..Slot.MusicResources["west"].west_bonus)

end




-- -----------------------------------------------------------------------------
--west主题动画 add 12.18
-- -----------------------------------------------------------------------------
Slot.west_animation.sparkTab={}


Slot.west_animation.westModuleSpark= function(self,parentNode,secs)

    if secs==nil then secs=8 end


    
    local pStar = cc.ParticleSnow:create()
    
    parentNode:addChild(pStar)




    pStar:setTexture(cc.Director:getInstance():getTextureCache():addImage("image/modules/west/spark1.png"))

    --pStar:setTotalParticles(1500)
    pStar:setStartSize(20)
    pStar:setStartSizeVar(19)
    --pStar:setPosition(posTab[1])

    local height=parentNode:getContentSize().height
    local width=parentNode:getContentSize().width
    pStar:setPosition(cc.p(width/4,height-100))
    pStar:setPosVar(cc.p(width/8,0))

    pStar:setDuration(secs)
    --pStar:setSpeed(600)

    pStar:setSpeed(250)
    pStar:setSpeedVar(20)
    pStar:setPositionType(cc.POSITION_TYPE_RELATIVE)
    --pStar:setStartColor(cc.c4b(255,255,255,255))

    --设置角度

    pStar:setAngle(292.5)
    pStar:setAngleVar(22.5)


    pStar:setGravity(cc.p(100,0))

    --pStar:setEmissionRate(20)

    pStar:setEmissionRate(1)




end





Slot.west_animation.getSmokeKind = function(self,index)

    local id1,id2
    if index==1 then
        id1=1
        id2=1

    elseif index==2 then
        id1=1
        id2=2
    elseif index==3 then
        id1=2
        id2=1

    elseif index==4 then
        id1=2
        id2=2

    end

    return id1,id2

end

Slot.west_animation.getSmokeNode = function(self,id1,id2)

    U:addSpriteFrameResource("plist/modules/west/moduleAction.plist")
    local smokeIdTab={}
    local smokeNodeTab={}
    table.insert(smokeIdTab,id1)
    table.insert(smokeIdTab,id2)

    for i=1,2 do

--        local smokeFileName=string.format("image/modules/west/smoke"..smokeIdTab[i]..".png")
        local smokeSprite=U:getSpriteByName("smoke"..smokeIdTab[i]..".png")
        table.insert(smokeNodeTab,smokeSprite)
    end

    return smokeNodeTab

end

Slot.west_animation.addSandNode = function(self,smokeSprite)

    U:addSpriteFrameResource("plist/modules/west/moduleAction.plist")

    --添加小石头
   -- local sandFileName=string.format("image/modules/west/sand.png")
    local sandSprite=U:getSpriteByName("sand.png")
    smokeSprite:addChild(sandSprite,1000)

    --位置随机
    local smokeW=smokeSprite:getContentSize().width
    local smokeH=smokeSprite:getContentSize().height

    sandSprite:setPosition(cc.p(math.random(smokeW/6,smokeW*2/3),math.random(smokeH/6,smokeH*2/3)))

    local width=math.random(5,10)
    local height=math.random(1,5)
    local move=cc.MoveBy:create(5,cc.p(smokeW,-50))
    local repF=cc.RepeatForever:create(move)
    sandSprite:runAction(repF)

end



Slot.west_animation.westModuleAction = function(self,parentNode,height,callback,speed)



    --if speed==nil then speed=300 end
    if speed==nil then speed=300 end

    local director = cc.Director:getInstance()
    local glview = director:getOpenGLView()


    self.screenSize = director:getWinSize()

    --math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))

    --添加火星粒子

    Slot.west_animation:westModuleSpark(parentNode)
    

    local smokeId1
    local smokeId2

    for i=1,4 do

        local smokeNodeTab={}
        local num=math.random(1,4)

        smokeId1,smokeId2=self:getSmokeKind(num)
        smokeNodeTab=self:getSmokeNode(smokeId1,smokeId2)
        parentNode:addChild(smokeNodeTab[1])
        parentNode:addChild(smokeNodeTab[2])
        smokeNodeTab[1]:setScale(1.5)
        smokeNodeTab[2]:setScale(1.5)

        local pos=cc.p(-smokeNodeTab[1]:getContentSize().width/2-(i-1)*smokeNodeTab[1]:getContentSize().width/2,height+smokeNodeTab[1]:getContentSize().height/2-50)
        smokeNodeTab[1]:setPosition(pos)
        smokeNodeTab[2]:setPosition(pos)
        smokeNodeTab[1]:setOpacity(200)
        smokeNodeTab[2]:setOpacity(200)

        self:addSandNode(smokeNodeTab[1])
        self:addSandNode(smokeNodeTab[2])


        --添加动作
        for j=1,#smokeNodeTab do

            local distance=self.screenSize.width+(2*i-1)*smokeNodeTab[j]:getContentSize().width
            local move=cc.MoveBy:create(distance/speed,cc.p(distance,0))
            local rem=cc.RemoveSelf:create()
            local seqA=cc.Sequence:create(move,rem)
            smokeNodeTab[j]:runAction(seqA)

        end

--        print("smokeId1:"..smokeId1)
--        print("smokeId2:"..smokeId2)


    end


   if callback and type(callback)=="function" then

        callback()
   end


    print("================================")

end





--播放特殊图表音乐
Slot.west_animation.westSpecailItemMusic = function(self,index)


    if index==self.specailItemIndex[1] then

        Slot.Audio:playEffect("sound/modules/west/"..Slot.MusicResources["west"].west_icon1)

    elseif index==self.specailItemIndex[2] then

        Slot.Audio:playEffect("sound/modules/west/"..Slot.MusicResources["west"].west_icon2)

    elseif index==self.specailItemIndex[3] then

        Slot.Audio:playEffect("sound/modules/west/"..Slot.MusicResources["west"].west_wild)

    elseif index==self.specailItemIndex[4] then

        Slot.Audio:playEffect("sound/modules/west/"..Slot.MusicResources["west"].west_scatter)

    elseif index==self.specailItemIndex[5] then

        Slot.Audio:playEffect("sound/modules/west/"..Slot.MusicResources["west"].west_bonus)

    end

end

Slot.west_animation.isHaveTargetIndex=function(self,index)

    for k,v in pairs(self.specailTagTab) do

        if index==v then

            return true
        end

    end

    return false

end

--west={1,2,50,100,200},  Slot.west_animation.specailItemIndex
Slot.west_animation.getWestPriorityTag=function(self,specailTagTab)

    self.specailTagTab=specailTagTab

    if self:isHaveTargetIndex(self.specailItemIndex[1]) then

        return self.specailItemIndex[1]
    elseif self:isHaveTargetIndex(self.specailItemIndex[2]) then

        return self.specailItemIndex[2]

    end


end















