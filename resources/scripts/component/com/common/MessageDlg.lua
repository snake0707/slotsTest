--
-- Created by IntelliJ IDEA.
-- User: xiaofuan
-- Date: 15-1-10
-- Time: 下午5:44
-- To change this template use File | Settings | File Templates.
--

--
-- Created by IntelliJ IDEA.
-- User: xiaofuan
-- Date: 15-1-6
-- Time: 下午3:36
-- To change this template use File | Settings | File Templates.
--

Slot.com = Slot.com or {}
Slot.com.MessageDialog = Slot.ui.CCBDialog:extend({
    __className = "Slot.com.MessageDialog",

    initWithCode = function(self, options)


        self:_super(options)

    end,

    _setup = function(self)

        self.title_text = self.proxy:getNodeWithName("title_text")
        self.title_node = self.proxy:getNodeWithName("title_node")
        self.content_node = self.proxy:getNodeWithName("content_node")
--        self.ok_btn = self.proxy:getNodeWithName("ok_btn")

        self:_initMessage()

        self:_registEvent()

        self:resize()

        self:_super()
    end,

    _initMessage = function(self)

        self.title_text:setString(U:locale("common", self._options.title))

        if self._options.message then
            local size = self.content_node:getContentSize()

            local label =  Slot.ui.SmartLabel:new({
                text = U:locale("common", self._options.message),
                preferredWidth = size.width,
                color   = self._options.color,
                halign  = self._options.halign,
                fontSize= self._options.fontSize
            })

--            self.messge = cc.LabelTTF:create(self._options.message,self._options.font,self._options.fontSize)
            label:setAnchorPoint(cc.p(0.5, 0.5))
            label:setPosition(cc.p(size.width/2, size.height/2))
            self.content_node:addChild(label:getRootNode())

        end

    end,

    _registEvent = function(self)

--        self.proxy:handleButtonEvent(self.ok_btn, function()
--            print("click ok_btn")
--            self:close()
--        end)
    end,

    resize = function(self)

    end,

    getDefaultOptions = function(self)

        return U:extend(false, self:_super(), {
            ccbi = "ccbi/LargeDlg.ccbi",
            priority = Slot.TouchPriority.dialog,
            showClose = false,
            title = "dialog",
            message = nil,
            font = Slot.Font.default,           -- 文字字体集
            color = Slot.CCC3.white,
            fontSize = 60,
            halign = cc.TEXT_ALIGNMENT_CENTER,
            resources = {
                "common/dlg_title_bg.png",
                "common/content_bg.png"
            }
        })
    end,
})

