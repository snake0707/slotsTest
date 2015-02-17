--
-- by bbf
--

Slot.pages.MaintainPage = Slot.pages.Page:extend({

    __className = "Slot.ui.MaintainPage",

    initWithCode = function(self,options)
        self:_super(options)

        self:addContent()
    end,


    addContent = function(self)

        self:createIcon()

        self:createTips()

    end,


    createIcon = function(self)
        local icons = Slot.start_page_icons

        local left = self._winsize.width
        for k, v in pairs(icons) do
            local tsprite =U:getSpriteByName("start_page_"..v..".png")
            local tsize = tsprite:getContentSize()
            left = left - tsize.width
        end

        left = (left - Slot.Margin.start_page_icons.left * 3) / 2


        local bottom = self._winsize.height/2 + Slot.Margin.start_page_icons.bottom

        for k, v in pairs(icons) do

            local sprite =U:getSpriteByName("start_page_"..v..".png")
            local size = sprite:getContentSize()
            sprite:setPosition(cc.p(left + size.width/2, bottom))
            self.rootNode:addChild(sprite)

--            local action = {}

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
        local sprite = U:getSpriteByName("game_logo.png")
        sprite:setPosition(cc.p(self._winsize.width/2,self._winsize.height/2 + Slot.Margin.start_page_icons.bottom))
        self.rootNode:addChild(sprite)

        --添加星星闪烁 1.05
        local width=self.rootNode:getContentSize().width
        local height=self.rootNode:getContentSize().height

        local posTab={
            cc.p(width/4,height*5/6),cc.p(width/2,height*5/6),cc.p(width*3/4,height*5/6),
            cc.p(width/4-100,height*5/6+50),cc.p(width/2-100,height*5/6+100),cc.p(width*3/4-100,height*5/6+80),
            cc.p(width*3/4+100,height*5/6+50),cc.p(width/2-80,height*5/6-50),cc.p(width/4-150,height*5/6-100),


            cc.p(width*3/4,height/2+150),cc.p(width/4-250,height*5/6-200),cc.p(width*3/4+210,height/2+130),
            cc.p(width/4+200,height/2+50),cc.p(width*3/4-100,height*2/3+100),cc.p(width/4,height/2+250),
            cc.p(width/2-100,height*5/6-100),cc.p(width*3/4-200,height*2/3+300),

            cc.p(width/4+100,height*5/6),cc.p(width*3/4,height*2/3+100),cc.p(width/2,height*5/6-100),

        }
        math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
        Slot.animation:lightAction(self.rootNode,posTab,1,0.2,true)


    end,

    createTips = function(self)

        local pagePara = self._options.pagePara

        if pagePara and pagePara.start_time and pagePara.time then

            local title = cc.Label:createWithSystemFont(U:locale("maintain", "title"), self._options.font, 80)
--            local tips = cc.Label:createWithSystemFont(U:locale("maintain", "tips", {start_time = pagePara.start_time, time = pagePara.time}), self._options.font, self._options.fontSize)
            local tips = Slot.ui.SmartLabel:new({
                text = U:locale("maintain", "tips", {start_time = pagePara.start_time, for_time = math.ceil(tonumber(pagePara.time)/3600)}),
                fontSize = self._options.fontSize,
                preferredWidth = self._winsize.width - 100,
                color = Slot.CCC3.white,
            })
            title:setPosition(cc.p((self._winsize.width) / 2, (self._winsize.height) / 4 ))
            tips:setPosition(cc.p((self._winsize.width) / 2 - tips:getContentSize().width/2, (self._winsize.height) / 5 - tips:getContentSize().height))
            self.rootNode:addChild(title)
            self.rootNode:addChild(tips:getRootNode())

        end

    end,

    _addHeader = function(self) end,

    _addFooter = function(self) end,

    _addBody = function(self) end,

    getCommonResources = function(self)

        return {
            "plist/common/common.plist",
            "plist/common/start_page.plist",
        }

    end,

    getRootNode = function(self)
        if not self.rootNode then

            local bg=self._options.bg
            local texture = cc.Director:getInstance():getTextureCache():addImage(bg)
            local sprite=cc.Sprite:createWithTexture(texture)
            local rect=self._options.inset
            local x,y,x1,y1=rect.x,rect.y,sprite:getTextureRect().width-(rect.x+rect.width),sprite:getTextureRect().height-(rect.y+rect.height)
            self.rootNode = cc.Scale9Sprite:create(cc.rect(x,y,x1,y1),bg)

--            self.rootNode = cc.Scale9Sprite:create("common/start_page_bg.jpg")
            self.rootNode:setContentSize(self._winsize)
            self.rootNode:setAnchorPoint(cc.p(0.5,0.5))
            self.rootNode:setPosition(cc.p(self._winsize.width/2,self._winsize.height/2))

        end
        return self.rootNode
    end,


    getDefaultOptions = function(self)
        return {
            nodeEventAware  = true,
            transition      = true,
            layout          = "absolute",
            fontSize        = 60,
            font        = Slot.Font.default,
            onExit = function(self)
                self.rootNode:stopAllActions()
                if Slot.Configuration.DEBUG == "false" then
                    cc.OASSdk:getInstance():unregisterHandler(Slot.SdkType.LOGIN)
                end
                Slot.SpriteCacheManager:removeSpriteFrameByFile("plist/common/start_page.plist")
                Slot.SpriteCacheManager:removeSpriteFrameByFile("plist/common/common.plist")
                cc.Director:getInstance():getTextureCache():removeTextureForKey(that._options.bg)
            end,
            inset=cc.rect(0,0,0,0),
            bg = "common/start_page_bg.jpg",

            keyName="common"
        }
    end

})