--[[
-- LCD接法示例, 以Air105开发板的HSPI为例
LCD管脚       Air105管脚
GND          GND
VCC          3.3V
SCL          (PB02/SPI2_SCK)
SDA          (PB04/SPI2_MOSI)
RES          (PB05/SPI2_MISO)
DC           (PA00) --开发板上的U0_RX
CS           (PB03/SPI2_CSN)
BL           (PA01) --开发板上的U0_TX

提示:
1. 只使用SPI的时钟线(SCK)和数据输出线(MOSI), 其他均为GPIO脚
2. 数据输入(MISO)和片选(CS), 虽然是SPI, 但已复用为GPIO, 并非固定,是可以自由修改成其他脚
]]


-- 1. display: st7735+air105  spi2
function init_air105_st7735 ()
    -- spi test ok
    -- spi id is 2, cs is PB03
    -- spi_lcd = spi.deviceSetup(2,7,0,0,8,20000000,spi.MSB,1,1)
    spi_lcd = spi.deviceSetup(2,pin.PB03,0,0,8,2*1000*1000,spi.MSB,1,1)

    log.info("SPI OK")

    -- st7735 + esp32
    -- log.info("lcd.init",
    -- lcd.init("st7735",{port = "device",pin_dc = 6, pin_pwr = 11,pin_rst = 10,direction = 0,w = 128,h = 160,xoffset = 0,yoffset = 0},spi_lcd))
    
    -- air105 + st7735
    log.info("lcd.init",
    lcd.init("st7735",{port = "device",pin_dc = pin.PC00 ,pin_rst = pin.PB05,pin_pwr = pin.PC01,direction = 0,w = 128,h = 160,xoffset = 0,yoffset = 0},spi_lcd))
    -- log.info("lcd.init",
    -- lcd.init("st7735",{port = "device",pin_dc = 32 ,pin_rst = 21,pin_pwr = 33,direction = 0,w = 128,h = 160,xoffset = 0,yoffset = 0},spi_lcd))

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