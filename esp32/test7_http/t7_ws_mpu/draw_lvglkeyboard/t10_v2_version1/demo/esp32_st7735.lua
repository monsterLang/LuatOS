-- 1. display: st735
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

--代码来源--https://doc.openluat.com/wiki/21?wiki_page_id=2561
-- 整理：youkai
-- 注意事项：部分函数中存在wait，需要在sys.taskInit中调用。

function init_lvgl()
    -- LCD_W, LCD_H = 128,160
    LCD_W, LCD_H = 128,160
    -- LCD_W, LCD_H = spi_lcd.getSize()
    log.info("lcd", "size", LCD_W, LCD_H )

    -- log.info(spi_lcd.w)

    log.info("init lvgl")
    -- log.info("lvgl", lvgl.init(128,160))
    -- m = lvgl.init(128,160)
    -- if ( m == true )
    lvgl_disp = lvgl.init(128,160)
    -- lvgl_disp = lvgl.init(160,128)
    if lvgl_disp == true  then
        log.debug("lvgl init ok.")
    else
        log.debug("lvgl init error.")
    end
end

function clear_lvgl()
    -- lcd.clear(0xFFFFFF)
    -- lcd.draw()
    sys.wait(2000)
end