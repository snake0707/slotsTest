--
-- Created by IntelliJ IDEA.
-- User: bbf
-- Date: 14-11-5
-- Time: 下午6:09
-- To change this template use File | Settings | File Templates.
--

Slot = Slot or {}

Slot.libs = Slot.libs or {}

Slot.libs.sqlite = Class:extend({

    __className = "Slot.libs.sqlite",
    init = function(self, dbpath)
        if dbpath then
            self:create(dbpath)
        end

    end,

    create = function (self, dbpath)
        local sqlite3 = require("lsqlite3")
        local path = cc.FileUtils:getInstance():fullPathForFilename(dbpath)
        self.db = sqlite3.open(path)
    end,

    --[[
    --
    -- insert db
    --
    -- strParams = (id INTEGER PRIMARY KEY, content)
    --
    -- ]]--
    createTblByStr = function(self, tbl, strParams)

        local sql = "CREATE TABLE IF NOT EXISTS "..tbl.." ("..strParams..")"--CREATE TABLE test (id INTEGER PRIMARY KEY, content)

        self:commandBySql(sql)

    end,

    --[[
    --
    -- insert db
    --
    -- values = {'(1,2)','(3,4)'}
    --
    -- ]]--

    insert = function(self, tbl, values)

        if type(values) ~= "table" then U:debug("type of 'condition' is "..type(values).."  it must be a table") return end

        for i, v in pairs(values) do

            local sql = 'INSERT INTO '..tbl..' VALUES '..v

            self:commandBySql(sql)
        end

    end,

    --[[
    --
    -- insert db
    --
    -- values = {{id = 1, content = 2},{id = 3, content = 4}}
    --
    -- ]]--

    insertByKeys = function(self, tbl, tvalues)

        if type(tvalues) ~= "table" then U:debug("type of 'condition' is "..type(tvalues).."  it must be a table") return end

--        for i, t in pairs(values) do
--
----            local cols , values= "(", "("
----            local flag = false
----            for k, v in t do
----                if flag then
----                    cols = cols..","
----                    values = values..","
----                end
----                cols = cols..k
----                values = values..v
----                flag = true
----            end
----            cols = cols..")"
----            values = values..")"
--
--
----            local sql = 'INSERT INTO '..tbl.." "..cols..' VALUES '..values     --INSERT INTO test (content,id) VALUES(10,200)
----
----            self:commandBySql(sql)
-- end

        local keys, values = {},{}

        for k, v in pairs(tvalues) do
            table.insert(keys, k)
            table.insert(values, v)
        end

        self:insertByKV(tbl, keys, values)

    end,
    --[[
    --
    -- insert db
    --
    -- keys = {"id", "content"}
    -- values = {3, 4}
    --
    -- ]]--
    insertByKV = function(self, tbl, keys, values)
        local key = "("..table.concat(keys, ",")..")"
--        local value = "("..table.concat(values, ",")..")"

        local value = "("
        local flag = false
        for k, v in pairs(values) do
            if flag then value = value.."," end
            value = value.."'"..v.."'"
            flag = true
        end
        value = value..")"

        local sql = 'INSERT INTO '..tbl.." "..key..' VALUES '..value

        self:commandBySql(sql)
    end,

    commandBySql = function(self, sql)

--        print(sql)
        self.db:exec (sql)

    end,

    --[[
    --
    -- update db
    --
    -- values = {id = 2, content = 3, exp = 4}
    -- condition = {id = 2, content = 3, exp = 4}
    --
    --
    -- ]]--
    update = function(self, tbl, values, conditions)

        if type(values) ~= "table" and type(conditions) ~= "table" then U:debug("values and condition must be a table") return end

        local rows = self:readRowsByCondition(tbl, conditions)

        if #rows <= 0 then

            -- not exit then insert
--            U:debug(values)
--            U:debug(conditions)
            U:extend(false, values, conditions)

            self:insertByKeys(tbl, values)

            return
        end

        local updateValue , cons= "", ""
        local flag = false

        for k1, v1 in pairs(values) do
            if flag then updateValue = updateValue.."," end
            updateValue = updateValue..k1.."='"..v1.."'"
            flag = true

        end

        flag = false
        for k2, v2 in pairs(conditions) do
            if flag then cons = cons.." and " end

            if v2 == "ISNULL" then
                cons = cons..k2.." "..v2
            else
                cons = cons..k2.."='"..v2.."'"
            end

            flag = true

        end


        self:updateByStr(tbl, updateValue, cons)
    end,


    updateByStr = function(self, tbl, value, condition)

        local sql = "UPDATE "..tbl.." SET "..value.." WHERE "..condition     --UPDATE Person SET FirstName = 'Fred' WHERE LastName = 'Wilson'

        self:commandBySql(sql)
    end,

    --[[
    --
    -- delete
    --
    -- condition = {id = 2, content = 3, exp = 4}
    --
    -- ]]--

    deleteByStr = function(self, tbl, condition)

        local sql = "DELETE FROM "..tbl.." WHERE "..condition     --UPDATE Person SET FirstName = 'Fred' WHERE LastName = 'Wilson'

        self:commandBySql(sql)
    end,

    delete = function(self, tbl, conditions)

        local cons= ""
        local flag = false

        for k, v in pairs(conditions) do
            if flag then cons = cons.." and " end

            if v == "ISNULL" then
                cons = cons..k.." "..v
            else
                cons = cons..k.."='"..v.."'"
            end

            flag = true
        end

        self:deleteByStr(tbl, cons)

    end,

    --[[
    --
    -- read db
    --
    -- ]]--
    readRows = function(self, tbl)
        local sql = "SELECT * FROM "..tbl

--        print(sql)
        return self:readRowsBySql(sql)

    end,

    readRowsByCondition = function(self, tbl, condition)

        if not condition then
            return self:readRows(tbl)
        end

        if type(condition) ~= "table" and type(condition) ~= "string" then U:debug("type of 'condition' is "..type(condition).."  it must be a table or string") return end

        local sql = "SELECT * FROM "..tbl.." WHERE "
        local flag = false

        if type(condition) == "table" then
            for i, v in pairs(condition) do
                if flag then sql = sql.." and " end
                sql = sql..i.."='"..v.."'"
                flag = true
            end
        else
            sql = sql..condition
        end

--        print(sql)
        return self:readRowsBySql(sql)

    end,

    readRowsBySql = function(self, sql)
        local rows = {}
        for row in self.db:nrows(sql) do
            table.insert(rows, row)
        end
        return rows

    end,

    close = function(self)
        self.db:close()
    end,


})

