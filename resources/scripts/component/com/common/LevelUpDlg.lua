--
-- Created by IntelliJ IDEA.
-- User: bbf
-- Date: 14-12-2
-- Time: 下午9:49
-- To change this template use File | Settings | File Templates.
--


require "component.ui.CCBDialog"
Slot.com = Slot.com or {}
Slot.com.LevelUpDialog = Slot.ui.CCBDialog:extend({
    __className = "Slot.com.LevelUpDialog",

    initWithCode = function(self, options)
        self:_super(options)
        self._shareFlag = true
    end,

    _setup = function(self)
--        self.level_up_text = self.proxy:getNodeWithName("level_up_text")
        self.level_star = self.proxy:getNodeWithName("level_star")
--        self.left_text = self.proxy:getNodeWithName("left_text")
--        self.right_text = self.proxy:getNodeWithName("right_text")
        self.level_text = self.proxy:getNodeWithName("level_text")
--        self.reward_text = self.proxy:getNodeWithName("reward_text")
        self.coin_text = self.proxy:getNodeWithName("coin_text")
        self.unlock_bg = self.proxy:getNodeWithName("unlock_bg")
        self.ok_btn = self.proxy:getNodeWithName("ok_btn")

        self.reward_node = self.proxy:getNodeWithName("reward_node")
        self.max_bet_node = self.proxy:getNodeWithName("max_bet_node")
        self.coin_node = self.proxy:getNodeWithName("coin_node")
        self.unlock_node = self.proxy:getNodeWithName("unlock_node")

        self.max_bet_num = self.proxy:getNodeWithName("max_bet_num")


        --add 12.05
        self.left_node=self.proxy:getNodeWithName("left_node")
        self.right_node=self.proxy:getNodeWithName("right_node")
        self.level_root=self.proxy:getNodeWithName("level_root")

        self.share_layer = self.proxy:getNodeWithName("share_layer")
        self.share_circle = self.proxy:getNodeWithName("share_circle")
        self.share_gou = self.proxy:getNodeWithName("share_gou")
        self.share_text = self.proxy:getNodeWithName("share_text")

        self:_initAward()
    end,

    _initAward = function(self)

        U:setTitle(self.ok_btn, U:locale("common","Ok"), "fnt", "font/common/gre.fnt", cc.CONTROL_STATE_NORMAL)

        self._commomdata = Slot.DM:getCommonData()
        self._lastLevel = self._commomdata.levelup_data[self._options.level - 1]
        self._nowLevel = self._commomdata.levelup_data[self._options.level]


        self.level_text:setString(self._options.level)
        self.coin_text:setString(self._nowLevel.bonus)
        self.max_bet_num:setString(tonumber(self._nowLevel.bet)*30) --30条线

        self._modules = Slot.MP:getModulesName()
        local unlockMoudle = self._modules[tonumber(self._nowLevel.unlock)]
        local sprite = cc.Sprite:create("common/small_"..unlockMoudle..".png")
--        local sprite = U:getSpriteByName("small_"..unlockMoudle..".png")

        local size = self.unlock_bg:getContentSize()
        sprite:setPosition(cc.p(size.width/2, size.height/2))
        self.unlock_bg:addChild(sprite)

        local visibleAward = {}

        if tonumber(self._nowLevel.bet) > tonumber(self._lastLevel.bet) then
            self.max_bet_node:setVisible(true)
            table.insert(visibleAward, self.max_bet_node)
        else
            self.max_bet_node:setVisible(false)
        end

        table.insert(visibleAward, self.coin_node)

        if tonumber(self._nowLevel.unlock) > tonumber(self._lastLevel.unlock) then
            self.unlock_node:setVisible(true)
            table.insert(visibleAward, self.unlock_node)
        else
            self.unlock_node:setVisible(false)
        end

        if #visibleAward >= 3 then return end

        local award_node_size = self.reward_node:getContentSize()
        local space = award_node_size.width/(#visibleAward + 1)
        local x = space
        for k, v in ipairs(visibleAward) do

            v:setPositionX(x)
            x = x + space

        end



    end,

    --12.05添加一个函数 把升级特效加到函数里 记得调用基类的方法

    open=function(self)

        self:_super()

        local nodeTab={Slot.ui.Dialog._overlay,self.level_star,self.level_root,self.left_node,self.right_node }
        Slot.animation:levelUpAction(nodeTab)

        Slot.Audio:playEffect("sound/common/"..Slot.MusicResources["common"]["crowdcheers1"])

    end,


    _registEvent = function(self)
        self:_super()

        self.proxy:handleButtonEvent(self.ok_btn, function()
            print("click ok_btn")
            self:close()
        end)

        self.proxy:handleButtonEvent(self.share_layer, function()
            print("click share_layer")
            self._shareFlag = not self._shareFlag

            self.share_gou:setVisible(self._shareFlag)

        end, self._options.priority-1)

    end,

    close = function(self)

        local profile = Slot.DM:getBaseProfile()
        profile.coin = profile.coin + tonumber(self._nowLevel.bonus)
        Slot.DM:setBaseProfile(profile)
        self:fireEvent("profile_update", profile)
        if self._shareFlag and Slot.Configuration.DEBUG == "false" then

            print("is sharing=====")

            local parm = {
                name = U:locale("share", "levelup_name", {level = profile.level}),
                caption = U:locale("share", "levelup_caption"),
                description = U:locale("share", "levelup_description"),
                link = Slot.shareLink,
                picture = Slot.shareIcon,
            }

            cc.OASSdk:getInstance():share(parm)

        end
        self:_super()

    end,

    getDefaultOptions = function(self)

        return U:extend(false, self:_super(), {
            ccbi = "ccbi/LevelUpDlg.ccbi",
            priority = Slot.TouchPriority.dialog,
            resources = {
                "common/dlg_title_bg.png",
                "common/content_bg.png",
                "common/level_up_head.png"
            }
        })
    end,
})

