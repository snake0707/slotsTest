

Slot.__loaded = {
}

require = (function(r)
    return function(module)
        table.insert(Slot.__loaded, module)
        return r(module)
    end
end)(_G["require"])

--[[
--
--
-- for debug log and bug info
--
-- ]]--
function CCLOG(...)
    if ... == nil then
        print(...)
    else
        print(string.format(...))
    end
end

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    local fmsg=tostring(msg) .. "\n"..debug.traceback()
    print("----------------------------------------")
    print("LUA ERROR: " ..fmsg)
    print("----------------------------------------")

    return msg
end


local function initScaleFactor()

    local director = cc.Director:getInstance()
    local glview = director:getOpenGLView()
    local screenSize = cc.Director:getInstance():getWinSize()
    local framesize = cc.Director:getInstance():getOpenGLView():getFrameSize()
    CCLOG("------------------------------------------------")
    CCLOG("screenSize height: %f", screenSize.height)
    CCLOG("screenSize width: %f", screenSize.width)
    CCLOG("------------------------------------------------")

    local targetPlatform = cc.Application:getInstance():getTargetPlatform()

    local scaleFactor
    if targetPlatform == cc.PLATFORM_OS_IPHONE or targetPlatform == cc.PLATFORM_OS_IPAD then

        local frameArea = framesize.width * framesize.height
        if frameArea == 480*320 then
            scaleFactor = 0.25
        elseif frameArea == 960*640 then

            scaleFactor = 0.5

        elseif frameArea == 1136*640 then

            scaleFactor = 0.5

        elseif frameArea == 1024*768 then

            scaleFactor = 0.5

        elseif frameArea == 2048*1536 then

            scaleFactor = 1

        end

    elseif targetPlatform == cc.PLATFORM_OS_ANDROID or targetPlatform == cc.PLATFORM_OS_WINDOWS then


    end

    local size = cc.size(framesize.width/scaleFactor, framesize.height/scaleFactor)
    glview:setDesignResolutionSize(size.width, size.height, cc.ResolutionPolicy.FIXED_HEIGHT)

    --turn on display FPS
    director:setDisplayStats(true)

    --set FPS. the default value is 1.0/60 if you don't call this
    director:setAnimationInterval(1.0 / 60)


end

local function initEnvironment()

--    initScaleFactor()

end

-- 加载资源
local function requireResources()

    require "bootstrap"

end

local function main()

    initEnvironment()

    requireResources()

    Slot.Algo:runGames()

end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    error(msg)
end