Slot.sqlite = Slot.libs.sqlite





--[[ test sqlite3 ]]--

--    local sq = Slot.sqlite:new()
--    sq:create("storage/slotdata.db")
--
--    sq:update('test',{content = 1000},{id = 10})
--    local rows = sq:readRows("test")
--
--    print_table(rows)


---------------------

--    local sqlite3 = require("lsqlite3")
--    local path = cc.FileUtils:getInstance():fullPathForFilename("storage/mydatabase.sqlite")
--    local db = sqlite3.open(path)
--
--    print("sqlite3============================"..path)
--
--    db:exec[[
--
--      INSERT INTO slotData VALUES (3, 100);
--      INSERT INTO slotData VALUES (4, 200);
--
--    ]]
--
--    for row in db:nrows("SELECT * FROM slotData") do
--        print(row.id, row.level, row.exp)
--    end
--
--    db:exec[[
--      CREATE TABLE test (id INTEGER PRIMARY KEY, content);
--
--      INSERT INTO test VALUES (1, 'Hello World');
--      INSERT INTO test VALUES (2, 'Hello Lua');
--      INSERT INTO test VALUES (3, 'Hello Sqlite3');
--      INSERT INTO test VALUES (4, 'lalalalalala');
--    ]]
--
--    for row in db:nrows("SELECT * FROM test") do
--        print(row.id, row.content)
--    end
--
--    db:close()
--
--    local db = sqlite3.open(path)
--
--    print("sqlite3============================1")
--    for row in db:nrows("SELECT * FROM slotData") do
--        print(row.id, row.level, row.exp)
--    end
--
--    for row in db:nrows("SELECT * FROM test") do
--        print(row.id, row.content)
--    end
--
--    db:close()