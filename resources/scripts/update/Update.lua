--
--by bbf
--

-- update文件需要相对独立于其他文件
Slot = Slot or {}

Slot.UpdateConfig = {

    basePath = cc.FileUtils:getInstance():getWritablePath().."cache/",
    originAddress = "http://124.205.66.76", --固定地址
    serverAddress = "http://10.1.8.41",
    update_path   = "scripts/update/Update.lua",
    getSearchPaths = function(self)

        return {
            self.basePath.."scripts/",
            self.basePath.."image/",
        }

    end,
}

Slot.Update = Slot.ui.UIComponent:extend({

    __className = "Slot.Update",

    initWithCode = function(self, options)
        self:_super(options)
        self._files = {}
        self._downLoadNum = 1
--        self._curState = "GETCONFIGFILE" --"GETFILELIST" --"GETGAMEFILE"

        self._curState = "GETFILELIST"
        if self._options.type == "common" then
            self._curState = "GETCONFIGFILE"
        end

--        self._localFilesMd5 = self:getJsonFromStorage()
        self:_setup()
    end,

    _setup = function(self)

        self:_prepareForUpdate()

    end,

    _prepareForUpdate = function(self)

        self:updateSearchPath()  -- 预先设置优先搜索路径

--        if self:isNetEnable() then
--
--            self:update()
--
--        end
        self:testNetWork()

    end,

    isNetEnable = function(self)

        if Slot.Configuration.DEBUG == "true" then return true end

        local status = Slot.NetworkStatus[cc.LeverNetworkUtils:getInstance():getNetworkType("www.apple.com")]

        if status == "kNetworkTypeNone" then
            self:openFailDlg()
            return false
        end

        return true

    end,

    testNetWork = function(self)

        if Slot.Configuration.DEBUG == "true" then return self:update() end

        U:debug("status000000=========================")

        local status = Slot.NetworkStatus[cc.LeverNetworkUtils:getInstance():getNetworkType("www.apple.com")]

        U:debug("status========================="..status)

        if status == "kNetworkTypeNone" then

            self:openFailDlg()

        elseif status == "kNetworkTypeWWAN" then

            if Slot.updateWarningDlg then return end

            Slot.updateWarningDlg = Slot.com.MessageDialog:new({
                title   = U:locale("common", "update_title"),
                message = U:locale("common", "update_message", {num = #self._files - self._downLoadNum + 1}),
                ccbi = "ccbi/LargeDlg.ccbi",
                overlayClick = false,
                leftText = U:locale("common", "Later"),

                leftBtnClick = function(opt)

                    opt.afterClose = function(that)

                        Slot.DM:setLocalStorage(self._options.type.."_download", 0, false)
                        Slot.DM:setLocalStorage(self._options.type.."_downloading", 0, false)
                        self._options.laterDownLoad()
                        self:fireEvent("laterdownload")
                        self:reset()

                        if self._options.type == "common" then

                            Slot.App:load()

                        end

                        Slot.updateWarningDlg = nil

                    end

                    Slot.updateWarningDlg:close()


                end,

                rightText = U:locale("common", "DOWNLOAD"),

                rightBtn = {
                    normal = "green_longer_btn.png",
                    hightLight = "green_longer_btn.png",
                    selected = "green_longer_btn.png",
                    disabled = "green_longer_btn.png",
                },

                rightBtnClick = function(opt)

                    Slot.updateWarningDlg:close()
                    Slot.updateWarningDlg = nil
                    self:update()

                end,

            })
            Slot.updateWarningDlg:open()

        else

            self:update()

        end

    end,

    getUpdateFileList = function(self)

        require "libs.dkjson"

        local update_files = {}

        local path = cc.FileUtils:getInstance():getWritablePath().."cache/"..self._options.type..".json"
        local all_files = U:getJsonFromFile(path)
        if not all_files then
            self:openFailDlg()
            return nil
        end

        Slot.Configuration.Update_FileList[self._options.type] = true

        -- check the update file self's update

        local update_path = Slot.UpdateConfig.update_path

        if self._options.type == "common"
                and (not cc.FileUtils:getInstance():isFileExist(update_path)
                or Slot.libs.md5:md5file(update_path) ~= all_files[update_path])
        then
            self.update_self = true
            return update_files
        end

       -- other file's update

        local fileMd5 = Slot.libs.md5:md5file(path)
        if Slot.DM:getLocalStorage(self._options.type.."_file_MD5", false) == fileMd5 then
            return update_files

        end

--        Slot.DM:setLocalStorage(self._options.type.."_file_MD5", fileMd5, false)

--        local local_files_md5 = self:getJsonFromStorage()

        for k, v in pairs(all_files) do

            if U:getFileExt(k) == "json" then  -- 模块更新
                local filename = U:getFileName(k)
                local moduleMd5 = Slot.DM:getLocalStorage(filename.."_file_MD5", false)
                if moduleMd5 and moduleMd5 ~= v then
                    Slot.DM:setLocalStorage(filename.."_download", 0, false)  --置下载状态为0
                end

            else
--                U:debug("self._localFilesMd5[k]===="..self._localFilesMd5[k])

                if not cc.FileUtils:getInstance():isFileExist(k) or Slot.libs.md5:md5file(k) ~= v then --self._localFilesMd5[k] ~= v then
                    table.insert(update_files, {k, v})
                end

            end

        end
        return update_files

    end,

    update = function(self)

--        GET FILE LIST

        local path = cc.FileUtils:getInstance():getWritablePath().."cache/"

        if self._curState == "GETCONFIGFILE" then

            return self.rootNode:update(Slot.UpdateConfig.originAddress.."/server/config.json", path)

        end

        Slot.UpdateConfig.serverAddress = Slot.DM:getLocalStorage("serverAddress", false) or Slot.UpdateConfig.serverAddress

        if self._curState == "GETFILELIST" then
--            U:debug(Slot.Configuration.serverAddress.."/output/"..self._options.type..".json")
            if Slot.Configuration.Update_FileList[self._options.type] then
               return self._options.onSuccess()

            end
            return self.rootNode:update(Slot.UpdateConfig.serverAddress.."/output/"..self._options.type..".json", path)

        end

        if self.update_self then
            return self.rootNode:update(Slot.UpdateConfig.serverAddress.."/output/resources/"..Slot.UpdateConfig.update_path, path..U:getFileDir(Slot.UpdateConfig.update_path))

        end


        if #self._files == 0 then
            return self._options.onSuccess()

        end

        local item = self._files[self._downLoadNum]

        self.rootNode:update(Slot.UpdateConfig.serverAddress.."/output/resources/"..item[1], path..U:getFileDir(item[1]))

    end,

    updateSearchPath = function(self, reload)
        local lfs = require "lfs"

        if reload then
            U:reloadModule("libs.Configuration")
        end

        local need_searchPaths = Slot.UpdateConfig:getSearchPaths()
        local searchPaths = cc.FileUtils:getInstance():getSearchPaths()

        for k, v in pairs(need_searchPaths) do

            if not U:ArrayContainValue(searchPaths, v) then
                lfs.mkdir(v)
                table.insert(searchPaths, 1, v)
            end
        end

        cc.FileUtils:getInstance():setSearchPaths(searchPaths)

    end,

    reset = function(self, reload)
        self:updateSearchPath(reload)
        self.rootNode:release()
    end,

    restartUpdate = function(self)
        self._options.restartUpdate()

    end,

    onError = function(self)
        self:openFailDlg()

    end,

    onProgress = function(self)

    end,

    onSuccess = function(self)

--        GET FILE LIST

        if self._curState == "GETCONFIGFILE" then

            local path = cc.FileUtils:getInstance():getWritablePath().."cache/config.json"
            local config = U:getJsonFromFile(path)
            if not config then
                self:openFailDlg()
                return nil
            end

            if self:updateConfig(config) then

                self._curState = "GETFILELIST"

                return self:update()
            end

            return

        end


        if self._curState == "GETFILELIST" then

            self._files = self:getUpdateFileList()

            if not self._files then
                return
            end
            self._curState = "GETGAMEFILE"

            if self.update_self then return self:update() end

            return self:update()
        end

        if self.update_self then
            self.update_self = false

            self:reset()

            return  self:restartUpdate()
        end


        if #self._files == 0 then

            self:update_sucess()
            self:reset()

            self:fireEvent("update_sucess"..self._options.type, {
                percent = 100,
                totalFileNum = 100,
                downLoadNum = 100
            })
            self._options.callBack(100, 2, {
                totalFileNum = 100,
                downLoadNum = 100
            })
            return

        end

        -- 下载下一个文件
        -- U:debug("下载文件"..self._downLoadNum)
        -- U:debug("下载文件总数"..#self._files)

--        self:setJsonToStorage()

        local percent = (self._downLoadNum) / #self._files * 100

        self:fireEvent("update_sucess"..self._options.type, {
            percent = percent,
            totalFileNum = #self._files,
            downLoadNum = self._downLoadNum
        })
        self._options.callBack(percent, 0.5, {
            --            percent = percent,
            totalFileNum = #self._files,
            downLoadNum = self._downLoadNum
        })

        if self._downLoadNum < #self._files then

            Slot.DM:setLocalStorage(self._options.type.."_downloading", 1, false)
            self._downLoadNum = self._downLoadNum + 1
            self:update()
        else

            self:update_sucess()
            self:reset(true)

        end

    end,

    updateConfig = function(self, cofigFile)

        Slot.UpdateConfig.serverAddress = cofigFile.serverAddress
        Slot.Configuration.httpServer  = cofigFile.httpServer

        if cofigFile.serverAddress then
            Slot.DM:setLocalStorage("serverAddress", cofigFile.serverAddress, false)
        end

        if cofigFile.httpServer then
            Slot.DM:setLocalStorage("httpServer", cofigFile.httpServer, false)
        end

        if tonumber(Slot.Configuration.nativeVersion) < tonumber(cofigFile.nativeVersion) and cofigFile.forceUpdate then

            self.versionDlg = Slot.com.MessageDialog:new({
                title   = U:locale("common", "need_update_title"),
                message = U:locale("common", "need_update_content"),
                ccbi = "ccbi/LargeDlg.ccbi",
                overlayClick = false,
                midText = U:locale("common", "go_update"),
                midBtn = {

                    normal = "green_long_btn.png",
                    hightLight = "green_long_btn.png",
                    selected = "green_long_btn.png",
                    disabled = "green_long_btn.png",

                },

                midBtnClick = function(opt)

                    self.versionDlg:close()

--                  todo::
                    cc.LeverUtils:getInstance():openUrl("http://www.baidu.com") --todo::


                end})

            self.versionDlg:open()

            return false

        end

        return true

    end,

    update_sucess = function(self)

        Slot.Configuration.Update_FileList[self._options.type] = nil
        Slot.DM:setLocalStorage(self._options.type.."_download", 1, false)
        Slot.DM:setLocalStorage(self._options.type.."_downloading", 0, false)

        local path = cc.FileUtils:getInstance():getWritablePath().."cache/"..self._options.type..".json"
        local fileMd5 = Slot.libs.md5:md5file(path)

        Slot.DM:setLocalStorage(self._options.type.."_file_MD5", fileMd5, false)

    end,

    openFailDlg = function(self)
--        if self.updateFailDlg then return end

        self.updateFailDlg = Slot.com.MessageDialog:new({
            title   = U:locale("common", "network_delay_title"),
            message = U:locale("common", "network_delay_message"),
            ccbi = "ccbi/LargeDlg.ccbi",
            overlayClick = false,
            leftText = U:locale("common", "Wait"),

            leftBtnClick = function(opt)
                U:debug("for game update88888888888=====================================")
                opt.afterClose = function(opt)

                    U:debug("for game update11111=====================================")
                    self:reset()
                    self:restartUpdate()
                    self:fireEvent("restart_update"..self._options.type)
                    self.updateFailDlg = nil

                end

                self.updateFailDlg:close()

            end,

            rightText = U:locale("common", "Restart"),

            rightBtn = {

                normal = "green_long_btn.png",
                hightLight = "green_long_btn.png",
                selected = "green_long_btn.png",
                disabled = "green_long_btn.png",

            },

            rightBtnClick = function(opt)
                opt.afterClose = function(opt)
                    Slot.App:load()
                    self.updateFailDlg = nil
                end

                self.updateFailDlg:close()

            end,


        })
        self.updateFailDlg:open()

    end,



    getJsonFromStorage = function(self)

        local key = self._options.type.."_fileLists_MD5"

        local list_md5 = Slot.DM:getLocalStorage(key, false)

        local tlist_md5 = {}
        if list_md5 then
            tlist_md5 = dkjson.decode(list_md5)
        end

        return tlist_md5

    end,

    setJsonToStorage = function(self, tostorage)

        if not self._files or #self._files == 0 or not self._downLoadNum or self._downLoadNum == 0 then return end
        local key = self._options.type.."_fileLists_MD5"
        local item = self._files[self._downLoadNum]
--        local tlist_md5 = self:getJsonFromStorage()
--        local path = cc.FileUtils:getInstance():getWritablePath().."cache/"
--        local fileMd5 = Slot.libs.md5:md5file(path..item[1])


        if self._localFilesMd5[item[1]] ~= item[2] then
            self._localFilesMd5[item[1]] = item[2]
            local js_string = dkjson.encode(self._localFilesMd5)
            Slot.DM:setLocalStorage(key, js_string, false)
        end

--        if tostorage then
--            local js_string = json.encode(self._localFilesMd5)
--            Slot.DM:setLocalStorage(key, js_string)
--        end

    end,



    getRootNode = function(self)
        if not self.rootNode then
--            self.rootNode = cc.LeverAssetsManager:create(self._options.onError, self._options.onProgress, self._options.onSuccess)
--            self.rootNode:retain()
--            self.rootNode:setConnectionTimeout(3)

            self.rootNode = cc.LeverAssetsManager:new()
            self.rootNode:retain()
            self.rootNode:setDelegate(self._options.onError, cc.LEVER_ASSETSMANAGER_PROTOCOL_ERROR)
            self.rootNode:setDelegate(self._options.onProgress, cc.LEVER_ASSETSMANAGER_PROTOCOL_PROGRESS)
            self.rootNode:setDelegate(self._options.onSuccess, cc.LEVER_ASSETSMANAGER_PROTOCOL_SUCCESS )
            self.rootNode:setConnectionTimeout(3)

        end
        return self.rootNode
    end,

    getDefaultOptions = function(self)
        return {
            nodeEventAware = true,
            type = "common", --or module name
            onError = function()
                self:onError()
                self:fireEvent("update_error")

            end,
            onProgress = function()

                self:fireEvent("update_progress"..self._options.type)

            end,
            onSuccess = function()

                self:onSuccess()

            end,
            callBack = function(percent, sec, attach) end,
            restartUpdate = function() end,
            laterDownLoad = function() end,
        }
    end
})