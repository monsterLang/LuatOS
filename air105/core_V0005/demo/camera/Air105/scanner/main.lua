

PROJECT = "scanner"
VERSION = "1.0.0"

local sys = require "sys"

--[[
-- LCD接法示例, 以Air105开发板的HSPI为例
LCD管脚       Air105管脚
GND          GND
VCC          3.3V
SCL          (PC15/HSPI_SCK)
SDA          (PC13/HSPI_MOSI)
RES          (PC12/HSPI_MISO)
DC           (PE08) --开发板上的U3_RX
CS           (PC14/HSPI_CS)
BL           (PE09) --开发板上的U3_TX


提示:
1. 只使用SPI的时钟线(SCK)和数据输出线(MOSI), 其他均为GPIO脚
2. 数据输入(MISO)和片选(CS), 虽然是SPI, 但已复用为GPIO, 并非固定,是可以自由修改成其他脚
]]

if wdt then
    wdt.init(15000)--初始化watchdog设置为15s
    sys.timerLoopStart(wdt.feed, 10000)--10s喂一次狗
end

spi_lcd = spi.deviceSetup(5,pin.PC14,0,0,8,48*1000*1000,spi.MSB,1,1)

-- log.info("lcd.init",
-- lcd.init("st7735s",{port = "device",pin_dc = pin.PE08 ,pin_rst = pin.PC12,pin_pwr = pin.PE09,direction = 2,w = 160,h = 80,xoffset = 1,yoffset = 26},spi_lcd))

log.info("lcd.init",
lcd.init("st7789",{port = "device",pin_dc = pin.PE08 ,pin_rst = pin.PC12,pin_pwr = pin.PE09,direction = 0,w = 240,h = 320,xoffset = 0,yoffset = 0},spi_lcd))

-- log.info("lcd.init",
-- lcd.init("st7735",{port = "device",pin_dc = pin.PE08 ,pin_rst = pin.PC12,pin_pwr = pin.PE09,direction = 0,w = 128,h = 160,xoffset = 2,yoffset = 1},spi_lcd))

-- log.info("lcd.init",
-- lcd.init("gc9306",{port = "device",pin_dc = pin.PE08 ,pin_rst = pin.PC12,pin_pwr = pin.PE09,direction = 0,w = 240,h = 320,xoffset = 0,yoffset = 0},spi_lcd))

