--
-- Created by IntelliJ IDEA.
-- User: xiaofuan
-- Date: 14-11-25
-- Time: 上午11:13
-- To change this template use File | Settings | File Templates.
--

Slot = Slot or {}
Slot.com = Slot.com or {}
Slot.com.SettingsDlg = Slot.ui.CCBDialog:extend({
    __className  = "Slot.com.SettingsDlg",


    initWithCode = function(self, options)
        self:_super(options)
    end,

    _setup = function(self)
--        self.proxy = Slot.CCBProxy:new()
--        self._options.content  = self.proxy:readCCBFile(self._options.ccbi)
--        self._options.content:addChild(self.proxy:getRootNode())

--        self.facbook_text = self.proxy:getNodeWithName("facbook_text")
--        self.music_text = self.proxy:getNodeWithName("music_text")
--        self.sound_text = self.proxy:getNodeWithName("sound_text")
--        self.notification_text = self.proxy:getNodeWithName("notification_text")
--        self.rate_text = self.proxy:getNodeWithName("rate_text")
--        self.contact_text = self.proxy:getNodeWithName("contact_text")

--        self.login_btn = self.proxy:getNodeWithName("login_btn")
--        self.logout_btn = self.proxy:getNodeWithName("logout_btn")
        self.music_on_btn = self.proxy:getNodeWithName("music_on_btn")
        self.music_off_btn = self.proxy:getNodeWithName("music_off_btn")
        self.music_layer = self.proxy:getNodeWithName("music_layer")

        self.sound_on_btn = self.proxy:getNodeWithName("sound_on_btn")
        self.sound_off_btn = self.proxy:getNodeWithName("sound_off_btn")
        self.sound_layer = self.proxy:getNodeWithName("sound_layer")

        self.notification_on_btn = self.proxy:getNodeWithName("notification_on_btn")
        self.notification_off_btn = self.proxy:getNodeWithName("notification_off_btn")
        self.notification_layer = self.proxy:getNodeWithName("notification_layer")

        self.rate_btn = self.proxy:getNodeWithName("rate_btn")
--        self.mail_btn = self.proxy:getNodeWithName("mail_btn")

--        local basefile = Slot.DM:getBaseProfile()
--        local login_visible = not basefile.facebook_id
--        self.login_btn:setVisible(login_visible)
--        self.logout_btn:setVisible(not login_visible)

        local music_on = Slot.DM:getLocalStorage("music_on")
        local is_music_on = tonumber(music_on) ~= 0  --true ==>音乐开启
        self.music_on_btn:setVisible(is_music_on)
        self.music_off_btn:setVisible(not is_music_on)

        local sound_on = Slot.DM:getLocalStorage("sound_on")
        local is_sound_on = tonumber(sound_on) ~= 0
        self.sound_on_btn:setVisible(is_sound_on)
        self.sound_off_btn:setVisible(not is_sound_on)

        local notification_on = Slot.DM:getLocalStorage("notification_on")
        local is_notification_on = tonumber(notification_on) ~= 0
        self.notification_on_btn:setVisible(is_notification_on)
        self.notification_off_btn:setVisible(not is_notification_on)

        self:_registEvent()

        self:_super()

    end,


    _registEvent = function(self)

--        self.proxy:handleButtonEvent(self.login_btn, function()
--            print("click login_btn")
--        end)
--        self.proxy:handleButtonEvent(self.logout_btn, function()
--            print("click login_btn")
--        end)


        self.proxy:handleButtonEvent(self.music_layer, function()
            local music_on = Slot.DM:getLocalStorage("music_on")
            local flag = tonumber(music_on) ~= 0
            self.music_on_btn:setVisible(not flag)
            self.music_off_btn:setVisible(flag)

            if flag then music_on = 0 else music_on = 1 end
            Slot.DM:setLocalStorage("music_on", music_on)

            if music_on == 0 then
                Slot.Audio:stopMusic(true)
            else

                local module=self._options.modulename

                if  module=="common" then

                    Slot.Audio:stopMusic(true)
                    Slot.Audio:playMusic("sound/"..self._options.modulename.."/"..Slot.MusicResources[self._options.modulename][self._options.modulename],true)
                else
                    Slot.Audio:stopMusic(true)
                    Slot.Audio:playMusic("sound/modules/"..self._options.modulename.."/"..Slot.MusicResources[self._options.modulename][self._options.modulename])
                end

            end


        end, self._options.priority-1)

--        self.proxy:handleButtonEvent(self.music_off_btn, function()
--            print("click music_off_btn")
--            self.music_on_btn:setVisible(true)
--            self.music_off_btn:setVisible(false)
--            Slot.DM:setLocalStorage("music_on",0)
--        end, self._options.priority-1)

        self.proxy:handleButtonEvent(self.sound_layer, function()
            local sound_on = Slot.DM:getLocalStorage("sound_on")
            local flag = tonumber(sound_on) ~= 0
            self.sound_on_btn:setVisible(not flag)
            self.sound_off_btn:setVisible(flag)

            if flag then sound_on = 0 else sound_on = 1 end
            Slot.DM:setLocalStorage("sound_on", sound_on)

        end, self._options.priority-1)

        self.proxy:handleButtonEvent(self.notification_layer, function()
            local notification_on = Slot.DM:getLocalStorage("notification_on")
            local flag = tonumber(notification_on) ~= 0
            self.notification_on_btn:setVisible(not flag)
            self.notification_off_btn:setVisible(flag)

            if flag then
                notification_on = 0
                Slot.NM:removeAllNotification()

            else
                notification_on = 1
                Slot.NC:fireAllEvent()
            end
            Slot.DM:setLocalStorage("notification_on", notification_on)

        end, self._options.priority-1)


        self.proxy:handleButtonEvent(self.rate_btn, function()
            print("click rate_btn")

            local dlg = Slot.com.RateDialog:new()
            dlg:open()

            self:close()

        end)
--        self.proxy:handleButtonEvent(self.mail_btn, function()
--            print("click mail_btn")
--        end)

        self:_super()

    end,

    getDefaultOptions = function(self)

        return U:extend(true, self:_super(), {
            nodeEventAware=true,
            ccbi = "ccbi/Settings.ccbi",
            priority = Slot.TouchPriority.dialog,
            showClose = true,
            resources = {
                "common/titleboard_bg.png",
                "common/content_bg.png"
            }
        })
    end,
})
