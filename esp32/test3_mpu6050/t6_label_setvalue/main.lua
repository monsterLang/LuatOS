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
    -- si_x = init_mpu6050_slider_x()
    -- si_y = init_mpu6050_slider_y()
    -- si_z = init_mpu6050_slider_z()
    sys.wait(1500)

    init_bar("x")
    init_bar("y")
    init_bar("z")
    --}
    while 1 do


        -- mpu6050 value display{
        temp_a = get_mpu6xxx_value()
        -- get_mpu6xxx_value()

        temp_x = set_bar_value(value_range[1][1],value_range[1][2],temp_a.x,"x")
        temp_y = set_bar_value(value_range[2][1],value_range[2][2],temp_a.y,"y")
        temp_z = set_bar_value(value_range[3][1],value_range[3][2],temp_a.z,"z")
        -- log.info("temp_x",temp_x)
        -- temp_x = set_slider_value(value_range[1][1],value_range[1][2],temp_a.x)
        -- temp_y = set_slider_value(value_range[2][1],value_range[2][2],temp_a.y,"y")
        -- temp_z = set_slider_value(value_range[3][1],value_range[3][2],temp_a.z)

        lvgl.bar_set_value(bar_list["x"]["bar"], temp_x, lvgl.ANIM_OFF)
        lvgl.bar_set_value(bar_list["y"]["bar"], temp_y, lvgl.ANIM_OFF)
        lvgl.bar_set_value(bar_list["z"]["bar"], temp_z, lvgl.ANIM_OFF)
        -- lvgl.slider_set_value(si_x, temp_x, lvgl.ANIM_OFF)
        -- lvgl.slider_set_value(si_y, temp_y, lvgl.ANIM_OFF)
        -- lvgl.slider_set_value(si_z, temp_z, lvgl.ANIM_OFF)

        -- log.debug("get-------",lvgl.slider_get_value(si_1))
        -- log.info("layout update")
        -- }
        sys.wait(10)
    end
end)
-- ================main end==================

sys.run()
