--
-- by bbf
--
--

Slot.libs = Slot.libs or {}
Slot.libs.Video = {
    play =  function(self, video, callback)
--        LeverVideoPlayer:getInstance():registerScriptHandler(function(event)
----            print("Video play event:"..event)
--            if callback then
--                callback(event)
--            end
--            Slot.app.showWaitWithoutIcon(false)
--        end)
        --LeverVideoPlayer:getInstance():play("Videos/"..video)
--        Slot.app.showWaitWithoutIcon(true)
    end
}

Slot.Video = Slot.libs.Video or {}