--GC032A输出灰度图像初始化命令
local GC032A_InitReg_Gray =
{
	zbar_scan = 1,--是否为扫码
    draw_lcd = 1,--是否向lcd输出
    i2c_id = 0,
	i2c_addr = 0x21,
    pwm_id = 5;
    pwm_period  = 24*1000*1000,
    pwm_pulse = 0,
	sensor_width = 640,
	sensor_height = 480,
    color_bit = 16,
	init_cmd =
	{
        0xf3,0xff,
        0xf7,0x01,
        0xf8,0x03,
        0xf9,0xce,
        0xfa,0x00,
        0xfc,0x02,
        0xfe,0x02,
        0x81,0x03,
        0xfe,0x00,
        0x03,0x01,
        0x04,0xc2,
        0x05,0x01,
        0x06,0xc2,
        0x07,0x00,
        0x08,0x08,
        0x0a,0x04,
        0x0c,0x04,
        0x0d,0x01,
        0x0e,0xe8,
        0x0f,0x02,
        0x10,0x88,
        0x17,0x54,
        0x19,0x04,
        0x1a,0x0a,
        0x1f,0x40,
        0x20,0x30,
        0x2e,0x80,
        0x2f,0x2b,
        0x30,0x1a,
        0xfe,0x02,
        0x03,0x02,
        0x06,0x60,
        0x05,0xd7,
        0x12,0x89,
        0xfe,0x00,
        0x18,0x02,
        0xfe,0x02,
        0x40,0x22,
        0x45,0x00,
        0x46,0x00,
        0x49,0x20,
        0xfe,0x01,
        0x0a,0xc5,
        0x45,0x00,
        0xfe,0x00,
        0x40,0xff,
        0x41,0x25,
        0x42,0x83,
        0x43,0x10,
        0x46,0x26,
        0x49,0x03,
        0x4f,0x01,
        0xde,0x84,
        0xfe,0x02,
        0x22,0xf6,
        0xfe,0x01,
        0x12,0xa0,
        0x13,0x3a,
        0xc1,0x3c,
        0xc2,0x50,
        0xc3,0x00,
        0xc4,0x32,
        0xc5,0x24,
        0xc6,0x16,
        0xc7,0x08,
        0xc8,0x08,
        0xc9,0x00,
        0xca,0x20,
        0xdc,0x8a,
        0xdd,0xa0,
        0xde,0xa6,
        0xdf,0x75,
        0xfe,0x01,
        0x7c,0x09,
        0x65,0x00,
        0x7c,0x08,
        0x56,0xf4,
        0x66,0x0f,
        0x67,0x84,
        0x6b,0x80,
        0x6d,0x12,
        0x6e,0xb0,
        0x86,0x00,
        0x87,0x00,
        0x88,0x00,
        0x89,0x00,
        0x8a,0x00,
        0x8b,0x00,
        0x8c,0x00,
        0x8d,0x00,
        0x8e,0x00,
        0x8f,0x00,
        0x90,0xef,
        0x91,0xe1,
        0x92,0x0c,
        0x93,0xef,
        0x94,0x65,
        0x95,0x1f,
        0x96,0x0c,
        0x97,0x2d,
        0x98,0x20,
        0x99,0xaa,
        0x9a,0x3f,
        0x9b,0x2c,
        0x9c,0x5f,
        0x9d,0x3e,
        0x9e,0xaa,
        0x9f,0x67,
        0xa0,0x60,
        0xa1,0x00,
        0xa2,0x00,
        0xa3,0x0a,
        0xa4,0xb6,
        0xa5,0xac,
        0xa6,0xc1,
        0xa7,0xac,
        0xa8,0x55,
        0xa9,0xc3,
        0xaa,0xa4,
        0xab,0xba,
        0xac,0xa8,
        0xad,0x55,
        0xae,0xc8,
        0xaf,0xb9,
        0xb0,0xd4,
        0xb1,0xc3,
        0xb2,0x55,
        0xb3,0xd8,
        0xb4,0xce,
        0xb5,0x00,
        0xb6,0x00,
        0xb7,0x05,
        0xb8,0xd6,
        0xb9,0x8c,
        0xfe,0x01,
        0xd0,0x40,
        0xd1,0xf8,
        0xd2,0x00,
        0xd3,0xfa,
        0xd4,0x45,
        0xd5,0x02,
        0xd6,0x30,
        0xd7,0xfa,
        0xd8,0x08,
        0xd9,0x08,
        0xda,0x58,
        0xdb,0x02,
        0xfe,0x00,
        0xfe,0x00,
        0xba,0x00,
        0xbb,0x04,
        0xbc,0x0a,
        0xbd,0x0e,
        0xbe,0x22,
        0xbf,0x30,
        0xc0,0x3d,
        0xc1,0x4a,
        0xc2,0x5d,
        0xc3,0x6b,
        0xc4,0x7a,
        0xc5,0x85,
        0xc6,0x90,
        0xc7,0xa5,
        0xc8,0xb5,
        0xc9,0xc2,
        0xca,0xcc,
        0xcb,0xd5,
        0xcc,0xde,
        0xcd,0xea,
        0xce,0xf5,
        0xcf,0xff,
        0xfe,0x00,
        0x5a,0x08,
        0x5b,0x0f,
        0x5c,0x15,
        0x5d,0x1c,
        0x5e,0x28,
        0x5f,0x36,
        0x60,0x45,
        0x61,0x51,
        0x62,0x6a,
        0x63,0x7d,
        0x64,0x8d,
        0x65,0x98,
        0x66,0xa2,
        0x67,0xb5,
        0x68,0xc3,
        0x69,0xcd,
        0x6a,0xd4,
        0x6b,0xdc,
        0x6c,0xe3,
        0x6d,0xf0,
        0x6e,0xf9,
        0x6f,0xff,
        0xfe,0x00,
        0x70,0x50,
        0xfe,0x00,
        0x4f,0x01,
        0xfe,0x01,
        0x44,0x04,
        0x1f,0x30,
        0x20,0x40,
        0x26,0x9a,
        0x27,0x02,
        0x28,0x0d,
        0x29,0x02,
        0x2a,0x0d,
        0x2b,0x02,
        0x2c,0x58,
        0x2d,0x07,
        0x2e,0xd2,
        0x2f,0x0b,
        0x30,0x6e,
        0x31,0x0e,
        0x32,0x70,
        0x33,0x12,
        0x34,0x0c,
        0x3c,0x20,
        0x3e,0x20,
        0x3f,0x2d,
        0x40,0x40,
        0x41,0x5b,
        0x42,0x82,
        0x43,0xb7,
        0x04,0x0a,
        0x02,0x79,
        0x03,0xc0,
        0xcc,0x08,
        0xcd,0x08,
        0xce,0xa4,
        0xcf,0xec,
        0xfe,0x00,
        0x81,0xb8,
        0x82,0x12,
        0x83,0x0a,
        0x84,0x01,
        0x86,0x25,
        0x87,0x18,
        0x88,0x10,
        0x89,0x70,
        0x8a,0x20,
        0x8b,0x10,
        0x8c,0x08,
        0x8d,0x0a,
        0xfe,0x00,
        0x8f,0xaa,
        0x90,0x9c,
        0x91,0x52,
        0x92,0x03,
        0x93,0x03,
        0x94,0x08,
        0x95,0x44,
        0x97,0x00,
        0x98,0x00,
        0xfe,0x00,
        0xa1,0x30,
        0xa2,0x41,
        0xa4,0x30,
        0xa5,0x20,
        0xaa,0x30,
        0xac,0x32,
        0xfe,0x00,
        0xd1,0x3c,
        0xd2,0x3c,
        0xd3,0x38,
        0xd6,0xf4,
        0xd7,0x1d,
        0xdd,0x73,
        0xde,0x84,
        0xfe,0x01,
        0x13,0x20,
        0xfe,0x00,
        0x4f,0x00,
        0x03,0x00,
        0x04,0xa0,
        0x71,0x60,
        0x72,0x40,
        0x42,0x80,
        0x77,0x64,
        0x78,0x40,
        0x79,0x60,
        0xfe,0x00,
        0x44,0x90,	--输出灰度
        0x46,0x0f,
	}
}

