--
-- Utility functions
--


U = U or {}

U.noop = function(self) end
U.log = function(self, ...) U:debug(unpack(arg)) end

U.spriteFrame = function(self,name)
    return cc.Sprite:create(name):getSpriteFrame()
end


U.isNil = function(self,s)
    if s~=nil then
        if type(s) == "string" then
            return s == ""
        end
        if type(s) == "table" then
            return next(s) == nil
        end
        return false
    end
    return true
end

U.safeRelease = function(self, t)
    if not t then return end

    if U:isUI(t) then
        t = t:getRootNode()
    end

    if t and t:retainCount() > 0 then
        t:release()
    end
end

U.debug = function(self,msg,...)
    if  Slot.Configuration.DEBUG == "true" then
        if type(msg) == "table" then
            print("[debug] ----------debug table----------")
            print_table(msg)
            return
        end
        if msg ~= nil then
            if {...} ~= nil and #{...} ~= 0 then
                print("[debug] "..string.format(msg,...))
            else
                print("[debug] "..msg)
            end
        else
            print("[debug] nil")
        end
    end
end

U.fdebug = function(self,module,action,msg,...)
    if Slot.Configuration.DEBUG == "true" then
        local m = "["..string.rep(" ",12 - string.len(module)-2)..module.."]"
        local a = "["..string.rep(" ",18 - string.len(action)-2)..action.."]"
        local s = msg or ""
        if msg ~= nil then
            if {...} ~= nil and #{...} ~= 0 then
                s = string.format(msg,...)
            end
        end
        CCLOG("[debug] %s %s %s",m,a,s)
    end
end

U.ferror = function(self,module,action,msg,...)
    local m = "["..string.rep(" ",12 - string.len(module)-2)..module.."]"
    local a = "["..string.rep(" ",18 - string.len(action)-2)..action.."]"
    local s = msg or ""
    if msg ~= nil then
        if {...} ~= nil and #{...} ~= 0 then
            s = string.format(msg,...)
        end
    end
    error(string.format("[error] %s %s %s",m,a,s))
end

---
-- 检测一个object 是否是UIComponent的实例
-- @param self
-- @param t
--
U.isUI = function(self, t)
    return Class:isInstanceObject(t) and t:instanceof(Slot.ui.UIComponent)
end

U.round = function(self, num, idp)
    local mult = 10^(idp or 0)
    return math.floor(num * mult + 0.5) / mult
end

--- Used for the custom scroll controll in HSlider and VSlider
-- @param self
-- @param x
-- @param y
-- @param ui
--
U.isXYInUIRect = function(self, x, y, ui)
    local n, p, s = ui, nil, nil
    if U:isUI(ui) then
        n = ui.rootNode
    end
    rect = n:getBoundingBox()
    p = n:getParent():convertToNodeSpace(cc.p(x, y))
--    return rect:containsPoint(p)
    return cc.rectContainsPoint(rect, p)
end


U.isXInUIRect = function(self,x,ui)
    local n, p, s = ui, nil, nil
    if U:isUI(ui) then
        n = ui.rootNode
    end
    rect = n:getBoundingBox()
    p = n:convertToNodeSpace(cc.p(x, 0))
    p.y = rect:getMinY()
    return cc.rectContainsPoint(rect, p) --rect:containsPoint(p)
end

U.isYInUIRect = function(self,y,ui)
    local n, p, s = ui, nil, nil
    if U:isUI(ui) then
        n = ui.rootNode
    end
    rect = n:getBoundingBox()
    p = n:convertToNodeSpace(cc.p(0, y))
    p.x = rect:getMinX()
    return cc.rectContainsPoint(rect, p) --rect:containsPoint(p)
end

U.cleanSchedules=function(self)
    local sc=cc.Director:getInstance():getScheduler()
    for k,v in pairs(self.callbackEntries) do
        sc:unscheduleScriptEntry(k)
    end
end

U.numAction = function(self, node, end_num, start_num,callback, time)

    if not start_num then start_num= 0 end
    if not time then time = 2 end
    if self._numInterval then
        U:clearInterval(self._numInterval)
        self._numInterval = nil
    end

    local addCoin = (end_num - start_num)
    local cpc = 1
    local sec = time/60

    if addCoin > 60 then
        cpc = math.ceil(addCoin/60) + 1
    else
        sec = time/addCoin
    end

    self._numInterval = U:setInterval(function()
        if start_num < end_num then
            start_num = start_num + cpc
            if start_num >= end_num then start_num = end_num end

            --这里添加个函数把数字转化成字符串 1.09

            local str=U:formatNumber(tostring(start_num))
            --node:setString(start_num)
            node:setString(str)
        else
            U:clearInterval(self._numInterval)

            if callback and type(callback)=="function" then
                callback()
            end

            self._numInterval = nil
        end

    end, sec)

    return self._numInterval
end

--- setTimeout
-- @param self
-- @param func
-- @param secs
--
U.setTimeout = function(self, func, secs)
    if not secs then secs = 0 end

    local delay = cc.DelayTime:create(secs)
    local callback = cc.CallFunc:create(func)
    local action = {}
    table.insert(action, delay)
    table.insert(action, callback)
    local seq = cc.Sequence:create(action)

    cc.Director:getInstance():getRunningScene():runAction(seq)
end
U.setTimeoutUnsafe = function(self, func, secs)
    if not secs then secs = 0 end
    local id=0
    id=cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(id)
        func()
    end, secs, false)
    return id
end

U.setInterval = function(self,func, secs,node)
    local delay = cc.DelayTime:create(secs)
    local callback = cc.CallFunc:create(func)
    local action = {}
    table.insert(action, delay)
    table.insert(action, callback)
    local seq = cc.Sequence:create(action)
    local act= cc.RepeatForever:create(seq)
    local n=node or cc.Director:getInstance():getRunningScene()
    n:runAction(act)
    return act
