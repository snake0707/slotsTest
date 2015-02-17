--
-- by bbf
--
require('component.ui.Slot')
Slot = Slot or {}

Slot.ui = Slot.ui or {}

Slot.ui.SlotManager = Slot.ui.UIComponent:extend({
    __className = "Slot.ui.SlotManager",

    initWithCode = function(self, options)
        self:_super(options)

        self._miniSec  = 1
        self._miniInterval =0.08
        self._levelUp = false
        local pagePara = self._options.pagePara or {}
        local freeSpin = pagePara.freeSpin or {}

        self._freeSpin = freeSpin.freeSpinNum or -1
        self._total_freeSpin = freeSpin.total_freeSpin or 0
        self._freeSpinCoin = pagePara.win or 0


        self._expectTime = 2.5 -- 期待时间
        self:onEvent("level_up",function(e)

            self._levelUp = true

        end)

        self:onEvent("switch_end",function()


            if self._options.pagePara and self._freeSpin >0 then

                self:handleFreeSpinAction(0, 0)
            end

            self._options.pagePara = nil
        end)


        self._isExpect  = false

        self:_setup()

    end,

    _setup = function(self)

        for i = 1, self._options.wheel.col do
            self["weelnode"..i] = self.proxy:getNodeWithName("col"..i)
            local size = self["weelnode"..i]:getContentSize()
            self._options.frameWidth = size.width
            self._options.frameHeight = size.height
            self._options.componentWidth = size.width
            self._options.componentHeight = size.height/self._options.wheel.row

            self["weelnode"..i]:setContentSize(cc.size(self._options.frameWidth, self._options.frameHeight))
            self["_slot"..i] = Slot.ui.Slot:new({
                frameWidth  = self._options.frameWidth,
                frameHeight = self._options.frameHeight,
                componentWidth = self._options.componentWidth,
                componentHeight = self._options.componentHeight,
                component = self._options.component,
                wheel = self._options.wheel,
                modulename = self._options.modulename,
                onDoneSpining = function()

                end,
                --
                --                stopSpin = function(data)
                --                   self:stopSpin(data)
                --
                --                end
            })
            self["weelnode"..i]:addChild(self["_slot"..i].rootNode)
        end

        --add
        self.layerColorMask = self.proxy:getNodeWithName("Layer_Mask")

        --add 11.30
        Slot.animation:clearAll()



        --设置位置，板子大小
        local size = self.rootNode:getContentSize()
        local layerSize = self.layerColorMask:getContentSize()
        local y = self.layerColorMask:getPositionY()
        local offsetY = 0
        self.rootNode:setPosition(cc.p(self._options.emptySize.width/2, self._options.emptySize.height/2))

    end,

    -- add on 11.26
    --资源暂时只添加到了ios目录下
    --添加一个加载动画缓存plist的函数 11.26

    handleAfterSlot = function(self, callback)
    --        if isover then
    --        end

        if type(callback) == "function" then
            callback()
        end


        local handleAction = function()

        --这里需要调用一个画线的方法 一条一条的画 重复执行

            local nodeTab={self["weelnode1"],self["weelnode2"],self["weelnode3"],self["weelnode4"],self["weelnode5"] }

            local childrenTab={}

            for i = 1, self._options.wheel.col do

                childrenTab[i]={}
                childrenTab[i]=self["_slot"..i]:getChildrenByParent()

            end

            for i=1,self._options.wheel.col do

                for j=1,3 do

                    local  tag=childrenTab[i][j]:getTag()

                end

            end
            --11.30

            --这里调用赢得金币的动画 根据返回值winType 以及totalBet ／awardGold调用不同的动画

            local startPos=cc.p(self._winsize.width/2,self._winsize.height/2)
            --local startPos=cc.p(self.layerColorMask:getContentSize().width/2,self.layerColorMask:getContentSize().height/2)

            local type
            --
            if self.backTab.bonus ~= 0 then   --优先级高，在freespin中也可能出现

                type = "bonus"

            elseif self._freeSpin >= 0 or self.backTab.freeSpin ~= 0 then


                type = "scatter"

            else
                type = "common"

                self:fireEvent("stop_spin", {
                    type = type,
                    freespin = self._freeSpin >= 0
                })

            end
            

            --发送一个事件
            self:fireEvent("win_coin", {
                type=type,
                startPos = startPos,
                dataTab=self.backTab,
                layerMask=self.layerColorMask,
                childrenTab = childrenTab,
                nodeTab = nodeTab,
                footheight=self._options.footheight,

                --                modulename = self._options.modulename,
                callback = function()

                    if type == "bonus" then

                        return self:handleBonusAction()


                    elseif type == "scatter" then
                        
                        return self:handleFreeSpinAction(self.backTab.freeSpin, self.backTab.awardGold)

                    elseif type == "common" then

                         --self:fireEvent("stop_spin")

                    end

                end
            })

        --

        end

        -- 处理动画显示
        self._commomdata = Slot.DM:getCommonData()
        local profile = Slot.DM:getBaseProfile()

        if self._levelUp == true and profile.exp >= self._commomdata.levelup_data[profile.level].exp then
            profile.level = profile.level + 1
            Slot.DM:setBaseProfile(profile)
            self:fireEvent("profile_update", profile)

            self.levelUpDlg = Slot.com.LevelUpDialog:new({
                level = tonumber(profile.level),
                afterClose = function(opt)
                    handleAction()

                end,
            })

            self.levelUpDlg:open()
        else
            handleAction()
        end


    end,

    handleFreeSpinAction = function(self, freeSpin, coin)

        if not coin then coin = 0 end

        self._total_freeSpin = self._total_freeSpin + freeSpin
        if self._freeSpin == -1 then
            self._freeSpin = freeSpin-1
        else
            self._freeSpin = self._freeSpin + freeSpin-1
            self._freeSpinCoin = self._freeSpinCoin + coin
        end


        if self._freeSpin == -1 and freeSpin == 0 then


            self:fireEvent("free_spin_stop")
            -- 动画显示总钱数

            --add 1.28

            self.freeSpinDlg = Slot.com.BonusDialog:new({
                bonus_type = "freespin",
                win_num = self._freeSpinCoin,
                --win_num = self._total_freeSpinCoin,
                freeSpin = self._total_freeSpin,
                modulename = self._options.modulename,
                afterClose = function(opt)
                    self._freeSpinCoin = 0
                    self._total_freeSpin = 0
                    self._freeSpin = -1

                    self._total_freeSpinCoin=0
                    --                    local profile = Slot.DM:getBaseProfile()
                    --                    profile.coin = profile.coin + tonumber(self._freeSpinCoin)
                    --                    Slot.DM:setBaseProfile(profile)
                    self.freeSpinDlg = nil

                end,
            })

            self.freeSpinDlg:open()

            return


        end

        --self._isFreeSpinState=true

        self:fireEvent("free_spin",{
            num = self._freeSpin,
            win = self._freeSpinCoin
        })
        local bet = Slot.DM:getLocalStorage(self._options.modulename.."bet")

        self:startSpin({
            bet = bet,
            isFreeSpin = true,
            profile = Slot.DM:getBaseProfile()

        })

    end,

    handleBonusAction = function(self)


--        self:fireEvent("stop_spin")  --todo::暂时添加，加入小游戏之后去掉

        Slot.App:switchTo("games/"..self._options.modulename,
            {
                pagePara = {
                    win = self._freeSpinCoin+self.backTab.awardGold,
                    totalbet = self.backTab.totalBet,
                    freeSpin = {
                        freeSpinNum = self._freeSpin,
                        total_freeSpin = self._total_freeSpin,
                    }
                }
            })

    end,


    startSpin = function(self, arg)

       --先停止所有音效
        Slot.Audio:stopAllEffects()

        --添加音乐 2015 1.05 test ok

        Slot.Audio:playEffect("sound/modules/"..self._options.modulename.."/"..Slot.MusicResources[self._options.modulename][self._options.modulename.."_spin"])

        Slot.animation:removeAllAction(self.layerColorMask,self._options.componentHeight,self._options.modulename)

        self._startTime = os.time()
        local speed= 30
        for i = 1, self._options.wheel.col do
            math.randomseed(os.time()*i)
            self["_slot"..i]:startSpin(speed,2,1)
        end


        Slot.Algo:runGame(self._options.modulename, arg, function(data, callback) self:stopSpin(data, callback) end)

        Slot.Audio:playEffect("sound/modules/"..self._options.modulename.."/"..Slot.MusicResources[self._options.modulename][self._options.modulename.."_reel_roll"])
    end,

    stopSpin = function(self,data,callback)



    --add by hxp
        self.backTab=data
        --        U:debug(data)
        --test for drawLine

        --这里要调用一个画线的方法 让所有线都画好 但不显示


        local nodeTab={self["weelnode1"],self["weelnode2"],self["weelnode3"],self["weelnode4"],self["weelnode5"] }

        local childrenTab={}

        for i = 1, self._options.wheel.col do

            childrenTab[i]={}
            childrenTab[i]=self["_slot"..i]:getChildrenByParent()

        end





        self:stopSlotAction(data, callback)

        Slot.animation:DrawAllLine(childrenTab,nodeTab,self.layerColorMask,data,self._options.modulename,self._options.componentHeight)





    end,


    stopSlotAction = function(self, data, callback)
        local stopPage = {}
        local expectTime = {}
        for i = 1, self._options.wheel.col do
            stopPage[i] = stopPage[i] or {}
            for j = 1, self._options.wheel.row do
                stopPage[i][j] = data.resultMatrix[self._options.wheel.row - j + 1][i]
            end

            --期待时间
            expectTime[i] = 0
            if data.expectBonus ~= 0 and tonumber(data.expectBonus) == i then
                expectTime[i] = self._expectTime
            end

            if #data.expectScatter > 0 and U:ArrayContainValue(data.expectScatter, i)  then
                expectTime[i] = self._expectTime
            end

            if data.except5 ~= 0 and tonumber(data.except5) == i then
                expectTime[i] = self._expectTime
            end

            --test
            --            if i == 3 then expectTime[i] = self._expectTime end

        end

        U:setTimeoutUnsafe(function() self:stopOneByOne(1, stopPage, expectTime, callback) end, self._miniSec)


    --        for i = 1, self._options.wheel.col do
    --            --            self["_slot"..i]:stopSpin(stopPage[i],callback)
    --            U:setTimeoutUnsafe(function()
    --                self["_slot"..i]:stopSpin(stopPage[i],function()
    --                    self:handleAfterSlot(i==self._options.wheel.col, callback)
    --                end)
    --            end, self._miniSec+(i-1)*self._miniInterval)
    --        end

    end,



    _isPlayExpectSuccess=function(self)
    --添加音乐 1,2,3 期待效果成功
        if  self.backTab.bonus~=0 or self.backTab.freeSpin~=0 then

            Slot.Audio:playEffect("sound/common/"..Slot.MusicResources["common"]["crowdcheers"..math.random(1,3)])
        else

            Slot.Audio:playEffect("sound/common/"..Slot.MusicResources["common"]["crowdsigh"..math.random(1,3)])

        end
    end,

    stopOneByOne = function(self, index, stopPage, expectTime, callback, speed)

    --暂时去掉期待效果
    --        expectTime = {0,0,0,0,0}
        self["_slot"..index]:stopSpin(stopPage[index], function()

        --删除期待效果  todo::

            if U:isAllIndex(expectTime,0) then


                --如果都为0 调用普通效果

                Slot.Audio:playEffect("sound/modules/"..self._options.modulename.."/"..Slot.MusicResources[self._options.modulename][self._options.modulename.."_reel_stop"])

            else



                --期待效果 test ok

                if self.backTab.expectBonus ~= 0 then
                    --bonus
                    if  index==3 then

                        if self.backTab.bonus~=0 then
                            Slot.Audio:playEffect("sound/modules/"..self._options.modulename.."/"..Slot.MusicResources[self._options.modulename][self._options.modulename.."_expect_reel"..index.."_stop"])
                        else
                            Slot.Audio:playEffect("sound/modules/"..self._options.modulename.."/"..Slot.MusicResources[self._options.modulename][self._options.modulename.."_reel_stop"])
                        end

                    elseif index==1 or index==2 then

                        Slot.Audio:playEffect("sound/modules/"..self._options.modulename.."/"..Slot.MusicResources[self._options.modulename][self._options.modulename.."_expect_reel"..index.."_stop"])
                    else

                        Slot.Audio:playEffect("sound/modules/"..self._options.modulename.."/"..Slot.MusicResources[self._options.modulename][self._options.modulename.."_reel_stop"])
                    end
                end


                if #self.backTab.expectScatter > 0 then

                    if  index==4 then

                        if self.backTab.freeSpin~=0 then
                            Slot.Audio:playEffect("sound/modules/"..self._options.modulename.."/"..Slot.MusicResources[self._options.modulename][self._options.modulename.."_expect_reel"..index.."_stop"])
                        else
                            Slot.Audio:playEffect("sound/modules/"..self._options.modulename.."/"..Slot.MusicResources[self._options.modulename][self._options.modulename.."_reel_stop"])
                        end

                    elseif index==2 or index==3 then

                        Slot.Audio:playEffect("sound/modules/"..self._options.modulename.."/"..Slot.MusicResources[self._options.modulename][self._options.modulename.."_expect_reel"..index.."_stop"])
                    else

                        Slot.Audio:playEffect("sound/modules/"..self._options.modulename.."/"..Slot.MusicResources[self._options.modulename][self._options.modulename.."_reel_stop"])
                    end

                end

                if expectTime[index] > 0 then
                    Slot.animation:clearAllParticles()
                    self:_isPlayExpectSuccess()

                else

                    Slot.Audio:playEffect("sound/modules/"..self._options.modulename.."/"..Slot.MusicResources[self._options.modulename][self._options.modulename.."_reel_stop"])
                end


            end


            if index==self._options.wheel.col then

                return self:handleAfterSlot(callback)
            end


            if expectTime[index+1] > 0 then

                --添加音乐 2015 1.05 test ok

                Slot.Audio:playEffect("sound/modules/"..self._options.modulename.."/"..Slot.MusicResources[self._options.modulename][self._options.modulename.."_expect"])

                Slot.animation:ExpectAction(self["weelnode"..index+1])

            end

            return U:setTimeoutUnsafe(function()
                self:stopOneByOne(index+1, stopPage, expectTime, callback, speed)

            end, self._miniInterval + expectTime[index+1])

        end, speed)

    end,

    getRootNode = function(self)
        if not self.rootNode then
            self.proxy = Slot.CCBProxy:new()
            self.rootNode  = self.proxy:readCCBFile(self._options.ccbFile)
            self.rootNode:addChild(self.proxy:getRootNode())

            --屏蔽其他输入
            --            local layer=cc.Layer:create()
            --            layer:setTouchEnabled(true)
            --            layer:registerScriptTouchHandler(function() return true end,false,-10,true)
            --            self.rootNode:addChild(layer)
            --            self.touchLayer=layer
        end

        return self.rootNode
    end,

    getDefaultOptions = function(self)
        return U:extend(false, self:_super(), {
            wheel = {
                row = 3,
                col = 5,
            },
            frameWidth  = 72,       -- 窗口宽度
            frameHeight = 226,      -- 窗口高度
            componentWidth = 72,    -- 每个元素精灵的宽度
            componentHeight = 76,   -- 每个元素精灵的高度
            component = {1,2,3,4,5,6,7,8,9,10,50,100,200},       -- 一个轮子的精灵的个数

        })
    end
})