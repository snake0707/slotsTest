--
-- Created by IntelliJ IDEA.
-- User: oas
-- Date: 15-1-16
-- Time: 下午3:20
-- To change this template use File | Settings | File Templates.
--
Slot.libs = Slot.libs or {}
--- global scene

Slot.libs.DataManager = Slot.libs.DataManager or {
    __listener = {},
    __data     = {},
    --    __updateTimeStamp = {},
    __domain   = ""
}

Slot.libs.DataManager.initTestData = function(self)


    local reelnum = {[1]= "bigwin",[2]= "hugewin",[10]= "bonus",[11]="bigbonus",[12]="hugebonus",[20]="scatter",[21]="bigscatter",[22]="hugescatter"}
    local sq = Slot.sqlite:new()
    sq:create("storage/test.db")

    self.__data["test"] = {}

    for i, v in pairs(reelnum) do
        self.__data["test"][v] = self:sortDataByKey(sq:readRows("tbl_reel"..i), "type")
    end

    sq:close()

end


Slot.libs.DataManager.getTestData = function(self)

    if not self.__data["test"] then
        self:initTestData()
    end

    return self.__data["test"]

end

Slot.libs.DataManager.getTestDataByKey = function(self, key)

    if not self.__data["test"] then
        self:initTestData()
    end

    return self.__data["test"][key]

end


Slot.libs.DataManager.getExpLevel= function(self)

    return self.__data["common"]["levelup_data"]

end




