end

U.setIntervalUnsafe = function(self,func, secs)
    return cc.Director:getInstance():getScheduler():scheduleScriptFunc(function(dt)
        func(dt)
    end, secs, false)
end

U.clearInterval = function(self,id)
    if not id then return end
    if not tolua.isnull(id) and tolua.type(id) == "cc.RepeatForever" then
        cc.Director:getInstance():getActionManager():removeAction(id)
    elseif type(id)=='number' then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(id)
    end
end

--- add the child to the parent at the position horizontal center ,ignore the anchor point
-- @param self
-- @param child
-- @param parent
-- @param hightFromBaseLine in the worldspace
--
U.addToHCenter = function(self, child, parent, hightFromBaseLine, zIndex)
    if U:isUI(child) then child = child:getRootNode() end
    local p, left, bottom = child:getAnchorPoint(), 0, 0
    if child:isIgnoreAnchorPointForPosition() then
        p = cc.p(0,0)
    end
    left = parent:getContentSize().width / 2 + (p.x - 0.5) * child:getContentSize().width
    local height = hightFromBaseLine + p.y * child:getContentSize().height
    child:setPosition(cc.p(left, height))
    if U:isUI(parent) then
        parent.rootNode:addChild(child,zIndex or 0)
    else
        parent:addChild(child,zIndex or 0)
    end
end


--- add the child to the parent at the postion vertical center ,and set the left or right,ignore the anchor point
-- @param self
-- @param child
-- @param parent
-- @param leftOrRight
--
U.addToVCenter = function(self, child, parent, left, right, shadow, zorder)
    if U:isUI(child) then child = child:getRootNode() end
    local p, bottom = child:getAnchorPoint(), 0
    if child:isIgnoreAnchorPointForPosition() then
        p = cc.p(0,0)
    end
    local psize = parent:getContentSize()
    local csize = child:getContentSize()
    bottom = psize.height / 2 + (p.y - 0.5)* csize.height
    if shadow then
        bottom = bottom - shadow
    end

    if left then
        left = left + p.x * csize.width
    end
    if right then
        left = psize.width - (right + (1 - p.x) * csize.width)
    end
    child:setPosition(cc.p(left, bottom))
    if zorder then
        parent:addChild(child, zorder)
        return
    end

    parent:addChild(child)
end

--- add the child to the parent
-- @param self
-- @param child
-- @param parent 
--
U.addToCenter = function(self, child, parent, zIndex)
    if U:isUI(child) then child = child:getRootNode() end
    local p, left, bottom = child:getAnchorPoint(), 0, 0
    if child:isIgnoreAnchorPointForPosition() then p=cc.p(0,0) end
    left = parent:getContentSize().width / 2 + (p.x - 0.5) * child:getContentSize().width
    bottom = parent:getContentSize().height / 2 + (p.y - 0.5) * child:getContentSize().height
    child:setPosition(cc.p(left, bottom))

    if U:isUI(parent) then
        parent.rootNode:addChild(child,zIndex or 0)
    else
        parent:addChild(child,zIndex or 0)
    end
end

U.addToCenterLayer = function(self, child, parent)
    local csize, psize = child:getContentSize(), parent:getContentSize()
    child:setPosition((psize.width - csize.width) / 2, (psize.height - csize.height) / 2)
    parent:addChild(child)
end
--- set the child position relative to another child align to right side
-- @param self
-- @param child
-- @param brother
--
U.setRelativePositionX = function(self, child, brother, spacing)
    local ap,cs,psX,psY = brother:getAnchorPoint(), brother:getContentSize(), brother:getPosition()
    if child:isIgnoreAnchorPointForPosition() then ap=cc.p(0,0) end
    child:setAnchorPoint(ap)
    child:setPosition(psX + cs.width * (1 - ap.x) + spacing + child:getContentSize().width * ap.x, psY)
end

--- set the child position relative to another child align to bottom
-- @param self
-- @param child
-- @param brother
--
U.setRelativePositionY = function(self, child, brother, spacing)
    local ap,cs,psX, psY = brother:getAnchorPoint(), brother:getContentSize(), brother:getPosition()
    if child:isIgnoreAnchorPointForPosition() then ap=cc.p(0,0) end
    child:setAnchorPoint(ap)
    child:setPosition(psX, psY - cs.height * ap.y - spacing - child:getContentSize().height * (1 - ap.y))
end

U.layerWithChildrenHoriztal = function(self, children, spacing, alignment, height, parent, initPosX)
    local ly = parent or cc.Sprite:create()
    local w = initPosX or 0

    -- 默认居中排列
    if not alignment then alignment = cc.VERTICAL_TEXT_ALIGNMENT_CENTER end

    if not height then
        height = 0
        table.foreach(children,
            function(i,v)
                if height < v:getContentSize().height then
                    height = v:getContentSize().height
                end
            end
        )
    end

    local py = {
        [cc.VERTICAL_TEXT_ALIGNMENT_TOP] = 1,
        [cc.VERTICAL_TEXT_ALIGNMENT_CENTER] = 0.5,
        [cc.VERTICAL_TEXT_ALIGNMENT_BOTTOM] = 0,
    }
    local function getPositionY()
        return py[alignment] * (height)
    end

    for i = 1, #children do
        local child = children[i]
        if not U:isNil(child) then
            if U:isUI(child) then
                child = child:getRootNode()
            end
