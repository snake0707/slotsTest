--
-- Created by IntelliJ IDEA.
-- User: xiaofuan
-- Date: 15-1-5
-- Time: 下午12:22
-- To change this template use File | Settings | File Templates.
--


Slot = Slot or {}
Slot.com = Slot.com or {}
Slot.com.PaytableOne = Slot.ui.UIComponent:extend({
    __className  = "Slot.com.PaytableOne",


    initWithCode = function(self, options)
        self:_super(options)
    end,

    _setup = function(self)

        self.login_btn = self.proxy:getNodeWithName("login_btn")
        self.logout_btn = self.proxy:getNodeWithName("logout_btn")
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
        self.mail_btn = self.proxy:getNodeWithName("mail_btn")

        local basefile = Slot.DM:getBaseProfile()
        local login_visible = not basefile.facebook_id
        self.login_btn:setVisible(login_visible)
        self.logout_btn:setVisible(not login_visible)

        local music_on = Slot.DM:getLocalStorage("music_on")
        local is_music_on = not music_on or tonumber(music_on) == 1
        self.music_on_btn:setVisible(not is_music_on)
        self.music_off_btn:setVisible(is_music_on)

        local sound_on = Slot.DM:getLocalStorage("sound_on")
        local is_sound_on = not sound_on or tonumber(sound_on) == 1
        self.sound_on_btn:setVisible(not is_sound_on)
        self.sound_off_btn:setVisible(is_sound_on)

        local notification_on = Slot.DM:getLocalStorage("notification_on")
        local is_notification_on = not notification_on or tonumber(notification_on) == 1
        self.notification_on_btn:setVisible(not is_notification_on)
        self.notification_off_btn:setVisible(is_notification_on)

        self:_registEvent()

        self:_super()

    end,


    _registEvent = function(self)



    end,

    getRootNode = function(self)
        if not self.rootNode then

            self.rootNode = cc.Layer:create()
            self.proxy = Slot.CCBProxy:new()
            self.ccbnode  = self.proxy:readCCBFile("ccbi/ToolBar.ccbi")
            self.ccbnode:setContentSize(cc.size(self._winsize.width, self.ccbnode:getContentSize().height))

            local size = self.ccbnode:getContentSize()
            self.rootNode:setContentSize(size)

            self.ccbnode:setPosition(cc.p(size.width/2, size.height/2))
            self.rootNode:addChild(self.proxy:getRootNode())
            self.rootNode:addChild(self.ccbnode)


            self.rootNode:registerScriptTouchHandler(function(eventType, x, y)
                if eventType == "began" then -- touch began

                    local rect=cc.rect(0,0,size.width,size.height)
                    if not cc.rectContainsPoint(rect, self.rootNode:convertToNodeSpace(cc.p(x,y))) then -- rect:containsPoint() then
                        return false
                    end
                    return true
                end

            end, false, self._options.priority, true)
            self.rootNode:setTouchEnabled(true)
        end

        return self.rootNode
    end,

    getDefaultOptions = function(self)
        return U:extend(true, self:_super(), {
            nodeEventAware=true,
            ccbi = "ccbi/PayTableOne.ccbi",
            priority = Slot.TouchPriority.dialog,
            showClose = true,
        })
    end,
})

