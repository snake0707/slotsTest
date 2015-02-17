
---
-- 综合了各种Label，通过对不同参数的控制组合出特定的效果
-- 支持：高亮文字，图标，HTML转义

Slot.ui.SuperLabel = Slot.ui.UIComponent:extend({

    --[[
        usage : 通过text参数传入需要
    ]]--

    __className = "Slot.ui.SuperLabel",

    initWithCode = function(self,options)
        self:_super(options)
        self:_createLabel()
    end,

    setText = function(self,text)
        self._options.text = text
        self:refresh()
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

    _setContentHeight =  function(self,height)
        self._height = height
    end,

    setHAlign = function(self,align)
        self._options.halign = align
        self:refresh()
    end,

    refresh = function(self)
        self.rootNode:removeAllChildrenWithCleanup(true)
        self:_createLabel()
    end,

    --
    -- 根据{{}}切分字符串，需保证type(text)=='string',返回切分好的字符串数组
    -- 注意：对于text想要输出{{符号的未处理，会出现错误
    --

    _getTextTable = function(self, text, key)
        local start = 1
        local sub = text
        local result = {}
        local index = 1
        local go = true
        local pattern = '{{.-}}'

        if key and type(key)=='string' then
            pattern = key
        end

        while go do
            local i,j = string.find(sub, pattern)
            local length = string.len(sub)
            if i and j then
                result[index] = string.sub(sub,start,i-1)
                index = index + 1
                result[index] = string.sub(sub,i,j)
                index = index + 1
                sub = string.sub(sub,j+1)
            else
                if length > 0 then
                    result[index] = sub
                end
                go = false
            end
        end

        return result
    end,

    _getText = function(self, tt)
        local cindex = 1
        local color = self._options.color
        local highLight = self._options.highLight
        local text = {}
        local hllen = 1

        if type(highLight)=='table' then
            hllen = #highLight
        else
            hllen = 1
            highLight = { highLight }
        end

        for k,v in ipairs(tt) do
            i,j = string.find(v,'{{.-}}')
            if i and j then
                if cindex > hllen then
                    cindex = 1
                end
                text[k] = { text = string.sub(v,i+2,j-2), color = highLight[cindex] }
                cindex = cindex + 1
            else
                text[k] = { text = v, color = color }
            end
        end

        return text
    end,

    _stripBlank = function(str)
        str = string.gsub(str,"(\n+)","\n")
        return str
    end,

    _convertEntities = function(self, str)
        local entities = {
            nbsp = " ",
            lt = "<",
            gt = ">",
            amp = "&",
            cent="￠",
            pound="￡",
            yen="￥",
            euro=" ",
            sect="§",
            copy="?",
            reg="?",
            trade="?"
        }
        str = string.gsub(str, "&(%a+);",entities)
        return str
    end,

    _getHtml = function(self,text)
    --local t1 = self:_stripBlank(text)
        local t1 = text
        local tarray = self:_getTextTable(t1,'<.->')
        local pattern = '<.->'
        local key = self._options.hClass
        local color = self._options.color
        local highLight = self._options.highLight
        local text = {}
        local index = 1
        local next = nil

        if type(highLight)=='table' then
            highLight = highLight[1]
        end

        for k,v in ipairs(tarray) do
            i,j = string.find(v,pattern)
            if i and j then
                m,n = string.find(v,key)
                if m and n then
                    next = k + 1
                end
            else
                local ht = self:_convertEntities(v)
                if next == k then
                    text[index] = { text = ht , color = highLight }
                    index = index + 1
                else
                    text[index] = { text = ht , color = color }
                    index = index + 1
                end
            end
        end

        return text
    end,

    _escapeHTML = function(self,text)
        local t1 = text
        local tarray = self:_getTextTable(t1,'<.->')
        local pattern = '<.->'
        local key = self._options.hClass
        local color = self._options.color
        local highLight = self._options.highLight
        local text = ""
        local next = nil

        if type(highLight)=='table' then
            highLight = highLight[1]
        end

        for k,v in ipairs(tarray) do
            i,j = string.find(v,pattern)
            if i and j then
                m,n = string.find(v,key)
                if m and n then
                    next = k + 1
                end
            else
                local ht = self:_convertEntities(v)
                if next == k then
                    text = text .. '{{' .. ht .. '}}'
                else
                    text = text .. ht
                end
            end
        end

        return text
    end,

    _initText = function(self)
    --[[
    if self._options.html then
        local html = self._options.html
        local text = self:_getHtml(html)
        self._options.text = text
    else
    ]]--
        if type(self._options.text) == 'string' then
            if self._options.noTag then
                local t1 = self._options.text
                local t3 = self:_getTextTable(t1)
                local text = self:_getText(t3)
                self._options.text = text
                return
            end
            local t1 = self._options.text
            local t2 = self:_escapeHTML(t1)
            local t3 = self:_getTextTable(t2)
            local text = self:_getText(t3)
            self._options.text = text
        end
    end,

    _createText = function(self)
        self:_initText()

        local pre = cc.LabelTTF:create(self:getText(),self._options.font,self._options.fontSize)
        local predict = cc.LabelTTF:create("T",self._options.font,self._options.fontSize)
        pre:setDimensions (cc.size(self._options.preferredWidth,0))
        local height = pre:getContentSize().height

        local fixWidth = 0
        if self._options.icon then
            fixWidth = self._options.size.width + self._options.offset.left + self._options.spacing
        end

        self.rootNode:setContentSize(cc.size(self._options.preferredWidth,height))
        self:_setContentHeight(pre:getContentSize().height)

        if type(self._options.text) == "string" then
            pre:setHorizontalAlignment(self._options.halign)
            pre:setColor(self._options.color)
            pre:setAnchorPoint(cc.p(0,0))

            self.rootNode:addChild(pre)

        elseif type(self._options.text) == "table" then

            local linewidth = 0
            local lineheight = height - predict:getContentSize().height

            -- total line count
            local lines = math.ceil(height/predict:getContentSize().height)


            local curLine = 1
            local layout
            if self._options.halign == cc.TEXT_ALIGNMENT_CENTER then
                layout = Slot.libs.Layout.CenterHoriztalLayout:new(self.rootNode)
            end
            -- define function for a single label
            local addALabel


            addALabel = function(text,color,newline)

                if newline then
                    linewidth = 0
                    lineheight = lineheight - predict:getContentSize().height
                    curLine = curLine +  1
                end

                if curLine == lines and layout then
                    layout:setStartPosition(cc.p(0,lineheight))
                end

                local te = cc.LabelTTF:create(text,self._options.font,self._options.fontSize)
                te:setAnchorPoint(cc.p(0,0))
                local tw = te:getContentSize().width
                local th = te:getContentSize().height

                if linewidth + tw > self._options.preferredWidth then
                    local left = self._options.preferredWidth - linewidth
                    local wrap = ""
                    for i = 1 , utf8len(text) do
                        local c = utf8sub(text,i,i)
                        local ct = cc.LabelTTF:create(wrap..c,self._options.font,self._options.fontSize)
                        if ct:getContentSize().width > left then
                            ct = cc.LabelTTF:create(wrap,self._options.font,self._options.fontSize)
                            ct:setAnchorPoint(cc.p(0,0))
                            ct:setPosition(cc.p(linewidth+fixWidth,lineheight))
                            linewidth = linewidth + ct:getContentSize().width
                            ct:setColor(color)
                            self.rootNode:addChild(ct)
                            linewidth = 0
                            lineheight = lineheight - th
                            curLine = curLine +  1

                            local leftstr = utf8sub(text,i,utf8len(text))
                            addALabel(leftstr,color)
                            return
                        end
                        wrap = wrap..c
                    end
                    if string.len(wrap) > 0 then
                        local ct = cc.LabelTTF:create(wrap,self._options.font,self._options.fontSize)
                        ct:setAnchorPoint(cc.p(0,0))
                        ct:setPosition(cc.p(linewidth+fixWidth,lineheight))
                        linewidth = linewidth + ct:getContentSize().width
                        ct:setColor(color)

                        self.rootNode:addChild(ct)
                    end
                else
                    te:setPosition(cc.p(linewidth+fixWidth,lineheight))
                    linewidth = linewidth + tw

                    te:setColor(color)
                    if curLine == lines and layout  then
                        layout:addChild(te)
                    else
                        self.rootNode:addChild(te)
                    end

                end
            end

            local _addWrapedLines = function(label,color)
                local lines = {}
                for k, v in string.gmatch(label, "[^\n]+") do
                    if k ~=nil and U:trim(k) ~= "" then
                        addALabel(k,color,true)
                    else
                        addALabel(k,color,false)
                    end
                end
            end

            for i,k in ipairs(self._options.text) do
                if k["color"] == nil then k["color"] = self._options.color end
                if k["text"] == nil then k["text"] = "" end
                _addWrapedLines(k["text"],k["color"])
            end
            if layout then  layout:layoutSubviews() end
        end
    end,

    _createIcon = function(self)
        local _ops = self._options
        local icon = cc.Sprite:create(_ops.icon)
        local size = icon:getContentSize()
        local pSize = {}
        local t = cc.LabelTTF:create("T",self._options.font,self._options.fontSize)
        local th = t:getContentSize().height

        --[[
        -- 设置图片大小
        if self._options.size.width ~= 0 and self._options.size.height ~= 0 then
            pSize.width = self._options.size.width
            pSize.height = self._options.size.height
        elseif self._options.size.width ~= 0 then
            pSize.width = self._options.size.width
            pSize.height = (size.height/size.width)*pSize.width
        elseif self._options.size.height ~= 0 then
            pSize.height = self._options.size.height
            pSize.width = (size.width/size.height)*pSize.height
        else
            pSize.width = size.width
            pSize.height = size.height
        end

        self._options.size.width = pSize.width
        self._options.size.height = pSize.height

        icon:setScaleX(pSize.width/size.width)
        icon:setScaleY(pSize.height/size.height)
        ]]--

        icon:setAnchorPoint(cc.p(0,1))
        icon:setPosition(cc.p(_ops.offset.left,(size.height + th)/2 + _ops.offset.top))
        self.rootNode:addChild(icon)
    end,

    _createLabel = function(self)
        local icon = self._options.icon
        if icon then
            self:_createIcon()
        end
        self:_createText()
    end,

    getDefaultOptions = function(self)
        return U:extend(true, self:_super(), {
            icon = nil,                         -- 图片，默认为无图片
            size = { width = 0, height = 0 },   -- 图片大小
            offset = { top = 0, left = 0 },     -- 图片相对偏移量
            spacing = 0,                        -- 图片与文字间隔
            text = "",                          -- 文字
            font = Slot.Font.default,           -- 文字字体集
            color = Slot.CCC3.white,            -- 文字颜色，默认为白色
            fontSize = 40,                      -- 文字字体大小，默认12号
            preferredWidth = 200,               -- 文字宽度，默认200像素
            halign = cc.TEXT_ALIGNMENT_LEFT,    -- 文字对齐方式，默认左对齐
            highLight = Slot.CCC3.red,    -- 文字高亮颜色
            html = nil,                         -- HTML文本
            hClass = "highlight",               -- HTML高亮文本样式类
            noTag = false                       -- 设置为true时，不处理tag
        })
    end


})