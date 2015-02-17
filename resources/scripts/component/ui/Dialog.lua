--
-- by bbf
--

Slot = Slot or {}

Slot.ui = Slot.ui or {}

Slot.ui.Dialog = Slot.ui.Dialog or {}

--[[
 弹出多个Dialog
    dlg.open(true)
 弹出单个Dialog
    dlg.open()
 ]]--
Slot.ui.Dialog = Slot.ui.TitleBoard:extend({
    __className = "Slot.ui.Dialog",

    initWithCode = function(self, options)
        self:_super(options)
        self._canClose = false
    end,

    _setup = function(self)
        self._scene = cc.Director:getInstance():getRunningScene()
--        self._options.content = U:layerWithChildrenVertical({self._options.content, self:createButtons()}, 10)
        self:_super()
        self:addClose()

        Slot.EM:addListener("system.switch.scene", function(e)
                Slot.ui.Dialog._instances={}
                Slot.ui.Dialog._opening=nil
--                self:_removeOverlay()
            end, true)
    end,

    createButtons = function(self)
--        return U:layerWithChildrenHoriztal(self._options.btns, self._options.btnSpacing)
    end,

    addClose = function(self)
        if not self._options.showClose then return end

        local close --= cc.Sprite:create("common/icon_close.png")
        close = Slot.ui.Button:new({
            touchPriority = self._options.priority-1,
--            preferredSize = cc.size(30, 30),
            click = function()
                self:close()
            end,
            bg = {
                normal = "common/close_btn.png",
            }
        })
        close:setAnchorPoint(cc.p(0.5, 0.5))
        local size = close:getContentSize()
        close:setPosition(cc.p(self.size.width - size.width/2 - 16, self.size.height - size.height/2 - 16))
        --self:addChild(close, Slot.ZIndex.Dialog+1) -- 需要设置z才行，可能与渲染有关，需要查询
        self:getRootNode():addChild(close:getRootNode(),Slot.ZIndex.Dialog)

    end,

    open = function(self, force)

        if Slot.ui.Dialog._opening then

            table.insert(Slot.ui.Dialog._instances, self)

            return

        end

        self:_createOverlay()

        if not self.rootNode:getParent() then
            self.rootNode:setAnchorPoint(cc.p(0.5,0.5))
            self.rootNode:setPosition(self._winsize.width/2,(self._winsize.height)/2)
--            self.rootNode:setVisible(false)
            self.rootNode:setScale(0.2)
            Slot.ui.Dialog._overlay:addChild(self.rootNode)

            local fadeIn = cc.FadeIn:create(0.1)
            local scale_begin = cc.EaseIn:create(cc.ScaleTo:create(0.3, 1.1), 2)

            local scale_end = cc.EaseOut:create(cc.ScaleTo:create(0.2, 1), 1)
--            local scale_begin = cc.EaseElasticIn:create(cc.ScaleBy:create(0.2, 0.2))
--            local scale_end =  scale_begin:reverse()

            local sp = cc.Spawn:create(fadeIn, scale_begin)

            local callBack = cc.CallFunc:create(function()
                self._canClose = true
            end)

            local seq = cc.Sequence:create(sp, scale_end, callBack)
            self.rootNode:runAction(seq)
        end
--        if force == nil then
----            if Slot.ui.Dialog._opening ~= nil then
----                table.insert(Slot.ui.Dialog._instances, self)
----                self.rootNode:setVisible(false)
----            else
----                Slot.ui.Dialog._opening = self
----            end
--            Slot.ui.Dialog._opening = self
--        else
--            if Slot.ui.Dialog._opening ~= nil then
--                table.insert(Slot.ui.Dialog._instances,1, Slot.ui.Dialog._opening)
--                Slot.ui.Dialog._opening:setVisible(false)
--                Slot.ui.Dialog._opening = self
--            end
--        end

        --添加音乐
        --Slot.Audio:playEffect("sound/common/"..Slot.MusicResources["common"].windowshow)
    end,

    close = function(self)

--        self._options.onClose(self)

--        if #Slot.ui.Dialog._instances > 0 then
--            self.rootNode:removeFromParent(true)
--            local dlg = table.remove(Slot.ui.Dialog._instances, 1)
--            dlg:setVisible(true)
--            Slot.ui.Dialog._opening = dlg
--        else
--
--        end
        if not self._canClose then return end
        self._canClose = false
        if Slot.ui.Dialog._overlay then
            local scale_begin = cc.EaseIn:create(cc.ScaleTo:create(0.2, 1.1), 1)

            local scale_end = cc.EaseOut:create(cc.ScaleTo:create(0.2, 0.2), 2)
            local fadeOut = cc.FadeOut:create(0.1)
            local sp = cc.Spawn:create(scale_end, fadeOut)
            local callBack = cc.CallFunc:create(function()
                self._options.onClose(self)
                Slot.ui.Dialog._overlay:unregisterScriptTouchHandler()
                Slot.ui.Dialog._overlay:setTouchEnabled(false)
                self._scene:removeChild(Slot.ui.Dialog._overlay, true)
                U:setTimeoutUnsafe(function()
                    self:afterClose()
                end, 0.5)

            end)
            local seq = cc.Sequence:create(scale_begin, sp, callBack)
            self.rootNode:runAction(seq)

        end

        --添加音乐
        --Slot.Audio:playEffect("sound/common/"..Slot.MusicResources["common"].windowback)

        self._options.afterClose(self)

    end,

    afterClose = function(self)

        self._options:afterClose(self)

        Slot.ui.Dialog._overlay = nil
        Slot.ui.Dialog._opening = nil

        if #Slot.ui.Dialog._instances > 0 then

            local dlg = table.remove(Slot.ui.Dialog._instances, 1)
            dlg:open()
        end

        if #self._options.resources > 0 then

            for i, r in ipairs(self._options.resources) do

                Slot.SpriteCacheManager:removeImageCache(r)

            end

        end

    end,

    _createOverlay = function(self)
    
        if not Slot.ui.Dialog._overlay or tolua.isnull(Slot.ui.Dialog._overlay)  then
            -- Add overlay
            if self._options.fullscreen then
                U:debug(self._winsize.height)
                Slot.ui.Dialog._overlay = cc.LayerColor:create(cc.c4b(0,0,0, 255*.8), self._winsize.width, self._winsize.height + 100 )
                Slot.ui.Dialog._overlay:setPosition(cc.p(0,0))
            else
                Slot.ui.Dialog._overlay = cc.LayerColor:create(cc.c4b(0,0,0, 255*.8), self._winsize.width, self._winsize.height - 40 )
                Slot.ui.Dialog._overlay:setPosition(cc.p(0,40))
            end
            self._scene:addChild(Slot.ui.Dialog._overlay, Slot.ZIndex.Dialog)
            local onTouch = function(eventType, x, y)
            -- To intercept touch event
                if eventType == "began" then
--                    local box = self.rootNode:getBoundingBox()
--                    local pos = self.rootNode:getParent():convertToNodeSpace(cc.p(x,y))
--                    if not cc.rectContainsPoint(box, pos) then  --box:containsPoint(pos) then
--                        self:close()
--                    end
                    return true
                end

                if eventType == "ended" then
                    local box = self.rootNode:getBoundingBox()
                    local pos = self.rootNode:getParent():convertToNodeSpace(cc.p(x,y))
                    if not cc.rectContainsPoint(box, pos) then  --box:containsPoint(pos) then
                        if self._options.overlayClick and self._canClose then
                            self:close()
                        end

                    end
                end
            end
            Slot.ui.Dialog._overlay:registerScriptTouchHandler(onTouch, false, self._options.priority , true)
            Slot.ui.Dialog._overlay:setTouchEnabled(true)
        else
            Slot.ui.Dialog._overlay:setVisible(true)

        end
    end,

    _removeOverlay = function(self)
        if Slot.ui.Dialog._overlay==nil or tolua.isnull(Slot.ui.Dialog._overlay) then
            Slot.ui.Dialog._overlay=nil
            return
        end
        Slot.ui.Dialog._overlay:removeFromParent(true)
        Slot.ui.Dialog._overlay = nil
    end,

    getRootNode = function(self)

        if #self._options.resources > 0 then

            for i, r in ipairs(self._options.resources) do

                Slot.SpriteCacheManager:preloadImageCache(r)

            end

        end

        self:super()

    end,

    getDefaultOptions = function(self)

        return U:extend(false, self:_super(), {
            content = nil,
--            btns = { },
--            btnSpacing = 5,
            showClose = false,
            onCancel = function() end,
            onClose = function() end,
            afterClose = function() end,
            fullscreen = true,
            priority = Slot.TouchPriority.dialog,
            overlaycolor = Slot.CCC4.overlay,
            overlayClick = true,
            resources = {}
        })
    end,
})

