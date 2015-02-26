--
-- by bbf
--


Slot.libs = Slot.libs or {}
--- global scene

Slot.libs.DataManager = {
    __listener = {},
    __data     = {},
--    __updateTimeStamp = {},
    __domain   = "",
    _userInfo = {}
}

Slot.libs.DataManager.getUserInfo = function(self)
    return self._userInfo
end


--[[
--
--
-- baseProfile的读写
--
--
-- ]]--


Slot.libs.DataManager.getBaseProfile = function(self)


    if not self.__data["baseprofile"] then

        self.__data["baseprofile"] = self:getLoaclBaseProfile()

    end
    return self.__data["baseprofile"]
end

Slot.libs.DataManager.initLoaclBaseProfile = function(self, profile)
    local sq = Slot.sqlite:new()
    sq:create("profile.db")
--    local now = os.time()

    sq:insertByKeys('tbl_baseprofile',profile)

    sq:close()

    self:getBaseProfile()

end

Slot.libs.DataManager.getLoaclBaseProfile = function(self)

    self:initLocalDB()

    local sq = Slot.sqlite:new()
    sq:create("profile.db")
    local rows = sq:readRows("tbl_baseprofile")

    if #rows <= 0 then
        self:initLoaclBaseProfile({id = 1})
        rows = sq:readRows("tbl_baseprofile")
    end

    sq:close()

    return rows[1]

end

Slot.libs.DataManager.setBaseProfile = function(self,data, notifyAll)
    if data==nil then return end
    self.__data["baseprofile"] = data

    if data then
        local sq = Slot.sqlite:new()
        local path = cc.FileUtils:getInstance():getWritablePath()
        path = path.."cache/profile.db"
        sq:create(path)
        sq:update("tbl_baseprofile", data, {id = 1})
        sq:close()

        local profile = self:getBaseProfile()

    end

   if notifyAll then self:_notifyAll("baseprofile") end

end


Slot.libs.DataManager.setOutputData = function(self,data)
    if data==nil then return end
    if data then
        local sq = Slot.sqlite:new()
        local path = cc.FileUtils:getInstance():getWritablePath()
        path = path.."cache/profile.db"
        sq:create(path)
        sq:insertByKeys("tbl_output", data)
        sq:close()
    end
end


--[[
--
--
-- heaprecharge的读写
--
--
-- ]]--


Slot.libs.DataManager.getHeapRecharge = function(self)

    self:initLocalDB()

    local sq = Slot.sqlite:new()
    sq:create("profile.db")

    local rows = self:manageDataToKV(sq:readRows("tbl_heaprecharge"), "payfor")

    sq:close()

    if #rows > 1 then
        table.sort(rows, function(a, b) return tonumber(a.payfor) > tonumber(b.payfor) end)
    end

    return rows

end


-- must connect to the internet to set
Slot.libs.DataManager.deleteHeapRecharge = function(self, data)


    local sq = Slot.sqlite:new()

    sq:create("profile.db")
    sq:delete("tbl_heaprecharge", condition)

    sq:close()

end


Slot.libs.DataManager.setHeapRecharge = function(self, data) -- todo::::用之前处理数据为区间值

    if not data then return end

    local values = {
        payfor = data.payfor,
        paytimes = data.paytimes,
        usetimes = data.usetimes,
    }


    local condition = {}
    if not values.payfor then
        error("payfor is not exist")
    else
        condition.payfor = values.payfor
    end

    local sq = Slot.sqlite:new()
    sq:create("profile.db")
    sq:update("tbl_heaprecharge", values, condition)

    sq:close()

end


--[[
--
--
-- slotbardata的读写,只是lastwin
--
--
-- ]]--

Slot.libs.DataManager.getSlotBarData = function(self)

    return self.__data["slotbar"] or {}

end


Slot.libs.DataManager.setSlotBarData = function(self,data)
    if data==nil then return end
    self.__data["slotbar"] = data
    self:_notifyAll("slotbar")
end


--[[
--
--
-- localstorage的读写
--
--
-- ]]--

Slot.libs.DataManager.getLocalStorage = function(self, key, flag)

    if self.__data["localstorage"] == nil then

        self.__data["localstorage"] = self:getLocalStorageFromDB()

    end

    return self.__data["localstorage"][key]
end


Slot.libs.DataManager.getLocalStorageFromDB = function(self)

    self:initLocalDB()

    local sq = Slot.sqlite:new()
    sq:create("profile.db")
    local rows = sq:readRows("tbl_localstorage")

    local ret = {}
    for i, v in pairs(rows) do
        ret[v.key] = v.value
    end

    sq:close()
    return ret
