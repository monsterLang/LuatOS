--- 模块功能：gsensor- esp32_mpu6050
-- @module mpu6050
-- @author youkai
-- @release 2022.01.23

-- LuaTools需要PROJECT和VERSION这两个信息
PROJECT = "esp32_mpu6050"
VERSION = "1.0.0"

log.info("main", PROJECT, VERSION)

-- sys库是标配
_G.sys = require("sys")

require("t1_display")     --setup lcd

require("t2_lvgl_demo")
require("t2_label_align")

log.info("end require")
--添加硬狗防止程序卡死
-- wdt.init(15000)--初始化watchdog设置为15s
-- sys.timerLoopStart(wdt.feed, 10000)--10s喂一次狗

-- ----------------setup start----------------------
-- 初始化屏幕
init_air105_st7735 ()
display_line()
-- init_lvgl()
-- ----------------setup end------------------------


-- sys.timerLoopStart(function()
--     log.info("GPS", libgnss.getIntLocation())
-- end, 2000) -- 两秒打印一次

-- ================main start================
sys.taskInit(function()
    -- ps:有wait不能放在外面

    sys.wait(1500)

    while 1 do
        sys.wait(10)
    end
end)
-- ================main end==================

sys.run()