--            child:setAnchorPoint(cc.p(0,0))
            local p = child:getAnchorPoint()
            if child:isIgnoreAnchorPointForPosition() then p=cc.p(0,0) end
            local size = child:getContentSize()
            child:setPosition(w + p.x * size.width, getPositionY() + (p.y - py[alignment]) * size.height)
            w = w + size.width + spacing

            ly:addChild(child)
            if child.setCascadeOpacityEnabled then
                child:setCascadeOpacityEnabled(true)
            end
        end
    end

    ly:setContentSize(cc.size(w - spacing, height))
    ly:setAnchorPoint(cc.p(0,0))

    return ly
end

U.layerWithChildrenVertical = function(self, children, spacing, alignment, width)
    local ly = cc.Node:create()
    local h = 0

    if not alignment then alignment = cc.TEXT_ALIGNMENT_CENTER end

    local count = 0

    if not width then
        width = 0
        table.foreach(children,
            function(i,v)
                count  = count + 1
                if width < v:getContentSize().width then
                    width = v:getContentSize().width
                end
            end
        )
    end

    local px = {
        [cc.TEXT_ALIGNMENT_LEFT ] = 0,
        [cc.TEXT_ALIGNMENT_CENTER] = 0.5,
        [cc.TEXT_ALIGNMENT_RIGHT] = 1,
    }
    local function getPositionX()
        return px[alignment] * (width)
    end

    local tempChild = {}

    table.foreach(children,
        function(i, v)
            table.insert(tempChild, 1, v)
        end)

    table.foreach(tempChild,
        function(i, v)
            local child = v
            if not U:isNil(child) then
                if U:isUI(child) then
                    child = child:getRootNode()
                end
--                child:setAnchorPoint(ccp(0, 0))
                local p = child:getAnchorPoint()
                if child:isIgnoreAnchorPointForPosition() then p=cc.p(0,0) end
                local size = child:getContentSize()
                child:setPosition(getPositionX() + (p.x-px[alignment]) * size.width, h + p.y*size.height)
                h = h + size.height + spacing
                ly:addChild(child)
            end
        end
    )

    ly:setContentSize(cc.size(width, h - spacing))
--    ly:setAnchorPoint(cc.p(0,0))

    return ly
end

U.reLayoutHoriztal = function(self, parent, spacing, hasmargin, resize)

    local children, count = parent:getChildren(), parent:getChildrenCount()
    if not spacing then
        local pWidth = parent:getContentSize().width
        local cWidth = 0
        for i = 1,count do
            local child = children[i]
            cWidth = cWidth + child:getContentSize().width
        end

        spacing = (pWidth-cWidth)/(count-1)

        if hasmargin then spacing = (pWidth-cWidth)/(count+1) end
        if spacing <= 0 then spacing = 0 end
    end

    local w = 0
    if hasmargin then w = spacing end

    for i = 1,count do

        local child = children[i]
        local p = child:getAnchorPoint()
        if child:isIgnoreAnchorPointForPosition() then p=cc.p(0,0) end
        child:setPositionX(w + p.x * child:getContentSize().width)
        w = w + child:getContentSize().width + spacing
    end

    if resize then
        local width = w - spacing
        if hasmargin then width = w end
        parent:setContentSize(cc.size(width, parent:getContentSize().height))
    end

end

U.reLayoutVertical = function(self, parent, spacing, direction)
    local children, count = parent:getChildren(), parent:getChildrenCount()
    local height = 0
    for i = 1, count do
        local child = children[i]
        height = height + child:getContentSize().height
    end
    height = height + spacing * (count - 1)

    if direction == 1 then      -- 从上到下的布局 锚点应该设为(x,0)

        local h = height
        for i = 1, count do
            local child = children[i]
            local p = child:getAnchorPoint()
            if child:isIgnoreAnchorPointForPosition() then p=cc.p(0,0) end
            h = h - child:getContentSize().height
            child:setPositionY(h + p.y * child:getContentSize().height)
            h = h - spacing
        end
    else                        -- 从下到上的布局
        local h = 0
        for i = 1,count do
            local child = children[i]
            local p = child:getAnchorPoint()
            if child:isIgnoreAnchorPointForPosition() then p=cc.p(0,0) end
            child:setPositionY(h + p.y * child:getContentSize().height)
            h = h + child:getContentSize().height + spacing
        end
    end
    parent:setContentSize(cc.size(parent:getContentSize().width, height))
end
---
-- @param sec
--
U.formatTime = function(self,sec)
    local hour = math.floor(sec / (60 * 60))
    local second = math.floor(sec % (60 * 60))
    local minute = math.floor(second / 60)
    second = second % 60
    local str = ''
    if hour >= 10 then
        str = hour
    else
        str = "0" .. hour
    end

    if minute >= 10 then
        str = str .. ":" .. minute
    else
        str = str .. ":0" .. minute
    end

    if second >= 10 then
        str = str .. ":" .. second
    else
        str = str .. ":0" .. second
    end
    return str
end
U.formatTimeWithYear=function(self,ts,format)
    format=format or '%d-%d-%d %d:%02d'
    local t = os.date("*t", ts) 
    return string.format(format,t.year,t.month,t.day,t.hour,t.min)
end
--[[
-- 判断一个值是否在当前数组中
-- local arr=['aa','bb']
-- U.ArrayContainValue(arr,'aa')
-- ]]
U.ArrayContainValue = function(self, arr, value)
    if not arr then
        error("arr is nil")
    end
    if not value then
        error("value is nil")
    end

    for k in pairs(arr) do
        if arr[k] and U:equal(arr[k], value) then
            return true
        end
    end
    return false
end

U.equal = function(self,v1, v2)
    if type(v1) == "table" or type(v2) == "table" then return false end
    if type(v1) == 'string' then
        return v1 == tostring(v2)
    elseif type(v1) == 'number' then
        return v1 == tonumber(v2)
    end
end

U.cmp = function(self, v1, v2)
    assert (type (v1) ~= "table" and type (v2) ~= "table",
        "bad compare value")

    v1 = tonumber(v1)
    v2 = tonumber(v2)

    return v1 - v2
