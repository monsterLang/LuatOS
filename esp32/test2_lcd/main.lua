--- 模块功能：lcd:esp32-c3+st7735
-- @module lcd_st7735
-- @author youkai
-- @release 2022.01.23

-- LuaTools需要PROJECT和VERSION这两个信息
PROJECT = "esp32_lcdst7735"
VERSION = "1.0.0"

log.info("main", PROJECT, VERSION)

-- sys库是标配
_G.sys = require("sys")
require("esp32_st7735")
--添加硬狗防止程序卡死
-- wdt.init(15000)--初始化watchdog设置为15s
-- sys.timerLoopStart(wdt.feed, 10000)--10s喂一次狗

-- ----------------setup start----------------------
-- 初始化屏幕
init_esp32_st7735 ()

-- ----------------setup end------------------------

-- ================main start================
sys.taskInit(function()
    while 1 do
        lcd.clear()
        -- display_str ()
        
        sys.wait(1500)
        lcd.clear()
        display_line ()
        sys.wait(1500)
    end
end)
-- ================main end==================

-- 用户代码已结束---------------------------------------------
-- 结尾总是这一句
sys.run()
-- sys.run()之后后面不要加任何语句!!!!!
