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

require("esp32_st7735")
require("mpu6xxx_nolocal")

--添加硬狗防止程序卡死
-- wdt.init(15000)--初始化watchdog设置为15s
-- sys.timerLoopStart(wdt.feed, 10000)--10s喂一次狗


-- func lib{
-- 1. display: st735
-- function init_esp32_st7735 ()
--     log.info("init_esp32_st7735 start---------------")
--     -- spi test ok
--     -- spi clk is io2, cs is IO7
--     spi_lcd = spi.deviceSetup(2,7,0,0,8,20000000,spi.MSB,1,1)

--     log.info("SPI OK")

--     log.info("lcd.init",
--     -- st7735 + esp32
--     lcd.init("st7735",{port = "device",pin_dc = 6, pin_pwr = 11,pin_rst = 10,direction = 0,w = 128,h = 160,xoffset = 0,yoffset = 0},spi_lcd))

--     log.info("init_esp32_st7735 end---------------")
-- end

-- function display_line ()
--     log.info("lcd.drawLine", lcd.drawLine(20,20,150,20,0x001F))
--     log.info("lcd.drawRectangle", lcd.drawRectangle(20,40,120,70,0xF800))
--     log.info("lcd.drawCircle", lcd.drawCircle(50,50,20,0x0CE0))
--     -- sys.wait(1500)
--     log.info("display demo")
-- end

-- function display_str ()
--     lcd.setFont(lcd.font_opposansm12)
--     lcd.drawStr(40,10,"drawStr")
--     lcd.setFont(lcd.font_opposansm16_chinese)
--     lcd.drawStr(40,40,"drawStr测试")
-- end

-- }func lib end

-- ----------------setup start----------------------
-- 初始化屏幕
init_esp32_st7735 ()

-- ----------------setup end------------------------

-- ================main start================
sys.taskInit(function()
    init_mpu6050()      -- 有wait不能放在外面
    while 1 do
        lcd.clear()
        display_str()
        sys.wait(1500)
        lcd.clear()
        display_line()
        sys.wait(1500)
        get_mpu6xxx_value()
    end
end)
-- ================main end==================

-- 用户代码已结束---------------------------------------------
-- 结尾总是这一句
sys.run()
-- sys.run()之后后面不要加任何语句!!!!!


-- demo https://gitee.com/openLuat/LuatOS/blob/master/demo/i2c/main.lua
-- -- LuaTools需要PROJECT和VERSION这两个信息
-- PROJECT = "i2c 24c02 demo"
-- VERSION = "1.0.0"

-- -- sys库是标配
-- local sys = require "sys"

-- --1010 000x
-- --7bit地址，不包含最后一位读写位
-- local addr = 0x50
-- -- 按照实际芯片更改编号哦
-- local i2cid = 0

-- sys.taskInit(function()
--     log.info("i2c initial",i2c.setup(0))
--     while true do
--         --第一种方式
--         i2c.send(i2cid, addr, string.char(0x01).."1234abcd")
--         sys.wait(100)
--         i2c.send(i2cid, addr, string.char(0x01))
--         local data = i2c.recv(i2cid, addr, 8)
--         log.info("i2c", "data1",data:toHex(),data)

--         --第二种方式
--         i2c.writeReg(i2cid, addr, 0x01, "abcd1234")
--         sys.wait(100)
--         local data = i2c.readReg(i2cid, addr, 0x01, 8)
--         log.info("i2c", "data2",data:toHex(),data)
--         sys.wait(1000)
--     end

-- end)

-- -- 用户代码已结束---------------------------------------------
-- -- 结尾总是这一句
-- sys.run()
-- -- sys.run()之后后面不要加任何语句!!!!!