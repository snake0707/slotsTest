local function main()
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)

    CCLOG("------------------------------------------------")
    CCLOG("in main")
    CCLOG("------------------------------------------------")

    ---------base---------
    require "Cocos2d"
    require "Cocos2dConstants"
    require "DeprecatedEnum"
    require "DeprecatedClass"
    require "Deprecated"
    require "Cocos2dConstants"
    require "Cocos2d"
    require "AudioEngine"
    require "bitExtend"
    require "CCBReaderLoad"
    --    require "CocoStudio"
    --    require "DeprecatedOpenglEnum"
    --    require "DrawPrimitives"
    --    require "experimentalConstants"
    require "extern"
    --    require "GuiConstants"
    require "json"
    --    require "Opengl"
    --    require "OpenglConstants"
    --    require "StudioConstants"

    ---------libs---------
    require "libs.Class"
    require "libs.Event"

    require "component.ui.UIComponent"
    require "libs.Configuration"
    require "libs.Utils"
    require "libs.CCBProxy"
    require "libs.Sqlite"
    require "libs.md5"
    require "libs.Animation"
    require "libs.Http"
    require "libs.utf8"
    require "libs.dkjson"
    require "libs.ErrorCode"


    ---------pages---------
    require "component.pages.Page"
    require "component.pages.IndexPage"
    require "component.pages.home.GameHomePage"
    require "component.pages.maintain.MaintainPage"

    ---------libs---------
    require "libs.Constant"
    require "libs.Audio"
    require "libs.Video"

    require "libs.EventManager"
    require "libs.LayoutManager"
    require "libs.DataManager"
    require "libs.SpriteCacheManager"
    require "libs.AppController"
    require "libs.AppUtils"
    require "libs.SlotAlgorithm"
    require "libs.NotificationManager"
    require "libs.NotificationCenter"


    ---------layout---------
    require "component.ui.Layout"
    require "component.ui.AbsoluteLayout"
    require "component.ui.GridLayout"
    require "component.ui.DockLayout"
    require "component.ui.ColumnLayout"
    require "component.ui.RowLayout"

    ---------base component---------
    require "component.ui.TitleBoard"
    require "component.ui.CCBDialog"
    require "component.ui.Button"

    require "component.ui.Radio"
--    require "component.ui.BriefLabel"
    require "component.ui.Dialog"
--    require "component.ui.TextInput"
    require "component.ui.ScriptControl"
--    require "component.ui.Radio"
--    require "component.ui.CheckBox"
--    require "component.ui.Toast"
    require "component.ui.Scroller"
    require "component.ui.List"
    require "component.ui.SmartList"
    require "component.ui.SmartLabel"
    require "component.ui.SuperLabel"
    require "component.ui.PageView"

    require "component.ui.I18n"
    require "component.com.profiles.BaseProfile"
    require "component.com.toolbar.SlotToolBar"
    require "component.com.toolbar.HomeToolBar"
    require "component.com.paytable.Paytable"
    require "component.com.settings.SettingsDialog"
    require "component.com.common.LevelUpDlg"
    require "component.com.common.CoinBetDlg"
    require "component.com.common.FirstShopDlg"
    require "component.com.common.ShopDlg"
    require "component.com.common.RateDlg"
    require "component.com.common.BonusDlg"
    require "component.com.common.MessageDlg"
    require "component.com.common.ToastDlg"

    require "component.com.gamehome.GameHome"
    require "component.com.switchscene.SwitchScene"
    require "component.com.paytable.PaytableDlg.lua"


    ---------update component---------
    require "update.Update"


--    local sq = Slot.sqlite:new()
--    sq:create("storage/profile.db")
--
--    local rows = sq:readRows("tbl_baseproflie")
--
--    print_table(rows)
--
--    if #rows<= 0 then
--        local now = os.time()
--        sq:insertByKV('tbl_baseproflie',{"coin", "level", "exp", "bet", "continuclose", "collect_times", "last_collect_time", "last_login_time"},{"5000", "1", "0", "1", "0", "0","0", now})
--        rows = sq:readRows("tbl_baseproflie")
--        if #rows<= 0 then
--            error("can not init profile=======")
--        end
--    end
--
--    print_table(rows)
--
--    sq:close()

--  test
--    Slot.http:get("http://httpbin.org/post",{},function(data)
--        print("===========================================post")
--        print_table(data)
--    end)


end

xpcall(main, __G__TRACKBACK__)