end

-- must connect to the internet to set
Slot.libs.DataManager.setLocalStorage = function(self, key, value, flag)

    self:initLocalDB()

    if flag == nil then flag = true end -- 标识每个不同的用户

    local sq = Slot.sqlite:new()

    sq:create("profile.db")
    sq:update("tbl_localstorage",{value = value}, {key = key})

    if self.__data["localstorage"] == nil then

        self.__data["localstorage"] = self:getLocalStorageFromDB()

    end
    self.__data["localstorage"][key] = value

    sq:close()
end


Slot.libs.DataManager.initCommonLocalStorage = function(self)

    self:initLocalDB()

    if self:getLocalStorage("common_fileLists_MD5", false) then return end

    local strjson = U:getJsonFromFile("common.json")

    local str_common_json = dkjson.encode(strjson)

    self:setLocalStorage("common_fileLists_MD5", str_common_json, false)

end

--[[
--
--
-- commondata的读写
--
--
-- ]]--


Slot.libs.DataManager.getCommonData = function(self)

    if not self.__data["common"] then
        self:initCommonData()
    end

    return self.__data["common"]

end

Slot.libs.DataManager.getCommonDataByKey = function(self, key)

    local ret
    if not self.__data["common"] then
        self:initCommonData()
    end
    if self.__data["common"] then ret = self.__data["common"][key] end

    return ret

end

Slot.libs.DataManager.initCommonData = function(self)

    local sq = Slot.sqlite:new()
    sq:create("storage/commondata.db")

    self.__data["common"] = {}
--    self.__data.common["bet_type"] = {1,2,5,10,20,50,100,200,500,1000}
    self.__data["common"]["levelup_data"] = self:manageDataToKV(sq:readRows("tbl_levelup_data"), "level")
    self.__data["common"]["payback_cl"] = self:manageDataToKV(sq:readRows("tbl_payback_cl"), "level")
    self.__data["common"]["payback_levelbet"] = self:manageDataToKV(sq:readRows("tbl_payback_levelbet"), "level")
    self.__data["common"]["payback_levelcl"] = self:manageDataToKV(sq:readRows("tbl_payback_levelcl"), "level")
    self.__data["common"]["payback_lose"] = self:manageDataToKV(sq:readRows("tbl_payback_lose"), "losetime")
    self.__data["common"]["payback_purchase"] = self:manageDataToKV(sq:readRows("tbl_payback_purchase"), "price")
    self.__data["common"]["payback_reel"] = self:sortDataByKey(sq:readRows("tbl_payback_reel"), "reelnumber")
    self.__data["common"]["timebonus_normal"] = self:sortDataByKey(sq:readRows("tbl_timebonus_normal"), "time")
    self.__data["common"]["timebonus_wheel"] = self:sortDataByKey(sq:readRows("tbl_timebonus_wheel"), "number")
    self.__data["common"]["shop"] = sq:readRows("tbl_shop")

--    self:getPaybackBet()
    self:getUnlockLevel()

    sq:close()
end

Slot.libs.DataManager.sortDataByKey = function(self, t, key)

    table.sort(t, function(a, b) return tonumber(a[key]) < tonumber(b[key]) end)

    return t

end

Slot.libs.DataManager.manageDataToKV = function(self, t, key)

    local ret = {}

    for i, v in pairs(t) do
        ret[v[key]] = v
    end

    return ret

end
Slot.libs.DataManager.getUnlockLevel = function(self)
    local levelup_data = self.__data["common"]["levelup_data"]
    local unlock_level  = {}

    for i, v in pairs(levelup_data) do
        if not unlock_level[tonumber(v.unlock)] or unlock_level[tonumber(v.unlock)] > v.level then
            unlock_level[tonumber(v.unlock)] = v.level
        end
    end

    self.__data.common.unlock_level = unlock_level

end
Slot.libs.DataManager.getPaybackBet = function(self)
    self.__data.common.payback_bet = {}

--    print_table(self.__data.common.payback_levelbet)

    for level, bets in pairs(self.__data.common.payback_levelbet) do
        self.__data.common.payback_bet[level] = {}
        for k, v in pairs(bets) do
            local s, e = string.find(k, 'bet')
            if s and tonumber(v) ~= -1 then
                local bet = string.sub(k, e+1, string.len(k))
                table.insert(self.__data.common.payback_bet[level], tonumber(bet))
            end
        end
        table.sort(self.__data.common.payback_bet[level])
    end


