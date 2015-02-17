--
--by bbf
--

Slot = Slot or {}

Slot.com = Slot.com or {}

Slot.com.Paytable = Slot.ui.Dialog:extend({

    __className = "Slot.com.Paytable",

    initWithCode = function(self, options)
        self:_super(options)

--        self:_setup()
    end,

    _setup = function(self)
        self.reeldata =  Slot.DM:getCurrentReelData()
        self.payTableData = self.reeldata["paytable"]
        self._options.content = self:_createContent()

        self:_super()
    end,

    _createContent = function(self)

        local content = cc.Node:create()
        content:setContentSize(cc.size(self._options.frameWidth, self._options.frameHeight))

        self:createList()
        self._list:load()

        content:addChild(self._list:getRootNode(), Slot.ZIndex.Dialog+1)

        return content
    end,

    createList = function(self)


        self._list = Slot.ui.List:new({
            direction = 0,
            pageSize = 50,
            spacing = 0,
            hasmargin = true,
            priority=Slot.TouchPriority.dialog,
            frameWidth = self._options.frameWidth,
            frameHeight = self._options.frameHeight,
            onItemClick=function() end,
            cellSize = function()
            end,
            cellAtIndex = function(opt, data, index, _list)
                return self:createPaytableItem(data)
            end,
            loadFunc = function(opt, slider, current, page)
                self._list:appendData(self._options.paytable)
            end
        })

        return self._list
--        self._list:getRootNode():ignoreAnchorPointForPosition(false)
--        self._list:getRootNode():setAnchorPoint(cc.p(0,0))
--        self._list:getRootNode():setPositionY(Slot.Margin.poster.bottom)
--        self:getRootNode():addChild(self._list:getRootNode(), Slot.ZIndex.Dialog)

    end,


    createPaytableItem = function(self, index)
        if index == 1 then
            return self:paytableOne()
        elseif index == 2 then
            return self:paytableTwo()
        else
            return self:paytableThree()
        end

    end,

    paytableOne = function(self)
        self.proxy = Slot.CCBProxy:new()
        self.paytableOne  = self.proxy:readCCBFile(self._options.payTableOne)
        self.paytableOne:addChild(self.proxy:getRootNode())

        self.content_title = self.proxy:getNodeWithName("content_title")
        self.special_node = self.proxy:getNodeWithName("special_node")
        self.common_node = self.proxy:getNodeWithName("common_node")


        for k, v in ipairs(self._options.component) do

            local node = self.proxy:getNodeWithName("icon_"..v)

            --icon
            local scale9Sprite = self:createIcon(v)
            local size = node:getContentSize()
            scale9Sprite:setPreferredSize(size)
            scale9Sprite:setPosition(cc.p(size.width/2, size.height/2))
            node:addChild(scale9Sprite)

            --text
--            local pos = cc.p(node:getPosition())
--            local label = self:createPayLabel(v)
--            if label then
--                label:setAnchorPoint(cc.p(0, 0.5))
--                label:setPosition(cc.p(pos.x + size.width/2 + Slot.Margin.paytable.left, pos.y))
--                node:getParent():addChild(label:getRootNode())
--            end
--
--            if self:isSpecial(v) then
--
--                local specialLabel = self:createSpecialLabel(v)
--
--                if v == 50 then
--                    local pSize = node:getParent():getContentSize()
--                    specialLabel:setAnchorPoint(cc.p(0.5, 1))
--                    specialLabel:setPosition(cc.p(pSize.width/2, pos.y - Slot.Margin.paytable.bottom))
--                    node:getParent():addChild(specialLabel:getRootNode())
--                else
--                    specialLabel:setAnchorPoint(cc.p(0.5, 1))
--                    specialLabel:setPosition(cc.p(pos.x + size.width/2 + Slot.Margin.paytable.left, pos.y))
--                    node:getParent():addChild(specialLabel:getRootNode())
--                end
--
--            end
        end
        return self.paytableOne

    end,

    isSpecial = function(self, index)
       if index == 50 or index == 100 or index == 200 then return true end
       return false
    end,

    createSpecialLabel = function(self, id)

        local text = ""
        local preferredWidth = 40
        if id == 50 then
            text = "Wild symbots can substitute any other symbot except bonus and scatter"
            preferredWidth = 80
        end

        if id == 100 then
            text = "3 or more scatter symbots anywhere win XX free spins"
        end

        if id == 200 then
            text = "3 or more bonus symbots on a pauline start the bonus game"
        end

        return Slot.ui.SmartLabel:new({
            text = text,
            fontSize = 14,
            preferredWidth = preferredWidth,
            color = Slot.CCC3.white
        })
    end,

    createIcon = function(self, id)
        local icon = "modules/"..self._options.modulename.."/"..id..".png"
        local sprite = cc.Sprite:create(icon)
        local rect = self._options.inset
        local x,y,x1,y1=rect.x,rect.y,sprite:getTextureRect().width-(rect.x+rect.width),sprite:getTextureRect().height-(rect.y+rect.height)
        return cc.Scale9Sprite:create(cc.rect(x,y,x1,y1),icon)

    end,

    createPayLabel = function(self,id)

        local paytable = {}
        local paytable_data = self.payTableData[id] or {}
        for k, v in pairs(paytable_data) do
            local s, e = string.find(k, 'inar')
            if s and v ~= 0 then
                local pt = tonumber(string.sub(k, e+1, string.len(k)))
                paytable[pt] = v
            end
        end

        local text = {}

        for k, v in pairs(paytable) do

            local key = k
            if #text > 0 then key = "\n"..k end
            table.insert(text, {
                text = key,
                color = Slot.CCC3.yellow,
                fontSize = 20
            })

            table.insert(text, {
                text = v,
                color = Slot.CCC3.white,
                fontSize = 14
            })

        end

        if #text <= 0 then return nil end

        return Slot.ui.SmartLabel:new({
            text = text,
            fontSize = 14,
            preferredWidth = 10,
            color = Slot.CCC3.white
        })


    end,


    paytableTwo = function(self)

       local node = cc.Node:create()
       node:setContentSize(cc.size(self._options.frameWidth, self._options.frameHeight))

       local sprite = U:getSpriteByName("paytable_lines.png")
       --local sprite = cc.Sprite:create("modules/"..self._options.modulename.."/".."paytable_two.png")


       sprite:setPosition(cc.p(self._options.frameWidth/2, self._options.frameHeight/2))
       node:addChild(sprite)
       return node
    end,

    paytableThree = function(self)
--        local text = {
--            {
--                text = "● All active lines pay left to right except the scatter and bonus\n\n"
--            },
--
--            {
--                text = "● Wild symbols can subsitute any other symbol except the scatter and bonus\n\n"
--            },
--
--            {
--                text = "● All line payouts are multiplied by line bet\n\n"
--            },
--
--            {
--                text = "● Only the highest win is paid on each payline"
--            }
--        }
--        local text =  "● All active lines pay left to right except the scatter and bonus\n● Wild symbols can subsitute any other symbol except the scatter and bonus\n● All line payouts are multiplied by line bet\n● Only the highest win is paid on each payline"
--
--        return Slot.ui.SmartLabel:new({
--            text = text,
--            fontSize = 64,
--            preferredWidth = 1660,
--            color = Slot.CCC3.white
--        })
        local node = cc.Node:create()
        node:setContentSize(cc.size(self._options.frameWidth, self._options.frameHeight))
        local label = cc.Sprite:create("common/paytable_three.png")
        label:setPosition(cc.p(self._options.frameWidth/2, self._options.frameHeight/2))
        node:addChild(label)

        return node

    end,



--    getRootNode = function(self)
--        if not self.rootNode then
--            self.rootNode = cc.Node:create()
--            self.rootNode:setContentSize(cc.size(self._options.frameWidth, self._options.frameHeight))
--
--        end
--        return self.rootNode
--    end,

    getDefaultOptions = function(self)
        return U:extend(false, self:_super(),{
            nodeEventAware = true,
            title = cc.Sprite:create("common/paytable_text.png"),
            component = {1,2,3,4,5,6,7,8,9,10,50,100,200},
            paytable = {1,2,3},
            payTableOne = "ccbi/PayTableOne.ccbi",
            modulename = "west",
            inset=cc.rect(10,10,10,10),
            margin = {l = 100, r = 100, t = 200, b = 54},
            frameWidth = 1656,
            frameHeight = 1016,
        })
    end
})