PROJECT = "sensor"
VERSION = "1.0.0"


_G.sys = require("sys")

require("sen_BH1750")       -- 光感
require("sen_TCS34725")     -- 色彩
require("sen_BMP180")       -- 气压
require("sen_GY271")        -- 磁感应强度
require("t1_display")
require("t2_lvgl_demo")

-- 加载I²C功能测试模块
T1_BH1750 = 0
T2_TCS34725 = 0
T3_BMP180 = 0
T4_GY271 = 1

-- i2c ID
esp32_i2c_id = 0        -- esp32只支持一路i2c, id为0
esp32_spi_id = 2        -- esp32只支持一路spi, id为2

-- i2c 速率
esp32_i2c_speed = i2c.SLOW -- 100000

-- 初始化屏幕
init_esp32_st7735()


sys.taskInit(function()
    -- ps:有wait不能放在外面

    if T2_TCS34725 == 1 then
        TCS34725_init(esp32_i2c_id,esp32_i2c_speed) -- TCS34725地址默认为0x29
    end
    
    if T1_BH1750 == 1 then
        BH1750_init(esp32_i2c_id)
    end

    if T3_BMP180 == 1 then
        -- BMP180_test(esp32_i2c_id)
        BMP180_init(esp32_i2c_id)
    end

    if T4_GY271 == 1 then
        
        hmc5883l_test()
    end


    -- sys.wait(1500)

    while 1 do
        
        if T1_BH1750 == 1 then
            BH1750_get()
        end

        if T2_TCS34725 == 1 then
            TCS34725_get() -- TCS34725地址默认为0x29
        end

        if T3_BMP180 == 1 then
            -- BMP180_test(esp32_i2c_id)
            BMP180_get_temp_press()
        end

        sys.wait(100)
    end
end)

sys.run()
