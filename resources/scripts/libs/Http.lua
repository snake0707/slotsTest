--
-- Created by IntelliJ IDEA.
-- User: bbf
-- Date: 14-11-17
-- Time: 下午2:38
-- To change this template use File | Settings | File Templates.
--

---
-- Network 封装
--
-- bbf
--

--
-- Network
--

Slot = Slot or {}

Slot.libs = Slot.libs or {}

Slot.libs.http = Slot.libs.http or {}

--Slot.libs.http.baseUrl = string.format("http://%s%s/ajax",Configuration.serverAddress ,Configuration.webContext)

Slot.libs.http.method = {
    "GET",
    "POST"
}

Slot.libs.http.responseType = {
    cc.XMLHTTPREQUEST_RESPONSE_STRING,
    cc.XMLHTTPREQUEST_RESPONSE_ARRAY_BUFFER,
    cc.XMLHTTPREQUEST_RESPONSE_BLOB,
    cc.XMLHTTPREQUEST_RESPONSE_DOCUMENT,
    cc.XMLHTTPREQUEST_RESPONSE_JSON
}

Slot.libs.http.requestMap = {}

Slot.libs.http.clearQueue = function(self)
    U:fdebug("Slot.libs.http","clearQueue")
    for k,v in pairs(self.requestMap) do
--        if not v.sticky then
--            self.requestMap[k]=nil
--        end
        self.requestMap[k]=nil
    end
end

Slot.libs.http.do_auth = function(self, func)

    local profile = Slot.DM:getBaseProfile()
    -- U:debug(profile)
    local params = {
        player_id = profile.player_id,
        password = profile.password,
        isSigned = false,
    }
    self:post("player/auth", params , function(data)

        if data.rc == 0 then

            local p = data.player
            profile.token = p.token
            profile.token_expire = data.expire
            Slot.DM:setBaseProfile(profile)

            local device_token_expire = data.token_reamin_time + os.time()
            Slot.DM:setLocalStorage("device_token_expire", device_token_expire)

            func()

        end

    end)

end

Slot.libs.http.requestSync = function(self,method,url,params,handle, options)

    if not options then options = {} end

    if not options.requestTimes then options.requestTimes = 1 else options.requestTimes = options.requestTimes + 1 end

    if not options.lastTime then options.lastTime = os.time() end

    if not options.current_page then options.current_page = Slot.App:getCurrentPage() end

    table.insert(self.requestMap, {
        method = method,
        url = url,
        params = params,
        handle = handle,
        options = options
    })

    local isSigned = params.isSigned
    params.isSigned = nil
    if isSigned == nil then isSigned = true end

    local doAuth = params.doAuth
    params.doAuth = nil
    if doAuth == nil then doAuth = false end

    -- 预处理

    local MA = U:split(url, "/")

    if MA and #MA > 1 then
        local _msg = table.concat(MA, ".")
        params['_msg'] = _msg
    end
    local profile = Slot.DM:getBaseProfile()

    local device_token_expire = Slot.DM:getLocalStorage("device_token_expire")
    if not device_token_expire then device_token_expire = 0 end

    if (isSigned and (profile and not U:empty(profile.player_id) and tonumber(device_token_expire) <= os.time() - 3600)) or doAuth then

        local requestMap = table.remove(self.requestMap)

        self:do_auth(function()
            requestMap.params.doAuth = false
            self:requestSync(requestMap.method, requestMap.url, requestMap.params, requestMap.handle, requestMap.options)

--          local sig = {profile.player_id, profile.token, profile.token_expire}
--          params['_sig'] = table.concat(sig, ".")

--          self:request(method,params,function(status, data, err)
--              handle(status, data, err)
--          end,options)

        end)

        return
    end

    if isSigned then
        local sig
        if profile then
            sig = {profile.player_id, profile.token, profile.token_expire}
        end


        params['_sig'] = table.concat(sig, ".")

    end

    self:request(method,params,function(status, data, err)
        handle(status, data, err)
    end)