end

U.numberToBool = function(self, num)
    assert (type(num) == "number")
    if num == 0 then
        return false
    else
        return true
    end
end

table.find = function(self, arr, value)
    if not arr then
        error("arr is nil")
    end
    if not value then
        error("value is nil")
    end

    for k in pairs(arr) do
        if arr[k] and U:equal(arr[k], value) then
            return k
        end
    end
    return nil
end

--- converts a number representing the date and time back to a higher-level representation
-- @param t format string e.g. "%m月%d日%H时"
-- @param sec
--
U.formatTimeToDate = function(self,t, sec)
    return os.date(t, sec);
end

U.getHourOfTheDay = function(self)
    local time  = os.time()
    return  tonumber(os.date("%H", os.time()))
end


--
-- get from now time, 获取距离现在的时间（3天前、3小时前、3分钟前、3秒前）
-- @param t 上次登录时间，如1364185749
--
U.getFromNowTime = function(self,t)
    local time = os.time()
    local diff = time-tonumber(t)
    if diff < 1 then
        diff = 1
    end
    local day = math.floor(diff/(3600*24))
    local hour = math.floor(diff%(3600*24)/3600)
    local minute = math.floor(diff%3600/60)
    local second = math.floor(diff%60)
    local s = ""
    if day > 0 then
        s = day.."天前"
    elseif hour > 0 then
        s = hour.."小时前"
    elseif minute > 0 then
        s = minute.."分钟前"
    elseif second > 0 then
        s = second.."秒前"
    end
    return s
end

--
-- get cold down time, 获取距离现在的时间（3天2小时、3小时15分钟、3分钟、3秒钟）
-- @param t 秒，如15880
--
U.getColdDownTime = function(self,t)

    local s = ""

    if t <= 0 then
        s = "0秒"
        return s
    end

    local day = math.floor(t/(3600*24))
    local hour = math.floor(t%(3600*24)/3600)
    local minute = math.floor(t%3600/60)
    local second = math.floor(t%60)

    if day > 0 then
        s = day.."天"
        if hour > 0 then
            s = s..hour.."小时"
        end
    elseif hour > 0 then
        s = hour.."小时"
        if minute > 0 then
            s = s..minute.."分"
        end
    elseif minute > 0 then
        s = minute.."分"
        if second > 0 then
            s = s..second.."秒"
        end
    elseif second > 0 then
        s = second.."秒"
    end
    return s
end

-- 去除空白字符串
U.trim = function(self, str)
    return (str:gsub("^%s*(.-)%s*$", "%1"))
end


--- 从技能列表中筛选出克制技能的名称，默认无克制技
--- @param skills
U.getSkill = function(self, skills)
    local s = "无克制技"
    table.foreach(skills,
        function(i, v)
            if tonumber(v.rebirth) == 1 then
                s = v.name
            end
        end
    )
    return s
end
--
-- Print table contents
-- @param table sth
--
function print_table( sth )
    local t=debug.getinfo(2)
    print(string.format('PRINT_TABLE:from [%s@line:%d]',t.source,t.currentline))
    local address = {}
    if type(sth) ~= "table" then
        print(sth)
        return
    end


    local space, deep = string.rep(' ', 4), 0
    local function _dump(t)
        local temp = {}
        for k,v in pairs(t) do
            local key = tostring(k)

            if type(v) == "table" then
                address[v]=0
                deep = deep + 2
                print(string.format("%s[%s] => Table\n%s(",
                    string.rep(space, deep - 1),
                    key,
                    string.rep(space, deep)
                    )
                ) --print.
                _dump(v)

                print(string.format("%s)",string.rep(space, deep)))
                deep = deep - 2
            else
                if type(v) ~= "string" then
                    v = tostring(v)
                end

                print(string.format("%s[%s] => %s",
                    string.rep(space, deep + 1),
                    key,
                    v
                    )
                ) --print.
            end 
        end 
    end
    print(string.format("Table\n("))
    _dump(sth)
    print(string.format(")"))
end

--
-- Split string to table
-- @param string s
-- @param char delim
--
U.split = function(self,s, delim, vType)
    if U:isNil(s) then return nil end
    assert (type (delim) == "string" and string.len (delim) > 0,
        "bad delimiter")
    if not vType then vType = "string" end

    local start = 1
    local t = {}  -- results table

    -- find each instance of a string followed by the delimiter

    while true do
        local pos = string.find (s, delim, start, true) -- plain find

        if not pos then
            break
        end

        table.insert (t, U:convertToType(string.sub(s, start, pos - 1), vType))
        start = pos + string.len (delim)
    end -- while

    -- insert final one (after last delimiter)

    table.insert (t, U:convertToType(string.sub (s, start), vType))

    return t

end

U.convertToType = function(self, value, type)

    if not type or not value then
        error("U.convertToType: value or type must not be empty")
        return
    end

    if type == "string" then
        return ""..value
    elseif type == "number" then
        return tonumber(value)
    elseif type == "boolean" then
        return not not value
    end

    return nil

end

--
--获得table的大小
--
U.getTableSize = function(self, tbl)
	local size = 0
	if type(tbl) == "table" then
		for key, value in pairs(tbl) do
			size = size + 1
		end
	end
	return size
end

--
--根据key排序
--
U.sortTable = function(self, tbl)
    if type(tbl) == "table" then
        for key, value in pairs(tbl) do
            if type(key) == "string" and tonumber(key) then
                if not tbl[tonumber(key)] then
                    tbl[tonumber(key)] = tbl[key]
                    tbl[key] = nil
                end
            end
        end
    end
end

