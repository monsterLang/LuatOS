PROJECT = "socket"
VERSION = "1.0.0"

-- 一定要添加sys.lua !!!!
sys = require "sys"

require("ws_data")


-- send websocket msg
flag_send = true
flag_recv = true
temp_msg_send = "youkai"

function judge_sr_status()
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

sys.taskInit(
    function ()
        
        init_wifi()

        ws_connect()

        while true do


            judge_sr_status()


        end
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