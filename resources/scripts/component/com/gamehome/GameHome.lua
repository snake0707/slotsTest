--
--by bbf
--
require "modules.pages"
require "component.com.gamehome.GameHomeItem"

Slot = Slot or {}

Slot.com = Slot.com or {}

Slot.com.GameHome = Slot.ui.UIComponent:extend({

    __className = "Slot.com.GameHome",

    initWithCode = function(self, data, options)
        self:_super(options)

        self._data = Slot.MP:getModulesName()

        self:_setup()
    end,

    _setup = function(self)

        self:createGameList()
        self._list:reload()
    end,

    createGameList = function(self)

        local data = {}

        for k,v in pairs(self._data) do

            table.insert(data, v)

        end

--        table.insert(data, "coming_soon")

        local commondata = Slot.DM:getCommonData()
        local baseprofile = Slot.DM:getBaseProfile()
        local level = baseprofile.level
        if baseprofile.level > #commondata["levelup_data"] then
            level = #commondata["levelup_data"]
        end

        local unlock = commondata["levelup_data"][level]["unlock"]
        local size = self.rootNode:getContentSize()
        self._list = Slot.ui.List:new({
            direction = 0,
            pageSize = 50,
            spacing = 0,
            hasmargin = true,
            frameWidth = size.width,
            frameHeight = size.height,
            cellSize = function()

            end,
            ignoremove=true,
            cellAtIndex = function(opt, data, index, _list)
                local cell = Slot.com.GameHomeItem:new(data, {
                    id = index,
                    unlock = index <= tonumber(unlock),

                })
                return cell
            end,
            loadFunc = function(opt, slider, current, page)

                self._list:appendData(data)
            end
        })

--        self._list:appendData(self._data)

        self._list:getRootNode():ignoreAnchorPointForPosition(false)
        self._list:getRootNode():setAnchorPoint(cc.p(0,0))
--        self._list:getRootNode():setPositionY(Slot.Margin.poster.bottom)
        self.rootNode:addChild(self._list:getRootNode())

        local size = self.rootNode:getContentSize()
        local emptySize = cc.size(self._options.emptySize.width, self._options.emptySize.height - Slot.Margin.poster.top * 2)

        self.rootNode:setPositionY(self._options.emptySize.height/2 - size.height/2)

    end,


    getRootNode = function(self)

        if not self.rootNode then
            self.rootNode = cc.Node:create()

            local tmpSprite = U:getSpriteByName("poster_west.png")

            self.rootNode:setContentSize(cc.size(self._options.emptySize.width, tmpSprite:getContentSize().height))
--            self.rootNode:setPositionY(self._options.emptySize.height/2-self._options.frameWidth/2)
            --动画层
--            self.bg = cc.Node:create()
--            self.bg:setAnchorPoint(ccp(0,0))
--            self.bg:setContentSize(cc.size(self._options.frameWidth, self._options.frameHeight))

        end
        return self.rootNode
    end,

    getDefaultOptions = function(self)
        return {
            nodeEventAware = true,
        }
    end
})