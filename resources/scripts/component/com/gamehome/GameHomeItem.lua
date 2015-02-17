--
--by bbf
--
Slot = Slot or {}

Slot.com = Slot.com or {}

Slot.com.GameHomeItem = Slot.ui.UIComponent:extend({

    __className = "Slot.com.GameHomeItem",

    initWithCode = function(self, data, options)
        self:_super(options)

        self._data = data

        if self._data == "west" then

            Slot.DM:setLocalStorage(self._data.."_download", 1, false)

        end

        self:_setup()
    end,

    _setup = function(self)

        self.poster_node = self.proxy:getNodeWithName("poster_layer")
        self.lock_btn = self.proxy:getNodeWithName("lock_btn")
        self.download_btn = self.proxy:getNodeWithName("download_btn")
        self.play_btn = self.proxy:getNodeWithName("play_btn")
        self.lock_level = self.proxy:getNodeWithName("lock_level")
        self.down_loading_node = self.proxy:getNodeWithName("down_loading_node")


        --一张大图
        local sprite = U:getSpriteByName("poster_"..self._data..".png")
        local size = sprite:getContentSize()

        self.rootNode:setContentSize(size)
        self.poster_node:setContentSize(size)

        self.poster_node:setPosition(cc.p(size.width/2, size.height/2))
        sprite:setPosition(cc.p(size.width/2, size.height/2))
        self.poster_node:addChild(sprite)

        self.down_loading_node:setVisible(false)

        if self._data == "coming_soon" then

            self.lock_btn:setVisible(false)
            self.download_btn:setVisible(false)
            self.play_btn:setVisible(false)
            self.lock_level:setVisible(false)

            return
        end

        local s,e = string.find(self._data, "_cs")
        if s then

            self.lock_btn:setVisible(false)
            self.download_btn:setVisible(false)
            self.play_btn:setVisible(false)
            self.lock_level:setVisible(false)

            return
        end


        --
        self.lock_btn:setPositionX(size.width/2)
        self.download_btn:setPositionX(size.width/2)
        self.play_btn:setPositionX(size.width - self.play_btn:getContentSize().width)
        self.poster_node:reorderChild(self.play_btn, 1)

        -- status
        local profile = Slot.DM:getBaseProfile()
        self.unlock_level = Slot.DM:getCommonDataByKey("unlock_level")

        if not self.unlock_level[self._options.id] then self.unlock_level[self._options.id] = 0 end

--        U:debug("++++++++++++++++++++++++++++++++")
--        U:debug(self.unlock_level)
--        U:debug(profile)

        if self.unlock_level[self._options.id] <= profile.level then
            self.lock_btn:setVisible(false)
            local download = Slot.DM:getLocalStorage(self._data.."_download", false)
            if not download or tonumber(download) == 0 then
                self.play_btn:setVisible(false)
                self.download_btn:setVisible(true)
            else
                self.play_btn:setVisible(true)
                self.download_btn:setVisible(false)
            end

            local download_state = Slot.DM:getLocalStorage(self._data.."_downloading", false)

            if download_state and tonumber(download_state) == 1 then

                self.play_btn:setVisible(false)
                self.download_btn:setVisible(false)

            end

        else
            self.lock_btn:setVisible(true)

            --self.lock_level:setString("Level "..self.unlock_level[self._options.id])

            self.lock_level:setString(tostring(self.unlock_level[self._options.id]))

            self.play_btn:setVisible(false)
            self.download_btn:setVisible(false)
        end
        self:createProgress()
        self:_registEvent()

    end,
    _isTouchInside = function(self, x, y)
        local rect = self.download_btn:getBoundingBox()
        local p = self:getRootNode():convertToNodeSpace(cc.p(x, y))
        local b = cc.rectContainsPoint(rect, p)
        return b

    end,


    _registEvent = function(self)

        self:onEvent("update_sucess"..self._data,function(e)

            self.download_btn:setVisible(false)
            self.down_loading_node:setVisible(true)

            if not self.progress then
                self:createProgress()
            end

            local sec = tonumber(e.attach.sec)
            local percent = tonumber(e.attach.percent)

            if not self._downLoadNum then self._downLoadNum = 0 end

            if not self._totalFileNum then self._totalFileNum = e.attach.totalFileNum end

            self._downLoadNum = self._downLoadNum + 1

            if self._downLoadNum < e.attach.downLoadNum then self._downLoadNum = e.attach.downLoadNum end

--            if self._downLoadNum > 100 then self._downLoadNum = 100 end

            local down_percent = self._downLoadNum / self._totalFileNum * 100

            if down_percent > 100 or percent == 100 then down_percent = 100 end

            if down_percent == 100 and down_percent > percent then
                down_percent = percent
            end

            self:gameReady(down_percent, sec)

        end)

        self:onEvent("update_progress"..self._data,function(e)

            if self.download_btn:isVisible() then
                self.download_btn:setVisible(false)
            end

            if not self.down_loading_node:isVisible() then
                self.down_loading_node:setVisible(true)
            end

            if not self.progress then
                self:createProgress()
            end

        end)

        self:onEvent("update_error"..self._data,function(e)
            U:debug("for game update44444444=====================================")
            self.download_btn:setVisible(true)
            self.down_loading_node:setVisible(false)

        end)

        self:onEvent("restart_update"..self._data,function(e)
            U:debug("for game update2222=====================================")
            self:update()
        end)

        self:onEvent("laterdownload",function(e)

            self.download_btn:setVisible(true)
            self.down_loading_node:setVisible(false)

        end)

        self.proxy:handleButtonEvent(self.download_btn, function()
            print("click download_btn")

            if self.download_btn:isVisible() then

                self.download_btn:setVisible(false)
                self.down_loading_node:setVisible(true)
                self:update()
            end

        end)


        local profile = Slot.DM:getBaseProfile()
        local download = Slot.DM:getLocalStorage(self._data.."_download", false)

        self.proxy:handleButtonEvent(self.poster_node, function()
            print("click poster_node")

            if self.unlock_level[self._options.id] <= profile.level and tonumber(download) == 1 then
                Slot.App:switchTo("modules/"..self._data)
            else
                if self.download_btn:isVisible() then
                    
                    self.download_btn:setVisible(false)
                    self.down_loading_node:setVisible(true)
                    self:update()
                end

            end


        end, self._options.priority)

    end,

    gameReady = function(self, percent, sec)

        if not sec then sec = 0.5 end
        local actions = {}
        local to = cc.ProgressTo:create(sec, percent)
        local switch = cc.CallFunc:create(function()
            U:debug(percent)
            if percent == 100 then
                self.play_btn:setVisible(true)
                self.down_loading_node:setVisible(false)
                self:_registEvent()
                --                        self.loading:runAction(cc.FadeOut:create(0.5))
            end

        end)
        table.insert(actions,to)
        table.insert(actions,cc.DelayTime:create(0.5))
        table.insert(actions,switch)
        local seq = cc.Sequence:create(actions)
        self.progress:runAction(seq)
    end,

    createProgress = function(self)

        local size = self.down_loading_node:getContentSize()

        local progressBg = U:getSpriteByName("downloading_bg.png")

        progressBg:setPosition(cc.p(size.width/2, size.height/2))
        self.down_loading_node:addChild(progressBg)

        self.progress = cc.ProgressTimer:create(U:getSpriteByName("downloading.png"))
        self.progress:setType(cc.PROGRESS_TIMER_TYPE_BAR)
        self.progress:setMidpoint(cc.p(0, 0))
        self.progress:setBarChangeRate(cc.p(1, 0))
        self.progress:setPosition(cc.p(size.width/2, size.height/2))
        self.down_loading_node:addChild(self.progress)

        local downloading_text =U:getSpriteByName("downloading_text.png")
        downloading_text:setPosition(cc.p(size.width/2, size.height/2))

        self.down_loading_node:addChild(downloading_text)

        self.progress:setPercentage(0)

        self.down_loading_node:setVisible(false)

    end,

    update = function(self)

        U:debug("for game update=====================================")
        local update = Slot.Update:new(
            {
                type = self._data,
--                restartUpdate = function()
--                    self:update()
--                end,

            })

--        local update = Slot.Update:new({
--            type = self._data,
--            callBack = function(percent, sec)
--
--                if not sec then sec = 0.5 end
--                local actions = {}
--                local to = cc.ProgressTo:create(sec, percent)
--                local switch = cc.CallFunc:create(function()
--
--                    if percent == 100 then
--                        Slot.DM:setLocalStorage(self._data.."_download", 1)
--
--                        self.down_loading_node:setVisible(false)
--                        self:_registEvent()
----                        self.loading:runAction(cc.FadeOut:create(0.5))
--                    end
--
--                end)
--                table.insert(actions,to)
--                table.insert(actions,cc.DelayTime:create(0.5))
--                table.insert(actions,switch)
--                local seq = cc.Sequence:create(actions)
--
--                self.progress:runAction(seq)
--
--            end,
--        })

    end,

    getRootNode = function(self)
        if not self.rootNode then
--            self.rootNode = cc.Node:create()
            self.proxy = Slot.CCBProxy:new({
                ignoremove = false
            })
            self.rootNode  = self.proxy:readCCBFile("ccbi/GameHomeItem.ccbi")
            self.rootNode:addChild(self.proxy:getRootNode())

--            self.rootNode:setContentSize(cc.size(self._options.width, self._options.height))
--            self.rootNode:ignoreAnchorPointForPosition(false)

--            local sc = Slot.ui.ScriptControl:new({})
--            sc:getRootNode():setContentSize(cc.size(self._options.width, self._options.height))
--            self.rootNode:addChild(sc:getRootNode())
--            sc:bind("click",function()
--                print("click me"..self._data)
--                Slot.App:switchTo("modules/"..self._data)
--            end)

        end
        return self.rootNode
    end,

    getDefaultOptions = function(self)
        return U:extend(false, self:_super(),{
            nodeEventAware = true,
            priority = Slot.TouchPriority.list,
            onExit = function(opt, that)

                self:clearEvent("update_sucess"..self._data)
                self:clearEvent("update_progress"..self._data)
                self:clearEvent("update_error")
                self:clearEvent("laterdownload")

            end,
        })
    end
})