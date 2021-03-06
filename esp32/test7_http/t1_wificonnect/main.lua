PROJECT = "wifidemo"
VERSION = "1.0.0"

-- 引入必要的库文件(lua编写), 内部库不需要require
local sys = require "sys"

log.info("main", "ask for help", "https://wiki.luatos.com")

wifi_name = "LangZhao"
wifi_passwd = "19971226"

sys.taskInit(
    function()
        log.info("wlan", "wlan_init:", wlan.init())

        wlan.setMode(wlan.STATION)
        wlan.connect(wifi_name, wifi_passwd)

        -- 参数已配置完成，后台将自动开始连接wifi
        result, _ = sys.waitUntil("WLAN_READY")
        log.info("wlan", "WLAN_READY", result)
        -- 等待连上路由,此时还没获取到ip
        result, _ = sys.waitUntil("WLAN_STA_CONNECTED")
        log.info("wlan", "WLAN_STA_CONNECTED", result)
        -- 等到成功获取ip就代表连上局域网了
        result, data = sys.waitUntil("IP_READY")
        log.info("wlan", "IP_READY", result, data)

        while true do
            --local httpc = esphttp.init(esphttp.GET, "http://httpbin.org/get")
            local httpc = esphttp.init(esphttp.GET, "https://httpbin.org/get")
            if httpc then
                local ok, err = esphttp.perform(httpc, true)
                if ok then
                    while 1 do
                        local result, c, ret, data = sys.waitUntil("ESPHTTP_EVT", 20000)
                        log.info("httpc", result, c, ret)
                        if c == httpc then
                            if esphttp.is_done(httpc, ret) then
                                break
                            end
                            if ret == esphttp.EVENT_ON_DATA and esphttp.status_code(httpc) == 200 then
                                log.info("data", "resp", data)
                            end
                        end
                    end
                else
                    log.warn("esphttp", "bad perform", err)
                end
                esphttp.cleanup(httpc)
            end
            sys.wait(5000)
        end
    end
)
-- 用户代码已结束---------------------------------------------
-- 结尾总是这一句
sys.run()
-- sys.run()之后后面不要加任何语句!!!!!
