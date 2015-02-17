--
-- by bbf
--
Slot.libs = Slot.libs or {}



Slot.libs.Audio = {


    stopAllEffects=function(self)

       self.audioEngine:stopAllEffects()

    end,


    getMusicVolume=function(self)

        return self.audioEngine:getMusicVolume()

    end,

    isMusicPlaying=function(self)

        return self.audioEngine:isMusicPlaying()

    end,


    getEffectsVolume=function(self)

        return self.audioEngine:getEffectsVolume()

    end,

    --volume 0~1
    setMusicVolume=function(self,volume)

        self.audioEngine:setMusicVolume(volume)

    end,

    stopEffect=function(self,id)

        self.audioEngine:stopEffect(id)

    end,


    stopMusic=function(self,isReleaseData)

        if isReleaseData==nil then isReleaseData=false end

        self.audioEngine:stopMusic(isReleaseData)

    end,

    pauseAllEffects=function(self)

        self.audioEngine:pauseAllEffects()

    end,

    playMusic=function(self,filename,isLoop)

        local isMusicOn = tonumber(Slot.DM:getLocalStorage("music_on"))

        if isMusicOn==0 then return end

        if isLoop==nil then isLoop=false end



        self.audioEngine:playMusic(filename,isLoop)

    end,

    preloadMusic=function(self,filename)


        self.audioEngine:preloadMusic(filename)

    end,

    resumeMusic=function(self)

        local isMusicOn = tonumber(Slot.DM:getLocalStorage("music_on"))

        if isMusicOn==0 then return end

        self.audioEngine:resumeMusic()

    end,

    pauseMusic=function(self)

        self.audioEngine:pauseMusic()

    end,

    playEffect=function(self,filename,isLoop,pitch)

        if not pitch then pitch=1.0 end

        local isSoundOn = tonumber(Slot.DM:getLocalStorage("sound_on"))

        if isSoundOn==0 then return end

        if isLoop==nil then isLoop=false end

        self.audioEngine:playEffect(filename,isLoop,pitch)

    end,

    rewindMusic=function(self)

        local isMusicOn = tonumber(Slot.DM:getLocalStorage("music_on"))

        if isMusicOn==0 then return end

        self.audioEngine:rewindMusic()

    end,

    unloadEffect=function(self,filename)

        self.audioEngine:unloadEffect(filename)

    end,

    unloadModuleEffect=function(self,effectNameTab,moduleName)

        if type(effectNameTab)==nil  then return end
        
        self.moduleName=moduleName

           for k,v in pairs(effectNameTab) do

               if v~=nil and k~=moduleName then
                    self:unloadEffect("sound/modules/"..moduleName.."/"..v)
               end

           end


    end,

    preloadEffect=function(self,filename)

        local isSoundOn = tonumber(Slot.DM:getLocalStorage("sound_on"))

        if isSoundOn==0 then return end

        self.audioEngine:preloadEffect(filename)

    end,

    setEffectsVolume=function(self,volume)

        self.audioEngine:setEffectsVolume(volume)

    end,

    pauseEffect=function(self,id)

        self.audioEngine:pauseEffect(id)

    end,

    resumeEffect=function(self,id)

        local isSoundOn = tonumber(Slot.DM:getLocalStorage("sound_on"))

        if isSoundOn==0 then return end

        self.audioEngine:resumeEffect(id)

    end,

    resumeAllEffects=function(self)

        self.audioEngine:resumeAllEffects()

    end,


    removeAllMusicAndEffects=function(self)

        cc.SimpleAudioEngine:destroyInstance()
    end




}

require "libs.DataManager"

Slot.libs.Audio.audioEngine=cc.SimpleAudioEngine:getInstance()


Slot.Audio = Slot.libs.Audio



