


-- str_data={"aaavvvv"}

-- print(string.len("aaavvvv"))
-- m= 0x61 ~ 0x13
-- n= 0xff ~ 0xf0
-- x= 255 ~ 240
-- print(m)
-- print(n,type(n))
-- print(x)
-- print(string.len('a'))

-- -- y= string.toHex(str_data[1])
-- -- --  ~ 0xff
-- -- print(y)

-- -- print(string.char(0x80 | 0x01))
-- print(0x80 | 0x01)
-- print(string.char(129, 97))
-- -- print(string.byte(0x81))

-- mask={0x13,0x61,0x0c,0x1a}
-- msg="abcdef"

-- -- print(string.char(129))
-- -- print(str_data[1])
-- t1=string.byte("ab",2)
-- t2=0x61
-- print("t1",t1)
-- print(t1~t2)

mask_key = {0x13,0x61,0x0c,0x1a}
message="abcd"
msg_byte={}
msg_char={}
msg_data_send={}
msg_len = #message

function msg_sub( str )
    -- s="abcdefg"
    -- 拆分成{"1","2","3","4","a","b","c","d"}
    local str_len=string.len(str)

    local list1={}
    for i=1,str_len do
        list1[i]=string.sub(str,i,i)    -- 字符类型
        list1[i]=string.byte(list1[i])  -- 整形，用于bit计算
        -- print(list1[i])
    -- for i=1,k do
    --     print(list1[i])
    -- end
    end

    return list1
end

-- str="abcdefg"
-- msg_list=msg_sub( str )
-- print(msg_list[1])


-- msg_byte = msg_sub( message )
-- for i = 1, msg_len do
--     -- print(msg_byte[i],"|",mask_key[(i-1)%4+1])
--     msg_byte[i] = msg_byte[i] ~ mask_key[(i-1)%4+1]
--     print(msg_byte[i])
--     msg_char[i]=string.char(msg_byte[i])
--     print(msg_char[i])
--     -- msg_byte[i]=x
--     -- print(msg_byte[i])
-- end

-- print(table.concat(msg_char))




-- data_send=string.char(0x80, mask_key[1], mask_key[2], mask_key[3], mask_key[4])
-- print(data_send)

function ws_send_encode( opcode, message) -- sock,
    -- message type"Fin | RSV1/2/3" + "opcode(0x0~0xA)"
    data_send=string.char(0x80 | opcode)
    print(data_send)
    
    table.insert(msg_data_send,data_send)
    -- print(data_send)

    -- empty message
    if not message then
            data_send=string.char(0x80, mask_key[1], mask_key[2], mask_key[3], mask_key[4])
            table.insert(msg_data_send,data_send)
            -- print(data_send)
        return 0
    end

    -- message msg_len "Mask(1bit) | len(7bit)" len:7bit + 0/16/64bit
    local msg_len = #message
    if msg_len<125 then
        -- print(msg_len)
        data_send=string.char(msg_len | 0x80)    --0x80为mask标志位，表示发送
        table.insert(msg_data_send,data_send)
        -- print(data_send)
        -- sock:send(data_send)
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
    data_send=string.char(mask_key[1], mask_key[2], mask_key[3], mask_key[4])
    table.insert(msg_data_send,data_send)
    -- print(data_send)

    -- message "person data"
    msg_byte = msg_sub( message )
    for i = 1, msg_len do
        -- print(msg_byte[i],"|",mask_key[(i-1)%4+1])
        msg_byte[i] = msg_byte[i] ~ mask_key[(i-1)%4+1]
        -- print(msg_byte[i])
        msg_char[i]=string.char(msg_byte[i])
        -- print(msg_char[i])
        -- msg_byte[i]=x
        -- print(msg_byte[i])
    end
    data_send=table.concat(msg_char)
    table.insert(msg_data_send,data_send)

    print(table.concat(msg_data_send))

    return table.concat(msg_data_send)
    -- return sock:send(string.char(unpack(msg_byte)))
end

wifi_id="LangZhao"
-- local wifi_id="youkai"
wifi_passwd = "19971226"
-- 自己的腾讯云
websocket_ip = "124.221.115.14"
websocket_port = 3001

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

ws_head = {}
ws_accept = nil
websocket_client = nil
temp_msg_send = "youkai"
temp_msg_recv = {}

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
    if websocket_client == nil then
        return
    end
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
    if websocket_client == nil then
        return
    end
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
    if websocket_client == nil then
        return
    end
    local data_recv, data_recv_len = socket.recv(websocket_client)
    if data_recv ~= nil then
        log.info("socket","msg_recv:",data_recv,"len:", data_recv_len)
        print("<<<<<<<<<<<<<<<<<<<<<<<")
        print(data_recv)
        print("<<<<<<<<<<<<<<<<<<<<<<<")

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



-- local function read(ws)
--     local sock = ws.socket
--     local res, err, part
--     if ws.remain>0 then
--         local res, err, part = sock:receive(ws.remain)
--         if part then
--             -- still some bytes remaining
--             ws.buffer, ws.remain = ws.buffer..part, ws.remain-#part
--             return nil, nil, "pending"
--         else
--             -- all parts recieved
--             ws.buffer, ws.remain = ws.buffer..res, 0
--             return ws.buffer, ws.head, nil
--         end
--     end
--     -- byte 0-1
--     res, err = sock:receive(2)
--     if err then return res, nil, err end
--     local head = res:byte()
--     -- Moved to _M:update
--     -- local flag_FIN = res:byte()>=0x80
--     -- local flag_MASK = res:byte(2)>=0x80
--     local byte = res:byte(2)
--     local msg_len = band(byte, 0x7f)
--     if msg_len==126 then
--         res = sock:receive(2)
--         local b1, b2 = res:byte(1, 2)
--         msg_len = shl(b1, 8) + b2
--     elseif msg_len==127 then
--         res = sock:receive(8)
--         local b5, b6, b7, b8 = res:byte(5, 8)
--         msg_len = shl(b5, 24) + shl(b6, 16) + shl(b7, 8) + b8
--     end
--     if msg_len==0 then return "", head, nil end
--     res, err, part = sock:receive(msg_len)
--     if part then
--         -- incomplete frame
--         ws.head = head
--         ws.buffer, ws.remain = part, msg_len-#part
--         return nil, nil, "pending"
--     else
--         -- complete frame
--         return res, head, err
--     end
-- end

-- send(1,message)