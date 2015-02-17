--
-- Created by IntelliJ IDEA.
-- User: bbf
-- Date: 14-12-2
-- Time: 下午9:49
-- To change this template use File | Settings | File Templates.
--


require "component.ui.CCBDialog"
Slot.com = Slot.com or {}
Slot.com.BonusDialog = Slot.ui.CCBDialog:extend({
    __className = "Slot.com.BonusDialog",

    initWithCode = function(self, options)
        self:_super(options)

    end,

    _setup = function(self)
        self.title = self.proxy:getNodeWithName("title_text")
        self.win_text = self.proxy:getNodeWithName("win_text")
        self.win_num = self.proxy:getNodeWithName("win_num")
        self.bonus_type = self.proxy:getNodeWithName("bonus_type")
        self.ok_btn = self.proxy:getNodeWithName("ok_btn")
        self.share_layer = self.proxy:getNodeWithName("share_layer")
        self.share_circle = self.proxy:getNodeWithName("share_circle")
        self.share_gou = self.proxy:getNodeWithName("share_gou")
        self.share_text = self.proxy:getNodeWithName("share_text")
        self.logo_node = self.proxy:getNodeWithName("logo_node")

        self._shareFlag = false
        self:_initData()

        local data=Slot.DM:getBaseProfile()

--        if tonumber(data.type)==3 then
--            self.share_layer:setVisible(true)
--            self._shareFlag = true
--        end

        self.share_layer:setVisible(true)
        self._shareFlag = true

    end,

    open=function(self)

        self:_super()
        Slot.Audio:playEffect("sound/common/"..Slot.MusicResources["common"]["crowdcheers1"])
    end,
    

    _initData = function(self)
        self.win_num:setString(self._options.win_num)

        if self._options.bonus_type == "freespin" then
            self.bonus_type:setString(U:locale("common", "scatter_tips", {num = self._options.freeSpin}))
        elseif self._options.bonus_type == "bonus" then
            self.bonus_type:setString(U:locale("common", "bonus_tips"))
        end

        U:addSpriteFrameResource("plist/common/start_page.plist")
        local sprite = U:getSpriteByName("start_page_"..self._options.modulename..".png")
        local size = self.logo_node:getContentSize()

        sprite:setPosition(cc.p(size.width/2, size.height/2))
        self.logo_node:addChild(sprite)

        U:setTitle(self.ok_btn, U:locale("common","Ok"), "fnt", "font/common/gre.fnt", cc.CONTROL_STATE_NORMAL)
        self.logo_node:setScale(0.8)

    end,

    _registEvent = function(self)
        self:_super()

        self.proxy:handleButtonEvent(self.ok_btn, function()
            print("click ok_btn")
            self:close()
        end, self._options.priority-1)

        self.proxy:handleButtonEvent(self.share_layer, function()
            print("click share_layer")
            self._shareFlag = not self._shareFlag

            if self._shareFlag then
                self.share_gou:setVisible(true)
            else
                self.share_gou:setVisible(false)
            end


        end, self._options.priority-1)

    end,

    close = function(self)

        if self._shareFlag and Slot.Configuration.DEBUG == "false" then

            local parm = {
                name = U:locale("share", "scatter_name"),
                caption = U:locale("share", "scatter_caption", {num = self._options.freeSpin}),
                description = U:locale("share", "scatter_description",{coin = self._options.win_num, num = self._options.freeSpin}),
                link = Slot.shareLink,
                picture = Slot.shareIcon,
            }

            cc.OASSdk:getInstance():share(parm)

        end

        self:_super()

    end,


    getDefaultOptions = function(self)

        return U:extend(false, self:_super(), {
            ccbi = "ccbi/BonusDlg.ccbi",
            priority = Slot.TouchPriority.dialog,

            resources = {
                "common/dlg_title_bg.png",
                "common/content_bg.png"
            }
        })
    end,
})

