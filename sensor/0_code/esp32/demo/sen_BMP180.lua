--- 模块功能：I2C BMP180功能测试.   气压温度海拔传感器
-- @author denghai
-- @module i2c.BMP180
-- @license MIT
-- @copyright openLuat
-- @release 2021.09.22

--[[		
    BMP180_REG_ID = 0xD0,			//contains 0x55 after power on
    BMP180_REG_RESET = 0xE0,		//write 0xB6 to reset
    BMP180_REG_STATUS = 0xF3,		//bit 0: im_update, bit 3: measuring
    BMP180_REG_CTRL_MEAS = 0xF4,	//sets data acquisition options of device	
    BMP180_REG_CONFIG = 0xF5,		//sets the rate, filter and interface options of the device.
    BMP180_REG_OUT = 0xF6,			//raw conversion results
    
    BMP180_REG_CAL_AC1 = 0xAA,		//2 bytes each. can never be 0x0000 or oxFFFF
    BMP180_REG_CAL_AC2 = 0xAC,
    BMP180_REG_CAL_AC3 = 0xAE,
    BMP180_REG_CAL_AC4 = 0xB0,
    BMP180_REG_CAL_AC5 = 0xB2,
    BMP180_REG_CAL_AC6 = 0xB4,
    
    BMP180_REG_CAL_B1 = 0xB6,
    BMP180_REG_CAL_B2 = 0xB8,
    
    BMP180_REG_CAL_MB = 0xBA,
    BMP180_REG_CAL_MC = 0xBC,
    BMP180_REG_CAL_MD = 0xBE,	
]]


BMP180_REG_ID = 0xD0			--contains 0x55 after power on
BMP180_REG_RESET = 0xE0		--write 0xB6 to reset
BMP180_REG_STATUS = 0xF3		--bit 0: im_update bit 3: measuring
BMP180_REG_CTRL_MEAS = 0xF4	--sets data acquisition options of device	
BMP180_REG_CONFIG = 0xF5		--sets the rate filter and interface options of the device.
BMP180_REG_OUT = 0xF6			--raw conversion results

BMP180_REG_CAL_AC1 = 0xAA		--2 bytes each. can never be 0x0000 or oxFFFF
BMP180_REG_CAL_AC2 = 0xAC
BMP180_REG_CAL_AC3 = 0xAE
BMP180_REG_CAL_AC4 = 0xB0
BMP180_REG_CAL_AC5 = 0xB2
BMP180_REG_CAL_AC6 = 0xB4

BMP180_REG_CAL_B1 = 0xB6
BMP180_REG_CAL_B2 = 0xB8

BMP180_REG_CAL_MB = 0xBA
BMP180_REG_CAL_MC = 0xBC
BMP180_REG_CAL_MD = 0xBE

BMP180_CMD_RESET = 0xB6

--register 0xD0
BMP180_MASK_ID = 0xFF

--register 0xE0
BMP180_MASK_RESET = 0xFF

--register 0xF4
BMP180_MASK_OSS = 0xC0
BMP180_MASK_SCO = 0x20
BMP180_MASK_MCTRL = 0x1F

BMP180_CMD_TEMP = 0x2E      --start temperature conversion
BMP180_CMD_PRESS = 0x34     --start pressure conversion

-- i2c ID
BMP180_i2c_id = 0

-- i2c 速率
BMP180_i2c_speed = 0

BMP180_i2c_addr = 0x77


-- 初始化
function BMP180_init_i2c(t_i2c_id,address)
    BMP180_i2c_id = t_i2c_id
    if i2c.setup(BMP180_i2c_id, BMP180_i2c_speed, -1, 1) ~= BMP180_i2c_speed then
        log.error("i2c", "setup fail", BMP180_i2c_addr)
        return
    end
    BMP180_i2c_addr = address
    -- print("BMP180 addr:",addr)
end

