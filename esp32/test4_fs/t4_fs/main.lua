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



tag = "fsTest"

function fsTest()
    if fs == nil then
        log.error(tag, "this fireware is not support fs")
        return
    end
    log.info(tag, "START")
    log.info(tag .. ".fsstat:", fs.fsstat())
    log.info(tag .. ".fsstat:/", fs.fsstat("/"))
    log.info(tag .. ".fsstat:/luadb/", fs.fsstat("/luadb/"))
    log.info(tag .. ".fsize:/luadb/code.png", fs.fsize("/luadb/code.png"))
    log.info(tag .. ".fsstat:/luadb/main.luac", fs.fsstat("/luadb/main.luac"))
    log.info(tag .. ".fsstat:/luadb/main.lua", fs.fsstat("/luadb/main.lua"))

    -- names = io.lsdir("/ldata/")
    -- log.info("dir",names)
    -- log.info(tag .. ".fsize", fs.fsize("/luadb/main.luac"))
    log.info(tag, "DONE")
end

--添加硬狗防止程序卡死
-- wdt.init(15000)--初始化watchdog设置为15s
-- sys.timerLoopStart(wdt.feed, 10000)--10s喂一次狗

-- ================main start================
sys.taskInit(function()
    fsTest()
    while 1 do
        sys.wait(1000)

    end
end)
-- ================main end==================

sys.run()


