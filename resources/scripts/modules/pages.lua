--
-- by bbf
--


Slot = Slot or {}

Slot.modules = Slot.modules or {}

Slot.modules.pages = {

    modulesTable = {},

    gamesTable = {},

    modulesName = {},

    --[[
    --
    -- modules
    --
    -- ]]--
    _initModulesTable = function(self)
        require "modules.west.WestPage"
        require "modules.blackhand.BlackHandPage"
        require "modules.girl.GirlPage"
        require "modules.hawaii.HawaiiPage"
--        self:addModule("index", Slot.pages.modules)
        self:addModule("west", Slot.modules.westPage)
        self:addModule("blackhand", Slot.modules.BlackHandPage)
        self:addModule("girl", Slot.modules.GirlPage)
        self:addModule("hawaii", Slot.modules.HawaiiPage)
        self:addModule("london_cs", Slot.modules.LondonPage)
        self:addModule("roma_cs", Slot.modules.RomaPage)
        self:addModule("monaco_cs", Slot.modules.MonacoPage)

    end,

    addModule = function(self,module,action)
        self.modulesTable[module] =  action
        table.insert(self.modulesName, module)
    end,

    getModulesTable = function(self)

        if not next(self.modulesTable) then
            self:_initModulesTable()
        end

        return self.modulesTable

    end,

    getModulesName = function(self)

        if #self.modulesName <= 0 then
            self:_initModulesTable()
        end

        return self.modulesName

    end,


    --[[
    --
    -- game_tables
    --
    -- ]]--

    _initGamesTable = function(self)

        require "modules.west.HighNoonPage"
        require "modules.blackhand.BlackHandCardPage"
        require "modules.girl.GirlLuckyPlatePage"
        require "modules.hawaii.HawaiiParadisePage"



        self:addGame("west", Slot.modules.HighNoonPage)
        self:addGame("blackhand", Slot.modules.BlackHandCardPage)
        self:addGame("girl", Slot.modules.GirlLuckyPlatePage)
        self:addGame("hawaii", Slot.modules.HawaiiParadisePage)

    end,


    addGame = function(self,module,action)
        self.gamesTable[module] =  action
    end,

    getGamesTable = function(self)

        if not next(self.gamesTable) then
           self:_initGamesTable()
        end

        return self.gamesTable

    end,
}

Slot.MP = Slot.modules.pages



