--- 模块功能：lcd- air105+st7735
-- @module lvgl_img_bin
-- @author youkai
-- @release 2022.02.20

-- LuaTools需要PROJECT和VERSION这两个信息
PROJECT = "esp32_mpu6050"
VERSION = "1.0.0"

log.info("main", PROJECT, VERSION)

-- sys库是标配
_G.sys = require("sys")

require("t1_display")     --setup lcd
require("t2_lvgl_demo")
log.info("end require")

--添加硬狗防止程序卡死
-- wdt.init(15000)--初始化watchdog设置为15s
-- sys.timerLoopStart(wdt.feed, 10000)--10s喂一次狗

-- 初始化屏幕
init_air105_st7735 ()
init_lvgl()

-- ================main start================
sys.taskInit(function()
    -- ps:有wait不能放在外面
    -- demo_arc()
    
    -- sys.wait(3000)
    -- local path = "/luadb/t1.jpg"
    -- img_path = "/luadb/test3.bmp"
    img_path = "/luadb/setup_alpha_29x29.png"
    img_path = "/luadb/RedPack_.jpg"
    img_path = "/luadb/logo.jpg"
    -- img_path = "/luadb/0.jpg"
    img_path = "/luadb/bbb.bin"

    log.info("fsize:"..img_path, fs.fsize(img_path))

    lvgl_img_test(img_path)

    sys.wait(1500)

    while 1 do
        sys.wait(10)
    end
end)
-- ================main end==================

sys.run()
