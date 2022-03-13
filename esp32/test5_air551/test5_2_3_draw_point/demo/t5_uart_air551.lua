
-- uartid = 1 -- 根据实际设备选取不同的uartid

-- --初始化
-- local result = uart.setup(
--     uartid,--串口id
--     115200,--波特率
--     8,--数据位
--     1--停止位
-- )

-- require("t5_change_draw")

tag_uart = "test5_uart"

id = 1
len = 1024

get_gga_time = 2000

data_time = ""
data_longitude = ""     -- 经度
data_latitude = ""      -- 纬度
data_GGA = ""
data_GGA_status = ""
GGA_list = {}
GGA_list["time"] = data_time
GGA_list["x"] = data_longitude
GGA_list["y"] = data_latitude
GGA_list["status"]= data_GGA_status

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

    init_air551G_cont()
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
    log.info("uart_air551_receive start---------------")
    local s = ""
    s = uart.read(id, len)
    if #s > 0 then -- #s 是取字符串的长度
        -- 如果传输二进制/十六进制数据, 部分字符不可见, 不代表没收到
        -- 关于收发hex值,请查阅 https://doc.openluat.com/article/583
        -- log.info("uart", "receive", id, #s, s)   -- 这句将接收的都打印出来
        log.info("get air551","uart", "receive", id, #s)
        -- log.info("uart", "receive", id, #s, s:toHex())
    end

    data_GGA = get_gga(s)
    log.info("data_GGA",data_GGA)

    get_gga_longitude_latitude(data_GGA)
    log.info("uart_air551_receive end---------------")
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
    temp_start = string.find(value,'GGA',1)-3
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

    -- 获取GGA数据
    -- log.info("L2_temp",L2_temp)
    L2_temp = string.sub(value_gga,8)   -- +8是因为"$gngga"

    -- 获取时间
    data_time_h = string.sub(L2_temp,1,2)
    data_time_m = string.sub(L2_temp,3,4)
    data_time_s = string.sub(L2_temp,4,5)
    -- data_time_h = string.t(data_time_h)

    data_time_h = math.floor(data_time_h +8)
    -- log.info(type(data_time_h),data_time_h)
    if data_time_h >= 24 then
        data_time_h = data_time_h -24 
    end
    -- data_time_h = tostring(data_time_h)
    if data_time_h <10 then
        data_time_h = '0'..data_time_h
    end
    -- log.info(type(data_time_h),data_time_h)
    -- data_time_h = tostring(data_time_h)
    -- data_time_h = string.(8 + string.toValue(data_time_h))
    data_time = data_time_h..":"..data_time_m..":"..data_time_s

    -- 获取纬度
    L2_temp_x_start = string.find(L2_temp,',',1)+1
    L2_temp_x_end = string.find(L2_temp,',N',1)-1
    data_longitude = string.sub(L2_temp,L2_temp_x_start,L2_temp_x_end)

    -- 获取经度
    L2_temp_y_start = L2_temp_x_end+4
    -- +4是因为"time,xxx,N,yyy,E",",N"后面三个才是y开始
    L2_temp_y_end = string.find(L2_temp,',E',1)-1
    data_latitude = string.sub(L2_temp,L2_temp_y_start,L2_temp_y_end)
    -- log.info("L2_temp_gga",data_longitude,data_latitude)
    -- log.info("temp_value:",temp_start,temp_end,temp_gga)

    -- 获取定位指示",E,定位指示,"
    L2_temp_status_start = L2_temp_y_end + 4
    L2_temp_status_end = L2_temp_status_start 
    data_GGA_status = string.sub(L2_temp,L2_temp_status_start,L2_temp_status_end)

    -- log.info("data_GGA_status",data_GGA_status)

    if data_GGA_status == "0" then
        log.info("定位指示为0,未定位")
    elseif data_GGA_status == "1" then
        log.info("定位指示为1,SPS 模式,定位有效")
        GGA_ok()
    elseif data_GGA_status == "2" then
        log.info("定位指示为2,差分,SPS 模式,定位有效")
    end

    GGA_list["time"] = data_time
    GGA_list["x"] = data_longitude
    GGA_list["y"] = data_latitude
    GGA_list["status"]= data_GGA_status

    -- 显示当前状态
    -- set_air551G_cont()

    -- 转换为dd.dddd
    GGA_ok()

    return temp_gga
end

function init_air551G_cont()
    air551G_cont = lvgl.cont_create(lvgl.scr_act(), nil)
    lvgl.obj_set_size(air551G_cont,128,160)
    lvgl.obj_set_auto_realign(air551G_cont, true) 
    lvgl.obj_align_origo(air551G_cont, nil, lvgl.ALIGN_CENTER, 0, 0)
    lvgl.cont_set_fit(air551G_cont, lvgl.FIT_NONE)   --此时cont未设置自适应状态，则内容在cont中
    lvgl.cont_set_layout(air551G_cont, lvgl.LAYOUT_COLUMN_LEFT) --布局靠左
    --}

    log.info("scr_load",lvgl.scr_load(air551G_cont))     --显示   容器

    --创建标签label
    GGA_label = lvgl.label_create(air551G_cont, nil)
    lvgl.label_set_text(GGA_label, "GGA_data")
    lvgl.obj_set_pos(GGA_label, 2, 5)

    -- -- 分开数据
    -- GGA_status_label = lvgl.label_create(air551G_cont, nil)
    -- lvgl.label_set_text(GGA_status_label, "status"..data_GGA_status)
    -- lvgl.obj_set_pos(GGA_status_label, 2, 5)

    -- sys.wait(500)

    -- GGA_x_label = lvgl.label_create(air551G_cont, nil)
    -- lvgl.label_set_text(GGA_x_label, "longitude"..data_longitude)
    -- lvgl.obj_set_pos(GGA_x_label, 2, 25)

    -- sys.wait(500)

    -- GGA_y_label = lvgl.label_create(air551G_cont, nil)
    -- lvgl.label_set_text(GGA_y_label, "latitude"..data_latitude)
    -- lvgl.obj_set_pos(GGA_y_label, 2, 35)
end

function set_air551G_cont()
    -- lvgl.label_set_text(GGA_status_label, "status"..data_GGA_status)
    -- lvgl.label_set_text(GGA_x_label, "longitude"..data_longitude)
    -- lvgl.label_set_text(GGA_y_label, "latitude"..data_latitude)

    -- lvgl.label_set_text(GGA_status_label, "status: "..data_GGA_status)
    -- lvgl.label_set_text(GGA_x_label, "x: "..data_longitude)
    -- lvgl.label_set_text(GGA_y_label, "y: "..data_latitude)

    string_GGA = "GGA_data"..'\r'.."time: "..GGA_list["time"]..'\r'.."x: "..GGA_list["x"]..'\r'.."y: "..GGA_list["y"]..'\r'.."status: "..GGA_list["status"]

    log.info("string_GGA",string_GGA)

    if string_GGA == "" then
        return -1
    end
    lvgl.label_set_text(GGA_label, string_GGA)

end


lng_ddmmmm = "3114.474413632" --经度 x 与赤道垂直
lat_ddmmmm = "12128.43953236" --维度 y 与赤道平行

function ddmmmm2dd(a,b)

    -- temp_dd_lng = string.format("%.10f", lng_ddmmmm)  -- 字符转浮点
    -- print("temp: ",temp_dd_lng)
    -- local dd_lng_int = math.floor(temp_dd_lng/100.0)
    -- local dd_lng_float = (temp_dd_lng-dd_lng_int*100.0)*100.0/60.0
    -- local dd_lng = dd_lng_int + dd_lng_float/100.0
    -- print("dd_lng = ",dd_lng_int,dd_lng_float,dd_lng)
    
    -- temp_dd_lat = string.format("%.10f", lat_ddmmmm)  -- 字符转浮点
    -- print("temp: ",temp_dd_lat)
    -- local dd_lat_int = math.floor(temp_dd_lat/100.0)
    -- local dd_lat_float = (temp_dd_lat-dd_lat_int*100.0)*100.0/60.0
    -- local dd_lat = dd_lat_int + dd_lat_float/100.0
    -- print("dd_lat = ",dd_lat_int,dd_lat_float,dd_lat)

    -- 小数点
    -- temp_dd_lng = string.format("%.10f", lng_ddmmmm)  -- 字符转浮点
    -- print("temp: ",temp_dd_lng)
    -- local dd_lng_int = math.floor(temp_dd_lng/100.0000000)
    -- print("temp: ",temp_dd_lng)
    -- local dd_lng_float = (temp_dd_lng-dd_lng_int*100.0000000)*100.0000000/60.0000000
    -- local dd_lng = dd_lng_int + dd_lng_float/100.0000000
    -- print("dd_lng = ",dd_lng_int,dd_lng_float,dd_lng)
    
    -- temp_dd_lat = string.format("%.10f", lat_ddmmmm)  -- 字符转浮点
    -- print("temp: ",temp_dd_lat)
    -- local dd_lat_int = math.floor(temp_dd_lat/100.0000000)
    -- local dd_lat_float = (temp_dd_lat-dd_lat_int*100.0000000)*100.0000000/60.0000000
    -- local dd_lat = dd_lat_int + dd_lat_float/100.0000000
    -- print("dd_lat = ",dd_lat_int,dd_lat_float,dd_lat)

    -- 计算失败
    -- temp_dd_lng = string.format("%.10f", a)  -- 字符转浮点
    temp_dd_lng = string.format("%.10f", lng_ddmmmm)  -- 字符转浮点
    print("temp: ",temp_dd_lng)
    local dd_lng_int = math.floor(temp_dd_lng/100)
    local dd_lng_float = (temp_dd_lng-dd_lng_int*100)*100/60
    local dd_lng = dd_lng_int + dd_lng_float/100
    print("dd_lng = ",dd_lng_int,dd_lng_float,dd_lng)

    -- temp_dd_lat = string.format("%.10f", b)  -- 字符转浮点
    temp_dd_lat = string.format("%.10f", lat_ddmmmm)  -- 字符转浮点
    print("temp: ",temp_dd_lat)
    local dd_lat_int = math.floor(temp_dd_lat/100)
    local dd_lat_float = (temp_dd_lat-dd_lat_int*100)*100/60
    local dd_lat = dd_lat_int + dd_lat_float/100
    print("dd_lat = ",dd_lat_int,dd_lat_float,dd_lat)

    return dd_lng,dd_lat
end

-- ddmmmm2dd(lng_ddmmmm,lat_ddmmmm)

-- GGA_list["x"] = data_longitude
-- GGA_list["y"] = data_latitude
function GGA_ok()
    temp_lng,temp_lat = ddmmmm2dd(GGA_list["x"],GGA_list["y"])
    
end

-- GGA_list["time"] = data_time
-- GGA_list["x"] = data_longitude
-- GGA_list["y"] = data_latitude
-- GGA_list["status"]= data_GGA_status

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
