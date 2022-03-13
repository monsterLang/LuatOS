
-- LuaTools需要PROJECT和VERSION这两个信息
PROJECT = "fsdemo"
VERSION = "1.0.0"

log.info("main", PROJECT, VERSION)

-- sys库是标配
_G.sys = require("sys")
require("t4_fs_info")


--添加硬狗防止程序卡死
wdt.init(15000)--初始化watchdog设置为15s
sys.timerLoopStart(wdt.feed, 10000)--10s喂一次狗

get_fs_info()

sys.taskInit(function()

    -- 每次开机,把记录的数值+1
    fs_test()

    t4_fs_root_write()

    while 1 do
        sys.wait(500)
    end
end)

-- 用户代码已结束---------------------------------------------
-- 结尾总是这一句
sys.run()
-- sys.run()之后后面不要加任何语句!!!!!
