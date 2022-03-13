
-- LuaTools需要PROJECT和VERSION这两个信息
PROJECT = "gpio2demo"
VERSION = "1.0.0"

log.info("main", PROJECT, VERSION)

-- sys库是标配
_G.sys = require("sys")

if wdt then
    --添加硬狗防止程序卡死，在支持的设备上启用这个功能
    wdt.init(15000)--初始化watchdog设置为15s
    sys.timerLoopStart(wdt.feed, 10000)--10s喂一次狗
end

--配置gpio7为输入模式，下拉，并会触发中断
--请根据实际需求更改gpio编号和上下拉
-- a=0
-- function hw_delay()
--     for i=1,1000,1 do
--         -- print(i)
--         a=a+1
--     end
-- end

-- t=0
-- gpio.setup(13, function()
--     log.info("gpio", "IO13",t)
--     t=t+1
--     hw_delay()
--     -- gpio.setup(13,1)
--     -- sys.wait(100)
--     -- gpio.setup(13,1)
--     -- sys.wait(1000)
-- end, gpio.PULLDOWN)

function key5_init()
    gpio.setup(0, nil)  -- mod
    gpio.setup(1, nil)  -- right
    gpio.setup(12, nil) -- left
    gpio.setup(18, nil) -- down
    gpio.setup(19, nil) -- up
    gpio.setup(13, nil)
end


num = 0
function judge_key5()
    local a = 0
    a= gpio.get(13)
    -- print(a)

    if a == 1 then
        print("mod")
        num = num+1
        print(num)
        sys.wait(500)
    end
    -- if gpio.get(1) == 1 then
    --     print("right")
    --     sys.wait(200)
    -- end
    -- if gpio.get(12) == 1 then
    --     print("left")
    --     sys.wait(200)
    -- end
    -- if gpio.get(18) == 1 then
    --     print("down")
    --     sys.wait(200)
    -- end
    -- if gpio.get(19) == 1 then
    --     print("up")
    --     sys.wait(200)
    -- end
end

a= 0
sys.taskInit(function()

    key5_init()

    while 1 do

        judge_key5()
        -- -- gpio.setup(13, 0)
        -- a = gpio.get(13)
        -- -- print("a",a)
        -- if a == 1 then
        --     print("key down")
        --     sys.wait(200)
        --     a = 0
        -- end

        sys.wait(10)
        -- sys.wait(500)
    end
end)
-- 用户代码已结束---------------------------------------------
-- 结尾总是这一句
sys.run()
-- sys.run()之后后面不要加任何语句!!!!!
