--- 模块功能：gsensor- esp32_mpu6050
-- @module mpu6050
-- @author youkai
-- @release 2022.01.23

-- LuaTools需要PROJECT和VERSION这两个信息
PROJECT = "esp32_fs"
VERSION = "1.0.0"

log.info("main", PROJECT, VERSION)

-- sys库是标配
_G.sys = require("sys")
require("t4_fs_info")
require("t4_fs_sdcard_spi")

--添加硬狗防止程序卡死
-- wdt.init(15000)--初始化watchdog设置为15s
-- sys.timerLoopStart(wdt.feed, 10000)--10s喂一次狗

-- fs_test_boottime()

T4_fs_info = 0
T4_fs_luadb_rw = 0

T4_fs_sdcard_spi = 1




if T4_fs_luadb_rw == 1 then
    -- fs_info()

    -- demo_fs_mkdir() --接口未完成

    fs_read_txt("/luadb/boot_time.txt")

    -- fs_write_txt("/test_write.txt")

    -- fs_read_txt("/test_write.txt")
end


-- ================main start================
sys.taskInit(function()

    if T4_fs_sdcard_spi == 1 then
        t4_fs_sdcard() 
    end
    
    if T4_fs_info == 1 then
        fs_info()
    end
    while 1 do
        -- fs_test_boottime()
        sys.wait(1000)

    end
end)
-- ================main end==================

sys.run()


