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

require("esp32_st7735")     --setup lcd
require("mpu6xxx_nolocal")  --setup mpu6050
require("lvgl_demo")
require("mpucont")
require("label_align_test")

--添加硬狗防止程序卡死
-- wdt.init(15000)--初始化watchdog设置为15s
-- sys.timerLoopStart(wdt.feed, 10000)--10s喂一次狗

-- ----------------setup start----------------------
-- 初始化屏幕
init_esp32_st7735 ()
init_lvgl()
-- ----------------setup end------------------------

-- ================main start================
sys.taskInit(function()

    -- labtest()
 
    -- mpu6050 value display{
    init_mpu6050()      -- 有wait不能放在外面
    init_mpu6050_cont()

    init_bar_xyz()
    --}

    sys.wait(1500)

    while 1 do

        -- mpu6050 value display{
        temp_a = get_mpu6xxx_value()    -- 获取mpu6050的值

        display_mpu_value()     -- 绘制三个bar，同时显示当前xyz的参考值（百分比）
        -- }

        judge_status()          -- 如果xy数值超过限制，则触发上下左右四个事件。

        sys.wait(10)
    end
end)
-- ================main end==================

sys.run()
