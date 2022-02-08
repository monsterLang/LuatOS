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
require("mpu_event")

--添加硬狗防止程序卡死
-- wdt.init(15000)--初始化watchdog设置为15s
-- sys.timerLoopStart(wdt.feed, 10000)--10s喂一次狗

-- ----------------setup start----------------------
-- 初始化屏幕
init_esp32_st7735 ()
init_lvgl()
-- ----------------setup end------------------------

T0_enable_mpu6050 = 0
T1_mpu_bar = 0
T2_mpu_trigger_event = 0

T3_lvgl_test = 0
T4_uart = 1

-- ================main start================
sys.taskInit(function()
    -- ps:有wait不能放在外面

    -- labtest()
    if T3_lvgl_test == 1 then
        demo_arc()
        clear_lvgl()

        demo_bar()
        clear_lvgl()

        demo_slider()
        clear_lvgl()

        demo_img_symble()
        clear_lvgl()

        demo_cont()
        clear_lvgl()

        -- clear_lvgl()
    end
 
    -- mpu6050 value display{
    if T0_enable_mpu6050 == 1 then
        init_mpu6050()      -- 初始化三轴传感器
    end

    -- func1: 创建cont存放bar，用于显示当前数值
    if T1_mpu_bar == 1 then
        init_mpu6050_cont()
        init_bar_xyz()
    end

    --}

    -- func2: create temp label to display font
    if T2_mpu_trigger_event == 1 then
        init_event_label()

    end

    sys.wait(1500)

    while 1 do

        -- mpu6050 value display{
        if T0_enable_mpu6050 == 1 then
            temp_a = get_mpu6xxx_value()    -- 获取mpu6050的值
        end
        
        -- func1: 显示当前数值
        if T1_mpu_bar == 1 then
            display_mpu_value()     -- 绘制三个bar，同时显示当前xyz的参考值（百分比）
        end
        -- }

        if T2_mpu_trigger_event == 1 then
            save_mpu_temp_value()
            -- log.info("test")
            judge_status()          -- 如果xy数值超过限制，则触发上下左右四个事件。
        end

        sys.wait(10)
    end
end)
-- ================main end==================

sys.run()
