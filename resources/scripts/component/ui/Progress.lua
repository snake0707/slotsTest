--
-- by bbf
--
Slot = Slot or {}

Slot.ui = Slot.ui or {}

Slot.ui.Progress = Slot.ui.UIComponent:extend({

    __className = "Slot.ui.Progress",

    initWithCode = function(self,options)
        self:_super(options)

        self:createProgress()
        self:refresh()
    end,

    createProgress = function(self)

        local bg

        local progressBg =U:getSpriteByName(self._options.background)

        local size = progressBg:getContentSize()
        self.rootNode:setContentSize(size)
        progressBg:setAnchorPoint(cc.p(0.5,0.5))
        progressBg:setPosition(size.width / 2, size.height / 2)

        self.rootNode:addChild(progressBg)

        self.progress = cc.ProgressTimer:create(U:getSpriteByName(self._options.bar))

        self.progress:setType(cc.PROGRESS_TIMER_TYPE_BAR)
        -- Setup for a bar starting from the left since the midpoint is 0 for the x
        self.progress:setMidpoint(cc.p(0, 0))
        -- Setup for a horizontal bar since the bar change rate is 0 for y meaning no vertical change
        self.progress:setBarChangeRate(cc.p(1, 0))
        --        left:runAction(cc.RepeatForever:create(to1))
        self.progress:setAnchorPoint(cc.p(0.5, 0.5))
        self.progress:setPosition(size.width / 2, size.height / 2)
        self.rootNode:addChild(self.progress)


        if self._options.labelTemplate then
            --当前进度，10%或10/100

            self._percent=cc.LabelBMFont:create("","font/common/win_coin_base.fnt")
            self._percent:setPosition(size.width / 2, size.height / 2)
            self.rootNode:addChild(self._percent)
        end

        self:createIcon()

        if self._options.enabledClick then
            local sc = Slot.ui.ScriptControl:new()
            sc:getRootNode():setContentSize(self.rootNode:getContentSize())
            sc:getRootNode():setAnchorPoint(cc.p(0,0))
            sc:getRootNode():setPosition(cc.p(0,0))
            sc:bind("click",function()
                self._options.click()
            end)

            self.rootNode:addChild(sc:getRootNode())
        end

    end,

    createIcon = function(self)

        if self._options.icon then
            self.icon = U:getSpriteByName(self._options.icon)
            self.icon:setAnchorPoint(cc.p(0.5, 0.5))
            self.icon:setPosition(cc.p(self.icon:getContentSize().width/6+Slot.Offset.baseprofile.xpicon_left, self.rootNode:getContentSize().height/2+Slot.Offset.baseprofile.xpicon_bottom))
            self.rootNode:addChild(self.icon)
        end

        if self._options.icon_value then
            local size = self.icon:getContentSize()
            self.icon_value=cc.LabelBMFont:create(self._options.icon_value,"font/common/levelNum.fnt")
            self.icon_value:setScale(0.7)
            self.icon_value:setAnchorPoint(cc.p(0.5,0.5))
            self.icon_value:setPosition(cc.p(size.width/2-Slot.Offset.baseprofile.xpiconValue_left, size.height/2-Slot.Offset.baseprofile.xpiconValue_bottom))
            self.icon:addChild(self.icon_value)
        end

    end,

    iconvalue = function(self, value)
        self.icon_value:setString(value)
    end,

    getIcon = function(self)
        return self.icon
    end,

    refresh = function(self)

        local p = self:percentage()
        --local per = p.."%"

        local per = p
        local div = self._options.value.."/"..(self._options.max - self._options.min)
        --设置宽度
        --        self._bar:setScaleX(p/100)
        --        self.progress:setPercentage(p)
        self.progress:runAction(cc.ProgressTo:create(1, p))


        if self._options.labelTemplate then
            if (self._options.labelTemplate == "percent") then


                self._percent:setString(per)


            elseif (self._options.labelTemplate == "divide") then

                self._percent:setString(div)


            elseif (self._options.labelTemplate == "value") then
                self._percent:setString(self._options.value)
            elseif (self._options.labelTemplate == "totalvalue") then


                if not self._options.totalvalue then return end

                local str=U:formatNumber(tostring(self._options.totalvalue))

                self._percent:setString(str)
            end
        end

    end,

    --百分值
    percentage = function(self)

        local p = math.ceil(100 * self._options.value / (self._options.max - self._options.min))
        if (p > 100) then
            p = 100
        elseif (p < 0) then
            p = 0
        end
        return p
    end,

    value = function(self, value, totalvalue)

        if self._options.labelTemplate == "totalvalue" and not totalvalue then return self._options.totalvalue end
        if self._options.labelTemplate ~= "totalvalue" and not value then return self._options.value end

        self._options.value = value
        self._options.totalvalue = totalvalue
        self:refresh()
    end,

    max = function(self, max)
        if (max == nil) then
            return self._options.max
        end
        self._options.max = max
        self:refresh()
    end,

    -- 显示进度条上文字
    showPercent = function(self)
        self._percent:setVisible(true)
    end,

    -- 隐藏进度条上文字
    hidePercent = function(self)
        self._percent:setVisible(false)
    end,

    getRootNode = function(self)
        if not self.rootNode then
            self.rootNode = cc.Node:create()

        end
        return self.rootNode
    end,

    getDefaultOptions  = function(self)
        return {
            width = 100,
            height = 15,
            max = 100,
            min = 0,
            value = 0,
            labelTemplate = "percent",--"#{percent}" represents the "xx%" data, and "#{divide}" represent "xx/xx" data
            background = "common/progress_bg.png", -- optional, could be false
            bar = "common/progress_value.png", -- required
            border = 1,
            fontColor = Slot.CCC3.white,
            fontSize = 60,
            icon = nil, -- 进度条的头部图标,
            enabledClick = false,
            click = function() end,
        }
    end,
})