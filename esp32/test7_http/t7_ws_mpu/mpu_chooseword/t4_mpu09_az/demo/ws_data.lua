mask_key = {0x61,0x62,0x63,0x64}
-- mask_key = {0x13,0x61,0x0c,0x1a}


function msg_sub( str )
    local str_len=string.len(str)

    local list1={}
    for i=1,str_len do
        list1[i]=string.sub(str,i,i)    -- 字符类型
        list1[i]=string.byte(list1[i])  -- 整形，用于bit计算
        -- print(list1[i])
    end
    return list1
end

function ws_send_encode( opcode, message) -- sock,
    -- message type"Fin | RSV1/2/3" + "opcode(0x0~0xA)"
    print("opcode: ["..opcode.."]","message:["..message.."]")

    local msg_data_send = {}
    
    data_send_fin_num=0x80 | opcode
    -- print("fin:",data_send_fin_num)
    local data_send_fin=string.char(data_send_fin_num)
    -- print("fin:",data_send_fin)
    -- print(data_send)
    table.insert(msg_data_send,data_send_fin)
    -- print(data_send)
    -- print(msg_data_send[1])
    
    -- message msg_len "Mask(1bit) | len(7bit)" len:7bit + 0/16/64bit
    local msg_len = #message
    if msg_len<125 then
        -- print(msg_len)
        local data_send_len=msg_len | 0x80    --0x80为mask标志位，表示发送
        -- print("len",msg_len, data_send_len)
        
        data_send_len=string.char(data_send_len)
        -- print("len",data_send_len,type(data_send_len))
        table.insert(msg_data_send,data_send_len)
        -- print(data_send)
        -- sock:send(data_send)
    end

    -- print("fin & head",string.format(msg_data_send[1]),string.format(msg_data_send[2]))
    -- data_send_finhead = data_send_fin + data_send_len
    -- print("data_send_finhead",data_send_finhead)
    -- table.insert(msg_data_send,string.char(data_send_finhead))

    -- empty message
    if not message then
        -- data_send_mask=0
        local data_send_mask=string.char(0x80, mask_key[1], mask_key[2], mask_key[3], mask_key[4])
        table.insert(msg_data_send,data_send_mask)
        print("no message")
        -- print(data_send)
        return 0
    end
    -- if msg_len>65535 then
    --     sock:send(string.char(127 | 0x80,
    --         0, 0, 0, 0,
    --         band(shr(msg_len, 24), 0xff),
    --         band(shr(msg_len, 16), 0xff),
    --         band(shr(msg_len, 8), 0xff),
    --         band(msg_len, 0xff)))
    -- elseif msg_len>125 then
    --     sock:send(string.char(126 | 0x80,
    --         band(shr(msg_len, 8), 0xff),
    --         band(msg_len, 0xff)))
    -- else
    --     sock:send(string.char(msg_len | 0x80))
    -- end

    -- message "Masking-key"
     
    local data_send_key=string.char(mask_key[1], mask_key[2], mask_key[3], mask_key[4])
    -- print("data_send_key",data_send_key)
    table.insert(msg_data_send,data_send_key)
    -- print(data_send)

    -- message "person data"
    local msg_byte={}
    local msg_char={}

    msg_byte = msg_sub( message )
    for i = 1, msg_len do
        -- print("data",msg_byte[i],i)
        -- print(msg_byte[i],"|",mask_key[(i-1)%4+1])
        msg_byte[i] = msg_byte[i] ~ mask_key[(i-1)%4+1]
        -- print(msg_byte[i])
        msg_char[i]=string.char(msg_byte[i])

        -- print("msg_byte[i]",msg_byte[i],"msg_char[i]",msg_char[i])
        -- print(msg_char[i])
        -- msg_byte[i]=x
        -- print(msg_byte[i])
    end
    
    local data_send_msg=table.concat(msg_char)
    -- print("data_send_msg",data_send_msg)
    table.insert(msg_data_send,data_send_msg)
    -- table.insert(msg_data_send,'\r\n')

    -- print(table.concat(msg_data_send))

    return table.concat(msg_data_send)
    -- return sock:send(string.char(unpack(msg_byte)))
