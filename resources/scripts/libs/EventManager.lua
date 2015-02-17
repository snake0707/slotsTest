--
-- by bbf
--


Slot.libs = Slot.libs or {}

Slot.libs.Event = Class:extend({

    __className = "Slot.libs.Event",

    init      = function(self,t,a)
        self.type = t;
        self.attach = a;
    end,

    fire      = function(self) Slot.libs.EventManager:dispatchEvent(self) end,

    getType   = function(self) return self.type end,

    getAttach = function(self) return self.attach end,

    toString  = function(self) return "Event: "..self.type end

})

Slot.libs.EventManager = {

    __className= "Slot.libs.EventManager",

    __listener = {},

    addListener = function(self,t,c,triggerOnce,isglobal,systemEvent)
        if triggerOnce == nil then triggerOnce = false end
        U:fdebug("Slot.EM","added",t.."  triggerOnce: "..tostring(triggerOnce))

        self.__listener[t] = self.__listener[t] or {}
        self.__listener[t][c] = {isglobal = isglobal , triggerOnce = triggerOnce,systemEvent=systemEvent}
    end,

    removeListener = function(self,t,c)
        U:fdebug("Slot.EM","removed",t)
        if  self.__listener[t] then self.__listener[t][c] = nil end
    end,

    removeAllListener = function(self,t)
        self.__listener[t] = nil
    end,

    clearAll = function(self,clearSystemEvent)
        U:fdebug("Slot.EM","clear all")
        if clearSystemEvent then
            self.__listener = {}
        else
            local t={}
            for k,v in pairs(self.__listener) do
                for k1,v1 in pairs(v) do
                    if v1.systemEvent then 
                        t[k]=t[k] or {}
                        t[k][k1]=v1
                    end
                end
            end
            self.__listener=t
        end
    end,

    clearNotGlobal = function(self)

    end,

    dispatchEvent = function(self,e)
        local t = e:getType()
        U:fdebug("Slot.EM","dispatched",t)
        if self.__listener[t] then
            for c,v in pairs(self.__listener[t]) do
               if c then
                  U:fdebug("Slot.EM","triggered",t)
                  if c(e) == false then break end
                  if v.triggerOnce then
                      self:removeListener(t,c)
                  end
               end
            end
        end
    end
}

Slot.EM = Slot.libs.EventManager

--注册页面跳转事件，预先注册
Slot.EM:addListener("system.switch.scene", function()

    Slot.http:removeFailState()

end)