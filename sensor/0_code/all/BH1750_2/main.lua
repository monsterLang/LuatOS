--必须在这个位置定义PROJECT和VERSION变量
--PROJECT：ascii string类型，可以随便定义，只要不使用,就行
--VERSION：ascii string类型，如果使用Luat物联云平台固件升级的功能，必须按照"X.X.X"定义，X表示1位数字；否则可随便定义
PROJECT = "BH1750"
VERSION = "1.0.0"

_G.sys = require("sys")

-- 加载I²C功能测试模块
require("bh1750")



sys.taskInit(function()
    -- ps:有wait不能放在外面
    bh1750_test()

    while 1 do
        

        sys.wait(1000)
    end
end)

sys.run()