end


Slot.libs.http.request = function(self,method,params,handle)
--    local url = Slot.libs.http.baseUrl..url

    Slot.Configuration.httpServer = Slot.DM:getLocalStorage("httpServer", false) or Slot.Configuration.httpServer
    local request_url = Slot.Configuration.httpServer.."/index.php"

    local xhr = cc.XMLHttpRequest:new()
    xhr:setRequestHeader("M-Compress-Message", "0")
    xhr.timeout = 8
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
    xhr:registerScriptHandler(function()
        handle(xhr.status, xhr.response, xhr.statusText)

    end)

    if method == "get" then
        local temp = {}

        for k,v in pairs(params) do table.insert(temp, U:urlencode(k).."="..U:urlencode(v)) end

        xhr:open("GET", request_url..(function() if #temp > 0 then return "?"..table.concat(temp, "&") else return "" end end)())

        xhr:send()
    else

        local temp = { {"a","1"} }
        for k,v in pairs(params) do table.insert(temp, { k, v }) end
        table.sort(temp,function(first,second)
            return first[1] < second[1]
        end)
        local sendParam = {}
        for i,param in ipairs(temp) do table.insert(sendParam, U:urlencode(param[1]).."="..U:urlencode(param[2])) end

        xhr:open("POST", request_url)

        xhr:send(table.concat(sendParam, "&"))
        U:debug("[sendParam:]"..table.concat(sendParam, "&"))

--      网络状态不好的等待弹框
        self.wait = U:setTimeoutUnsafe(function()

            if not self:checkCurPage(self.requestMap[1]) then
                return

            end

            if not self.toastDlg then
                self.toastDlg = Slot.com.ToastDialog:new({
                    afterClose = function(opt)

                        self.toastDlg = nil

                    end
                })
                self.toastDlg:open()
            end

        end, 3)

        self.waitEnd = U:setTimeoutUnsafe(function()
            self.waitEnd = nil
            self:openFailDlg()
        end, 13)

    end
end

Slot.libs.http.handleMultiLogin  = function(self,data)


    if data and data.rc == Slot.Error.ERR_TOKEN_MISMATCH then

        Slot.Error:openDlg(data.rc)

        return -1
    end
    return 0
end

Slot.libs.http.getHandler = function(self,success,faild)
    success = success or U.noop
    faild   = faild   or function(data, code, err)
        code = code or "nil"
        U:debug("http request got error status = "..code)
    end

    local handle = function (status, data, err)

        self:removeFailState()

        local _d=data

        if status == 1 then
            -- U:debug(_d)
            self:openFailDlg()

            faild(data, status, err)
            return
        end

        if(status == 200 or status == 401 ) then
            if self.failDlg then
                self.failDlg:close()
            end

            if not next(self.requestMap) then return end
            local requestMap = table.remove(self.requestMap)
            if not self:checkCurPage(requestMap) then return end
            self:clearQueue()


            local _data = dkjson.decode(data)
            if _data == nil then
                U:debug('response code '..status)
                U:debug('invalid json response '.._d..' error:'..(err or ''))

            else
                U:debug("[response data:]")
                U:debug(_data)
            end

            if self:handleMultiLogin(_data) == -1 then return end

            if _data.rc == 99999 then
                if Slot.App:getCurrentPage().controller~= "maintain" then
                    Slot.App:switchTo("maintain", {pagePara=_data})
                end
                return
            end

--            for random seed
            if _data.seed and Slot.DM:getBaseProfile() then

                Slot.DM:setLocalStorage("seed", _data.seed)

            end

            success(_data, status)


        else
            self:openFailDlg(status == -1)

            faild(data, status, err)
        end
    end
    return  handle
end


--[[
--
-- for fail state begin
--
-- ]]--

Slot.libs.http.checkCurPage = function(self, requestMap)
    if requestMap and requestMap.options and requestMap.options.current_page then

        local last_page = requestMap.options.current_page

        local current_page = Slot.App:getCurrentPage()
        if last_page.controller ~= current_page.controller or last_page.action ~= current_page.action then
            return false

        end
        return true
    end

    return false

end

Slot.libs.http.removeFailState = function(self)

    if self.toastDlg then

        self.toastDlg:close()

    end

    if self.wait then
        U:clearInterval(self.wait)
        self.wait = nil
    end

    if self.waitEnd then
        U:clearInterval(self.waitEnd)
        self.waitEnd = nil
    end

end

Slot.libs.http.openFailDlg = function(self, restart)

--网络不好的情况

    local requestMap = table.remove(self.requestMap)
    self:clearQueue()
--    if not requestMap then return end

    if not self:checkCurPage(requestMap) then
        return

    end
    if self.failDlg then return end
    if not restart and requestMap and requestMap.options and (requestMap.options.requestTimes % 4 ~= 0 or os.time() - requestMap.options.lastTime < 10) then
        self:requestSync(requestMap.method, requestMap.url, requestMap.params, requestMap.handle, requestMap.options)

        return

    end
    self:removeFailState()

    local leftText, rightText, midText

    if not restart then

        leftText = U:locale("common", "Wait")
        rightText = U:locale("common", "Restart")
    else

        midText = U:locale("common", "Restart")
    end


    self.failDlg   = Slot.com.MessageDialog:new({
        title   = U:locale("common", "network_delay_title"),
        message = U:locale("common", "network_delay_message"),
        overlayClick = false,
        afterClose = function(opt)

            self.failDlg = nil

        end,
        leftText = leftText,

        leftBtnClick = function(opt)
            U:debug("for game update66666666=====================================")
            self.failDlg :close()

            if requestMap and next(requestMap) then
                requestMap.options.lastTime = os.time()

                if requestMap.options.requestTimes % 4 == 0 then requestMap.options.requestTimes = requestMap.options.requestTimes + 1 end

                self:requestSync(requestMap.method, requestMap.url, requestMap.params, requestMap.handle, requestMap.options)
            end

        end,

        rightText = rightText,

        rightBtnClick = function(opt)

            self.failDlg :close()
            self.failDlg = nil
            Slot.App:load()

        end,

        midText = midText,

        midBtnClick = function(opt)

            self.failDlg :close()

            Slot.App:load()

        end,
        midBtn =  {
            normal = "green_long_btn.png",
            hightLight = "green_long_btn.png",
            selected = "green_long_btn.png",
            disabled = "green_long_btn.png",
        }

    })
    self.failDlg :open()

end

Slot.libs.http.testNetWork = function(self, restart)

    if Slot.Configuration.DEBUG == "true" then return true end

    local status = Slot.NetworkStatus[cc.LeverNetworkUtils:getInstance():getNetworkType("www.apple.com")]
    if status == "kNetworkTypeNone" then

        self:openFailDlg(true)

        return false
    end

    return true

end

--[[
--
-- api
--
-- ]]--

Slot.libs.http.get = function(self, url, params, success, faild, options)
--    if options and options.showWait == true then
--        Slot.app.showWait(true)
--    end

    if not self:testNetWork(true) then return end
    local handle = self:getHandler(success, faild)
    self:requestSync("GET", url, params, handle, options)
end

Slot.libs.http.post = function(self, url, params, success, faild, options)
--    if options and options.showWait == true then
--        Slot.app.showWait(true)
--    end
    local handle = self:getHandler(success, faild)

    if not Slot.Configuration.net_connect then
        return handle("200", {rc = 0,seed = os.time() }, "200ok")
    end

    if not self:testNetWork(true) then return end


    self:requestSync("POST", url, params, handle, options)
end

Slot.http = Slot.libs.http