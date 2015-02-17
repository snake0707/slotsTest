--
-- Created by IntelliJ IDEA.
-- User: bbf
-- Date: 15-1-5
-- Time: 下午12:19
-- To change this template use File | Settings | File Templates.
--

Slot = Slot or {}

Slot.com = Slot.com or {}

Slot.com.PaytableDlg = Slot.ui.CCBDialog:extend({

    __className = "Slot.com.PaytableDlg",

    initWithCode = function(self, options)
        self:_super(options)

    end,

    _setup = function(self)
        self.reeldata =  Slot.DM:getCurrentReelData()
        self.payTableData = self.reeldata["paytable"]

        self.page_select_1 = self.proxy:getNodeWithName("page_select_1")
        self.page_select_2 = self.proxy:getNodeWithName("page_select_2")
        self.page_select_3 = self.proxy:getNodeWithName("page_select_3")
        self.page_no_select_1 = self.proxy:getNodeWithName("page_no_select_1")
        self.page_no_select_2 = self.proxy:getNodeWithName("page_no_select_2")
        self.page_no_select_3 = self.proxy:getNodeWithName("page_no_select_3")

        self.content_bg = self.proxy:getNodeWithName("content_bg")

        self:createList()
        self.content_bg:addChild(self._list:getRootNode(), Slot.ZIndex.Dialog+10)
        self._list:setPosition(cc.p(Slot.Offset.paytable.left,0))
        self:_setPageSelect()
        self:_registEvent()
        self:_super()
    end,

    _setPageSelect = function(self)

        local index = self._list:getCurPageIndex() + 1

        for i=1, 3 do

            self["page_select_"..i]:setVisible(false)
--            self["page_no_select_"..i]:setVisible(true)
        end

        self["page_select_"..index]:setVisible(true)


    end,

    _registEvent = function(self)

        self._list:registEvent(function()

            self:_setPageSelect()

        end)

        for i=1, 3 do

            self["select_"..i] = Slot.ui.ScriptControl:new({
                touchPriority = self._options.priority,--Slot.TouchPriority.dialog_list_item,
                swallow = true,
            })
            self["select_"..i]:getRootNode():setContentSize(self["page_no_select_"..i]:getContentSize())
            self["select_"..i]:getRootNode():setAnchorPoint(cc.p(0,0))
            self["select_"..i]:getRootNode():setPosition(cc.p(0,0))
            self["page_no_select_"..i]:addChild(self["select_"..i]:getRootNode())
            self["select_"..i]:bind("click",function()

--                self._list:scrollToPage((i-1))
                if not self["page_select_"..i]:isVisible() then
                    self._list:scrollToPage(i-1)
                end

            end)

        end
       self:_super()

    end,

    createList = function(self)

        self._list = Slot.ui.PageView:new({

            frameWidth = self._options.frameWidth,
            frameHeight = self._options.frameHeight,

            cellAtIndex = function(opt, data, index, _list)
                return self:createPaytableItem(data)
            end,
            loadFunc = function(opt, slider, current, page)
                self._list:appendData(self._options.paytable)
            end
        })

        self._list:load()

        return self._list

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
        
        --Slot.SpriteCacheManager:removeSpriteFrameByName("plist/common/payTable.plist")

        self.paytableOne_proxy = Slot.CCBProxy:new()
        self.paytableOne  = self.paytableOne_proxy:readCCBFile(self._options.payTableOne)
        self.paytableOne:addChild(self.paytableOne_proxy:getRootNode())

        self.content_title = self.paytableOne_proxy:getNodeWithName("content_title")
        self.special_node = self.paytableOne_proxy:getNodeWithName("special_node")
        self.common_node = self.paytableOne_proxy:getNodeWithName("common_node")

        self.content_title:setString(U:locale("paytable", "pageone_title"))

        for k, v in ipairs(self._options.component) do

            local node = self.paytableOne_proxy:getNodeWithName("icon_"..v)

            --icon
            local scale9Sprite = self:createIcon(v)
            local size = node:getContentSize()
            scale9Sprite:setPreferredSize(size)
            scale9Sprite:setPosition(cc.p(size.width/2, size.height/2))
            node:addChild(scale9Sprite)

            --text
            local pos = cc.p(node:getPosition())
            local label = self:createPayLabel(v)
            if label then
                label:setAnchorPoint(cc.p(0, 0.5))
                label:setPosition(cc.p(pos.x + size.width + Slot.Margin.paytable.left, pos.y))
                node:getParent():addChild(label:getRootNode())
            end

            if self:isSpecial(v) then

                local specialLabel = self:createSpecialLabel(v, node:getParent())

                if v == 50 then
                    local pSize = node:getParent():getContentSize()
                    specialLabel:setAnchorPoint(cc.p(0.5, 1))
                    specialLabel:setPosition(cc.p(pSize.width/2 + Slot.Margin.paytable.left, pos.y - size.height/2 - Slot.Margin.paytable.bottom))
                    node:getParent():addChild(specialLabel:getRootNode())
                else
                    specialLabel:setAnchorPoint(cc.p(0, 0.5))
                    specialLabel:setPosition(cc.p(pos.x + size.width + Slot.Margin.paytable.left, pos.y))
                    node:getParent():addChild(specialLabel:getRootNode())
                end

            end
        end
        return self.paytableOne

    end,

    isSpecial = function(self, index)
        if index == 50 or index == 100 or index == 200 then return true end
        return false
    end,

    createSpecialLabel = function(self, id, node)

        local size = node:getContentSize()
        local text = ""
        local preferredWidth = size.width/2
        if id == 50 then
            text = U:locale("paytable", "wild_desc")
            preferredWidth = size.width
        end

        if id == 100 then
            text = U:locale("paytable", "scatter_desc")

            local data=Slot.libs.DataManager:getReelData().config
            local freeSpinNum=data[1].freespin3
            text=text..freeSpinNum.." free spins"

        end

        if id == 200 then
            text = U:locale("paytable", "bonus_desc")
        end

        return Slot.ui.SmartLabel:new({
            text = text,
            fontSize = Slot.FontSize.payTableOne.specialLabel,
            preferredWidth = preferredWidth,
            color = Slot.CCC3.white,
        })


    end,

    createIcon = function(self, id)

        --local icon =self._options.modulename.."_"..id..".png"
        U:addSpriteFrameResource("plist/modules/"..self._options.modulename.."/"..self._options.modulename..".plist")
        local icon =id..".png"

        local sprite = U:getSpriteByName(icon)
        local rect = self._options.inset
        local x,y,x1,y1=rect.x,rect.y,sprite:getTextureRect().width-(rect.x+rect.width),sprite:getTextureRect().height-(rect.y+rect.height)

        return U:get9SpriteByName(icon,cc.rect(x,y,x1,y1))

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

        local width = 0

        for k, v in pairs(paytable) do
            k = k.."   "
            local tk = cc.LabelTTF:create(k, Slot.Font.default, Slot.FontSize.payTableOne.payLabelInar)
            local tv = cc.LabelTTF:create(v, Slot.Font.default, Slot.FontSize.payTableOne.payLabel)

            local w = tk:getContentSize().width + tv:getContentSize().width

            if width < w then width = w end

            local key = k
--            if #text > 0 then key = "\n"..k end

            if tonumber(k) < 5 then key = "\n"..k end

            table.insert(text, 1, {
                text = v,
                color = Slot.CCC3.white,
                fontSize = Slot.FontSize.payTableOne.payLabel
            })

            table.insert(text, 1, {
                text = key,
                color = Slot.CCC3.yellow,
                fontSize = Slot.FontSize.payTableOne.payLabelInar
            })


        end

        if #text <= 0 then return nil end

        return Slot.ui.SmartLabel:new({
            text = text,
            fontSize = Slot.FontSize.payTableOne.payLabel,
            preferredWidth = width,
            color = Slot.CCC3.white,
            spacing = 5,
        })


    end,


    paytableTwo = function(self)

        U:addSpriteFrameResource("plist/modules/"..self._options.modulename.."/paytable.plist")

        local node = cc.Node:create()
        node:setContentSize(cc.size(self._options.frameWidth, self._options.frameHeight-2))

        local sprite = U:getSpriteByName("paytable_lines.png")
        local rect = cc.rect(0,0,0,0)
        local x,y,x1,y1=0,0,sprite:getTextureRect().width,sprite:getTextureRect().height

        --local sprite = cc.Sprite:create("modules/"..self._options.modulename.."/".."paytable_two.png")

--        sprite:setPosition(cc.p(self._options.frameWidth/2, self._options.frameHeight/2))
        local scale9sprite = U:get9SpriteByName("paytable_lines.png", cc.rect(x,y,x1,y1))
        scale9sprite:setPreferredSize(cc.size(self._options.frameWidth-10, self._options.frameHeight-20))
        node:addChild(scale9sprite)
        return node

    end,

    paytableThree = function(self)

        --Slot.SpriteCacheManager:removeSpriteFrameByName("plist/common/payTable.plist")
        local text = {
            {
                text = U:locale("paytable", "pagethree_lineone"),
            },
            {
                text = U:locale("paytable", "pagethree_linetwo"),
            },
            {
                text = U:locale("paytable", "pagethree_linethree"),
            },
            {
                text = U:locale("paytable", "pagethree_linefour"),
            }
        }

        local label = Slot.ui.SmartLabel:new({
            text = text,
            fontSize = Slot.FontSize.payTableThree,
            preferredWidth = self._options.frameWidth - Slot.Margin.default * 2,
            color = Slot.CCC3.white,
            spacing = 60,
        })

        local node = cc.Node:create()

        node:setContentSize(cc.size(self._options.frameWidth, self._options.frameHeight))
        node:setAnchorPoint(cc.p(0.5, 0.5))
        label:setAnchorPoint(cc.p(0.5, 0.5))
--        local label = cc.Sprite:create("common/paytable_three.png")
        label:getRootNode():setPosition(cc.p(self._options.frameWidth/2, self._options.frameHeight/2))

        node:addChild(label:getRootNode())

        return node
    end,

    getDefaultOptions = function(self)

        return U:extend(false, self:_super(),{
            nodeEventAware = true,
            component = {1,2,3,4,5,6,7,8,9,10,50,100,200},
            paytable = {1, 2, 3},
            ccbi = "ccbi/PayTableDlg.ccbi",
            modulename = "west",
            inset=cc.rect(10,10,10,10),
            showClose = true,
            frameWidth = 1656,
            --frameWidth = 1700,
            frameHeight = 1016,
            priority = Slot.TouchPriority.dialog,
            resources = {
                "common/titleboard_bg.png",
                "common/content_bg.png"
            }
        })
    end
})
