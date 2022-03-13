PROJECT = "socket"
VERSION = "1.0.0"

-- 一定要添加sys.lua !!!!
local sys = require "sys"

require("ws_data")

local wifi_id="LangZhao"
-- local wifi_id="youkai"
local wifi_passwd = "19971226"
-- 自己的腾讯云
local websocket_ip = "124.221.115.14"
local websocket_port = 3002

-- http://www.websocket-test.com/
-- local websocket_ip = "121.40.165.18"
-- local websocket_port = 8800

-- 合宙demo
-- local websocket_ip = "112.125.89.8"
-- local websocket_port = 35227

-- WebSocket protocol constants
-- First byte
WS_FIN            = 0x80
WS_OPCODE_TEXT    = 0x01
WS_OPCODE_BINARY  = 0x02
WS_OPCODE_CLOSE   = 0x08
WS_OPCODE_PING    = 0x09
WS_OPCODE_PONG    = 0x0a
-- Second byte
WS_MASK           = 0x80
--WS_MASK           = 0x00
WS_SIZE16         = 126
WS_SIZE64         = 127


local ws_head = {}
local ws_accept
local websocket_client
temp_msg_send = "youkai"
temp_msg_recv = {}

function set_ws_head()
    table.insert(ws_head,"GET ws://124.221.115.14:3002/ HTTP/1.1")
    table.insert(ws_head,"Connection: Upgrade")
    table.insert(ws_head,"Host: 124.221.115.14:3002")
    table.insert(ws_head,"Origin: http://124.221.115.14")
    table.insert(ws_head,"Sec-WebSocket-Key: w4v7O6xFTi36lq3RNcgctw==")
    table.insert(ws_head,"Sec-WebSocket-Version: 13")
    table.insert(ws_head,"Upgrade: websocket")
    table.insert(ws_head,"\r\n")
    -- table.insert(ws_head,)
    -- table.insert(ws_head,)
    -- table.insert(ws_head,)
    -- table.insert(ws_head,)

    -- ws_head[1]="GET / HTTP/1.1"
    -- ws_head[2]="Host: 121.40.165.18:8800"
    -- ws_head[2]="Host: 124.221.115.14:3002"      -- 腾讯云
    -- ws_head[4]="Connection: Upgrade"
    -- ws_head[5]="Sec-WebSocket-Key: w4v7O6xFTi36lq3RNcgctw=="
    -- ws_head[6]="Sec-WebSocket-Protocol: esp32"
    -- ws_head[7]="Sec-WebSocket-Version: 13\r\n"
    -- ws_head[7]="Upgrade: websocket"
    -- ws_head[7]="Origin: http://124.221.115.14:3001"
    -- ws_head[8]="Sec-WebSocket-Version: 13\r\n"
    msg_send_head=table.concat(ws_head, "\r\n")
    -- msg_send_head=msg_send_head+tostring('\r\n')
    -- print(msg_send_head)
    -- print(type(msg_send_head))
end
-- set_ws_head()

function init_wifi()
    log.info("init wifi")
    repeat
        ret = wlan.init()
        log.info("wlan", "wlan_init:", ret)
        wlan.setMode(wlan.STATION)
        wlan.connect(wifi_id, wifi_passwd)
        -- 等到成功获取ip就代表连上局域网了
        result, data = sys.waitUntil("IP_READY")
        log.info("wlan", "IP_READY", result, data)
    until (result == true)
end

function ws_send(temp_data_send)
    -- temp_data_send="abcaaaa"
    if temp_data_send == nil then
        return
    end

    temp_data_opcode = WS_OPCODE_TEXT
    data_send = ws_send_encode( temp_data_opcode , temp_data_send)

    local data_send_len = socket.send(websocket_client, data_send)
    log.info("socket", ">sendlen", data_send_len)
    print(">>>>>>>>>>>>>>>>>>>>>>")
    print(data_send)
    print(">>>>>>>>>>>>>>>>>>>>>>")
end

function ws_recv_test()
    local data_recv, data_recv_len = socket.recv(websocket_client)
    if data_recv ~= nil then
        log.info("socket","msg_recv:",data_recv,"len:", data_recv_len)
        print("<<<<<<<<<<<<<<<<<<<<<<<")
        print(data_recv)
        print("<<<<<<<<<<<<<<<<<<<<<<<")

        -- ws_result=string.find(data_recv,"HTTP/1.1 101 Switching Protocols")
        -- if ws_result ~= nil then
        --     log.info("websocket connect ok.")
        --     return
        -- end
    end

    -- temp_data_opcode = WS_OPCODE_TEXT
    -- data_send = ws_send_encode( temp_data_opcode , temp_data_send)

    -- local data_send_len = socket.send(websocket_client, data_send)
    -- log.info("socket", ">sendlen", data_send_len)
    -- print("<<<<<<<<<<<<<<<<<<<<<<<")
    -- print(data_send)
    -- print("<<<<<<<<<<<<<<<<<<<<<<<")
