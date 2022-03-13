--- 模块功能：lvgldemo
-- @module lvgl
-- @author Dozingfiretruck
-- @release 2021.01.25

-- LuaTools需要PROJECT和VERSION这两个信息
PROJECT = "lvgldemo"
VERSION = "1.0.0"

LV_LOG_LEVEL  = 3

log.info("main", PROJECT, VERSION)

-- sys库是标配
_G.sys = require("sys")

function init_esp32_st7735 ()
    log.info("===init lcd")
    spi_lcd = spi.deviceSetup(2,7,0,0,8,20000000,spi.MSB,1,1)

    log.info("lcd.init",
    -- st7735 + esp32
    lcd.init("st7735",{port = "device",pin_dc = 6, pin_pwr = 11,pin_rst = 10,direction = 0,w = 128,h = 160,xoffset = 0,yoffset = 0},spi_lcd))

    log.info("LCD OK.")
end


function arc()
    -- 1. 初始化
    --{
    -- scr = lvgl.obj_create(nil, nil)
    -- arc = lvgl.arc_create(scr, nil)  -- 创建曲线
    arc = lvgl.arc_create(lvgl.scr_act(), nil)  -- 创建曲线
    lvgl.obj_set_size(arc, 128, 128)            -- 设置尺寸
    lvgl.obj_align(arc, nil, lvgl.ALIGN_CENTER, 0, 0)-- 设置位置居中
    -- 绘制弧度
    -- lvgl.arc_set_end_angle(arc, 100)
    -- }

    -- -- 方法1：直接是设置固定角度
    -- -- 绘制背景角度
    -- lvgl.arc_set_bg_angles(arc, 0, 180) --背景0-180度
    -- -- 绘制前景角度（填充的）
    -- lvgl.arc_set_angles(arc, 0, 90)     --前景0-90度
    -- log.info("scr_load",lvgl.scr_load(arc))--显示

    -- -- 方法2：设置背景角度后，设置背景范围，通过传入数值显示
    -- lvgl.arc_set_bg_angles(arc, 150, 30) --背景0-180度
    -- lvgl.arc_set_range(arc, 0, 100)      --设置数值范围
    -- lvgl.arc_set_value(arc, 30)          --传入数值
    -- log.info("scr_load",lvgl.scr_load(arc))--显示

    -- 方法3：隔1s显示不同数值
    lvgl.arc_set_bg_angles(arc, 150, 30) --背景0-180度
    lvgl.arc_set_adjustable(arc, true)   --允许输入
    lvgl.arc_set_value(arc, 30)          --传入数值
    log.info("scr_load",lvgl.scr_load(arc))--显示

    sys.wait(1000)                       -- 等1s传入新值
    lvgl.arc_set_value(arc, 50)          --传入数值

    m = lvgl.scr_load(arc)
    log.info(m)
    -- log.info("scr_load",lvgl.scr_load(arc))
    sys.wait(1000)

    log.info("lvgl demo: arc")

    -- test
    y = 0
    log.info(y)

    -- temp_status = lvgl.obj_clean(scr)
    -- temp_status = lvgl.obj_del(arc)
    temp_status = lvgl.obj_clean(arc)
    log.info(temp_status)    --清除其内容

    x = 1
    log.info(x)
    -- log.info("scr_load",lvgl.scr_load(arc))--显示
    -- lvgl.obj_del(arc)           --删除
end

log.info("start----------------")

init_esp32_st7735 ()

LCD_W, LCD_H = 128,160
-- LCD_W, LCD_H = spi_lcd.getSize()
log.info("lcd", "size", LCD_W, LCD_H )


log.info("init lvgl")
-- log.info("lvgl", lvgl.init(128,160))
m = lvgl.init(128,160)
log.info(m)
if ( m == true )
-- if ( lvgl.init(128,160) == true )

then
    log.debug("lvgl init ok.")
else
    log.debug("lvgl init error.")
end


log.info("end----------------")

-- x = lvgl.theme_set_act("mono")
-- log.info(x)

sys.taskInit(function()
    arc()
    while 1 do
        sys.wait(1000)
    end
end)


-- 用户代码已结束---------------------------------------------
-- 结尾总是这一句
sys.run()
-- sys.run()之后后面不要加任何语句!!!!!