--注册摄像头事件回调
local tick_scan = 0
camera.on(0, "scanned", function(id, str)
    if type(str) == 'string' then
        log.info("扫码结果", str)
        -- air105每次扫码仅需200ms, 当目标一维码或二维码持续被识别, 本函数会反复触发
        -- 鉴于某些场景需要间隔时间输出, 下列代码就是演示间隔输出
        -- if mcu.ticks() - tick < 1000 then
        --     return
        -- end
        -- tick_scan = mcu.ticks()
        -- 输出内容可以经过加工后输出, 例如带上换行(回车键)
        usbapp.vhid_upload(0, str.."\r\n")
    end
end)

local camera_pwdn = gpio.setup(pin.PD06, 1, gpio.PULLUP) -- PD06 camera_pwdn引脚
local camera_rst = gpio.setup(pin.PD07, 1, gpio.PULLUP) -- PD07 camera_rst引脚

usbapp.start(0)

sys.taskInit(function()
    camera_rst(0)
    local camera_id = camera.init(GC032A_InitReg_Gray)--屏幕输出灰度图像并扫码
    
    log.info("摄像头启动")
    camera.start(camera_id)--开始指定的camera
end)

-- 用户代码已结束---------------------------------------------
-- 结尾总是这一句
sys.run()
-- sys.run()之后后面不要加任何语句!!!!!
