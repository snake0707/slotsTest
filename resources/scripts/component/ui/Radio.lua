--
-- by bbf
--
Slot = Slot or {}

Slot.ui = Slot.ui or {}

Slot.ui.Radio = Slot.ui.UIComponent:extend({

    __className = "Slot.ui.Radio",

    initWithCode = function(self,options)
        self:_super(options)

        self:_setup()
    end,

   _setup=function(self)

       local menu=cc.Menu:create()


       self.rootNode:addChild(menu)




       self.menuImageItem=cc.MenuItemImage:create(self._options.normal_image,self._options.selected_image)
       menu:addChild(self.menuImageItem)



       if self._options.radio_flag==true then
           self.menuImageItem:selected()
           self.selected=true
       else
           self.selected=false
       end


--       self.menuImageItem:registerScriptTapHandler(function()
--
--           if self._options.radio_flag==true then
--               self.menuImageItem:unselected()
--               self._options.radio_flag=false
--               self.selected=true
--           else
--
--               self.menuImageItem:selected()
--               self._options.radio_flag=true
--               self.selected=false
--
--           end
--
--
--       end)
       self.itemWidth=self.menuImageItem:getContentSize().width
       self.itemHeight=self.menuImageItem:getContentSize().height

       menu:setPosition(cc.p(self.itemWidth/2,self.itemHeight/2))

       self:_createLable()

       --return menu

   end,


    _createLable=function(self)

        local label = cc.LabelTTF:create(self._options.text_label, "Marker Felt", self._options.fontSize)
        self.rootNode:addChild(label)
        label:setPosition(cc.p(self.itemWidth+self._options.offsetDistance+label:getContentSize().width/2,self.itemHeight/2))


    end,

    getRootNode = function(self)


        if not self.rootNode then
            self.rootNode =cc.Node:create()
        end
        return self.rootNode
    end,


    getDefaultOptions = function(self)
        return U:extend(false,self:_super(),{
            normal_image="image/common/radio_normal.png",
            selected_image="image/common/radio_selected.png",
            radio_flag=false,
            text_label="",
            offsetDistance=15,
            fontSize=48,


        })
    end

})