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