--    print_table(self.__data.common.payback_bet)

end



--[[
--
--
-- reeldata的读写
--
--
-- ]]--


Slot.libs.DataManager.initReelData = function(self, modulename, reelnum)

    local sq = Slot.sqlite:new()
    sq:create("storage/"..modulename.."data.db")

    self.__data["reeldata"] = {}

    self.__data["reeldata"]["bonus_game"] = self:manageDataToKV(sq:readRows("tbl_bonus_game"), "number")
    self.__data["reeldata"]["config"] = sq:readRows("tbl_config")
    self.__data["reeldata"]["lines"] = sq:readRows("tbl_lines")
    self.__data["reeldata"]["paytable"] = self:manageDataToKV(sq:readRows("tbl_paytable"), "type")

    for i = 1, reelnum do
        self.__data["reeldata"]["reel"..i] = self:sortDataByKey(sq:readRows("tbl_reel"..i), "type")
    end

    self:doLinesData()

    sq:close()

end

Slot.libs.DataManager.clearModuleData = function(self, modulename)
    self.__data["reeldata"] = nil

end

Slot.libs.DataManager.doLinesData = function(self)

    -- manage the self.__data["reeldata"]["lines"]
    local config = self.__data["reeldata"]["config"][1]
    local linesData = {}
    for i, v in pairs(self.__data["reeldata"]["lines"]) do
        local line = v.linenumber
        linesData[line] = linesData[line] or {}
        for j = 1, config['displaywidth'] do
            table.insert(linesData[line], v['reel'..j])
        end
    end
    self.__data["reeldata"]["lines"] = linesData


    -- manage reel1...n

end

Slot.libs.DataManager.getReelData = function(self, modulename, reelnum)

    if not reelnum then reelnum = 18 end

    if not self.__data["reeldata"] then
        self:initReelData(modulename, reelnum)
    end

    return self.__data["reeldata"]

end

Slot.libs.DataManager.getCurrentReelData = function(self)

    return self.__data["reeldata"]

end

Slot.libs.DataManager.initLocalDB = function(self)


    local path = "profile.db"

    if not cc.FileUtils:getInstance():isFileExist(path) then
        path = cc.FileUtils:getInstance():getWritablePath()
        path = path.."cache/profile.db"
        local sq = Slot.sqlite:new()

        sq:create(path)
        sq:createTblByStr("tbl_output",
            'id integer NOT NULL PRIMARY KEY AUTOINCREMENT,\
            "cur_level" integer NOT NULL DEFAULT 1,\
            "cur_bet" integer  NOT NULL DEFAULT 0,\
            "cur_coin" integer  NOT NULL DEFAULT 0,\
            "cur_exp" integer NOT NULL DEFAULT 0,\
            "cur_win_times" integer  NOT NULL DEFAULT 0,\
            "cur_lose_times" integer  NOT NULL DEFAULT 0,\
            "cur_payfor" integer  NOT NULL DEFAULT 0,\
            "cur_payfor_times" integer  NOT NULL DEFAULT 0,\
            "p1" integer  NOT NULL DEFAULT 0,\
            "p2" integer  NOT NULL DEFAULT 0,\
            "p3" integer  NOT NULL DEFAULT 0,\
            "p4" integer  NOT NULL DEFAULT 0,\
            "p" integer  NOT NULL DEFAULT 0,\
            "reel_num" integer  NOT NULL DEFAULT 0,\
            "win_coin" integer  NOT NULL DEFAULT 0,\
            "bonus" integer  NOT NULL DEFAULT 0,\
            "scatter" integer  NOT NULL DEFAULT 0,\
            "big_win" integer  NOT NULL DEFAULT 0,\
            "huge_win" integer  NOT NULL DEFAULT 0,\
            "expect" integer  NOT NULL DEFAULT 0'
        )

        sq:createTblByStr("tbl_heaprecharge",
            'id integer primary key unique not null,\
            payfor integer,\
            paytimes integer,\
            usetimes integer'
        )
        sq:createTblByStr("tbl_baseprofile",
            'id integer NOT NULL PRIMARY KEY AUTOINCREMENT,\
            level integer  NOT NULL DEFAULT 1,\
            exp integer  NOT NULL DEFAULT 0,\
            bet integer  NOT NULL DEFAULT 1,\
            coin integer  NOT NULL DEFAULT 1000,\
            bonus_coin integer  NOT NULL DEFAULT 300,\
            continuwin integer  NOT NULL DEFAULT 0,\
            continuclose integer  NOT NULL DEFAULT 0, \
            isFreeSpin integer  NOT NULL DEFAULT 0, \
            spinnum integer  NOT NULL DEFAULT 0,\
            modulename integer  NOT NULL DEFAULT "west"'
        )

        sq:createTblByStr("tbl_localstorage",
            "id integer primary key unique not null,\
            key text,\
            value text"
        )
    end

