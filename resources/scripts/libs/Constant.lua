--
-- by bbf
--

Slot = Slot or {}

Slot.Collect = {
    --test
    time = 60

    --time=14400
}
--
--Slot.timeForSecs = {
--    day = 86400,
--    hour = 3600,
--    min = 60
--}

Slot.SdkType = {
    LOGIN = 0,
    SHARE = 1,
    PAY = 2,
    BIN = 3
}

Slot.SdkMenuPos = {
    MenuPositionLeftUp      = 1,        -- 左上
    MenuPositionLeftMiddle  = 2,       -- 左中
    MenuPositionLeftDown    = 3,        -- 左下
    MenuPositionRightUp     = 4,        -- 右上
    MenuPositionRightMiddle = 5,        -- 右中
    MenuPositionRightDown   = 6         -- 右下
}

Slot.Bet = {1000,500,200,100,50,20,10,5,2,1}

Slot.start_page_icons = {

    "blackhand",
    "west",
    "hawaii",
    "girl",

}

Slot.Font = {
    default = "TimesNewRomanPS-BoldMT",
    thin    = "TimesNewRomanPSMT",
}

Slot.CCC3 = {
    coffee      = cc.c3b(0x54,0x2b,0x17),
    black       = cc.c3b(0,0,0),
    lightYellow = cc.c3b(0xd7,0xe4,0xbd),
    yellow      = cc.c3b(255,255,0),
    deepYellow  = cc.c3b(0xff,0xc8,0x3f),
    lightGreen  = cc.c3b(0x2b,0x87,0x61),
    lighterGreen = cc.c3b(93,199,147),
    freshGreen = cc.c3b(0x7b,0xed,0x02),
    deepGreen   = cc.c3b(37,102,75),
    deeperGreen = cc.c3b(6,78,24),
    red         = cc.c3b(255,0,0),
    deepRed     = cc.c3b(153,0,0),
    important   = cc.c3b(0xA8,0x0E,0x0E),
    orange      = cc.c3b(255,127,0),
    gold        = cc.c3b(0xff,0xd8,0),
    white       = cc.c3b(255,255,255),
    lightwhite  = cc.c3b(244,240,205),
    indigo      = cc.c3b(0, 0xff, 0xd2),
    brown       = cc.c3b(0x54,0x2b,01),
    deepbrown   = cc.c3b(0x72,0x30,0x18),
    fbTitle     = cc.c3b(1,211,173),
    menuFont    = cc.c3b(193,180,128),
    grass       = cc.c3b(0xb8,0xce,0x74),
    toastColor  = cc.c3b(0xf2,0xee,0xc3),
    blue        = cc.c3b(0,0,0xff),

    excellent   = cc.c3b(132,213,255),       -- 真
    ghost       = cc.c3b(195,155,255),       -- 鬼
    god         = cc.c3b(255,240,0),         -- 神

    -- 角色爵位颜色
    nobility1  = cc.c3b(154,66,0),
    nobility2  = cc.c3b(0,134,61),
    nobility3  = cc.c3b(0,96,168),
    nobility4  = cc.c3b(165,14,190),
    nobility5  = cc.c3b(192,0,0),

    rebirth4   = cc.c3b(32, 63, 143),
    rebirth5   = cc.c3b(99, 34, 91),
    rebirth6   = cc.c3b(189, 42, 45),

    dialogHeader= cc.c3b(242,238,195),

    tabselected = cc.c3b(84,43,1),

    profileFont = cc.c3b(208,223,185),

    highlight   = cc.c3b(255,200,63),

    BAFont      = cc.c3b(255, 204, 0),
    BAFont6     = cc.c3b(204, 0, 0),
    BAFont7     = cc.c3b(102, 0, 204),
    BAFont8     = cc.c3b(0, 102, 0),
    BAOutline   = cc.c3b(153, 0, 0)
}

Slot.FontSize = {
    payTableOne = {
        title = 56,
        payLabelInar = 35,
        payLabel = 35,
        specialLabel = 30
    },
    payTableThree = 80,

}

Slot.CCC4 = {

    open           = cc.c4b(0,0,0,0),
    gray           = cc.c4b(0,0,0,50),
    black          = cc.c4b(0x00,0x00,0x00,255),
    white          = cc.c4b(0xff,0xff,0xff,0),
    overlay        = cc.c4b(0,0,0, 255*.8)

}