-- 读取数据
function BMP180_send(...)
    sys.wait(10)
    -- print("addr",addr)
    if not BMP180_i2c_addr then
        log.info("i2c", "addr err")
        return
    end
    local t = {...}
    -- print("t",t[1],t[2])
    temp_t =  i2c.send(BMP180_i2c_id, BMP180_i2c_addr, t)
    -- print("#t",#t)
    -- print("temp_t",temp_t)
    -- if temp_t ~= #t then        -- 现在i2c.BMP180_send()返回值为true了，不是个数
    if temp_t ~= true then
        log.error("i2c", "BMP180_send fail", #t)
        return
    end
    return true
end

-- 发送数据
function BMP180_read(n)
    sys.wait(10)
    if not BMP180_i2c_addr then
        log.info("i2c", "addr err")
        return "\x00"
    end
    val = i2c.recv(BMP180_i2c_id, BMP180_i2c_addr, n)
    -- log.info("BMP180_read", val:toHex())
    if val and #val > 0 then return val end
    return "\x00"
end

-- 读取short 值 
function BMP180_short(t_addr, n)
    -- print("addr",addr)
    BMP180_send(t_addr)      -- 只传地址？
    -- print("BMP180_send addr")
    -- print("n",n)
    if n then
        f, val = pack.unpack(BMP180_read(2), ">H")
    else
        f, val = pack.unpack(BMP180_read(2), ">h")
    end
    
    -- log.info("val", f, val)
    return f and val or 0
end

function BMP180_init(t_i2c_id)
    BMP180_init_i2c(t_i2c_id,0x77)      -- 传入i2c地址0x77 = 119
    BMP180_send(BMP180_REG_ID)      -- 传入地址0xD0, 寄存器id
    local id = BMP180_read(1)
    -- print("bmp180 reg id ",id)
    if "U"~=id then 
        print("error id",id)
        sys.restart("error i2c id!")
        return
    end
    -- 复位
    BMP180_send(BMP180_REG_RESET,BMP180_CMD_RESET)     -- 0xE0,0XB6

    -- https://blog.csdn.net/weixin_50622833/article/details/118611152
    AC1 = BMP180_short(BMP180_REG_CAL_AC1)  -- 0xAA		--2 bytes each. can never be 0x0000 or oxFFFF
    AC2 = BMP180_short(BMP180_REG_CAL_AC2)  -- 0xAC
    AC3 = BMP180_short(BMP180_REG_CAL_AC3)  -- 0xAE
    AC4 = BMP180_short(BMP180_REG_CAL_AC4,true)    -- 0xB0
    AC5 = BMP180_short(BMP180_REG_CAL_AC5,true)    -- 0xB2
    AC6 = BMP180_short(BMP180_REG_CAL_AC6,true)    -- 0xB4
    B1  = BMP180_short(BMP180_REG_CAL_B1)  -- 0xB6
    B2  = BMP180_short(BMP180_REG_CAL_B2)  -- 0xB8
    MB  = BMP180_short(BMP180_REG_CAL_MB)  -- 0xBA
    MC  = BMP180_short(BMP180_REG_CAL_MC)  -- 0xBC
    MD  = BMP180_short(BMP180_REG_CAL_MD)  -- 0xBE	
end

function BMP180_get_temp_press()
    
    -- 温度 ℃
    BMP180_send(BMP180_REG_CTRL_MEAS,BMP180_CMD_TEMP)     --0xF4表示测量，0x2E表示温度
    sys.wait(1000)
    log.info("温度raw", BMP180_short(BMP180_REG_OUT))        --0xF6数据输出
    UT = BMP180_short(BMP180_REG_OUT)                  -- 温度数值
    -- print("UT",UT)
    -- 气压 Pa
    BMP180_send(BMP180_REG_CTRL_MEAS,BMP180_CMD_PRESS)     --0xF4,0x34
    sys.wait(1000)
    BMP180_send(BMP180_REG_OUT)
    _, UP = pack.unpack(BMP180_read(2), "<H")          -- 气压数值
    -- print("UP",UP)
    log.info("气压raw", UP)
    return BMP_UncompemstatedToTrue(UT,UP)

end

function BMP180_test(t_i2c_id)
    -- sys.wait(8000)

    BMP180_init(t_i2c_id)

    while true do
        sys.wait(2000)

        BMP180_get_temp_press()
    end

end


--https://blog.csdn.net/weixin_50622833/article/details/118611152

--//用获取的参数对温度和大气压进行修正，并计算海拔
function BMP_UncompemstatedToTrue(UT,UP)
    local Press = 0
    local X1 = (UT - AC6) * AC5/32768       -- 2^15，数据右移15位
    -- log.info("X1 ",X1,"UT ",UT,"AC6 ",AC6)
    -- local X2 = bit.lshift(MC,11) / (X1 + MD)
    local X2 = MC*2048 / (X1 + MD)          -- 2^11，左移11位
    -- log.info("X2",MC,"MC",X2,"MD",MD)
    local B5 = X1 + X2
    -- log.info("B5",B5)
    -- local Temp  = bit.rshift((B5 + 8) ,4)
    local Temp  = (B5 + 8)/16
    Temp = Temp * 0.1
    log.info("温度: ",Temp.." °C")

    local B6 = B5 - 4000
    -- log.info("B6",B6)
    X1 = (B2 *((B6 * B6)/4096))/2048
    -- X1 = bit.rshift(B2 * bit.rshift(B6 * B6,12) ,11)
    -- log.info("X1",X1,"B2",B2,"B6",B6)
    X2 = (AC2 * B6)/2048
    -- X2 = bit.rshift(AC2 * B6,11)
    -- log.info("X2",X2,"AC2",AC2)
    local X3 = X1 + X2
    -- log.info("X3",X3)
    local B3 = ((AC1 * 4 + X3) + 2) /4
    -- log.info("B3",B3,"AC1",AC1)
    X1 = (AC3 * B6)/8192
    -- X1 = bit.rshift(AC3 * B6 ,13)
    -- log.info("X1",X1,"AC3",AC3)
    X2 = (B1 *((B6*B6)/4096)) /65536
    -- X2 = bit.rshift((B1 *bit.rshift(B6*B6 ,12)) ,16)
    -- log.info("X2",X2,"B1",B1)
    -- X3 = bit.rshift(X1 + X2 + 2, 2)
    X3 = (X1 + X2 + 2)/4
    -- log.info("X3",X3)
    local B4 = (AC4 * (X3 + 32768))/32768
    -- local B4 = bit.rshift(AC4 * (X3 + 32768) ,15)
    -- log.info("B4",B4,"AC4",AC4)
    local B7 = (UP - B3) * 50000
    -- log.info("B7",B7,"UP",UP)
    if(B7 < 0x80000000) then
        Press = (B7 * 2) / B4
    else
        Press = (B7 / B4) * 2
    end
    -- log.info("Press",Press)
    X1 = (Press/256) * (Press/256)
    -- X1 = bit.rshift(Press ,8) * bit.rshift(Press,8)
    -- log.info("X1",X1)
    X1 = (X1 * 3038)/65536
    -- X1 = bit.rshift(X1 * 3038,16)
    -- log.info("X1",X1)
    X2 = (-7357 * Press)/65536
    -- X2 = bit.rshift(-7357 * Press, 16)
    -- log.info("X2",X2)
    Press = Press + (X1 + X2 + 3791)/16
    -- Press = Press + bit.rshift(X1 + X2 + 3791,4)
    -- log.info("气压修正", Press)
    -- Press = Press * 0.001
    log.info("气压: ", Press * 0.001 .." kPa")
    local altitude = 44330 * (1-((Press) / 101325.0)^1.0/5.255)
    altitude = altitude * 0.001
    log.info("海拔: ", altitude.." m")

    return Temp,Press * 0.001,altitude
end 
