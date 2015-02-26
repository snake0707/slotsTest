--
-- Created by IntelliJ IDEA.
-- User: bbf
-- Date: 14-11-6
-- Time: 上午11:06
-- To change this template use File | Settings | File Templates.
--

--[[
--
--
-- 老虎机算法开始
--
--
-- ]]--
Slot = Slot or {}

Slot.libs = Slot.libs or {}


Slot.libs.SlotAlgorithm = {


    --50:wild 100:scatter 200:bonus
    wildicon = 50,
    scattericon = 100,
    bonusicon = 200,
    index = 0,
    
    initOutput = function(self)

        self.output_log = {
            cur_level = 1,
            cur_bet = 0,
            cur_coin = 0,
            cur_exp = 0,
            cur_win_times = 0,
            cur_lose_times = 0,
            cur_payfor = 0,
            cur_payfor_times = 0,
            p1 = 0,
            p2 = 0,
            p3 = 0,
            p4 = 0,
            p = 0,
            reel_num = 0,
            win_coin = 0,
            bonus = 0,
            scatter = 0,
            big_win = 0,
            huge_win = 0,
            expect = 0
        }

        self.output = {

            awardGold = 0,

            winType = "",
            resultMatrix = {},
            payBackIds = {},
            freeSpin = 0,
            scatterPos = {},
            bonus = 0,
            bonusPos = {},
            continueLose = 0,
            totalBet = 0,
            leveup = 0,
            LinesData = {},
            -- 期待效果的列
            expectBonus = 0,
            expectScatter = {},
            except5 = 0,
        }

    end,
    --[[
    -- get the data from plistFile
    -- parms sFile -- path
    --
    -- ]]--
    getDataFromFile = function(self, sFile)
        if sFile == nil then
            sFile = "res/GameData.plist"
        end

        local plistFile = cc.FileUtils:getInstance():fullPathForFilename(sFile)                       --
        return cc.FileUtils:getInstance():getValueMapFromFile(plistFile)
    end,

    writeDataToFile = function(self, data, sFile)

        cc.UserDefault:getInstance():setDataForKey('output', data)
        cc.UserDefault:getInstance():flush()

    end,

    --[[
    --
    -- generate the matrix of one spin
    --
    -- ]]--


    generator = function(self, data)

        if data == nil or data['REELS'] == nil then
            print("generator has error for data['REELS']")
            return nil
        end


        local reels =  data['REELS']

        local config = data['config']

        if config == nil then
            error("config is not exist")
        end

        local expectBonus = config.expectbonus
        local expectScatter = U:split(config.expectscatter, ",", "number")

        local retMatrix = {}

        local freeSpin = 0
        local scatterPos = {}

        local bonusPos = {}

        local seed = tonumber(Slot.DM:getLocalStorage("seed"))

        if not seed then

            seed = os.time()

        end

        for i = 1, config.displaywidth do

            local hasSpecial = false

            local num = #reels['reel'..i]

            for k = #reels['reel'..i],1,-1 do
                if self:isCommonId(reels['reel'..i][k]) then break end
                num = num - 1
            end
--            print("======================")
--            print(num)
            if num == nil or num == 0 then num = 1 end


            -- 期待效果
            if #scatterPos >= 2 and expectScatter and U:ArrayContainValue(expectScatter, i) then
                table.insert(self.output.expectScatter, i)
            end
--            print_table(self.output.expectScatter)

            if expectBonus and i == tonumber(expectBonus) and #bonusPos >= 2 then
                self.output.expectBonus = i
            end

            -- 生成行
            for j = 1, config.displayheight do

                if retMatrix[j] == nil then retMatrix[j]= {} end

                local id, index

                if hasSpecial == true then
                    index, seed = U:randforgame(seed, 1, num)
                    id = reels['reel'..i][index]  -- this colum have got special icon, then remove the special icon
--                    self._randnum = self._randnum..";"..index..","..num
                    U:debug(seed)
                else
                    index, seed = U:randforgame(seed, 1, #reels['reel'..i])
                    id = reels['reel'..i][index]
--                    self._randnum = self._randnum..";"..index..","..(#reels['reel'..i])
                    U:debug(seed)


                    if id == self.scattericon then
                        freeSpin = freeSpin + 1
                        hasSpecial = true
                        table.insert(scatterPos, {j, i})

                    end

                    if id == self.bonusicon then
                        table.insert(bonusPos, {j, i})
                        hasSpecial = true
                    end

                end

                retMatrix[j][i] = id

            end

        end

        Slot.DM:setLocalStorage("seed", seed)


        self.output.resultMatrix = retMatrix




        return retMatrix, freeSpin, scatterPos, bonusPos

    end,

    isCommonId = function(self, id)

        if id == self.scattericon or id == self.bonusicon then
            return false
        end

        return true

    end,

    --[[
    --
    -- get the common award Matrix for display and get the payBackIds for compute the common award
    --
    --
    -- ]]--
    getAwardMatrix = function(self, data, matrix)
        if data == nil or data['LinesData'] == nil then
            print("computeAward has error for data['LinesData']")
            return nil
        end
        local config = data['config']

        local linesData = data['LinesData']
        local lineNum = data['LineNum']
        local tSucess = {}     -- the matrix of sucession, but the index maybe not discontinuous
        local payBackIds = {}

        for i =1, lineNum do

            tSucess[i] = {}

            local flag
            local wild = 0

            for col, row in pairs(linesData[i]) do

                local id = matrix[row][col]

                if #tSucess[i] <= 0 then  -- tSucess可以用数字替换
                    flag = id
                    if id == self.wildicon then
                        wild = wild + 1
                    end

                    if not self:isCommonId(id) then   -- remove the scatter and bonus
                        break
                    end

                    table.insert(tSucess[i], {row, col})

                else

                    if wild ~= 0 and id == self.wildicon and flag == self.wildicon then
                        wild  = wild + 1
                    end

                    if not ((flag == self.wildicon or id == self.wildicon or flag == id) and self:isCommonId(id))  then
                        break
                    end

                    table.insert(tSucess[i], {row, col})

                    if id ~= self.wildicon then
                        flag = id
                    end

                    if col == tonumber(config.displaywidth) - 1 and #tSucess[i] == tonumber(config.displaywidth) - 1 then
--                        self.output.except5 = config.displaywidth
                    end

                    if col == config.displaywidth and #tSucess[i] == config.displaywidth then
                        self.output.winType = "5ofkind"
                    end

                end
            end

            payBackIds[i] = {
                flag = flag,
                wild = wild,
                num = #tSucess[i],
                line = i,
            }

            if #tSucess[i] < 2 then
                tSucess[i] = nil
                payBackIds[i] = nil
            end
        end

        return tSucess, payBackIds

    end,

    --[[
    --
    -- whether it has a bonus
    --
    --
    -- ]]--

    isHasBonus = function(self, data, bonusPos)

        if #bonusPos < 3 then
            return false
        end

        local linesData = data['LinesData']
        local lineNum = data['LineNum']

        for i=1, lineNum do

            for j, pos in pairs(bonusPos) do
                if linesData[i][pos[2]] ~= pos[1] then
                    break
                end
                if j == #bonusPos then

                    self.output.bonus = i

                    return true
                end
            end

        end

        return false

    end,

    --[[
    --
    -- compute the total award Mul
    --
    --
    -- ]]--

    computeAwardMul = function(self, data, payBackIds, tSucess)

        if data == nil or data['PAYTABLE'] == nil then
            print("computeAward has error for data['PAYTABLE']")
            return nil
        end
        local bet = data['bet']
        if  bet == nil then
            bet = 1
        end
        local payTable = data['PAYTABLE']
        local mul = 0


        for key, payBackId in pairs(payBackIds) do
            local mulCommon
            if payBackId.flag ~= self.wildicon then

                mulCommon = payTable[payBackId.flag]['inar'..payBackId.num]
            end

            local mulWild
            if payBackId.wild > 1 then mulWild = payTable[self.wildicon]['inaR'..payBackId.wild] end

            --        print('..........')
            --        print(mulCommon)
            --        print(mulWild)

            if mulCommon == nil then mulCommon = 0 end
            if mulWild == nil then mulWild = 0 end

            if mulCommon == 0 and mulWild == 0 then  -- 没有赔率
                payBackId[key] = nil
                tSucess[key] = nil

            else
                if  mulWild > mulCommon then
                    mul = mul + mulWild
--                    self.output.payBackIds[key] = {line = payBackId.line, num = payBackId.wild, award = mul*bet }
                    table.insert(self.output.payBackIds, {line = payBackId.line, num = payBackId.wild, award = mulWild*bet })
                else
                    mul = mul + mulCommon
--                    self.output.payBackIds[key] = {line = payBackId.line, num = payBackId.num, award = mul*bet}
                    table.insert(self.output.payBackIds, {line = payBackId.line, num = payBackId.num, award = mulCommon*bet })
                end

            end  --删除并为获奖的线

        end

        return  mul, tSucess

    end,


    --[[
    --
    -- compute the total award, it is mul * bet now
    --
    --
    -- ]]--

    computeAward = function(self,data, mul)

        if data == nil then
            print("computeAward has error for data")
            return nil
        end

        local bet = data['bet']
        if  bet == nil then
            bet = 1
        end

        local goldCommon = bet * mul
--        local goldBonus = bet * bonusMul

        --track

        local lineNum = data['LineNum']
        --    print(lineNum)
        if lineNum == nil or lineNum == 0 then
            local linesData = data['LinesData']
            lineNum = #linesData
        end

--        local scope = data['winScope']
        local config = data['config']
        local totalBet = bet * lineNum
        self.output.totalBet = totalBet

        local rate = goldCommon/totalBet

        self.output.winType = "small"
        if rate > 0 then
            if rate < config.bigwin then
                self.output.winType = "small"
            elseif rate < config.hugewin then
                self.output.winType = "big"
            else
                self.output.winType = "huge"
            end
        end

        self.output.awardGold = goldCommon --+ goldBonus
        --    table.insert(output.award,{goldCommon, goldBonus})




        return goldCommon --+ goldBonus

    end,

    continueNum = function(self, isWin)
    -- track
        local arg = Slot.DM:getBaseProfile()
        if isWin then
            self.output['continueLose'] = 0
            arg.continuwin = arg.continuwin + 1
            arg.continuclose = 0
        else
            self.output['continueLose'] = self.output['continueLose'] + 1

            arg.continuclose = arg.continuclose + 1
            arg.continuwin = 0
        end

        Slot.DM:setBaseProfile(arg)

    end,


    prePareData = function(self, modulename, arg)

        local data = {}

        self._reeldata = Slot.DM:getReelData(modulename, 18)  -- 18个轮子
        self._commomdata = Slot.DM:getCommonData()
        data['LineNum'] = #self._reeldata.lines
        data['bet'] = self:confirmBet()
        data['profile'] = arg
        data['config'] = self._reeldata.config[1]

        data['LinesData'] = self._reeldata.lines
        self.output.LinesData = self._reeldata.lines

        data['PAYTABLE'] = self._reeldata.paytable

        local prob = 1
        if arg.isFreeSpin > 0 then
            prob = data['config'].freespinprob
        else
            prob = self:computeProb(data, modulename)

        end

        -- 根据已经得出的赔率参数确定本次spin选择的reel轮组编号
        local reelData = {}
--        table.sort(self._commomdata.payback_reel, function(a, b) return tonumber(a.reelnumber) > tonumber(b.reelnumber) end)
        for i, v in pairs(self._commomdata.payback_reel) do
            if tonumber(v.paynumber) == -1 or tonumber(v.paynumber) >= prob then
                reelData = self._reeldata["reel"..v.reelnumber]
                print("reelnumber"..v.reelnumber)
                self.output_log['reel_num'] = v.reelnumber
                break

            end
        end

--        if Slot.QAtype then
--
--            local data = Slot.DM:getTestData()
--            reelData = data[Slot.QAtype]
--
--            if Slot.QAtype=="scatter" or Slot.QAtype=="bigscatter" or Slot.QAtype=="hugescatter" then
--                Slot.QAtype=nil
--
--            end
--
--        end

        -- 处理reel轮子数据
        local reel = {}
--        table.sort(reelData, function(a, b) return tonumber(a.type) < tonumber(b.type) end)
        for i, v in pairs(reelData) do
            local type = v.type
            for j = 1, data['config']['displaywidth'] do
                reel['reel'..j] = reel['reel'..j] or {}
                for k = 1, v['reel'..j] do
                    table.insert(reel['reel'..j], type)
                end
            end
        end

        data['REELS'] = reel

--        print_table(reel)

        return data
    end,

    computeProb = function(self, data, modulename)
        local baseprofile = data['profile']

        local level = tonumber(baseprofile.level)
        --  根据玩家当前等级以及剩余金币数量决定玩家当前的剩余金币等级
        if baseprofile.level > #self._commomdata.payback_cl then level = #self._commomdata.payback_cl end
        local payback_cl = self._commomdata.payback_cl[level] --self:getDataByLevel(self._commomdata.payback_cl, "level", baseprofile.level)
        local cl = self:getKeyInSection(payback_cl, 'cl',baseprofile.coin)

        --  根据玩家当前等级以及剩余金币等级（步骤1得出结果），得到基础赔率p1
        local p1 = 0
        if baseprofile.level > #self._commomdata.payback_levelcl then level = #self._commomdata.payback_levelcl end
        local levelcl = self._commomdata.payback_levelcl[level] --self:getDataByLevel(self._commomdata.payback_levelcl, "level", baseprofile.level)
        p1 = levelcl[cl]
        self.output_log['p1'] = p1
        --  根据玩家当前等级以及此时的压注额度，得到参数 p2
        local p2 = 0
        if baseprofile.level > #self._commomdata.payback_levelbet then level = #self._commomdata.payback_levelbet end
        local bet = data['bet']
        local levelbet = self._commomdata.payback_levelbet[level] --self:getDataByLevel(self._commomdata.payback_levelbet, "level", baseprofile.level)
        p2 = levelbet["bet"..bet]
        self.output_log['p2'] = p2
        --  根据玩家当前的充值情况，得到参数 p3
        local p3 = 0

        local heaprecharge = Slot.DM:getHeapRecharge()
        U:debug(heaprecharge)
        local purchase = self._commomdata.payback_purchase

        for i, v in pairs(heaprecharge) do
            if purchase[v.payfor]['duration'] * v.paytimes - v.usetimes > 0 then
                local times = math.ceil(v.usetimes/purchase[v.payfor]['duration'])

                if times == 0 then times = 1 end
                if times > 10 then times= 10 end

                p3 = purchase[v.payfor]["time"..times]

                self.output_log['cur_payfor'] = v.payfor
                self.output_log['cur_payfor_times'] = times

                v.usetimes = v.usetimes + 1
                self.output.heaprecharge = v

                break
            end
        end
        self.output_log['p3'] = p3
        -- 根据玩家当前的连续失败（未能赢钱）的次数p4
        local p4 = 0
        local payback_lose = self._commomdata.payback_lose --baseprofile.continuclose

--        local continuclose = tonumber(Slot.DM:getLocalStorage("continuclose"))

        local continuclose = tonumber(baseprofile.continuclose)

        if not continuclose then continuclose = 0 end

        if continuclose > #payback_lose then
            p4 = payback_lose[#payback_lose]["addnumber"]
        elseif continuclose > 0 then
            p4 = payback_lose[continuclose]["addnumber"]
        end
        self.output_log['p4'] = p4
        -- 将以上各项参数相加，得到总的赔率参数

        local p = p1 + p2 + p3 + p4
        self.output_log['p'] = p
        return p



    end,


    getDataByLevel = function(self, t, keyname, keyvalue)

        table.sort(t, function(a, b) return tonumber(a[keyname]) < tonumber(b[keyname]) end)

        return t[keyvalue]

    end,

    -- 用于前缀字符串，后边是数字的key
    getKeyInSection = function(self, t, keyPrefix, value)
        local keys = {}
        for k, v in pairs(t) do
            local s, e = string.find(k, keyPrefix)
            if s then
                local num = tonumber(string.sub(k, e+1, string.len(k)))
                table.insert(keys, num)
            end
        end

        table.sort(keys)

        for i, v in ipairs(keys) do
            if value <= tonumber(t[keyPrefix..v]) then

                return keyPrefix..v

            end
            if tonumber(t[keyPrefix..v]) == -1 then
                return keyPrefix..keys[i-1]

            end
        end

        return keyPrefix..1


    end,

    computeFreeSpin = function(self, data, freeSpin, scatterPos)

        local freeSpinNum = data['config']['freespin'..freeSpin]
        if freeSpinNum == nil then freeSpinNum = 0 end
        self.output.freeSpin = freeSpinNum

        if freeSpinNum ~= 0 then

            self.output.scatterPos = scatterPos

        end

        return freeSpinNum

    end,

    computeBonus = function(self, data, bonusPos)

        local bonus = 0
        if self:isHasBonus(data, bonusPos) then

            self.output.bonusPos = bonusPos
            bonus = 1
        end

        return bonus

    end,

    handleData = function(self)

        self.output_log['win_coin'] = self.output.awardGold
        self.output_log['bonus'] = self.output.bonus
        self.output_log['scatter'] = self.output.freeSpin

        if self.output.winType == "small" then

        elseif self.output.winType == "big" then
            self.output_log['big_win'] = 1
        else
            self.output_log['huge_win'] = 1
        end

        if self.output.expectBonus ~= 0 or #self.output.expectScatter > 0 or self.output.except5 ~= 0 then
            self.output_log['expect'] = 1
        end

--        handle heaprecharge
        Slot.DM:setHeapRecharge(self.output.heaprecharge)

--        handle profile
        local arg = Slot.DM:getBaseProfile()
--      free spin don't increase exp
        if arg.isFreeSpin > 0 then
            arg.exp = arg.exp
        else
            arg.exp = arg.exp + self:confirmBet() * #self._reeldata.lines
        end

        local levelup_data = Slot.DM:getCommonDataByKey("levelup_data")
        local levelup_award = 0
        if arg.exp >= levelup_data[arg.level].exp then
            arg.level = arg.level + 1
            levelup_award = levelup_data[arg.level].bonus
        end
--      free spin don't cost coins
        if arg.isFreeSpin > 0 then
            arg.coin = arg.coin + levelup_award + self.output.awardGold
        else
            arg.coin = arg.coin + levelup_award + self.output.awardGold - self:confirmBet() * #self._reeldata.lines
        end
--      change bonus coin add
        if self.output.bonus > 0 then
            arg.coin = arg.coin + arg.bonus_coin *self:confirmBet()
        end

        if arg.isFreeSpin > 0 then
            arg.isFreeSpin = arg.isFreeSpin - 1
        else
            arg.spinnum = arg.spinnum - 1
        end

        if self.output_log['scatter'] > 0 then

            arg.isFreeSpin = arg.isFreeSpin + self.output_log['scatter']

        end
        Slot.DM:setBaseProfile(arg)

        Slot.DM:setOutputData(self.output_log)

    end,

    initInput = function(self)

        local arg = Slot.DM:getBaseProfile()

        self.output_log['cur_level'] = arg.level
        self.output_log['cur_bet'] = self:confirmBet()
        self.output_log['cur_coin'] = arg.coin
        self.output_log['cur_exp'] = arg.exp
        self.output_log['cur_win_times'] = arg.continuwin
        self.output_log['cur_lose_times'] = arg.continuclose
        
        return arg


    end,

    runGame = function(self, modulename)
    
        self:initOutput()

        local arg = self:initInput()

        local data = self:prePareData(modulename, arg)

        local matrix, freeSpin, scatterPos, bonusPos = self:generator(data)

        local bonus = self:computeBonus(data, bonusPos)

        local freeSpinNum = self:computeFreeSpin(data, freeSpin, scatterPos)

        local tSucess, payBackIds = self:getAwardMatrix(data, matrix)

        local mul = 0
        mul, tSucess= self:computeAwardMul(data, payBackIds, tSucess)        -- tSucess for the ani display
        local award = self:computeAward(data, mul)


        self:continueNum (mul ~= 0 or bonus ~= 0 or freeSpinNum ~= 0)

        self:handleData()

    end,

    -- confirm Bet Number
    confirmBet = function(self)
        local arg = Slot.DM:getBaseProfile()

        local confirmBetNumber = arg.bet
        if arg.bet == -1 then
            local levelup_data = Slot.DM:getCommonDataByKey("levelup_data")
            confirmBetNumber = levelup_data[arg.level].bet
        end
        return confirmBetNumber
    end,

    runGames = function(self)

        local arg = Slot.DM:getBaseProfile()

--        local notEnoughCoins = arg.cur_coin - self:confirmBet() * #self._reeldata.lines

        while((arg.spinnum > 0 or arg.isFreeSpin > 0) and arg.coin > 0) do
            self:runGame(arg.modulename)
            arg = Slot.DM:getBaseProfile()
            U:debug("==>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
            U:debug(arg)
        end

    end

}


Slot.Algo = Slot.libs.SlotAlgorithm