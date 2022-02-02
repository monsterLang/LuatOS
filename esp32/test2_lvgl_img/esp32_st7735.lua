-- 1. display: st735
function init_esp32_st7735 ()
    log.info("===init lcd")
    -- spi test ok
    -- spi clk is io2, cs is IO7
    spi_lcd = spi.deviceSetup(2,7,0,0,8,20000000,spi.MSB,1,1)

    log.info("lcd.init",
    -- st7735 + esp32
    lcd.init("st7735",{port = "device",pin_dc = 6, pin_pwr = 11,pin_rst = 10,direction = 0,w = 128,h = 160,xoffset = 0,yoffset = 0},spi_lcd))

-- spi_lcd = spi.deviceSetup(2,5,0,0,8,20000000,spi.MSB,1,1)
-- log.info("lcd.init",
-- lcd.init("st7789",{port = "device",pin_dc = 7, pin_rst = 8,direction = 0,w = 240,h = 320,xoffset = 0,yoffset = 0},spi_lcd))
    log.info("LCD OK.")
end

function display_line ()
    log.info("lcd.drawLine", lcd.drawLine(20,20,150,20,0x001F))
    log.info("lcd.drawRectangle", lcd.drawRectangle(20,40,120,70,0xF800))
    log.info("lcd.drawCircle", lcd.drawCircle(50,50,20,0x0CE0))
    -- sys.wait(1500)
    log.info("display demo")
end

function display_str ()
    lcd.setFont(lcd.font_opposansm12)
    lcd.drawStr(40,10,"drawStr")
    lcd.setFont(lcd.font_opposansm16_chinese)
    lcd.drawStr(40,40,"drawStr测试")
end