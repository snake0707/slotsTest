--
-- Created by IntelliJ IDEA.
-- User: xiaofuan
-- Date: 14-11-21
-- Time: 下午2:30
-- To change this template use File | Settings | File Templates.
--
Slot = Slot or {}

Slot.ui = Slot.ui or {}

Slot.ui.SmartLabel = Slot.ui.UIComponent:extend({

    __className = "Slot.ui.SmartLabel",

    initWithCode = function(self,options)
        self:_super(options)
        self._height = 0
        self._lines = 0
        self:refreshMultiLine()
    end,

    refreshMultiLine = function(self)
        self.rootNode:removeAllChildren()
        local height = 0

        if type(self._options.text) == "string" then
            local label = cc.LabelBMFont:create(self._options.text, self._options.fntfile)
            label:setHorizontalAlignment(self._options.halign)


            local size = label:getContentSize()
            height = size.height
            label:setAnchorPoint(cc.p(0.5, 0))
            label:setPosition(cc.p(self._options.preferredWidth/2, 0))

            self.rootNode:addChild(label)

        elseif type(self._options.text) == "table" then

            local addALabel
            local preheight

            addALabel = function(text, fntfile, linespace)
                local label = cc.LabelBMFont:create(text, fntfile)

                if self._options.halign == cc.TEXT_ALIGNMENT_CENTER then
                    label:setAnchorPoint(cc.p(0.5, 0))
                    label:setPosition(cc.p(self._options.preferredWidth/2, height))
                else
                    label:setAnchorPoint(cc.p(0, 0))
                    label:setPosition(cc.p(0, height))
                end

                height = height + label:getContentSize().height + linespace

                self.rootNode:addChild(label)

            end

            for i = #(self._options.text), 1, -1 do
                local k = self._options.text[i]
                if k["fntfile"] == nil then k["fntfile"] = self._options.fntfile end
                if k["linespace"] == nil then k["linespace"] = self._options.linespace end
                addALabel(k["text"], k["fntfile"], k["linespace"])
            end
        end

        self.rootNode:setContentSize(self._options.preferredWidth, height)
        self:_setContentHeight(height)

    end,


    setText = function(self,text)
        self._options.text = text
        self.rootNode:removeAllChildren()
        self:refreshMultiLine()
    end,

    getText = function(self,text)
        if type(self._options.text)=="string" then
            return self._options.text
        elseif type(self._options.text)=="table" then
            local s = ""
            for i,k in ipairs(self._options.text) do
                s = s..k["text"]
            end
            return s
        end
    end,

    getContentHeight = function(self)
        return self._height
    end,

    getContentLines = function(self)
        return self._lines
    end,

    _setContentHeight =  function(self,height)
        self._height = height
    end,

    setHAlign = function(self,align)
        self._options.halign = align
        self:refreshMultiLine()
    end,

    getRootNode = function(self)
        if not self.rootNode then
            self.rootNode = cc.Node:create()
            self.rootNode:setAnchorPoint(cc.p(0.5, 0.5))
        end
        return self.rootNode

    end,

    getDefaultOptions = function(self)
        return U:extend(true,self:_super(),{
            fntfile = "",
            linespace = 5,
            preferredWidth = 200,
            halign         = cc.TEXT_ALIGNMENT_LEFT,

        })
    end

    --[[
        cc.TEXT_ALIGNMENT_LEFT
        cc.TEXT_ALIGNMENT_RIGHT
        cc.TEXT_ALIGNMENT_CENTER
    ]]--

})


