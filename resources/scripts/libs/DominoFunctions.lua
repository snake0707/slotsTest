--
-- by bbf
--

Slot.libs = Slot.libs or {}

Slot.libs.DominoFunctions = Class:extend({
    __className = "Slot.libs.DominoFunctions",

    init = function(self)
        self:reset()
    end,

    pushFunc = function(self, func, ...)
        local last = self.funcs.last + 1
        self.funcs.last = last
        self.funcs[last] = func
        self.params[last] = {...}
    end,

    popFunc = function(self)
        local first = self.funcs.first

        if first > self.funcs.last then return nil end

        local value = self.funcs[first]
        self.funcs[first] = nil
        self.funcs.first = first + 1

        return value
    end,

    reset = function(self)
        self.funcs = {first = 1, last = 0 }
        self.locks = 1
        self.params = {}
    end,

    lock = function(self)
        self.locks = self.locks + 1
    end,

    unlock = function(self)
        self.locks = self.locks - 1
    end,

    callOneFunc = function(self)
        self:unlock()
        if self.locks ~= 0 then
            return
        end

        local func = self:popFunc()
        local param = self.params[self.funcs.first - 1]

        if not U:isNil(func) and type(func) == "function" then
            self:lock()
            func(unpack(param))
        end
    end,
})


Slot.DominoFunctions = Slot.libs.DominoFunctions