--
-- Created by IntelliJ IDEA.
-- User: xiaofuan
-- Date: 15-1-13
-- Time: 下午10:29
-- To change this template use File | Settings | File Templates.
--


Slot = Slot or {}
Slot.libs = Slot.libs or {}
Slot.libs.NotificationManager = {

    removeAllNotification = function(self)

        if Slot.Configuration.DEBUG == "false" then
            cc.LeverNotificationManager:getNotificationManager():removeAllNotification()
        end

    end,

    removeNotification = function(self, key)
        if Slot.Configuration.DEBUG == "false" then
            cc.LeverNotificationManager:getNotificationManager():removeNotification(key)
        end
    end,

    notification = function(self, msg, delay, key, repeats)
        -- repeats  0:不重复 1:/DAY  2:/HOUR 3:/MINUTE 4:SECOND

        local notification_on = Slot.DM:getLocalStorage("notification_on")
        if tonumber(notification_on) == 0 then return end

        if not msg or not key then error("no msg or key for Notification") end

        if not delay then delay = 86400 end
        if not repeats then repeats = 0 end
        if Slot.Configuration.DEBUG == "false" then
            cc.LeverNotificationManager:getNotificationManager():notification(msg, delay, repeats, key)
        end

    end,

    registerHandler = function(self, func)

        if Slot.Configuration.DEBUG == "false" then
            cc.LeverNotificationManager:getNotificationManager():registerHandler(func)
        end
    end,

}

Slot.NM = Slot.libs.NotificationManager