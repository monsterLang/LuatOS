
-- uartid = 1 -- 根据实际设备选取不同的uartid

-- --初始化
-- local result = uart.setup(
--     uartid,--串口id
--     115200,--波特率
--     8,--数据位
--     1--停止位
-- )
tag_uart = "test5_uart"

id = 1
len = 1024

get_gga_time = 10000

date_longitude = ""     -- 经度
date_latitude = ""      -- 纬度
date_GGA = ""


function init_uart_air551()
    -- uart.on(1, "recv", function(id, len)
    --     local data = uart.read(1, 1024)
    --     log.info("uart2", data)
    --     -- libgnss.parse(data)
    -- end)
    log.info(tag_uart,"init_uart_air551")
    uart.setup(1, 115200)

    uart_air551_NMEA_set()
    -- 定时发送数据
    -- timex = sys.timerLoopStart(uart_air551_send,1000)
    -- log.info(tag_uart,"time:",timex)

    sys.wait(1000)

    -- func1: 接收数据，只要收到就接收
    -- uart.on(id, "receive",uart_air551_receive)

    -- func2: 定时接收
    timex = sys.timerLoopStart(uart_air551_receive,get_gga_time)
    log.info(tag_uart,"time:",timex)

end

function uart_air551_send()
    -- log.info("uart_air551_send")
    uart.write(id, "test")
end

-- 下发命令
function uart_air551_NMEA_set()
    log.info("uart_air551_NMEA_set")
    uart.write(id, "$PGKC242,0,0,0,1*2A\r\n")       --只接收GGA数据。注意需要传入回车符
end

-- 获取串口数据
function uart_air551_receive()
    log.info("uart_air551_receive")
    local s = ""
    s = uart.read(id, len)
    if #s > 0 then -- #s 是取字符串的长度
        -- 如果传输二进制/十六进制数据, 部分字符不可见, 不代表没收到
        -- 关于收发hex值,请查阅 https://doc.openluat.com/article/583
        -- log.info("uart", "receive", id, #s, s)   -- 这句将接收的都打印出来
        log.info("get air551","uart", "receive", id, #s)
        -- log.info("uart", "receive", id, #s, s:toHex())
    end

    date_GGA = get_gga(s)
    log.info("date_GGA",date_GGA)

    get_gga_longitude_latitude(date_GGA)
end

--测试数据提取
function test_string_get()
    string_temp = "xxxxx$GNGGA,000004.811,XXX,N,XXX,E,0,0,,143.01,M,6.99,M,,*6D\r$GNGGA,000003.811,*6A"
    temp_start = string.find(string_temp,'$GNGGA',1)
    temp_end = string.find(string_temp,'\r',1)
    temp_gga = string.sub(string_temp,temp_start,temp_end-1)
    log.info("temp_x:",temp_start,temp_end,temp_gga)
end

-- 提取一组数据
function get_gga(value)
    temp_start = string.find(value,'$GNGGA',1)
    temp_end = string.find(value,'\r',1)
    temp_gga = string.sub(value,temp_start,temp_end-1)
    -- log.info("temp_value:",temp_start,temp_end,temp_gga)
    return temp_gga
end

function get_gga_longitude_latitude(value_gga)
    -- log.info(type(value_gga))
    if value_gga == "" then     --数据第一次异常
        return -1
    end
    L2_temp = string.sub(value_gga,8)   -- +8是因为"$gngga"
    log.info("L2_temp",L2_temp)
    L2_temp_x_start = string.find(L2_temp,',',1)+1
    L2_temp_x_end = string.find(L2_temp,',N',1)-1

    date_longitude = string.sub(L2_temp,L2_temp_x_start,L2_temp_x_end)

    L2_temp_y_start = L2_temp_x_end+4
    -- +4是因为"time,xxx,N,yyy,E",",N"后面三个才是y开始
    L2_temp_y_end = string.find(L2_temp,',E',1)-1
    date_latitude = string.sub(L2_temp,L2_temp_y_start,L2_temp_y_end)     
    log.info("L2_temp_gga",date_longitude,date_latitude)
    -- log.info("temp_value:",temp_start,temp_end,temp_gga)
    return temp_gga
end

-- sys.timerLoopStart(uart.write,1000, uartid, "test")
-- -- 收取数据会触发回调, 这里的"receive" 是固定值
-- uart.on(uartid, "receive", function(id, len)
--     local s = ""
--     repeat
--         -- 如果是air302, len不可信, 传1024
--         -- s = uart.read(id, 1024)
--         s = uart.read(id, len)
--         if #s > 0 then -- #s 是取字符串的长度
--             -- 如果传输二进制/十六进制数据, 部分字符不可见, 不代表没收到
--             -- 关于收发hex值,请查阅 https://doc.openluat.com/article/583
--             log.info("uart", "receive", id, #s, s)
--             -- log.info("uart", "receive", id, #s, s:toHex())
--         end
--     until s == ""
-- end)


-- -- LuaTools需要PROJECT和VERSION这两个信息
-- PROJECT = "uart_irq"
-- VERSION = "1.0.0"

-- log.info("main", PROJECT, VERSION)

-- -- 引入必要的库文件(lua编写), 内部库不需要require
-- local sys = require "sys"

-- if wdt then
--     --添加硬狗防止程序卡死，在支持的设备上启用这个功能
--     wdt.init(15000)--初始化watchdog设置为15s
--     sys.timerLoopStart(wdt.feed, 10000)--10s喂一次狗
-- end

-- log.info("main", "uart demo")

-- local uartid = 1 -- 根据实际设备选取不同的uartid

-- --初始化
-- local result = uart.setup(
--     uartid,--串口id
--     115200,--波特率
--     8,--数据位
--     1--停止位
-- )


-- --循环发数据
-- sys.timerLoopStart(uart.write,1000, uartid, "test")
-- -- 收取数据会触发回调, 这里的"receive" 是固定值
-- uart.on(uartid, "receive", function(id, len)
--     local s = ""
--     repeat
--         -- 如果是air302, len不可信, 传1024
--         -- s = uart.read(id, 1024)
--         s = uart.read(id, len)
--         if #s > 0 then -- #s 是取字符串的长度
--             -- 如果传输二进制/十六进制数据, 部分字符不可见, 不代表没收到
--             -- 关于收发hex值,请查阅 https://doc.openluat.com/article/583
--             log.info("uart", "receive", id, #s, s)
--             -- log.info("uart", "receive", id, #s, s:toHex())
--         end
--     until s == ""
-- end)

-- -- 并非所有设备都支持sent事件
-- uart.on(uartid, "sent", function(id)
--     log.info("uart", "sent", id)
-- end)

-- -- sys.taskInit(function()
-- --     while 1 do
-- --         sys.wait(500)
-- --     end
-- -- end)


-- -- 用户代码已结束---------------------------------------------
-- -- 结尾总是这一句
-- sys.run()
-- -- sys.run()之后后面不要加任何语句!!!!!
