--
-- by bbf
--

Slot = Slot or {}

Slot.Configuration = {

    basePath = cc.FileUtils:getInstance():getWritablePath().."cache/",
--    originAddress = "http://124.205.66.76", --固定地址
    httpServer = "http://10.1.8.41/server",
    DEBUG = cc.LeverConfigure:getInstance():getPlatfomParamByKey("debug"),
    nativeVersion = cc.LeverConfigure:getInstance():getPlatfomParamByKey("bundleVersion"),
    bundeId = cc.LeverConfigure:getInstance():getPlatfomParamByKey("bundeId"),
    languageCode = cc.LeverConfigure:getInstance():getPlatfomParamByKey("languageCode"),
    countryCode = cc.LeverConfigure:getInstance():getPlatfomParamByKey("countryCode"),

--    setConfig = function(self)
--
--        if self.DEBUG == "true" then return true end
--        Slot.DM:setLocalStorage("serverAddress", "", false)
--        Slot.DM:setLocalStorage("httpServer", "", false)
----        直接请求配置文件
--
--        local status = Slot.NetworkStatus[cc.LeverNetworkUtils:getInstance():getNetworkType("www.apple.com")]
--
--        if status == "kNetworkTypeNone" then
--
--            if self.msgDlg then return end
--
--            self.msgDlg = Slot.com.MessageDialog:new({
--                title   = U:locale("common", "network_delay_title"),
--                message = U:locale("common", "network_delay_message"),
--                ccbi = "ccbi/LargeDlg.ccbi",
--                overlayClick = false,
--                midText = U:locale("common", "Restart"),
--
--                midBtn = {
--
--                    normal = "green_long_btn.png",
--                    hightLight = "green_long_btn.png",
--                    selected = "green_long_btn.png",
--                    disabled = "green_long_btn.png",
--
--                },
--
--                midBtnClick = function(opt)
--                    opt.afterClose = function(that)
--                        self.msgDlg = nil
--                        Slot.App:load()
--                    end
--
--                    self.msgDlg:close()
--
--                end,
--
--            })
--            self.msgDlg:open()
--
--            return false
--        end
--        local leverAM = cc.LeverAssetsManager:new()
--        leverAM:retain()
--        local cofigFile = dkjson.decode(leverAM:getConfigFile(self.originAddress.."/server/config.json"))
--        Slot.DM:setLocalStorage("serverAddress", cofigFile.serverAddress, false)
--        if not cofigFile or not next(cofigFile) then
--
----            Slot.Error:openDlg(Slot.Error.ERR_CONFIG)
--
--            return false
--        end
--
--        self.serverAddress = cofigFile.serverAddress
--        self.http = cofigFile.httpServer
--
--        if cofigFile.serverAddress then
--            Slot.DM:setLocalStorage("serverAddress", cofigFile.serverAddress, false)
--        end
--
--        if cofigFile.httpServer then
--            Slot.DM:setLocalStorage("httpServer", cofigFile.httpServer, false)
--        end
--
--        if tonumber(self.nativeVersion) < tonumber(cofigFile.nativeVersion) and cofigFile.forceUpdate then
--
--            self.msgDlg = Slot.com.MessageDialog:new({
--                title   = U:locale("common", "need_update_title"),
--                message = U:locale("common", "need_update_content"),
--                ccbi = "ccbi/LargeDlg.ccbi",
--                overlayClick = false,
--
--                midText = U:locale("common", "go_update"),
--
--                midBtn = {
--
--                    normal = "green_long_btn.png",
--                    hightLight = "green_long_btn.png",
--                    selected = "green_long_btn.png",
--                    disabled = "green_long_btn.png",
--
--                },
--
--                midBtnClick = function(opt)
--
--                    self.msgDlg:close()
--
----                    todo::
--                    cc.LeverUtils:getInstance():openUrl("http://www.baidu.com") --todo::
--
--
--                end})
--
--            self.msgDlg:open()
--
--            return false
--
--        end
--
--        return true
--
--    end,


    debug_user = {
        userID = "xiaofengxyz2",
        token = "",
        platform = "",
        platformToken = "",
        type = 1,
    },

    Update_FileList = {},

    net_connect = true,


}