--[[
-- 扩展对象，用于设定默认值
-- extend(target,{aa='aa'},...)
-- target.aa=='aa'
--
-- extend(target,{aa='aa'},{aa='aa1'},...)
-- target.aa=='aa1'
--
-- ]]

U.extend = function(self,isDeepCopy,target,...)
    if not (target and type(target) == "table") then
        error("U.extend: target must be a table")
    end

    if not isDeepCopy then
       for i,k in ipairs({ ... }) do
           for key,value in pairs(k) do
               target[key] = value
           end
       end
    else
        for i, k in ipairs({ ... }) do
            if k and type(k) ~= "table" then
                target[#target + 1] = k
            else -- handle argument
                for key, value in pairs(k) do
                    local src = target[key]
                    if not src then -- src is nil
                        target[key] = value
                    else -- src is not nil
                        if type(src) == "table" then -- sFrc is a table
                            target[key] = U:extend(true,src, value)
                        elseif type(value) == "table" then
                            target[key] = U:extend(true,{src}, value)
                        else
                            target[key] = value
                        end
                    end
                end
            end
        end
    end
    return target
end

U.getString = function(self,str,...)
    result = str
    for i, value in ipairs({...}) do
        result = string.gsub(result, "{"..i.."}", tostring(value))
    end
    return result or ""
end

--Get the locale string
--@param cat the category string
--@param key the key string
--@param params the parameters
--U.locale = function(self, cat, key, params, userLanguage)
--	local result = ""
--	local paramsObj = params or {}
--	if cat and key then
--		if Slot.lang[cat] and Slot.lang[cat][key] then
--			result = Slot.lang[cat][key]
--		end
--		if result == "" then
--			if paramsObj.__default__ then
--				result = paramsObj['__default__']
--			else
--				result = key
--			end
--		end
--		for key, param in pairs(paramsObj) do
--			result = string.gsub(result, "{{" .. key .. "}}", paramsObj[key])
--		end
--	end
--	if result == key then
--		return U:localeWithLang(cat, key, params, userLanguage);
--	else
--		return result;
--	end
--end

--U.localeWithLang = function(self, cat, key, params, userLanguage)
--		if not userLanguage then
--			userLanguage = Slot.Language[tonumber(cc.Application:getInstance():getCurrentLanguage()) + 1]
--		end
--		local result = ""
--		local paramsObj = params or {}
--		if cat and key then
--            if Slot.lang[cat] and Slot.lang[cat][userLanguage] and Slot.lang[cat][userLanguage][key] then
--                result = Slot.lang[cat][userLanguage][key]
--            end
--            if result == "" then
--                if paramsObj.__default__ then
--                    result = paramsObj['__default__']
--                else
--                    result = key
--                end
--            end
--            for k, param in pairs(paramsObj) do
--                result = string.gsub(result, "{{" .. k .. "}}", paramsObj[k])
--            end
--        end
--	return result
--end

U.locale = function(self, cat, key, params, userLanguage)
    if not userLanguage then
        userLanguage = Slot.Language[tonumber(cc.Application:getInstance():getCurrentLanguage()) + 1]
    end

    if not userLanguage or  not Slot.lang[userLanguage] then
        userLanguage = "English"
    end


    local result = ""
    local paramsObj = params or {}
    if cat and key then
        if Slot.lang[userLanguage] and Slot.lang[userLanguage][cat] and Slot.lang[userLanguage][cat][key] then
            result = Slot.lang[userLanguage][cat][key]
        end
        if result == "" then
            if paramsObj.__default__ then
                result = paramsObj['__default__']
            else
                result = key
            end
        end
        for k, param in pairs(paramsObj) do
            result = string.gsub(result, "{{" .. k .. "}}", paramsObj[k])
        end
    end
    return result
end

---
-- @param sec
--
U.formatTimeAgo = function(self,sec)

    sec = tonumber(sec)

    local day = math.floor(sec/(3600*24))
    local hour = math.floor(sec / (60 * 60))
    local second = math.floor(sec % (60 * 60))
    local minute = math.floor(second / 60)
    second = second % 60

    local str = ''
    if day > 0 then
        return day.."天前"
    end

    if hour > 0 then
        return hour.."小时前"
    end

    if minute >= 0 then
        return minute.."分钟前"
    end

    if second > 0 then
        return second.."秒前"
    end
    return "刚刚"
end


U.formatTimePlus = function(self, format, time)
	if time == nil then
		time = os.time()
	end

	time = tonumber(time)

	local day, hour, minutes, second = 0, 0, 0, 0
	
	local dayIndex = string.find(format, "%%ddu")
	local hourIndex = string.find(format, "%%hhu")
	local minuteIndex = string.find(format, "%%mmu")
	
	if dayIndex and dayIndex > 0 then
		day = tonumber(time/(3600*24))
		time = tonumber(time%3600*24)
	end
	if hourIndex and hourIndex > 0 then
		
		hour = tonumber(time/3600)
		time = tonumber(time%3600)
	end
	if minuteIndex and minuteIndex > 0 then
		minutes = tonumber(time/60)
		time = tonumber(time%60)
	end
	second = tonumber(time)
	if day > 0 then
		format = string.gsub(format, "%%ddu", day .. U:locale('common', 'day'))
	else
		format = string.gsub(format, "%%ddu", "")
	end
	if hour > 0 then
		format = string.gsub(format, "%%hhu", hour .. U:locale('common', 'hour'))
	else
		format = string.gsub(format, "%%hhu", "")
	end
	if minutes > 0 then
		format = string.gsub(format, "%%mmu", minutes .. U:locale('common', 'minutes'))
	else
		format = string.gsub(format, "%%mmu", "")
	end
	if second > 0 then
		format = string.gsub(format, "%%ssu",  second .. U:locale('common', 'second'))
	else
		format = string.gsub(format, "%%ssu", "")
	end
	return format
end

U.round   = function(self,num,idp)
    local idp = idp and 10^idp or 1
    return  math.abs(math.ceil((num * idp - 0.5) / idp))
end

U.urlencode = function(self, str)
    if (str) then
        str = string.gsub (str, "\n", "\r\n")
        str = string.gsub (str, "([^(%w|_| |.)])",
            function (c) return string.format ("%%%02X", string.byte(c)) end)
        str = string.gsub (str, " ", "+")
    end
    return str
end
U.entityImgUrl=function(self,url)
    return string.sub(url, string.find(url, "entity"), -1)
end

---- 切圆角
--U.leverSpriteWithMask=function(self,imgUrl,imgHolder,maskSprite,scale)
--    local doMask=function(sprite)
--        sprite=tolua.cast(sprite,'CCSprite')
--        local w,h=sprite:getContentSize().width,sprite:getContentSize().height
--        local rt=cc.RenderTexture:create(w,h)
--        local mask=maskSprite
--        mask=cc.Sprite:create(maskSprite)
--        assert(mask,'creating mask sprite failed'..maskSprite)
--        mask:setPosition(w/2,h/2)
--        local ap=sprite:getAnchorPoint()
--        local x,y=sprite:getPositionX(),sprite:getPositionY()
--        sprite:setAnchorPoint(cc.p(.5,.5))
--        sprite:setPosition(w/2,h/2)
--        rt:beginWithClear(0,0,0,0)
--        local bf=ccBlendFunc:new_local()
--        bf.src=gl.SRC_ALPHA
--        bf.dst=gl.ONE_MINUS_SRC_ALPHA
--        mask:setBlendFunc(bf)
--        mask:visit()
--        bf=nil
--        bf=ccBlendFunc:new_local()
--        bf.src=gl.DST_ALPHA
--        bf.dst=gl.ZERO
--        sprite:setBlendFunc(bf)
--        sprite:visit()
--        bf=nil
--        local blendSp=rt:getSprite()
--        sprite:setTexture(blendSp:getTexture())
--        rt:endToLua()
--        sprite:setFlipY(true)
--        sprite:setAnchorPoint(ap)
--        sprite:setPosition(x,y)
--
--        if scale == nil then scale = 1 end
--        sprite:setScale(scale)
--
--    end
--    return LeverSprite:create(U:entityImgUrl(imgUrl or ''),imgHolder,doMask)
--end
--
---- 切圆角
--U.leverSpriteWithMaskSlot=function(self,imgUrl,imgHolder,maskSprite)
--    local doMask=function(sprite)
--        sprite=tolua.cast(sprite,'CCSprite')
--        local w,h=sprite:getContentSize().width,sprite:getContentSize().height
--        local rt=CCRenderTexture:create(w,h)
--        local mask=maskSprite
--        mask=CCSprite:create(maskSprite)
--        assert(mask,'creating mask sprite failed'..maskSprite)
--        mask:setPosition(w/2,h/2)
--        local ap=sprite:getAnchorPoint()
--        local x,y=sprite:getPositionX(),sprite:getPositionY()
--        sprite:setAnchorPoint(cc.p(.5,.5))
--        sprite:setPosition(w/2,h/2)
--        rt:beginWithClear(0,0,0,0)
--        local bf=ccBlendFunc:new_local()
--        bf.src=GL_SRC_ALPHA
--        bf.dst=GL_ONE_MINUS_SRC_ALPHA
--        mask:setBlendFunc(bf)
--        mask:visit()
--        bf=nil
--        bf=ccBlendFunc:new_local()
--        bf.src=GL_DST_ALPHA
--        bf.dst=GL_ZERO
--        sprite:setBlendFunc(bf)
--        sprite:visit()
--        bf=nil
--        local blendSp=rt:getSprite()
--        sprite:setTexture(blendSp:getTexture())
--        rt:endToLua()
--        sprite:setFlipY(true)
--        sprite:setAnchorPoint(ap)
--        sprite:setPosition(x,y)
--    end
--    return LeverSprite:createWithFrameName(imgUrl,imgHolder,doMask)
--end



U.combineSprite=function(self,size,...)
    local rt=cc.RenderTexture:create(size.width,size.height)
    rt:beginWithClear(0,0,0,0)

    for k,v in pairs({...}) do
        v:visit()
    end
    local ret=cc.Sprite:createWithTexture(rt:getSprite():getTexture())
    rt:endToLua()
    ret:setFlipY(true)
    return ret
end


U.clampf = function(self, value, min_inclusive, max_inclusive)
    value = tonumber(value)
    min_inclusive = tonumber(min_inclusive)
    max_inclusive = tonumber(max_inclusive)
    local temp = 0
    if min_inclusive > max_inclusive then
        temp = min_inclusive
        min_inclusive =  max_inclusive
        max_inclusive = temp
    end

    if value < min_inclusive then
        return min_inclusive
    elseif value < max_inclusive then
        return value
    else
        return max_inclusive
    end
end

U.splitStringToTable = function(self, s)
    if U:isNil(s) then return nil end

    local iter = 1
    local t = {}  -- results table

    while true do

        if iter > string.len(s) then
            break
        end
        local last = iter + utf8charbytes(s, iter) - 1
        table.insert (t, string.sub (s, iter, last))
        iter = last + 1
    end -- while

    return t
end

U.random = function(self, m, n)
    return math.random() * (n - m) + m
end

U.labelWithOutline = function(self, str, font, size, strColor, outColor, lineWidth)

    -- left
    local left = cc.LabelTTF:create(str, font, size)
    left:setColor(outColor)

    -- right
    local right = cc.LabelTTF:create(str, font, size)
    right:setColor(outColor)
    right:setPosition(cc.p(left:getContentSize().width * 0.5 + lineWidth * 2, left:getContentSize().height * 0.5))
    left:addChild(right)

    -- up
    local up = cc.LabelTTF:create(str, font, size)
    up:setColor(outColor)
    up:setPosition(cc.p(left:getContentSize().width * 0.5 + lineWidth, left:getContentSize().height * 0.5 + lineWidth))
    left:addChild(up)

    -- down
    local down = cc.LabelTTF:create(str, font, size)
    down:setColor(outColor)
    down:setPosition(cc.p(left:getContentSize().width * 0.5 + lineWidth, left:getContentSize().height * 0.5 - lineWidth))
    left:addChild(down)

    -- center
    local center = cc.LabelTTF:create(str, font, size)
    center:setColor(strColor)
    center:setPosition(cc.p(left:getContentSize().width * 0.5 + lineWidth, left:getContentSize().height * 0.5))
    left:addChild(center)

    return left
end

U.btnDisable = function(self, that, disabled, btns, ccbProxy, btnClick)
    if btns == nil then
        btns={
            'common/button/normal.png',
            'common/button/press.png',                       --todo
            'common/button/disabled.png'
        }
    end

    if disabled == true then
        local spriteFrame=U:spriteFrame(btns[3])
        that:setBackgroundSpriteFrameForState(spriteFrame,cc.CONTROL_STATE_NORMAL)
        that:setBackgroundSpriteFrameForState(spriteFrame,cc.CONTROL_STATE_HIGH_LIGHTED)
    elseif disabled == false then
        local normal=U:spriteFrame(btns[1])
        local press=U:spriteFrame(btns[2])
        that:setBackgroundSpriteFrameForState(normal,cc.CONTROL_STATE_NORMAL)
        that:setBackgroundSpriteFrameForState(press,cc.CONTROL_STATE_HIGH_LIGHTE)
    end

    if ccbProxy ~= nil and btnClick ~= nil and type(btnClick) == "function" then
        ccbProxy:handleButtonEvent(that, function()
            btnClick()
        end, cc.CONTROL_EVENTTYPE_TOUCH_UP_INSIDE)
    end


end

U.createNormalButton = function(self, options)
    local _options = {
        preferredSize = cc.size(140, 50),
        fontSize      = 20,
        title         = "title",
        fontColor     = Slot.CCC3.white,
        click         = function()
        end
    }
    _options = U:extend(true, _options, options)
    return Slot.ui.Button:new(_options)
end

U.createSpecialButton = function(self, options)
    local _options = {
        preferredSize = cc.size(140, 50),
        title         = "title",
        fontColor     = Slot.CCC3.white,
        bg            = {"common/button/140red-botton.png","common/button/140red-botton-down.png","common/button/140red-botton-down.png","common/button/140button-disable.png"},   --todo
        fontSize      = 20,
        click         = function()
        end
    }
    _options = U:extend(true, _options, options)
    return Slot.ui.Button:new(_options)
end

U.btnWithSound=function(self,proxy,btn,callback,event)
    proxy:handleButtonEvent(btn,function()
            Slot.Audio:playBtn()
            callback()
        end,event or cc.CONTROL_EVENTTYPE_TOUCH_UP_INSIDE)
end
U.postWithRetry=function(self,url,data,onsuccess,onError,delay,retry,exitCode,cnt)
    delay=delay or 5
    retry=retry or 0
    exitCode=exitCode or {'404'}
    cnt=cnt or 0
    Slot.http:post(url, data,
        function(resp) 
            cnt=cnt+1
            if tonumber(resp.errorCode)==0 then
                _=onsuccess and  onsuccess(resp,cnt)
            else
                U:setTimeoutUnsafe(function()
                    U:postWithRetry(url,data,onsuccess,onError,delay,retry,exitCode,cnt)
                end,delay) 
            end
        end,
        function(status,data)
            cnt=cnt+1
            if U:ArrayContainValue(exitCode or {},tostring(status)) then
                _=onError and onError(status,data,cnt)
                return
            elseif retry>=0 and cnt>=retry then
                _=onError and onError(status,data,cnt)
                return
            end
            U:setTimeoutUnsafe(function()
                U:postWithRetry(url,data,onsuccess,onError,delay,retry,exitCode,cnt)
            end,delay) 
        end,{},true) 
end
U.sequence=function(self,actions)
    local arr={}
    for k,v in pairs(actions) do
        table.insert(arr, v)
    end
    return cc.Sequence:create(arr)
end

-- 将转码的特殊符号再转过来
U.htmlDecode = function(self, str)
    local html_decode =
    [[
    {
        "&lt;" : "<",
        "&gt;" : ">",
        "&amp;" : "&",
        "&nbsp;": " ",
        "&quot;": "\"",
        "&lt" : "<",
        "&gt" : ">",
        "&amp" : "&",
        "&nbsp": " ",
        "&quot": "\""
    }
    ]]
    html_decode = dkjson.decode(html_decode)
    for k, v in pairs(html_decode) do
        str = string.gsub(str, k, v)
    end
    return str
end
U.tilingSprite=function(self,img,size)
    local ret=cc.Sprite:create()
    ret:setContentSize(size)
    
    local sprite=cc.Sprite:create(img)
    local w,h=sprite:getContentSize().width,sprite:getContentSize().height
    local m,n=math.floor((size.width+w-1)/w),math.floor((size.height+h-1)/h)
    local bn=cc.SpriteBatchNode:create(img,m*n)
    for i=1,m do
        for j=1,n do
            sprite=cc.Sprite:createWithTexture(bn:getTexture())
            sprite:setAnchorPoint(cc.p(1,1))
            sprite:setPosition(i*w,j*h)
            bn:addChild(sprite)
            sprite=nil
        end
    end
    ret:addChild(bn)
    return ret
end

U.collectCoinFactor = function(self)

    local profile = Slot.DM:getBaseProfile()

    local level = tonumber(profile.level)

    return 1+(level-1)*0.2

end

U.loadPng = function(self,preUrl,preName,count)
    for i=1, count do
        cc.Sprite:create(string.format("%s/%s%s.png", preUrl, preName, i))
    end
end

U.getFileNameWithExt = function(self, filepath)

    local fn_flag = (cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_WINDOWS)

    if fn_flag then

        return string.match(filepath, ".+\\([^\\]*%.%w+)$")

    end

    return string.match(filepath, ".+/([^/]*%.%w+)$")

end

U.getFileExt = function(self, filepath)

    return filepath:match(".+%.(%w+)$")

end

--去除扩展名
U.getFileName = function(self, filename)

    local idx = filename:match(".+()%.%w+$")
    if(idx) then
        return filename:sub(1, idx-1)
    else
        return filename
    end
end


U.getFileDir = function(self, filename)

    local fn_flag = (cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_WINDOWS)

    if fn_flag then

        return string.match(filename, "(.+)\\[^\\]*%.%w+$")
    end

    return string.match(filename, "(.+)/[^/]*%.%w+$")
--

end

U.clearModule = function(self, reload)

    Slot.__loaded = Slot.__loaded or {}

    for k,v in pairs(Slot.__loaded) do
        if v ~= "component.pages.IndexPage" then
--            print(v)
            package.loaded[v] = nil
        end
    end

    if reload then

        require "bootstrap"
    end

end

U.reloadModule = function (self, moduleName)

    package.loaded[moduleName] = nil

    return require(moduleName)

end

U.randforgame = function(self, value, min , max)

    if type(value) ~= "number" then value = tonumber(value) end

    if not min then min = 0 end
    local RANDOM_MAX = 4294967295
    local q = math.floor(value/127773)
    local r = math.floor(value%127773)
    local t = 16807*r-2836*q
    if t<=0  then t = t + RANDOM_MAX end

    local res = t%(RANDOM_MAX+1)
    if max then res = res % max end

    return math.floor(min + res), t

end

U.isAllIndex = function(self,tab,index)

    for i=1,#tab do

        if tab[i]~=index then
            return false
        end
    end

    return true


end

U.addTapMusic = function(self)
    --添加音乐
    Slot.Audio:playEffect("sound/common/"..Slot.MusicResources["common"].tap)
end


U.formatNumber=function(self,str)

   
    if string.len(str)<=3 then
        return str
    else

        local strR=string.sub(str,1,string.len(str)-3)
        return U:formatNumber(strR)..","..string.sub(str,string.len(str)-2)
    end



end


U.stringTonum=function(self,str)

    if not str or str == "" or string.len(str) <= 0 then return end

    local t = U:split(str, ",")

    if not t then return end

    local strnum = table.concat(t, "")

    return tonumber(strnum)

end

U.setTitle = function(self, btn, title, type, file, state)  --main for ccb controlbutton fnt

    if state == nil then  state = cc.CONTROL_STATE_NORMAL end

    if type == "ttf" then
        btn:setTitleTTFForState(file, state)
    elseif type == "fnt" then
        btn:setTitleBMFontForState(file, state)
    end

    btn:setTitleForState(title, state)


end

U.addSpriteFrameResource=function(self,fileName)

    local cache=cc.SpriteFrameCache:getInstance()
    cache:addSpriteFrames(fileName)

end

U.getSpriteFrame=function(self,frameName)

    local cache=cc.SpriteFrameCache:getInstance()
    local frame=cache:getSpriteFrame(frameName)

    return frame

end

U.getSpriteByName=function(self,frameName)

    return cc.Sprite:createWithSpriteFrameName(frameName)

end

U.get9SpriteByName=function(self,frameName,rect)

    if not rect then
        return cc.Scale9Sprite:createWithSpriteFrameName(frameName)
    end

    return cc.Scale9Sprite:createWithSpriteFrameName(frameName,rect)

end

U.isAllSame=function(self,tab)

    for i=1,#tab do

        local temp=tab[i]
        for j=i+1,#tab do

            if temp~=tab[j] then

                return false
            end

        end

    end

    return true

end


U.getJsonFromFile = function(self, filename)

    if not cc.FileUtils:getInstance():isFileExist(filename) then return end

    local path = cc.FileUtils:getInstance():fullPathForFilename(filename)

    local f = assert(io.open(path, 'r'))
    local string = f:read("*all")
    f:close()

    if not string or U:trim(string) == "" or string.len(string) <= 0 then
        return nil
    end
    return dkjson.decode(string)
end

U.writeJsonToFile = function(self, data, path)

    local js_string = dkjson.encode(data)
    local f = assert(io.open(path, 'w'))
    f:write(js_string)
    f:close()

end


U.getIndexInStr=function(self,str,subStr)

    local startPos=1
    local pos
    local endPos

    -- 得到最后一个空格的位置
    while true do

        pos=string.find(str,subStr,startPos)
        endPos=pos

        if pos then

            startPos=string.find(str,subStr,pos+1)

            if not startPos then break end

            startPos=startPos+1

        else
            endPos=startPos-1
            break

        end

    end

    return endPos


end


U.clearAllNode=function(self,tab)

    if tab then
        for i=1,#tab do

            if tab[i] then
                tab[i]:removeFromParent()
                tab[i]=nil
            end

        end
        tab=nil
    end

end


U.getDayTimeStamp = function(self, time)

    local date = os.date("*t", time)

    return os.time({year=date.year, month=date.month, day=date.day})
end

U.empty = function(self, v)

    if v == nil then return true end

    if type(v) == "string" and string.len(U:trim(v)) <= 0 then return true end

    if type(v) == "table"  and next(v) == nil then return true end

    return false

end