end


---TODO Updates data by type
-- @param self
-- @param type
-- @param data
--
Slot.libs.DataManager.updateByKVs = function(self,type,kvs)
    for k,v in pairs(kvs) do
        self.__data[type][k] = v
    end
    self:_notifyAll(type)
end

--- TODO Update data by type
-- @param self
-- @param type
-- @param data
--
Slot.libs.DataManager.update = function(self,type,data,isServer)
    self.__data[type] = self.__data[type] or {}
    self.__data[type] = U:extend(true,self.__data[type],data)
    self:_notifyAll(type,isServer)
end


---TODO  Update data by differ(only numeric property)
-- @param self
-- @param type
-- @param diffdata
--
Slot.libs.DataManager.updateByDiff = function(self,type,diffdata)
    if diffdata then
        for k,v in pairs(diffdata) do
            if self.__data[type][k] then
                if v < 0 then
                    if  self.__data[type][k] > -v then
                        self.__data[type][k] = self.__data[type][k] + v
                    else
                        self.__data[type][k] = 0
                    end
                else
                    self.__data[type][k] =  self.__data[type][k] + v
                end

            end
        end
        self:_notifyAll(type)
    end
end

--
--Slot.libs.DataManager.updateByLeaveTime = function(self, leaveTime)
--
--    Slot.app.updateByTypeLeaveTime(self, "profile", leaveTime)
--
--    self:_notifyAll("profile")
--
--
--end


--- TODO Switch Domain
-- @param self
-- @param domain
--
Slot.libs.DataManager.switchDomain = function(self,domain)
    self:clearInDomain(self.__domain)
    self.__domain = domain
end

--- TODO notify all listener
-- @param self
-- @param type
-- @param isServer
--
Slot.libs.DataManager._notifyAll = function(self,type,isServer)

    for d,t in pairs(self.__listener) do
        for tk,tc in pairs(t) do
            if tk == type then
                for c,zero in pairs(tc) do
                    U:debug("[Slot.DM] [triggerd] %s %s ",d,type)
                    c(self.__data[type],isServer)
                end
            end
        end
    end
--   Slot.libs.Event:new("user.profile.change",{}):fire()

    -- store in the sqlite


end

--- TODO Add a listener of some event in some scope
-- @param self
-- @param type       the event type
-- @param callback   callback functoin
-- @param domain     domain ,be global or pageName
--
Slot.libs.DataManager.onUpdate = function(self,type,callback,domain)
    if not domain then domain = self.__domain end
    U:debug("[Slot.DM] [added] %s %s",domain,type)
    self.__listener[domain]                 = self.__listener[domain] or {}
    self.__listener[domain][type]           = self.__listener[domain][type] or {}
    self.__listener[domain][type][callback] = 0
    if self.__data and self.__data[type] then
        U:debug("[Slot.DM] [triggered] %s %s",domain,type)
        callback(self.__data[type])
    end
end

--- TODO Remove a listener
-- @param self
-- @param type      the event type
-- @param callback  callback functoin
-- @param domain    domain ,be global or pageName
--

Slot.libs.DataManager.detach = function(self,type,callback,domain)
    if not domain then domain = self.__domain end
    U:debug("[Slot.DM] [detach]  %s %s ",domain,type)
    if self.__listener[domain] and self.__listener[domain][type] then self.__listener[domain][type][callback] = nil end
end

--- TODO Remove all listener in a special scope
-- @param self
-- @param domain
--
Slot.libs.DataManager.clearInDomain = function(self,domain)
    U:debug("[Slot.DM] [clearInDomain]  %s ",domain)
    if self.__listener[domain] then self.__listener[domain] = nil end
end

--- TODO Remove all listener in  a special event type
--
Slot.libs.DataManager.clearInType = function(self,type,domain)
    U:debug("[Slot.DM] [clearInType]  %s %s ",domain,type)
    if self.__listener[domain] then self.__listener[domain][type] = nil end
end

Slot.libs.DataManager.clear = function(self)
    U:debug("[Slot.DM] [clearall] ")
    self.__listener = {}
end

--- add shortcut for this
Slot.DM = Slot.libs.DataManager
