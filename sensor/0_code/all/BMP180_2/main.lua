PROJECT = "BMP180"
VERSION = "1.0.0"

_G.sys = require("sys")

-- 加载I²C功能测试模块
require ("BMP180")

sys.taskInit(function()
    -- ps:有wait不能放在外面

    BMP180_test()
    -- sys.wait(1500)

    while 1 do
        
        sys.wait(100)
    end
end)

sys.run()
