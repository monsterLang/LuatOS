
-- LuaTools需要PROJECT和VERSION这两个信息
PROJECT = "fatfsdemo"
VERSION = "1.0.0"

log.info("main", PROJECT, VERSION)

-- sys库是标配
_G.sys = require("sys")
require("t4_fs_fatfs")

--添加硬狗防止程序卡死
wdt.init(15000)--初始化watchdog设置为15s
sys.timerLoopStart(wdt.feed, 10000)--10s喂一次狗

-- fatfs_105()

sys.taskInit(function()
    -- fatfs_test()
    -- sfud_105()
    print("fatfs_105_test")
    fatfs_105_test()

    print("sdio_105_test")
    -- sdio_105_test()

    print("sfud_105")
    -- sfud_105_spi2()   -- 提示不支持JEDEC SFDP
    -- sfud_105_hspi()
    sfud_105(2)

    while 1 do
        sys.wait(500)
    end
end)

-- 用户代码已结束---------------------------------------------
-- 结尾总是这一句
sys.run()
-- sys.run()之后后面不要加任何语句!!!!!
