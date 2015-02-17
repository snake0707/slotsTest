--
-- Created by IntelliJ IDEA.
-- User: oas
-- Date: 15-1-16
-- Time: 下午3:26
-- To change this template use File | Settings | File Templates.
--

require "testdata"

Slot.QAtype = nil


Slot = Slot or {}



Slot.QAtest = Slot.ui.UIComponent:extend({

    __className = "QAtest",

    initWithCode = function(self,options)
        self:_super(options)

        self:_resert()

        self.Qadate=Slot.libs.DataManager:getTestData()  --self.__data["test"]

        self.levelUpTab=Slot.libs.DataManager:getExpLevel()
--
--        U:debug("self.levelUpTab================")
--        U:debug(self.levelUpTab)
--        U:debug("self.levelUpTab================")
        self:_createRadio()

        self:_createEditBox()

    end,

    _resert=function(self)

        Slot.QAtype = nil
    end,
    
    _cancelOtherSelected=function(self,tab,index)

        for i=1,#tab do

            if tab[i].selected==true and i~=index then

                tab[i].menuImageItem:unselected()
                tab[i].selected=false
            end

        end

    end,

    --test
    _getTestState=function(self,tab)

        if tab[1].selected==true then

            Slot.QAtype="bigwin"

        elseif tab[2].selected==true then

            Slot.QAtype="hugewin"

        elseif tab[3].selected==true then

            Slot.QAtype="bonus"

        elseif tab[4].selected==true then

            Slot.QAtype="bigbonus"

        elseif tab[5].selected==true then

            Slot.QAtype="hugebonus"

        elseif tab[6].selected==true then

            Slot.QAtype="scatter"

        elseif tab[7].selected==true then

            Slot.QAtype="bigscatter"

        elseif tab[8].selected==true then

            Slot.QAtype="hugescatter"

        else

            Slot.QAtype=nil

        end

        return self.Qadate

    end,


    _getTheLevel=function(self,exp)

        for i, v in ipairs(self.levelUpTab) do

            if exp<v.exp then

                return tonumber(v.level)
            elseif exp==v.exp then

                return tonumber(v.level)+1
            end

        end

    end,


    --test
    _createRadio=function(self)

        local textLable = {"bigwin","hugewin","bonus","bigbonus","hugebonus","scatter","bigscatter","hugescatter"}

        self.radioTab={}
        self.radioState={}
        for i=1,#textLable do
            local radio = Slot.ui.Radio:new({text_label=textLable[i]})
            self.rootNode:addChild(radio:getRootNode(),10000)
            table.insert(self.radioTab,radio)
            radio:setPosition(cc.p(0,650-90*(i-1)))

        end



        for i=1,#textLable do
            self.radioTab[i].menuImageItem:registerScriptTapHandler(function()

                if self.radioTab[i].selected==true then
                    self.radioTab[i].menuImageItem:unselected()
                    self.radioTab[i]._options.radio_flag=false
                    self.radioTab[i].selected=false

                else

                    self.radioTab[i].menuImageItem:selected()
                    self.radioTab[i]._options.radio_flag=true
                    self.radioTab[i].selected=true

                    --取消其他选框
                    self:_cancelOtherSelected(self.radioTab,i)

                end

                --存储下点击后的状态
                self:_getTestState(self.radioTab)

            end)
        end


    end,



    _createEditBox=function(self)



    --创建编辑框
        local kindTab={"exp","coin" }

        for i=1,#kindTab do
            local box = cc.EditBox:create(cc.size(150, 80), cc.Scale9Sprite:create("image/common/editbox_bg.png"))
            self.rootNode:addChild(box)
            box:setPosition(cc.p(80,800+(i-1)*100))
            box:setFont("Arial", 60)
            box:setFontColor(cc.c3b(255, 0, 0))
            box:setPlaceHolder(kindTab[i])
            box:registerScriptEditBoxHandler(function(strEventName,pSender)


                if strEventName == "return" then

                    local text=pSender:getText()
                    local params={}

                    if text=="" or tonumber(text)<=0 or tonumber(text)==nil then return end

                    params["debug"] = 1

                    if kindTab[i]=="exp" then
                        params["exp"] = tonumber(text)
                        params["level"]=self:_getTheLevel(tonumber(text))

                        Slot.http:post(
                            "debug/addExp",
                            params,
                            function(data)
                                if data.rc == 0 then
                                    local profile = Slot.DM:getBaseProfile()
                                    profile.exp = params["exp"]
                                    profile.level = params["level"]
                                    Slot.DM:setBaseProfile(profile)
                                    self:fireEvent("profile_update", profile)
                                end
                            end)
                    elseif kindTab[i]=="coin" then

                        params["coin"] = tonumber(text)
                        Slot.http:post(
                            "debug/addCoin",
                            params,
                            function(data)
                                if data.rc == 0 then
                                local profile =Slot.DM:getBaseProfile()
                                profile.coin = params["coin"]
                                Slot.DM:setBaseProfile(profile)
                                self:fireEvent("profile_update", profile)
                                end
                            end)

                    end


                end


            end)
        end


    end,



    getRootNode = function(self)
        if not self.rootNode then
            self.rootNode = cc.Node:create()
            self.rootNode:setContentSize(self._options.size)
        end
        return self.rootNode
    end,





    getDefaultOptions = function(self)
        return U:extend(false,self:_super(),{
            size=cc.size(100,800)
        })
    end

})