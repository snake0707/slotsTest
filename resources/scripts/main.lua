
--[[
--
--
-- game start
--
-- ]]--

-- utils
Slot = Slot or {}

--[[
--
--  init resources
--
-- ]]--
local function initSearchDir()

    --设置基本的搜索路径
    local lfs = require "lfs"


    --    优先搜索路径cache
    local path = cc.FileUtils:getInstance():getWritablePath()

    local cache = path.."cache/"
    print(cache)
    lfs.mkdir(cache) -- 如果文件夹存在，则返回 nil	File exists
    lfs.mkdir(cache.."image")
    lfs.mkdir(cache.."scripts")
    cc.FileUtils:getInstance():addSearchPath(cache, true)
    cc.FileUtils:getInstance():addSearchPath(cache.."image", true)
    cc.FileUtils:getInstance():addSearchPath(cache.."scripts", true)

    --    预打包路径
    cc.FileUtils:getInstance():addSearchPath("image")
    cc.FileUtils:getInstance():addSearchPath("scripts")
end


--[[
--
-- 预加载file
--
-- ]]--
local function initUpdateFile()

    require "Cocos2d"
    require "Cocos2dConstants"

end



local function initEnvironment()

    initUpdateFile()
    initSearchDir()

end

-- 加载资源
local function requireResources()

    require "init"

end

local function main()
    collectgarbage("collect")
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)

    -- initialize environment

    initEnvironment()

    -- initialize resources
    requireResources()

end

local status, msg = xpcall(main, function() end)
if not status then
    error(msg)
end