Slot.Opacity = {
    open = 0,
    shadow = 60,
    tabPanel = 150,
    expBgOpacity=180,
}

--系统默认的zIndex
Slot.ZIndex = Slot.ZIndex or {}
--toast的zindex系统默认值
Slot.ZIndex.Toast = 1024

Slot.ZIndex.Hit = 200
--dialog的zindex系统默认值
Slot.ZIndex.Dialog = 100
--tutorial的zindex系统默认值
Slot.ZIndex.Tutorial = 3

Slot.ZIndex.Webview = 4

Slot.ZIndex.showWait = 5

--toolbar的zindex系统默认值
Slot.ZIndex.Toolbar = 1


Slot.Animate = Slot.Animate or {}
Slot.Animate.showTime = 0.3

Slot.TouchPriority = {
    lowest = 100,
    list = 14,
    list_item = 13,
    baseprofile = 10,
    toolbar = 10,

    dialog = 0,
    dialog_list = -1,
    dialog_list_item = -2,

    layer = -4,
}

-- 通用的宽与高
Slot.Width = {
    -- Tab通用边距
    slottoolbar = {
        spacing = 14,
    },

    baseprofile = {
        spacing = 16,
    },

    Tab = {
        margin = 3,
        padding = 4,
        margin_outer_top = 5,
        border = 3,
        Button = {
            spacing = 7
        }
    },
}

Slot.Height = {
    spacing = 6,
    margin_top = 0,
    Tab = {
        border = 3,
    },
    poster = 308,
    numberBG_Height=260,
}

Slot.Margin = {

    poster = {
        lr = 10,
        bottom = 40,
        top = 10,
    },

    homebar = {
        bottom = 80
    },
    paytable = {
        left = 6,
        bottom = 6
    },

    start_page_icons = {
        left = -10,
        bottom = 100,
        midBottom = 50

    },

    default = 15

}

Slot.Offset = {

    slottoolbar = {
        shadow = 5
    },
    totalbetlist = {
        shadow = 5
    },
    smartlist = {
        shadow = 4
    },
    baseprofile = {
        shadow = 10,
        left=20,
        xpicon_left=15,
        xpicon_bottom=0,
        xpiconValue_left=2,
        xpiconValue_bottom=5,

    },

    paytable={
        left=20
    },

    totolbelbtn={
        shadow = 10

    }
--    baseproflie = {
--        back_btn = {
--            left_margin = 7
--        },
--        settingBtn = {
--            right_margin = 7
--        },
--        exp = {
--            left_margin = 75
--        },
--        coin = {
--            left_margin = 270
--        }
--    }
}

--正则表达式
Slot.REG = Slot.REG or {}
Slot.REG.Number = "^[0-9]+$"
Slot.REG.Language = Slot.REG.Language or {}
Slot.REG.Language.Character = Slot.REG.Language.Character or {}
Slot.REG.Language.Character.ZH = "^[A-Za-z0-9_]+$"


Slot.ControlType = {
    TOUCH_DOWN           = 1,    -- A touch-down event in the control.
    DRAG_INSIDE          = 2,    -- An event where a finger is dragged inside the bounds of the control.
    DRAG_OUTSIDE         = 4,    -- An event where a finger is dragged just outside the bounds of the control.
    DRAG_ENTER           = 8,    -- An event where a finger is dragged into the bounds of the control.
    DRAG_EXIT            = 16,    -- An event where a finger is dragged from within a control to outside its bounds.
    TOUCH_UP_INSIDE      = 32,    -- A touch-up event in the control where the finger is inside the bounds of the control.
    TOUCH_UP_OUTSIDE     = 64,    -- A touch-up event in the control where the finger is outside the bounds of the control.
    TOUCH_CANCEL         = 128,    -- A system event canceling the current touches for the control.
    VALUE_CHANGED        = 256     -- A touch dragging or otherwise manipulating a control, causing it to emit a series of different values.
}

Slot.PlantForms = {
    'windows',
    'linux',
    'mac',
    'android',
    'ios',
    'ios',
    'blackberry',
    'nacl',
    'emscripten',
    'tizen'
}


