--
-- by bbf
--

Slot = Slot or {}

Slot.app = Slot.app or {}

Slot.app.toast = {

    show = function(self, s, height,toastBg)
        if Slot.app.prevToast then
            Slot.app.prevToast:clear()
        end

        local toast   = Slot.ui.Toast:new(s,{bg=toastBg})
        local scene   = Slot.App.director:getRunningScene()
        local visibleSize = Slot.App.visibleSize
        toast.rootNode:setAnchorPoint(cc.p(0.5,0))
        if height then
            toast.rootNode:setPosition(visibleSize.width / 2, height)
        else
            toast.rootNode:setPosition(visibleSize.width/2,40)
        end
        scene:addChild(toast.rootNode, Slot.ZIndex.Toast)
        toast:show()
        Slot.app.prevToast = toast

    end,
}

Slot.app._overlay = nil
Slot.app._waitIcon = nil
Slot.app._waitAction = nil
Slot.app._waiting = false

Slot.app.createOverlay = function(self, options)
    options = options or { alpha = 0 }
    if not Slot.app._overlay then
        local scene = cc.Director:getInstance():getRunningScene()
        if not scene then
            return
        end

        local winsize = cc.Director:getInstance():getWinSize()
        Slot.app._overlay = CCLayerColor:create(ccc4(0,0,0,options.alpha), winsize.width, winsize.height)
        local onTouch = function(eventType, x, y)
        -- To intercept touch event
            if eventType == "began" then
                return true
            end
        end
        scene:addChild(Slot.app._overlay, Slot.ZIndex.showWait)
        Slot.app._overlay:registerScriptTouchHandler(onTouch, false, -10, true)
        Slot.app._overlay:registerScriptHandler(function(et)
            if et == 'exit' then
                Slot.app._overlay = nil
            end
        end)
        Slot.app._overlay:setTouchEnabled(true)
    end
    return Slot.app._overlay
end

Slot.app.removeOverlay = function(self)
    if Slot.app._overlay then
        Slot.app._overlay:removeFromParent(true)
        Slot.app._overlay = nil
    end
end


Slot.app.showWait = function(isOpen, options)
    local scene = cc.Director:getInstance():getRunningScene()
    if not scene then
        return
    end

    if isOpen then
        if Slot.app._waiting then
            return
        end

        Slot.app:createOverlay(options)

        Slot.app._waitIcon = CCSprite:create("common/icon/loading1.png")
        Slot.app._overlay:addChild(Slot.app._waitIcon)

        if options and type(options.x) == "number" and type(options.y) == "number" then
            Slot.app._waitIcon:setPosition(cc.p(options.x, options.y))
        else
            local winsize = cc.Director:getInstance():getWinSize()
            Slot.app._waitIcon:setPosition(cc.p(winsize.width / 2, winsize.height / 2))
        end
        Slot.app._waitIcon:runAction(CCRepeatForever:create(
            CCSequence:createWithTwoActions(
                CCDelayTime:create(.1),
                CCRotateBy:create(0,360/12))
        ))

        Slot.app._waiting = true
    else
        Slot.app:removeOverlay()
        Slot.app._waiting = false
    end
end

Slot.app.showWaitWithoutIcon = function(isOpen, options)
    local scene = cc.Director:getInstance():getRunningScene()
    if not scene then
        return
    end

    if isOpen then
        if Slot.app._waiting then
            return
        end

        if not Slot.app._overlay then
            Slot.app:createOverlay(options)
        end

        Slot.app._waiting = true
    else
        Slot.app:removeOverlay()
        Slot.app._waiting = false
    end
end



Slot.app.getUserLanguage = function(self)
    local lang = Slot.cache:get("user_language")
    if not lang then
        if Slot.app.data and Slot.app.data.userLanguage then
            lang = Slot.app.data.userLanguage
        else
            lang = 'zh_cn'
        end
    end
    return lang
end

