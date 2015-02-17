--
-- Created by IntelliJ IDEA.
-- User: xiaofuan
-- Date: 15-1-13
-- Time: 下午10:29
-- To change this template use File | Settings | File Templates.
--


Slot = Slot or {}
Slot.libs = Slot.libs or {}
Slot.libs.NotificationCenter = {

   fireEvent_CollectCoins=function(self,time)

           Slot.NM:notification(U:locale("pushmessage", "collect_coins"), time, "collectcoins")
   end,


    fireEvent_CollectWheel=function(self,time)

        Slot.NM:notification(U:locale("pushmessage", "collect_wheel"), time, "collectwheel")

    end,

   fireEvent_Recall=function(self)

       Slot.NM:notification(U:locale("pushmessage", "two_days_left"), 86400*2, "twodayleft")
       Slot.NM:notification(U:locale("pushmessage", "four_days_left"), 86400*4, "fourdayleft")
       Slot.NM:notification(U:locale("pushmessage", "seven_days_left"), 86400*7, "sevendayleft")

   end,

    onEvent = function(self,key)

        if key=="noticenter_coins" then
            Slot.libs.EventManager:addListener(key,function()
                self:fireEvent_CollectCoins()
            end)
        elseif key=="noticenter_wheels" then
            Slot.libs.EventManager:addListener(key,function()
                self:fireEvent_CollectWheel()
            end)
        elseif key=="noticenter_recall" then

            Slot.libs.EventManager:addListener(key,function()
                self:fireEvent_Recall()
            end)

        end

    end,

    fireEvent = function(self,t,a)
        local event = Slot.libs.Event:new(t,a)
        event:fire()
    end,

    fireAllEvent=function(self)

        Slot.NM:removeAllNotification()

        --发送唤回消息
        self:fireEvent_Recall()

        local collect_coin_times = Slot.DM:getLocalStorage("collect_coin_times")
        if not collect_coin_times then collect_coin_times = 0 end
        local normal_bonus = Slot.DM:getCommonDataByKey("timebonus_normal")
        local coin_last_time = Slot.DM:getLocalStorage("collect_coin_last_time")

        if not coin_last_time then
            Slot.DM:setLocalStorage("collect_coin_last_time", os.time())
            coin_last_time = Slot.DM:getLocalStorage("collect_coin_last_time")
        end

        --判断是否处于倒计时
        if Slot.Collect.time > os.time() - tonumber(coin_last_time) then

            local reamin_time = Slot.Collect.time - (os.time() - tonumber(coin_last_time))
            --判断是否时wheel或者coins
            if tonumber(collect_coin_times) >= #normal_bonus then

                self:fireEvent_CollectWheel(reamin_time) --发送转盘消息
            else
                self:fireEvent_CollectCoins(reamin_time) --发送搜集金币消息
            end

        end


    end,


}

Slot.NC = Slot.libs.NotificationCenter