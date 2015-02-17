--
-- by bbf
--



Slot = Slot or {}
Slot.UpdateScene = {

    __className = "Slot.UpdateScene",

    initWithCode = function(self,options)
        self._winsize  = cc.Director:getInstance():getVisibleSize()
        self._options  = U:extend(false, self:getDefaultOptions(), options)
        self:getRootNode()
        self:addContent()
    end,

    addContent   = function(self)

        self:createIcon()

        self:createProgress()

        self:createLoading()


    end,

    createIcon = function(self)
        local icons = Slot.start_page_icons

        local left = self._winsize.width
        for k, v in pairs(icons) do
            local tsprite = cc.Sprite:create("common/start_page_"..v..".png")
            local tsize = tsprite:getContentSize()
            left = left - tsize.width
        end

        left = (left - Slot.Margin.start_page_icons.left * 3) / 2


        local bottom = self._winsize.height/2 + Slot.Margin.start_page_icons.bottom

        for k, v in pairs(icons) do

            local sprite = cc.Sprite:create("common/start_page_"..v..".png")
            local size = sprite:getContentSize()
            sprite:setPosition(cc.p(left + size.width/2, bottom))
            self.rootNode:addChild(sprite)

            U:setTimeout(function()
                local up = cc.MoveBy:create(2, cc.p(0, 6))
                local down = up:reverse()
                local delay = cc.DelayTime:create(0.25)
                local seq = cc.Sequence:create(up, delay, down, delay)
                sprite:runAction(cc.RepeatForever:create(seq))
            end,k*0.5)

            left = left + size.width + Slot.Margin.start_page_icons.left

            if  (#icons)/2 > k then
                bottom = bottom + size.height/2
            elseif (#icons)/2 < k then
                bottom = bottom - size.height/2
            end

        end

        -- 中间的图标
        local sprite = cc.Sprite:create("common/game_logo.png")
        sprite:setPosition(cc.p(self._winsize.width/2,self._winsize.height/2 + Slot.Margin.start_page_icons.bottom))
        self.rootNode:addChild(sprite)

    end,

    createProgress = function(self)

        local progressBg = cc.Sprite:create("common/start_page_progress_bg.png")
        progressBg:setAnchorPoint(cc.p(0.5,0.5))
        progressBg:setPosition(cc.p((self._winsize.width) / 2, (self._winsize.height) / 4))
        self.rootNode:addChild(progressBg)

        self.progress = cc.ProgressTimer:create(cc.Sprite:create("common/start_page_progress.png"))
        self.progress:setType(cc.PROGRESS_TIMER_TYPE_BAR)
        -- Setup for a bar starting from the left since the midpoint is 0 for the x
        self.progress:setMidpoint(cc.p(0, 0))
        -- Setup for a horizontal bar since the bar change rate is 0 for y meaning no vertical change
        self.progress:setBarChangeRate(cc.p(1, 0))
        --        left:runAction(cc.RepeatForever:create(to1))
        self.progress:setAnchorPoint(cc.p(0.5, 0.5))
        self.progress:setPosition(cc.p((self._winsize.width) / 2, (self._winsize.height) / 4 ))
        self.rootNode:addChild(self.progress)

        --        progress:runAction(to)

        self.progress:setPercentage(0)
    end,

    createLoading = function(self)
        self.loading = cc.Sprite:create("common/start_page_loading.png")
        self.loading:setAnchorPoint(cc.p(0.5,0.5))
        self.loading:setPosition(cc.p((self._winsize.width) / 2, (self._winsize.height) / 4 + 25))
        self.rootNode:addChild(self.loading)

        local show = cc.FadeIn:create(1)
        local showreverse = show:reverse()
        --        local hide = cc.FadeOut:create(1)
        --        local delay = cc.DelayTime:create(1)
        local seq = cc.Sequence:create(show, showreverse)
        self.loadingAction = cc.RepeatForever:create(seq)
        self.loading:runAction(self.loadingAction)

    end,

    getRootNode = function(self)
        if not self.rootNode then

            local bg=self._options.bg
            local sprite=cc.Sprite:create(bg)
            local rect=self._options.inset
            local x,y,x1,y1=rect.x,rect.y,sprite:getTextureRect().width-(rect.x+rect.width),sprite:getTextureRect().height-(rect.y+rect.height)
            self.rootNode = cc.Scale9Sprite:create(cc.rect(x,y,x1,y1),bg)

            self.rootNode:setContentSize(self._winsize)
            self.rootNode:setAnchorPoint(cc.p(0.5,0.5))
            self.rootNode:setPosition(cc.p(self._winsize.width/2,self._winsize.height/2))


        end
        return self.rootNode
    end,

    update = function(self)

        require "update.Update"

        local update = Slot.Update:initWithCode({
            callBack = function(percent, sec)

                if not sec then sec = 0.5 end
                local actions = {}
                local to = cc.ProgressTo:create(sec, percent)
                local switch = cc.CallFunc:create(function()
                    if percent == 100 then
--                        U:clearModule(true)
                        self._options.callBack()

                        self.loading:runAction(cc.FadeOut:create(0.5))
                        Slot.DM:userLogin(function()
                            Slot.App:switchTo("GameHome")
                        end)
                    end
                end)
                table.insert(actions,to)
                table.insert(actions,cc.DelayTime:create(0.5))
                table.insert(actions,switch)
                local seq = cc.Sequence:create(actions)

                self.progress:runAction(seq)

            end,
        })

    end,

    getDefaultOptions = function(self)
        return {
            nodeEventAware  = true,
            transition      = true,
            inset=cc.rect(0,0,0,0),
            bg = "common/start_page_bg.jpg",
        }
    end

}