Slot.ui.Dialog._opening = Slot.ui.Dialog._opening
Slot.ui.Dialog._instances = Slot.ui.Dialog._instances or {}
Slot.ui.Dialog._overlay = Slot.ui.Dialog._overlay
Slot.ui.Dialog.LAYER_PRIORITY = -10
Slot.ui.Dialog.CONTROL_PRIORITY = Slot.ui.Dialog.LAYER_PRIORITY
Slot.ui.Dialog.removeAllDlg = function(self)

    local _dlgs = Slot.ui.Dialog._instances
    Slot.ui.Dialog._instances = {}
    for i, that in ipairs(_dlgs) do
        that:close()
    end

    if Slot.ui.Dialog._opening then
        Slot.ui.Dialog._opening:close()
    end
end

Slot.ui.MsgDialog = Slot.ui.Dialog:extend({

    initWithCode = function(self,options)
        self:_super(options)
    end,

    _setup = function(self)

        if self._options.message ~= nil then
            local content = cc.Node:create()

            local label =  Slot.ui.SuperLabel:new({
                text    = self._options.message,
                preferredWidth = self._options.preferredWidth,
                color   = self._options.color,
                halign  = self._options.halign,
                fontSize= self._options.fontSize
            })
            label:setAnchorPoint(cc.p(0.5,0))
            content:setContentSize(cc.size(self._options.frameSize.width,self._options.frameSize.height + 20))
            label:setPosition(cc.p(self._options.frameSize.width/2,self._options.frameSize.height/2))
            content:addChild(label.rootNode)
            self._options.content = content
        end

--        local btns = {}
--        if self._options.leftBtn  then
--            self.leftBtn = Slot.ui.Button:new({
--                preferredSize = cc.size(140,50),
--                fontSize = 20,
--                bg = {"common/button/140red-botton.png","common/button/140red-botton-down.png","common/button/140red-botton-down.png","common/button/140button-disable.png"},
--                title = self._options.leftBtn[1],
--                click = self._options.leftBtn[2],
--                disableClick = self._options.leftBtn[3],
--                fontColor = Slot.CCC3.white,
--                touchPriority = self._options.priority,
--                needShadow = self._options.btnNeedShadow
--            })
--            table.insert(btns, self.leftBtn)
--        end
--
--        if self._options.rightBtn then
--            self.rightBtn = Slot.ui.Button:new({
--                preferredSize = cc.size(140,50),
--                fontSize = 20,
--                title = self._options.rightBtn[1],
--                click = self._options.rightBtn[2],
--                disableClick = self._options.rightBtn[3],
--                fontColor = Slot.CCC3.white,
--                touchPriority = self._options.priority,
--                needShadow = self._options.btnNeedShadow
--            })
--            table.insert(btns,self.rightBtn)
--        end
--
--        self._options.btns = btns
        self:_super()
    end,

    getDefaultOptions = function(self)
        return U:extend(false,self:_super(),{
            bg = "common/content_bg.png",
            fontSize = 40,
            color = Slot.CCC3.coffee,
            halign =  cc.TEXT_ALIGNMENT_LEFT,
            message = nil,
            margin = {l = 100, r = 100, t = 200, b = 54},
            frameSize = cc.size(912, 420),
            preferredWidth = 800
        })
    end
})