end

-- wifi_id="LangZhao"
wifi_id="youkai"
wifi_passwd = "19971226"
-- 自己的腾讯云
websocket_ip = "124.221.115.14"
websocket_port = 3001


-- WebSocket protocol constants
-- First byte
local WS_FIN            = 0x80
WS_OPCODE_TEXT    = 0x01
local WS_OPCODE_BINARY  = 0x02
local WS_OPCODE_CLOSE   = 0x08
local WS_OPCODE_PING    = 0x09
local WS_OPCODE_PONG    = 0x0a
-- Second byte
local WS_MASK           = 0x80
--local WS_MASK           = 0x00
local WS_SIZE16         = 126
local WS_SIZE64         = 127

ws_head = {}
ws_accept = nil
websocket_client = nil


function set_ws_head()
    table.insert(ws_head,"GET ws://124.221.115.14:3001/ HTTP/1.1")
    table.insert(ws_head,"Connection: Upgrade")
    table.insert(ws_head,"Host: 124.221.115.14:3001")
    table.insert(ws_head,"Origin: http://124.221.115.14")
    table.insert(ws_head,"Sec-WebSocket-Key: w4v7O6xFTi36lq3RNcgctw==")
    table.insert(ws_head,"Sec-WebSocket-Version: 13")
    table.insert(ws_head,"Upgrade: websocket")
    table.insert(ws_head,"\r\n")
    msg_send_head=table.concat(ws_head, "\r\n")
end

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
    if websocket_client == nil then
        return
    end
    -- temp_data_send="abcaaaa"
    if temp_data_send == nil then
        return
    end
    -- print("ws_send in:",temp_data_send)

    local data_send_result=nil
    data_send_result = ws_send_encode( WS_OPCODE_TEXT , temp_data_send)
    -- print("=========",data_send_result)

    local data_send_len_ok = socket.send(websocket_client, data_send_result)
    log.info("socket", ">sendlen", data_send_len_ok)
    -- print(">>>>>>>>>>>>>>>>>>>>>>")
    -- print(data_send)
    -- print(">>>>>>>>>>>>>>>>>>>>>>")
end


function ws_recv(websocket_client)
    if websocket_client == nil then
        return
    end
    local data_recv = nil
    local data_recv, data_recv_len = socket.recv(websocket_client)
    if data_recv ~= nil then
        log.info("socket","msg_recv:",data_recv,"len:", data_recv_len)
        return data_recv
    end
end

function ws_close(websocket_client)
    if websocket_client == nil then
        return
    end
    socket.close(websocket_client)
    print("close socket")
end

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
    -- print(">>>>>>>>>>>>>>>>>>>>>>")
    -- print(msg_send_head)
    -- print(">>>>>>>>>>>>>>>>>>>>>>")

    log.info("--------4. recv Upgrade result----------")
    while 1 do 
        local msg_recv, msg_recv_len = socket.recv(websocket_client)

        if msg_recv ~= nil then
            log.info("socket","msg_recv_len:", msg_recv_len)
            print("<<<<<<<<<< ws recv <<<<<<<<<<<<<")
            print(msg_recv)
            print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")

            ws_result=string.find(msg_recv,"HTTP/1.1 101 Switching Protocols")
            if ws_result ~= nil then
                log.info("websocket connect ok.")

                ws_accept_start=string.find(msg_recv,'Accept: ')
                -- print("ws_accept_start",ws_accept_start)
                if ws_accept_start ~= nil then
                    temp = string.sub(msg_recv,ws_accept_start)
                    -- print("temp",temp)
                    temp_start = string.len('Accept: ')
                    temp_end = string.find(temp,'\r')
                    -- print(temp_start,type(temp_start),"|",temp_end,type(temp_end))
                    ws_accept= string.sub(temp,temp_start+1,temp_end-1)
                    print(ws_accept)
                    -- print("accept end")
                end
                break
            end

        end

        sys.wait(1000)
    end
end


