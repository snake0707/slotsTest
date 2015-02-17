--
-- by bbf
--
Slot.libs = Slot.libs or {}

Slot.libs.SpriteCacheManager = {
    cache = cc.SpriteFrameCache:getInstance(),
    preload = function(self, file)
        U:fdebug("Slot.SCM","LOAD RESOURCE",file)
        self.cache:addSpriteFrames(file)
    end,
    clean = function(self)
        self.cache:removeUnusedSpriteFrames()
    end,

    removeSpriteFrameByFile=function(self,file)
        U:fdebug("Slot.SCM","REMOVE RESOURCE",file)
        cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile(file)
    end,

    removeSpriteFrameByName=function(self,name)
        cc.SpriteFrameCache:getInstance():removeSpriteFrameByName(name)
    end,

    preloadImageCache = function(self, file)
        cc.Director:getInstance():getTextureCache():addImage(file)
    end,

    removeImageCache = function(self, file)
        cc.Director:getInstance():getTextureCache():removeTextureForKey(file)
    end

}

Slot.SpriteCacheManager = Slot.libs.SpriteCacheManager