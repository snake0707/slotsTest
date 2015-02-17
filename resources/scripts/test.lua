print("test===in the pre package")
------ local moduleName = ...
----print(module)
----print(aaa)
--
--require "libs.Http"
require "libs.Utils"
--require "libs.DataManager"
--print("in http===========================")
--
----Slot.http:post("player/guest", {
----    test = "test"
----}, function(data, status)
----    print("in http===========================2")
----    U:debug(data)
----end)
--
--
--
--local b =  tonumber(Slot.DM:getLocalStorage("seed"))
--print(b)
--local a, b = U:randforgame(b)
--print(a)
--print(b)
--
--local a, b = U:randforgame(b)
--print(a)
--print(b)
--
--local a, b = U:randforgame(b)
--print(a)
--print(b)
--
--
--local a, b = U:randforgame(b, 1, 50)
--print(a)
--print(b)
--
--local a, b = U:randforgame(b, 1, 50)
--print(a)
--print(b)
--
--local a, b = U:randforgame(b, 1, 50)
--print(a)
--print("cc.Application:getInstance():getCurrentLanguage():")
--print(cc.Application:getInstance():getCurrentLanguage())
--
--require "component.ui.I18n"
--print(U:locale("common", "rate"))
--cc.OASSdk:getInstance():retain()
--cc.OASSdk:getInstance():registerHandler(0, function(userInfo)
--
--    print("it is a test for sdk=========")
--    print_table(userInfo)
--
--end)
--cc.OASSdk:getInstance():autoLogin()
--cc.OASSdk:getInstance():release()

--print("http:www.baidu.com===========")switch_end
require "libs.Constant"
require "component.ui.I18n"
--print(Slot.NetworkStatus[cc.LeverNetworkUtils:getInstance():getNetworkType("www.apple.com")])


--print("removeNotification===========================")
--Slot.NM:removeNotification("collectcoins")
--Slot.NM:notification(U:locale("pushmessage", "collect_coins"), 20, "collectcoins")
--print("debug======="..cc.LeverConfigure:getInstance():getPlatfomParamByKey("debug"))
--print("getNetworkType======="..cc.LeverNetworkUtils:getInstance():getNetworkType())
--cc.LeverUtils:getInstance():openUrl("www.baidu.com")
print("debug======="..cc.LeverConfigure:getInstance():getPlatfomParamByKey("debug"))
print("bundleVersion======="..cc.LeverConfigure:getInstance():getPlatfomParamByKey("bundleVersion"))
print("bundeId======="..cc.LeverConfigure:getInstance():getPlatfomParamByKey("bundeId"))
print("languageCode======="..cc.LeverConfigure:getInstance():getPlatfomParamByKey("languageCode"))
print("countryCode======="..cc.LeverConfigure:getInstance():getPlatfomParamByKey("countryCode"))