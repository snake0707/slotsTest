--
-- Created by IntelliJ IDEA.
-- User: baofengbi
-- Date: 14-11-16
-- Time: 下午8:52
-- To change this template use File | Settings | File Templates.
--
Slot = Slot or {}

Slot.libs = Slot.libs or {}

Slot.libs.md5 = Slot.libs.md5 or {}

local core = require"lmd5core"

----------------------------------------------------------------------------
-- @param k String with original message.
-- @return String with the md5 hash value converted to hexadecimal digits

core.sumhexa = function(self, k)
    k = core.sum(k)
    return (string.gsub(k, ".", function (c)
        return string.format("%02x", string.byte(c))
    end))
end

core.md5file = function(self, filename)
    local path = cc.FileUtils:getInstance():fullPathForFilename(filename)
    local f = assert(io.open(path, "rb"))
    local d = f:read("*all")
    f:close()

    return core:sumhexa(d)
end

core.md5string = function(self, str)
    return core:sumhexa(str)
end

Slot.libs.md5 = core