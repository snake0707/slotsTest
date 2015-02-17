--
-- by bbf
--

---
-- 主要是为了解决一个Label内多个字体样式的问题。。。这样的问题真是让人蛋疼啊
Slot = Slot or {}

Slot.ui = Slot.ui or {}

Slot.ui.SmartLabel = Slot.ui.UIComponent:extend({

    __className = "Slot.ui.SmartLabel",

    initWithCode = function(self,options)
        self:_super(options)
        self._height = 0
        self._lines = 0

        if self._options.showInLine then
            self:refreshOneLine()
        else
            self:refreshMultiLine()
        end

    end,

    refreshOneLine = function(self)
        self.rootNode:removeAllChildren()

        if type(self._options.text) == "string" then


            local label = cc.LabelTTF:create(self:getText(),self._options.font,self._options.fontSize)
            local labelSize = label:getContentSize()
            self:_setContentHeight(labelSize.height)
            label:setHorizontalAlignment(self._options.halign)
            label:setColor(self._options.color)
            label:setAnchorPoint(cc.p(0,0))
            label:setPosition(cc.p(0,0))
            self.rootNode:setContentSize(cc.size(labelSize.width,labelSize.height))
            self.rootNode:addChild(label)

        elseif type(self._options.text) == "table" then

            local linewidth = 0
            local lineheight = 0


            local _addLabelInLine = function(text,color,size)

                local label = cc.LabelTTF:create(text,self._options.font,size)
                local labelSize = label:getContentSize()

                if lineheight < labelSize.height then
                    lineheight = labelSize.height
                end


                self:_setContentHeight(lineheight)
                label:setHorizontalAlignment(self._options.halign)
                label:setColor(color)
                label:setAnchorPoint(cc.p(0,0))
                label:setPosition(cc.p(linewidth,0))

                linewidth = linewidth + labelSize.width
                self.rootNode:setContentSize(cc.size(linewidth,lineheight))
                self.rootNode:addChild(label)

            end


            for i,k in ipairs(self._options.text) do

                if k["color"] == nil then k["color"] = self._options.color end
                if k["text"] == nil then k["text"] = "" end
                if k["fontSize"] == nil then k["fontSize"] = self._options.fontSize end
                _addLabelInLine(k["text"],k["color"],k["fontSize"])
            end

        end

        self._lines = 1
    end,


    refreshMultiLine = function(self)
        self.rootNode:removeAllChildren()

        local pre=cc.LabelTTF:create(self:getText(),self._options.font,self._options.fontSize)
        local predict = cc.LabelTTF:create("T",self._options.font,self._options.fontSize)
        pre:setDimensions (cc.size(self._options.preferredWidth,0))
        local height = pre:getContentSize().height
        self.rootNode:setContentSize(cc.size(self._options.preferredWidth,height))
        self:_setContentHeight(pre:getContentSize().height)

        if type(self._options.text) == "string" then
            pre:setHorizontalAlignment(self._options.halign)
            pre:setColor(self._options.color)
            pre:setAnchorPoint(cc.p(0,0))

            self.rootNode:addChild(pre)
            self._lines = 1

        elseif type(self._options.text) == "table" then

            local linewidth = 0
            local lineheight = height - predict:getContentSize().height

            -- total line count
            local lines = math.ceil(height/predict:getContentSize().height)

            self.rootNode:setContentSize(cc.size(self._options.preferredWidth,height + (lines-1) *  - self._options.spacing))

            local curLine = 1
--            local layout
--            if self._options.halign == cc.TEXT_ALIGNMENT_CENTER then
--                layout = Slot.system.Layout.CenterHoriztalLayout:new(self.rootNode)
--            end
            -- define function for a single label
            local addALabel


            addALabel = function(text,color,size,newline)

                if newline then
                    linewidth = 0
                    lineheight = lineheight - predict:getContentSize().height - self._options.spacing
                    curLine = curLine +  1
                    self._lines = curLine
                end

--                if curLine == lines and layout then
--                    --U:debug("lines ends")
--                    layout:setStartPosition(cc.p(0,lineheight))
--                end

                local te = cc.LabelTTF:create(text,self._options.font,size)
                te:setAnchorPoint(cc.p(0,0))
                local tw = te:getContentSize().width
                local th = te:getContentSize().height

                if linewidth + tw > self._options.preferredWidth then

                    local left = self._options.preferredWidth - linewidth
                    local wrap = ""

                    if self._options.type == "letter" then
                        for i = 1 , utf8len(text) do
                            local c = utf8sub(text,i,i)
                            local ct = cc.LabelTTF:create(wrap..c,self._options.font,size)
                            if ct:getContentSize().width > left then
                                ct = cc.LabelTTF:create(wrap,self._options.font,size)
                                ct:setAnchorPoint(cc.p(0,0))
                                --U:debug("add a new label "..wrap.." "..linewidth.." "..lineheight)
                                ct:setPosition(cc.p(linewidth,lineheight))
                                linewidth = linewidth + ct:getContentSize().width
                                ct:setColor(color)
                                self.rootNode:addChild(ct)
                                --new line
                                --U:debug("add a new line")
                                linewidth = 0
                                lineheight = lineheight - th
                                curLine = curLine +  1


                                --避免单词被分割
                                local str=wrap..c
                                local endPos=U:getIndexInStr(str," ")
                                local myStr=string.sub(str,1,endPos)
                                ct:setString(myStr)
                                
                                --local leftstr = utf8sub(text,i,utf8len(text))
                                local leftstr = utf8sub(text,endPos-1,utf8len(text))


                                addALabel(leftstr,color,size)
                                return
                            end
                            wrap = wrap..c
                        end

                    else

                        --todo::
--                        for i = 1 , utf8len(text) do
--
--                            local flag
--                            local t = utf8sub(text,i,utf8len(text))
--                            local s,e = string.find(t, " ")
--
--                            local c
--                            local ct
--                            if s and s > 1 then
--                                c = utf8sub(text,i,s-1)
--                                ct = cc.LabelTTF:create(wrap..c,self._options.font,size)
--                            else
--
--                            end
--
--
--                            local c = utf8sub(text,i,i)
--                            local ct = cc.LabelTTF:create(wrap..c,self._options.font,size)
--                            if ct:getContentSize().width > left then
--                                ct = cc.LabelTTF:create(wrap,self._options.font,size)
--                                ct:setAnchorPoint(cc.p(0,0))
--                                --U:debug("add a new label "..wrap.." "..linewidth.." "..lineheight)
--                                ct:setPosition(cc.p(linewidth,lineheight))
--                                linewidth = linewidth + ct:getContentSize().width
--                                ct:setColor(color)
--                                self.rootNode:addChild(ct)
--                                --new line
--                                --U:debug("add a new line")
--                                linewidth = 0
--                                lineheight = lineheight - th
--                                curLine = curLine +  1
--
--                                local leftstr = utf8sub(text,i,utf8len(text))
--                                addALabel(leftstr,color,size)
--                                return
--                            end
--                            wrap = wrap..c
--                        end

                    end

                    if string.len(wrap) > 0 then
                        local ct = cc.LabelTTF:create(wrap,self._options.font,size)
                        ct:setAnchorPoint(cc.p(0,0))
                        --U:debug("add a new label "..wrap.." "..linewidth.." "..lineheight)
                        ct:setPosition(cc.p(linewidth,lineheight))
                        linewidth = linewidth + ct:getContentSize().width
                        ct:setColor(color)

                        self.rootNode:addChild(ct)
                    end
                else
                    --U:debug("add a new label "..text.." "..linewidth.." "..lineheight)
                    te:setPosition(cc.p(linewidth,lineheight))
                    linewidth = linewidth + tw

                    te:setColor(color)
--                    if curLine == lines and layout  then
--                        layout:addChild(te)
--                    else
--                        self.rootNode:addChild(te)
--                    end
                    self.rootNode:addChild(te)

                end
            end

            local _addWrapedLines = function(label,color,size)
                local lines = {}

                local s,e = string.find(label, "\n")
                if not s then s = 0 end
                for k, v in string.gmatch(label, "[^\n]+") do
                    if k ~=nil  and U:trim(k) == "" or s>0 then
                        addALabel(k,color,size,true)
                    else
                        addALabel(k,color,size,false)
                    end
                end
            end

            for i,k in ipairs(self._options.text) do
                if k["color"] == nil then k["color"] = self._options.color end
                if k["text"] == nil then k["text"] = "" end
                if k["fontSize"] == nil then k["fontSize"] = self._options.fontSize end
                _addWrapedLines(k["text"],k["color"],k["fontSize"])
            end
--            if layout then  layout:layoutSubviews() end
            self._lines = curLine
        end
    end,


    setText = function(self,text)
        self._options.text = text
        self.rootNode:removeAllChildrenWithCleanup(true)
        if self._options.showInLine then
            self:refreshOneLine()
        else
            self:refreshMultiLine()
        end
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
        if self._options.showInLine then
            self:refreshOneLine()
        else
            self:refreshMultiLine()
        end
    end,

--    getRootNode = function(self)
--        if not self.rootNode then
--            self.rootNode = cc.LayerColor:create(Slot.CCC4.gray)
--        end
--        return self.rootNode
--    end,

    getDefaultOptions = function(self)
        return U:extend(true,self:_super(),{
            text           = "",
            font           = Slot.Font.default,
            color          = Slot.CCC3.white,
            fontSize       = 30,
            preferredWidth = 200,
            halign         = cc.TEXT_ALIGNMENT_LEFT,
            showInLine     = false,
            spacing        = 0,
            type = "letter", -- "word"
            isfreeSpinText=false,
        })
    end

    --[[
    kCCTextAlignmentLeft
    kCCTextAlignmentCenter
    ]]--

})
