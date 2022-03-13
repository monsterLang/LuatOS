PROJECT = "socket"
VERSION = "1.0.0"

-- 一定要添加sys.lua !!!!
local sys = require "sys"

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

local ws_head = {}
local ws_accept

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
    msg_send=table.concat(ws_head, "\r\n")
    -- msg_send=msg_send+tostring('\r\n')
    -- print(msg_send)
    -- print(type(msg_send))
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

function ws_send(data_send)
    local head_msg_send = {}
    table.insert(head_msg_send,"")
    table.insert(head_msg_send,"")
    table.insert(head_msg_send,"")
    table.insert(head_msg_send,"")
    table.insert(head_msg_send,"")
    table.insert(head_msg_send,"")
    table.insert(head_msg_send,"")
    table.insert(head_msg_send,"")
    table.insert(head_msg_send,"")
    print("send message")
    local data_send_len = socket.send(sock, data_send)
    log.info("socket", ">sendlen", data_send_len)
    print(">>>>>>>>>>>>>>>>>>>>>>")
    print(data_send)
    print(">>>>>>>>>>>>>>>>>>>>>>")

end

function ws_recv(sock)
    local data_recv, data_recv_len = socket.recv(sock)
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
end

function ws_close(sock)
    socket.close(sock)
    print("close socket")
end

sys.taskInit(
    function()
        
        init_wifi()

        log.info("socket", "1. create socket")
        local sock = socket.create(socket.TCP) -- tcp

        log.info("--------2. connected tcp 3 handshake----------")
        repeat
            err = socket.connect(sock, websocket_ip, websocket_port)
            log.info("socket", err)
            sys.wait(3000)  -- 重试间隔
        until (err == 0)

        log.info("--------3. send websocket Upgrade----------")
        -- msg_send = "hello lua esp32c3"
        set_ws_head()
        len = socket.send(sock, msg_send)
        log.info("socket", ">sendlen", len)
        print(">>>>>>>>>>>>>>>>>>>>>>")
        print(msg_send)
        print(">>>>>>>>>>>>>>>>>>>>>>")

        log.info("--------4. recv Upgrade result----------")
        while 1 do 
            local msg_recv, msg_recv_len = socket.recv(sock)

            if msg_recv ~= nil then
                log.info("socket","msg_recv_len:", msg_recv_len)
                print("<<<<<<<<<<<<<<<<<<<<<<<")
                print(msg_recv)
                print("<<<<<<<<<<<<<<<<<<<<<<<")
    
                ws_result=string.find(msg_recv,"HTTP/1.1 101 Switching Protocols")
                if ws_result ~= nil then
                    log.info("websocket connect ok.")

                    ws_accept_start=string.find(msg_recv,'Sec-WebSocket-Accept:')
                    print("ws_accept_start",ws_accept_start)
                    -- temp = string.sub(msg_recv,ws_accept_start)
                    -- print(temp)

                    break
                end

            end

            sys.wait(1000)
        end
        
        -- msg_send="aaa"
        -- ws_send(msg_send)

        -- ws_recv(sock)

        ws_close(sock)
        -- while 1 do
        --     -- log.info("========wait recv=====")
        --     local data, len = socket.recv(sock)
        --     if data ~= nil then
        --         -- log.info("++++judege recv++++++")
        --         log.info("socket","date<",data)
        --         print("<<<<<<<<<<<<<<<<<<<<<<<")
        --         log.info("socket","date<")
        --         print("<<<<<<<<<<<<<<<<<<<<<<<")

        --         if data == "close" then
        --             print("in close")
        --             socket.close(sock)
        --             log.info("socket", "close")
        --         end
        --         log.info("socket", "<len", len)
        --         log.info("socket", "<data", type(data),data)
        --         log.info("++++judege recv end++++++")
        --     end
        --     sys.wait(1000)
        -- end
        log.info("socket", "end")
    end
)

-- 用户代码已结束---------------------------------------------
-- 结尾总是这一句
sys.run()
-- sys.run()之后后面不要加任何语句!!!!!