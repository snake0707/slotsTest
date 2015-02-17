--
-- by bbf
--

Slot.const = Slot.const or {}
Slot.const.titleboard = {
    titleheight = 140
}
Slot = Slot or {}

Slot.ui = Slot.ui or {}

Slot.ui.TitleBoard = Slot.ui.UIComponent:extend({
    __className = "Slot.ui.TitleBoard",

    initWithCode = function(self, options)
        self:_super(options)
        self:_setup()
    end,

    _setup = function(self)

        self:setBoardSize()
        self:addTitle()
        self:addContent()
    end,

    createContent = function(self)

        if self._options.content_bg then
            local content  = cc.Scale9Sprite:create(self._options.content_bg)
--            local size = content:getContentSize()
--            if U:isUI(self._options.content) then self._options.content = self._options.content:getRootNode() end
            local csize = self._options.content:getContentSize()

            local m = self._options.in_margin
            local size = cc.size(csize.width + m.l + m.r, csize.height + m.t + m.b)
            content:setPreferredSize(size)

            local p = self._options.content:getAnchorPoint()
            if self._options.content:isIgnoreAnchorPointForPosition() then p=cc.p(0,0) end
            self._options.content:setPosition(size.width/2+(p.x-0.5)*csize.width, size.height/2+(p.y-0.5)*csize.height)
            content:addChild(self._options.content, Slot.ZIndex.Dialog)

            return content
        end

        return self._options.content
    end,

    getContent = function(self)
        if not self.content then
            self.content = self:createContent()
        end
        return self.content
    end,

    setBoardSize = function(self)
        local m = self._options.margin
        local conSize = self:getContent():getContentSize()
        self.size = cc.size(conSize.width + m.l + m.r, conSize.height + m.t + m.b + Slot.const.titleboard.titleheight)
        self.rootNode:setPreferredSize(self.size)
    end,

    addTitle = function(self)
        if type(self._options.title) == "string" then
            self.title = cc.LabelTTF:create(self._options.title, Slot.Font.bold, 50)
            self.title:setColor(self._options.titleColor)


        else
            self.title = self._options.title
        end

        U:addToHCenter(self.title, self.rootNode, 0, Slot.ZIndex.Dialog)
        self.title:setPositionY(self.size.height - Slot.const.titleboard.titleheight / 2 - 100)

    end,

    addContent = function(self)
        self.content = self:getContent()
        self.content:setAnchorPoint(cc.p(0,0))
        self.content:setPosition(self._options.margin.l, self._options.margin.b)
        self.rootNode:addChild(self.content)
    end,

    getRootNode = function(self)
        if not self.rootNode then
            local bg=self._options.bg
            local sprite=cc.Sprite:create(bg)
            local rect=self._options.inset
            local x,y,x1,y1=rect.x,rect.y,sprite:getTextureRect().width-(rect.x+rect.width),sprite:getTextureRect().height-(rect.y+rect.height)
            self.rootNode = cc.Scale9Sprite:create(cc.rect(x,y,x1,y1),bg)
        end
        return self.rootNode
    end,

    getDefaultOptions = function(self)
        return U:extend(false, self:_super(), {
            bg = "common/titleboard_bg.png",
            content_bg = "common/content_bg.png",
            title = "",
            inset=cc.rect(15,15,15,15),
            content = cc.Node:create(),
            margin = {l = 20, r = 20, t = 10, b = 20},
--            content_inset=cc.rect(5,5,5,5),
            in_margin = {l = 5, r = 5, t = 1, b = 5},
            titleColor=Slot.CCC3.toastColor,
        })
    end
})