Slot.Language = {
    "English",
    "Chinese",
    "French",
    "German",
    "Italian",
    "Russian",
    "Spanish",
    "Korean",
    "Japanese",
    "Hungarian",
    "Portuguese",
    "Arabic"
}


Slot.NetworkStatus = {
    [0] = "kNetworkTypeNone",
    [1] = "kNetworkTypeWWAN",
    [2] = "kNetworkTypeWifi",
}

Slot.DEBUG = 1


--add 12.20

Slot.smallGame={

    west="HighNoon",
    blackhand="BlackHandCard",
    girl="GirlLuckyPlate",
    hawaii="HawaiiParadise",


}

--add 12.21

Slot.SpecailItem={

    west={1,2,50,100,200},
    blackhand={1,2,3,50,100,200},
    girl={1,2,50,100,200},
    hawaii={1,2,3,50,100,200 },


}


--music add 2015 1.04
Slot.MusicResources={

    -- ------------------------------------------------共有音乐文件
    common={

        common="lobby.mp3",

        --赢得金币普通效果
        showcoins_small="showcoins_small.mp3",
        showcoins_mid="showcoins_mid.mp3",
        showcoins_large="showcoins_large.mp3",

        --收集金币
        coinsget="coinsget.mp3",

        --big huge  5ofkind
        fiveofakind="5ofakind.mp3",
        bigwin="bigwin.mp3",
        hugewin="hugewin.mp3",
        numberincrease="numberincrease.mp3",

        --点击一般按钮
        tap="tap.mp3",

        --升级
        levelup="levelup.mp3",
        levelup_firework="levelup_firework.mp3",

        --弹框
        windowshow="windowshow.mp3",
        windowback="windowback.mp3",

        --经验值
        expfly="expfly.mp3",


        --人群欢呼声
        crowdcheers1="crowdcheers1.mp3",
        crowdcheers2="crowdcheers2.mp3",
        crowdcheers3="crowdcheers3.mp3",

        --人群叹息声
        crowdsigh1="crowdsigh1.mp3",
        crowdsigh2="crowdsigh2.mp3",
        crowdsigh3="crowdsigh3.mp3",

        lobby_coins_collect="lobby_coins_collect.mp3",
        lobby_coins_fly="lobby_coins_fly.mp3",
        lobby_wheel="lobby_wheel.mp3",

        --充值
        shop_show="shop_show.mp3",





    },

    -- ------------------------------------------------ 西部牛仔音乐文件
    west={

        west="west.mp3",

        --特殊图标
        west_icon1="west_icon1.mp3",
        west_icon2="west_icon2.mp3",
        west_wild="west_wild.mp3",
        west_bonus="west_bonus.mp3",
        west_scatter="west_scatter.mp3",

        west_spin="west_spin.mp3",
        west_reel_roll="west_reel_roll.mp3",
        west_reel_stop="west_reel_stop.mp3",
        west_expect="west_expect.mp3",

        --期待效果 记得改回来wav
        west_expect_reel1_stop="west_expect_reel1_stop.mp3",
        west_expect_reel2_stop="west_expect_reel2_stop.mp3",
        west_expect_reel3_stop="west_expect_reel3_stop.mp3",
        west_expect_reel4_stop="west_expect_reel4_stop.mp3",
        west_expect_reel5_stop="west_expect_reel5_stop.mp3",


        --小游戏
        west_bgame_begin="west_bgame_begin.mp3",
        west_bgame_dooropen="west_bgame_dooropen.mp3",
        west_bgame_gold="west_bgame_gold.mp3",
        west_bgame_none="west_bgame_none.mp3",
        west_bgame_end="west_bgame_end.mp3"






    },

    -- ------------------------------------------------ 黑手党音乐文件
    blackhand={

        blackhand="blackhand.mp3",
        blackhand_rain="blackhand_rain.mp3",
        blackhand_light="blackhand_light.mp3",


        --特殊图标
        blackhand_icon1="blackhand_icon1.mp3",
        blackhand_icon2="blackhand_icon2.mp3",
        blackhand_icon3="blackhand_icon3.mp3",
        blackhand_wild="blackhand_wild.mp3",
        blackhand_bonus="blackhand_bonus.mp3",
        blackhand_scatter="blackhand_scatter.mp3",

        blackhand_spin="blackhand_spin.mp3",
        blackhand_reel_roll="blackhand_reel_roll.mp3",
        blackhand_reel_stop="blackhand_reel_stop.mp3",
        blackhand_expect="blackhand_expect.mp3",

        --期待效果
        blackhand_expect_reel1_stop="blackhand_expect_reel1_stop.mp3",
        blackhand_expect_reel2_stop="blackhand_expect_reel2_stop.mp3",
        blackhand_expect_reel3_stop="blackhand_expect_reel3_stop.mp3",
        blackhand_expect_reel4_stop="blackhand_expect_reel4_stop.mp3",
        blackhand_expect_reel5_stop="blackhand_expect_reel5_stop.mp3",

        --小游戏
        blackhand_bgame_begin="blackhand_bgame_begin.mp3",
        blackhand_bgame_pickcard="blackhand_bgame_pickcard.mp3",
        blackhand_bgame_cardmatch="blackhand_bgame_cardmatch.mp3",
        blackhand_bgame_end="blackhand_bgame_end.mp3",




    },

    -- ------------------------------------------------ 纸醉金迷音乐文件
    girl={

        girl="girl.mp3",

        --特殊图标
        girl_icon1="girl_icon1.mp3",
        girl_icon2="girl_icon2.mp3",
        girl_wild="girl_wild.mp3",
        girl_bonus="girl_bonus.mp3",
        girl_scatter="girl_scatter.mp3",

        girl_spin="girl_spin.mp3",
        girl_reel_roll="girl_reel_roll.mp3",
        girl_reel_stop="girl_reel_stop.mp3",
        girl_expect="girl_expect.mp3",

        --期待效果
        girl_expect_reel1_stop="girl_expect_reel1_stop.mp3",
        girl_expect_reel2_stop="girl_expect_reel2_stop.mp3",
        girl_expect_reel3_stop="girl_expect_reel3_stop.mp3",
        girl_expect_reel4_stop="girl_expect_reel4_stop.mp3",
        girl_expect_reel5_stop="girl_expect_reel5_stop.mp3",

        --小游戏
        girl_bgame_begin="girl_bgame_begin.mp3",
        girl_bgame_wheel_roll="girl_bgame_wheel_roll.mp3",
        girl_bgame_wheel_stop="girl_bgame_wheel_stop.mp3",
        girl_bgame_end="girl_bgame_end.mp3",


    },

    -- ------------------------------------------------ 夏威夷音乐文件
    hawaii={

        hawaii="hawaii.mp3",


        --特殊图标
        hawaii_icon1="hawaii_icon1.mp3",
        hawaii_icon2="hawaii_icon2.mp3",
        hawaii_icon3="hawaii_icon3.mp3",
        hawaii_wild="hawaii_wild.mp3",
        hawaii_bonus="hawaii_bonus.mp3",
        hawaii_scatter="hawaii_scatter.mp3",

        hawaii_spin="hawaii_spin.mp3",
        hawaii_reel_roll="hawaii_reel_roll.mp3",
        hawaii_reel_stop="hawaii_reel_stop.mp3",
        hawaii_expect="hawaii_expect.mp3",

        --期待效果
        hawaii_expect_reel1_stop="hawaii_expect_reel1_stop.mp3",
        hawaii_expect_reel2_stop="hawaii_expect_reel2_stop.mp3",
        hawaii_expect_reel3_stop="hawaii_expect_reel3_stop.mp3",
        hawaii_expect_reel4_stop="hawaii_expect_reel4_stop.mp3",
        hawaii_expect_reel5_stop="hawaii_expect_reel5_stop.mp3",

        --小游戏
        hawaii_bgame_begin="hawaii_bgame_begin.mp3",
        hawaii_bgame_pick="hawaii_bgame_pick.mp3",
        hawaii_bgame_empty1="hawaii_bgame_empty1.mp3",
        hawaii_bgame_empty2="hawaii_bgame_empty2.mp3",
        hawaii_bgame_end="hawaii_bgame_end.mp3",

    },

}

Slot.shareLink = "http://www.baidu.com"
Slot.shareIcon = "http://211.103.136.251/share/default.png"