end

function ws_recv(websocket_client)
    local data_recv, data_recv_len = socket.recv(websocket_client)
    if data_recv ~= nil then
        log.info("socket","msg_recv:",data_recv,"len:", data_recv_len)
        print("<<<<<<<<<<<<<<<<<<<<<<<")
        print(data_recv)
        print("<<<<<<<<<<<<<<<<<<<<<<<")

        return data_recv
        -- ws_result=string.find(data_recv,"HTTP/1.1 101 Switching Protocols")
        -- if ws_result ~= nil then
        --     log.info("websocket connect ok.")
        --     return
        -- end
    end
    
    -- while 1 do
    --     -- log.info("========wait recv=====")
    --     local data, len = socket.recv(websocket_client)
    --     if data ~= nil then
    --         -- log.info("++++judege recv++++++")
    --         log.info("socket","date<",data)
    --         print("<<<<<<<<<<<<<<<<<<<<<<<")
    --         log.info("socket","date<")
    --         print("<<<<<<<<<<<<<<<<<<<<<<<")

    --         if data == "close" then
    --             print("in close")
    --             socket.close(websocket_client)
    --             log.info("socket", "close")
    --         end
    --         log.info("socket", "<len", len)
    --         log.info("socket", "<data", type(data),data)
    --         log.info("++++judege recv end++++++")
    --     end
    --     sys.wait(1000)
    -- end
end

function ws_close(websocket_client)
    socket.close(websocket_client)
    print("close socket")
end




-- function ()
--     msg_recv="HTTP/1.1 101 Switching ProtocolsSec-WebSocket-Accept: Oy4NRAQ13jhfONC7bP8dTKb4PTU="
--     ws_accept_start=string.find(msg_recv,'Accept')
--     print("ws_accept_start",ws_accept_start)
-- end

function ws_connect()

    log.info("socket", "1. create socket")
    websocket_client = socket.create(socket.TCP) -- tcp

    log.info("--------2. connected tcp 3 handshake----------")
    repeat
        err = socket.connect(websocket_client, websocket_ip, websocket_port)
        log.info("socket", err)
        sys.wait(3000)  -- 重试间隔
    until (err == 0)

    log.info("--------3. send websocket Upgrade----------")
    -- msg_send_head = "hello lua esp32c3"
    set_ws_head()
    len = socket.send(websocket_client, msg_send_head)
    log.info("socket", ">sendlen", len)
    print(">>>>>>>>>>>>>>>>>>>>>>")
    print(msg_send_head)
    print(">>>>>>>>>>>>>>>>>>>>>>")

    log.info("--------4. recv Upgrade result----------")
    while 1 do 
        local msg_recv, msg_recv_len = socket.recv(websocket_client)

        if msg_recv ~= nil then
            log.info("socket","msg_recv_len:", msg_recv_len)
            print("<<<<<<<<<<<<<<<<<<<<<<<")
            print(msg_recv)
            print("<<<<<<<<<<<<<<<<<<<<<<<")

            ws_result=string.find(msg_recv,"HTTP/1.1 101 Switching Protocols")
            if ws_result ~= nil then
                log.info("websocket connect ok.")

                ws_accept_start=string.find(msg_recv,'Accept: ')
                print("ws_accept_start",ws_accept_start)
                if ws_accept_start ~= nil then
                    temp = string.sub(msg_recv,ws_accept_start)
                    print("temp",temp)
                    temp_start = string.len('Accept: ')
                    temp_end = string.find(temp,'\r')
                    print(temp_start,type(temp_start),"|",temp_end,type(temp_end))
                    ws_accept= string.sub(temp,temp_start+1,temp_end-1)
                    print(ws_accept)
                end
                break
            end

        end

        sys.wait(1000)
    end
end

flag_send = true
flag_recv = true

function judge_sr_status()

    while true do
        
        if flag_send == true then
            ws_send(temp_msg_send)
            flag_send = false
            flag_recv = true
        end

        if flag_recv == true then
            temp_data_recv = ws_recv(websocket_client)
            
            if temp_data_recv ~= nil then
                flag_recv = false
            end
        end

        sys.wait(100)

    end
    
end

sys.taskInit(
    function ()
            
        init_wifi()

        ws_connect()

        -- ws_send()
        -- ws_send()
        judge_sr_status()

        -- ws_close(websocket_client)

        log.info("socket", "end")
    end


    -- function ()
    --     -- string.char(0x80, unpack(mask_key)
    --     opcode=1
    --     print(string.char(bit.bor(0x80, opcode)))
    -- end
)



-- 用户代码已结束---------------------------------------------
-- 结尾总是这一句
sys.run()
-- sys.run()之后后面不要加任何语句!!!!!