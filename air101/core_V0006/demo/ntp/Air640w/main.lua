-- LuaTools需要PROJECT和VERSION这两个信息
PROJECT = "ntpdemo"
VERSION = "1.0.0"

-- 引入必要的库文件(lua编写), 内部库不需要require
local sys = require "sys"

sys.subscribe("WLAN_READY", function ()
    print("!!! wlan ready event !!!")
end)

sys.taskInit(function()
    wlan.setMode("wlan0", wlan.STATION)
    wlan.connect("uiot", "12345678")
    print("wait for WLAN_READY")
    sys.waitUntil("WLAN_READY", 30000)
    if wlan.ready() then
        socket.ntpSync()
        print(os.date())
        while 1 do
            print("prepare ds18b20 ...", os.date())
            local temp = (sensor.ds18b20(28) or "")
            print("TEMP: " .. temp)
            local t = {"GET /api/w60x/report/ds18b20?mac=", wlan.get_mac(), "&temp=", temp, " HTTP/1.0\r\n",
                    "Host: site0.cn\r\n",
                    "User-Agent: LuatOS/0.1.0\r\n",
                        "\r\n"}
            --local data = table.concat(t)
            --print(data)
            socket.tsend("site0.cn", 80, table.concat(t))
            print("tsend complete, sleep 30s")
            sys.wait(30*1000)
        end
    else
        print("wlan NOT ready!!!!")
    end
end)

-- 用户代码已结束---------------------------------------------
-- 结尾总是这一句
sys.run()
-- sys.run()之后后面不要加任何语句!!!!!
