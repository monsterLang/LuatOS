PROJECT = "socket"
VERSION = "1.0.0"

-- 一定要添加sys.lua !!!!
sys = require "sys"

require("ws_data")
require("esp32_st7735")     --setup lcd
require("mpu6xxx_nolocal")  --setup mpu6050
require("lvgl_demo")
require("mpucont")
require("mpu_event")

require("sen_BH1750")       -- 光感




-- data_send_fin=0
-- data_send_fin=0x80 | 0x01
-- print("fin:",data_send_fin)
-- data_send_fin=string.char(data_send_fin)
-- print("fin:",data_send_fin)
-- -- print(data_send)
-- table.insert(msg_data_send,data_send_fin)
-- data_send_len= 0
-- msg_len=4
-- data_send_len=msg_len | 0x80    --0x80为mask标志位，表示发送
-- print("len",msg_len, data_send_len)
-- -- data_send_len=string.char(data_send_len)
-- -- print("len",data_send_len)
-- table.insert(msg_data_send,data_send_len)
-- print("fin & head",msg_data_send[1],string.char(msg_data_send[2]))
-- print(table.concat(msg_data_send))
-- print(type(msg_data_send[1]),type(msg_data_send[2]))

T1_MPU = 1
T2_WS = 1
T3_BH1750 = 1

-- func1: mpu
T1_mpu_bar = 1
T2_mpu_trigger_event = 1
function mpu_event_judge()
    -- mpu6050 value display{
    temp_a = get_mpu6xxx_value()    -- 获取mpu6050的值

    -- func1: 显示当前数值
    if T1_mpu_bar == 1 then
        display_mpu_value()     -- 绘制三个bar，同时显示当前xyz的参考值（百分比）
    end
    -- }

    if T2_mpu_trigger_event == 1 then
        save_mpu_temp_value()
        -- log.info("test")
        judge_status()          -- 如果xy数值超过限制，则触发上下左右四个事件。
    end

    sys.wait(10)
end

-- func2: websocket
-- send websocket msg

flag_send = true
flag_recv = true
temp_msg_send_a = "aaaa"

function judge_sr_status()
    if flag_send == true then
        
        ws_send(temp_msg_send_a)
        -- print(">>send:",temp_msg_send)
        flag_send = false
        flag_recv = true
    end

    if flag_recv == true then
        temp_data_recv = ws_recv(websocket_client)
        
        if temp_data_recv ~= nil then
            flag_recv = false
            -- print("<<<<<<<<< ws recv <<<<<<<<<<<<<<")
            print("<<recv:","[",temp_data_recv,"]")
            -- print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
        end
    end
    sys.wait(100)
end

-- func3 light sensor
-- 加载I²C功能测试模块

-- i2c ID
esp32_i2c_id = 0        -- esp32只支持一路i2c, id为0

-- i2c 速率
esp32_i2c_speed = i2c.SLOW -- 100000

function func_mpu_init()
    -- mpu6050 value display{
        init_mpu6050()      -- 初始化三轴传感器

        -- func1: 创建cont存放bar，用于显示当前数值
        if T1_mpu_bar == 1 then
            init_mpu6050_cont()
            init_bar_xyz()
        end
    --}

    -- func1: create temp label to display font
    if T2_mpu_trigger_event == 1 then
        init_event_label()
    end
    sys.wait(1500)
end

function start_send_msg()
    flag_send = true
    
    -- temp_msg_send = table.concat(keyboard_value)
    -- print("keyboard_value",temp_msg_send)
    -- keyboard_value = {}
    temp_msg_send_a = "aa"
end


-- main
sys.taskInit(
    function ()
        -- ----------------setup start----------------------
        -- 初始化屏幕
        init_esp32_st7735 ()
        init_lvgl()
        -- ----------------setup end------------------------

        -- func1: mpu6050 lvgl init{
        if T1_MPU == 1 then
            func_mpu_init()
        end
        --}

        -- func2: websocket connetct{
        if T2_WS == 1 then
            init_wifi()
            ws_connect()
        end
        --}

        -- func3: light sensor{
            if T3_BH1750 == 1 then
                BH1750_init(esp32_i2c_id)
            end
        --}

        while true do
            if T2_WS == 1 then
                judge_sr_status()
            end

            if T1_MPU == 1 then
                mpu_event_judge()
            end

            if T3_BH1750 == 1 then
                local temp_light_value_x = BH1750_get()
                -- print("light",temp_light_value_x)
                if temp_light_value_x < 100 then
                    print("no light")
                    start_send_msg()
                    sys.wait(500)
                end
            end
        end
        -- ws_close(websocket_client)

        log.info("socket", "end")

    end


    -- function ( ... )
    --     sys.wait(100)
    -- end

)

sys.run()