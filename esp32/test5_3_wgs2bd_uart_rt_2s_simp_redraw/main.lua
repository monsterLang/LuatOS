--- 模块功能：gsensor- esp32_air551G
-- @module air551G
-- @author youkai
-- @release 2022.01.23

-- LuaTools需要PROJECT和VERSION这两个信息
PROJECT = "esp32_mpu6050"
VERSION = "1.0.0"

log.info("main", PROJECT, VERSION)

-- sys库是标配
_G.sys = require("sys")

function init_esp32_st7735 ()
    -- spi test ok
    -- spi clk is io2, cs is IO7
    spi_lcd = spi.deviceSetup(2,7,0,0,8,20000000,spi.MSB,1,1)

    log.info("SPI OK")

    log.info("lcd.init",
    -- st7735 + esp32
    lcd.init("st7735",{port = "device",pin_dc = 6, pin_pwr = 11,pin_rst = 10,direction = 0,w = 128,h = 160,xoffset = 0,yoffset = 0},spi_lcd))

    log.info("LCD OK")
end


function init_lvgl()
    LCD_W, LCD_H = 128,160
    -- LCD_W, LCD_H = spi_lcd.getSize()
    log.info("lcd", "size", LCD_W, LCD_H )
    
    log.info("init lvgl")
    if  lvgl.init(128,160) == true  then
        log.debug("lvgl init ok.")
    else
        log.debug("lvgl init error.")
    end
    
end

require("t5_uart_air551")

require("t5_BDlib_test")

log.info("end require")

--添加硬狗防止程序卡死
-- wdt.init(15000)--初始化watchdog设置为15s
-- sys.timerLoopStart(wdt.feed, 10000)--10s喂一次狗

-- ----------------setup start----------------------
-- 初始化屏幕
init_esp32_st7735 ()
-- init_lvgl()
-- ----------------setup end------------------------

T1_BD_xy_lib = 0
T2_realtime = 1

-- ================main start================
sys.taskInit(function()
    -- ps:有wait不能放在外面

    -- display_line ()

    -- print("aaaaa")
    -- lcd.clear()
    -- log.info("lcd.drawLine", lcd.drawLine(74,72,79,72,0x001F))
    -- lcd.drawLine(21,22,	21,	47,0x001F)
    -- sys.wait(1000)
    -- print("bbbb")

    -- lcd.update()

    -- 测试固定百度经纬度标
    if T1_BD_xy_lib == 1 then
        init_status()
        test_lib()
    end 

    -- 测试实时
    if T2_realtime == 1 then
        init_rt_test()
    end

    sys.wait(1500)

    while 1 do
        if T2_realtime == 1 then
            realtime_test()
        end

        sys.wait(10)
    end
end)
-- ================main end==================

sys.run()

