--
-- Created by IntelliJ IDEA.
-- User: bbf
-- Date: 14-12-2
-- Time: 上午11:18
-- To change this template use File | Settings | File Templates.
--

Slot = Slot or {}

Slot.com = Slot.com or {}

Slot.com.SwitchScene = Slot.ui.UIComponent:extend({
    __className = "Slot.com.SwitchScene",

    initWithCode = function(self, options)

        self:_super(options)
        self:cloud()
    end,

    cloud = function(self)

        U:addSpriteFrameResource("plist/common/cloud.plist")
        self._rightCloud=U:getSpriteByName("cloud.png")
        self._leftCloud = U:getSpriteByName("cloud.png")
        self._leftCloud:setFlippedX(true)
        self._leftCloud:setFlippedY(true)

        --        self._rightCloud:setScale(1.2)
        --        self._leftCloud:setScale(1.2)

        self._rightCloud:setScale(5)
        self._leftCloud:setScale(5)

        --self._rightCloud = cc.Sprite:create("common/cloud_right.png")



        local size = self.rootNode:getContentSize()

        self._leftCloud:setAnchorPoint(cc.p(0, 1))
        self._rightCloud:setAnchorPoint(cc.p(1, 0))

        self._leftCloud:setPosition(cc.p(0, size.height))
        self._rightCloud:setPosition(cc.p(size.width, 0))

        self.rootNode:addChild(self._leftCloud)
        self.rootNode:addChild(self._rightCloud)

        if self._options.modulename then

            self._loadingLabel = cc.LabelTTF:create("LOADING....",Slot.Font.default,60)

--            local num = 0
--            self._inteval = U:setInterval(function()
--                local text = "LOADING...."
--                if num == 0 then text = "LOADING" end
--                if num == 1 then text = "LOADING." end
--                if num == 2 then text = "LOADING.." end
--                if num == 3 then text = "LOADING..." end
--                if num == 4 then text = "LOADING...." end
--                num = num + 1
--                self._loadingLabel:setString()
--            end,1)

            self._loadingLabel:setAnchorPoint(cc.p(0.5,0.5))
            self._loadingLabel:setPosition(cc.p(self._winsize.width/2,self._winsize.height/4))
            self._loadingLabel:setColor(Slot.CCC3.black)
--            self._loadingLabel:setVisilble(false)
            self.rootNode:addChild(self._loadingLabel)

            local texture = cc.Director:getInstance():getTextureCache():addImage("image/modules/"..self._options.modulename.."/logo.png")

            self._logo=cc.Sprite:createWithTexture(texture)

            local logo_size = self._logo:getContentSize()
            self._logo:setPosition(cc.p(size.width/2, -logo_size.height))
            self._logo:setScale(0.5)
            self.rootNode:addChild(self._logo)
        end

    end,

    switchInBegin = function(self, callBack)
        U:debug("switchInBegin==================")
        if self._loadingLabel then
            local loading_seq = cc.Sequence:create(cc.FadeOut:create(2), cc.FadeIn:create(2))
            self._loadingLabel:runAction(cc.RepeatForever:create(loading_seq))

        end


        if self._logo then
            local size = self.rootNode:getContentSize()
            local action = cc.Spawn:create(
                cc.ScaleTo:create(0.5, 1),
                cc.MoveTo:create(0.5, cc.p(size.width/2, size.height/2))

            )
            local jump = cc.JumpBy:create(1, cc.p(0, 0), 10, 2)

            local callback=cc.CallFunc:create(function()
                if type(callBack) == "function" then

                    callBack()

                end

            end)

            local logo_seq = cc.Sequence:create(action, jump, cc.DelayTime:create(0.5), callback)

            self._logo:runAction(logo_seq)
        end

    end,

    switchInEnd = function(self, callBack)
        U:debug("switchInEnd==================")

        local left_cloud_size = self._leftCloud:getBoundingBox()
        local right_cloud_size = self._rightCloud:getBoundingBox()

        self._leftCloud:runAction(cc.MoveBy:create(1, cc.p(-left_cloud_size.width, 0)))
        self._rightCloud:runAction(cc.MoveBy:create(1, cc.p(right_cloud_size.width, 0)))

        --add 2.6
        Slot.Audio:playEffect("sound/common/"..Slot.MusicResources["common"]["windowshow"])

        if self._loadingLabel then
            self._loadingLabel:setVisible(false)

        end


        if self._logo then

            local action = cc.Spawn:create(
                cc.ScaleTo:create(1, 0.1),
                cc.FadeOut:create(1)
            )
            local seq_action = cc.Sequence:create(
                action,
                cc.CallFunc:create(function()
                    self.rootNode:getActionManager():removeAction(action)
                    self.rootNode:setVisible(false)
                    self.rootNode:removeFromParent(true)
                    self.rootNode = nil

                    if type(callBack) == "function" then

                        callBack()

                    end

                    --1.05 发送一个动画播放结束的事件
                    self:fireEvent("switch_end")

                end)
            )

            self._logo:runAction(seq_action)
        end



    end,

    getRootNode = function(self)

        Slot.Audio:stopMusic(true)
        
        if not self.rootNode then

            self.rootNode = cc.Layer:create()
            self.rootNode:setContentSize(self._winsize)

            self.rootNode:registerScriptTouchHandler(function(eventType, x, y)
                if eventType == "began" then -- touch began

                    local rect=cc.rect(0,0,self._winsize.width,self._winsize.height)
                    if not cc.rectContainsPoint(rect, self.rootNode:convertToNodeSpace(cc.p(x,y))) then -- rect:containsPoint() then
                        return false
                    end
                    return true
                end

            end, false, self._options.priority, true)
            self.rootNode:setTouchEnabled(true)
--            self.rootNode:setVisible(false)
        end

        return self.rootNode
    end,

    getDefaultOptions = function(self)

        return U:extend(false, self:_super(), {
            nodeEventAware=true,
            priority = Slot.TouchPriority.dialog,
            inset=cc.rect(40,40,40,40),
            onExit = function(opt)

                if self._interval then U:clearInterval(self._interval) end


            end
        })
    end,
})