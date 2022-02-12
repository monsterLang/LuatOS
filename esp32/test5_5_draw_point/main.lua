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
require("t2_ext_font")

require("t3_mpu6050")  --setup mpu6050
require("t3_mpucont")
require("t3_mpu_event")

require("t5_demo_uart")
require("t5_uart_air551")
require("t5_change_draw")

log.info("end require")
--添加硬狗防止程序卡死
-- wdt.init(15000)--初始化watchdog设置为15s
-- sys.timerLoopStart(wdt.feed, 10000)--10s喂一次狗

-- ----------------setup start----------------------
-- 初始化屏幕
init_esp32_st7735 ()
-- init_lvgl()
-- ----------------setup end------------------------


T0_enable_mpu6050 = 0
T1_mpu_bar = 0
T2_mpu_trigger_event = 0

T3_lvgl_test = 0

T5_uart_demo = 0
T5_uart_air551G = 0
T5_draw_xy_test = 0

x = 3118.38303

log.info(x)


-- a = 1234567890
-- y = a + 111
-- log.info(y,type(y))
-- b = 1234.4567890 
-- x = b%1
-- log.info(x,type(x))

-- log.info(a,type(a))
-- log.info(b,type(b))
-- b = tostring(b)
-- log.info(b,type(b))

-- x = 119477546%1000000
-- log.info(x,type(x))
-- -- 32200580

-- sys.timerLoopStart(function()
--     log.info("GPS", libgnss.getIntLocation())
-- end, 2000) -- 两秒打印一次

-- ================main start================
sys.taskInit(function()
    -- ps:有wait不能放在外面


    if T5_draw_xy_test == 1 then
        -- log.info("lcd.drawPoint", lcd.drawPoint(50,50,0x0CE0))
        log.info("lcd.drawPoint", lcd.drawLine(0,129,129,129,0x0CE0))
        test_change()
        log.info(table.concat(LCD_xy_list,","))
    end

    -- string.sub(sourcestr, -100)

    if T5_uart_demo ==1 then
        init_uart()
    end

    if T5_uart_air551G ==1 then
        -- test_string_get()

        init_uart_air551()
    end
    

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
