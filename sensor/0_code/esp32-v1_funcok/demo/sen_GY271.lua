--- 模块功能：ADC功能测试.      GY271  hmc5883l 三轴罗盘
-- ADC测量精度(12bit)
-- 每隔1s读取一次ADC值
-- @author openLuat
-- @module adc.testAdc
-- @license MIT
-- @copyright openLuat
-- @release 2018.12.19

--[[
VCC:电源正
GND:电源负
SCL:I2C串行时钟线
SDA:I2C串行数据线
DRDY：中断引脚      -- io11
]]

PROJECT = "hmc5883l_demo"
VERSION = "1.0.0"

-- require "log"
-- require "sys"
-- require "misc"

-- i2c ID
local GY271_i2c_id = 0

-- i2c 地址
local GY271_i2c_addr = 0x1e        --GY271_i2c_addr

-- i2c 速率
local GY271_i2c_speed = 100000      --iic速率
 
--打开vlcd电压域
-- pmd.ldoset(15,pmd.LDO_VLCD)-- GPIO 0、1、2、3、4

local status_GY271_cal = 0        --校准

local Config_a     = 0x00    --配置寄存器a:设置的数据输出速率和测量配置  0 11 100 00  0X70
local Config_b     = 0x01    --配置寄存器b：设置装置的增益              001 00000    0Xe0
local mode         = 0x02    --模式寄存器: 默认单一测量模式01，连续00           000000 00    0X00/0x01
local Msb_x        = 0x03    --x 高位数据输出
local Lsb_x        = 0x04    --x 低位数据输出
local Msb_y        = 0x07    --x 高位数据输出
local Lsb_y        = 0x08    --x 低位数据输出
local Msb_z        = 0x05    --x 高位数据输出
local Lsb_z        = 0x06    --x 低位数据输出
local status       = 0x09    --  状态寄存器    0x00
local recogn_a     = 0x0a    --  识别寄存器a   0x48
local recogn_b     = 0x0b    --  识别寄存器b   0x34
local recogn_c     = 0x0c    --  识别寄存器c   0x33


--写数据
local function I2C_Write_Byte(regAddress,val,val2)
    i2c.send(GY271_i2c_id, GY271_i2c_addr, {regAddress,val,val2})
    
end

--读取单个字节
local function I2C_Read_Byte(regAddress)
    i2c.send(GY271_i2c_id, GY271_i2c_addr, regAddress)
    local rdstr = i2c.recv(GY271_i2c_id, GY271_i2c_addr, 1)
    -- log.info("rdstr:toHex()",rdstr:toHex())      -- 打印原始数据
    return rdstr:byte(1)--变成10进制数据
end

--读取多个字节
local function I2C_Read_Bytes(regAddress,cnt)
    i2c.send(GY271_i2c_id, GY271_i2c_addr, regAddress)
    local rdstr = i2c.recv(GY271_i2c_id, GY271_i2c_addr, cnt)
    --log.info("rdstr:toHex()-------",rdstr:toHex())
    return rdstr
end


-- 初始化
function init()
    if  i2c.setup(GY271_i2c_id, GY271_i2c_speed, GY271_i2c_addr) ~= GY271_i2c_speed  then
        log.error("i2c", "setup fail", GY271_i2c_addr)
        i2c.close(GY271_i2c_id)
        return
    end

    log.info("dev i2c init_ok")

    sys.wait(1000)
    hmc5883l_int()
    
    hmc5883l_read()

    -- 校准
    GY271_cal()

    return true
end

function hmc5883l_int()

    I2C_Write_Byte(Config_a,0x70)  --写配置a寄存器数据
    I2C_Write_Byte(Config_b,0x20)  --写配置b寄存器数据  增益660
    I2C_Write_Byte(mode,0x00)      --写模式寄存器数据
end

function judge_xyz_range()
    
    if x_data > x_max then
        x_max = x_data
    else if x_data < x_min then
        x_min = x_data
    end
    end

    if y_data > y_max then
        y_max = y_data
    else if y_data < y_min then
        y_min = y_data
    end
    end

    if z_data > z_max then
        z_max = z_data
    else if z_data < z_min then
        z_min = z_data
    end
    end

    print("x range: ",x_max,x_min,"y range: ",y_max,y_min,"z range: ",z_max,z_min)
end

function get_angle()

    print("x "..x_data.." | y "..y_data.." | z "..z_data)
    x_p00 = x_max - (x_max - x_min)/2
    y_p00 = y_max - (y_max - y_min)/2
    z_p00 = z_max - (z_max - z_min)/2

    print("p00",x_p00,y_p00,z_p00)
    hmc5883l_angle = math.atan((y_data - y_p00)/(x_data - x_p00))*(180/3.14159265)+180
    -- hmc5883l_angle = math.atan((x_data - x_p00)/(y_data - y_p00))*(180/3.14159265)+180

    print("hmc5883l_angle",hmc5883l_angle)
    
end

function hmc5883l_read()

    local hx=I2C_Read_Byte(Msb_x)
    local lx=I2C_Read_Byte(Lsb_x)
    x_data=hx*256+lx

    local hy=I2C_Read_Byte(Msb_y)
    local ly=I2C_Read_Byte(Lsb_y)
    y_data=hy*256+ly

    local hz=I2C_Read_Byte(Msb_z)
    local lz=I2C_Read_Byte(Lsb_z)
    z_data=hz*256+lz

    if(x_data>32768)  then
        x_data= -(0xFFFF - x_data + 1)   
    end

    if(y_data>32768)  then
        y_data = -(0xFFFF - y_data + 1)
    end 

    if(z_data>32768)  then
        z_data = -(0xFFFF - z_data+ 1)
    end

    log.info("x,y,z-----------", x_data,y_data,z_data )



    -- local Angle= math.atan(x_data,y_data)*(180/3.14159265)+180 --单位：角度 (0~360)
    -- Angle= Angle 

    -- log.info("Angle",string.format("%.1f", Angle))

    return x_data,y_data,z_data
end



function hmc5883l_test()
    sys.wait(3000)
    
    hmc5883l_status = init()
    print("hmc5883l_status",hmc5883l_status)

    while true do
        sys.wait(1000)
        if hmc5883l_status then 

            --初始化hmc588配置
            -- hmc5883l_int()

            --读取x,y,z数值
            hmc5883l_read()
            judge_xyz_range()
            -- get_angle()

            raw2angle_y(x_data,y_data,x_max,x_min,y_max,y_min)
            -- i2c.close(GY271_i2c_id)
        end
    end
end

function set_GY271_cal()
    status_GY271_cal = 1
end

function GY271_cal_judge()
    if status_GY271_cal == 1 then
        GY271_cal()
        status_GY271_cal = 0
    end
end

function GY271_cal()
        x_max = x_data
        x_min = x_data
        y_max = y_data
        y_min = y_data
        z_max = z_data
        z_min = z_data
end


-- test

-- 交换xy求与y轴的夹角
-- y = 1
-- x = -3^(1/2)

-- y = -1
-- x = -3^(1/2)

-- 获取与y轴的夹角
function get_y_angle(x,y)
    local temp_atan = 0
    local pi = 3.1415926
    if x > 0 then
        if y > 0 then
            -- print("1")
            temp_atan = math.atan(x,y)/pi*180
        else if y<0 then
            -- print("2")
            temp_atan = math.atan(x,y)/pi*180 
        end

        if y == 0 then
            temp_atan = 90
        end
        end
    else if x < 0 then
        if y > 0 then
            -- print("4")
            temp_atan = math.atan(x,y)/pi*180 + 360
        else if y<0 then
            -- print("3")
            temp_atan = math.atan(x,y)/pi*180 + 360
        end
        end
        if y == 0 then
            temp_atan = 270
        end
    end
    end
    return temp_atan
end


-- n = get_y_angle(x,y)
-- -- print(m)
-- print(n)


-- 输入数值范围及当前数值，返回与y轴的夹角
function raw2angle_y(temp_x,temp_y,x_max,x_min,y_max,y_min)

    local R_x_max = x_max
    local R_x_min = x_min
    local R_y_max = y_max
    local R_y_min = y_min
    local R_range_x = R_x_max - R_x_min
    local R_range_y = R_y_max - R_y_min
    local R00_x = R_x_max - (R_range_x)/2
    local R00_y = R_y_max - (R_range_y)/2
    
    print("R00",R00_x,R00_y)
    
    local R_temp_x = temp_x
    local R_temp_y = temp_y

    local R_bias_x = R_temp_x - R00_x
    local R_bias_y = R_temp_y - R00_y
    
    N_angle = get_y_angle(R_bias_x,R_bias_y) - 90
    if N_angle < 0 then
        print("N-E")
        N_angle = N_angle+360
    end
    print("get_y_angle",N_angle)
    
    local lcd_x_max = 128 
    local lcd_y_max = 128 
    local R_step_x = lcd_x_max / R_range_x
    local R_step_y = lcd_y_max / R_range_y

    local lcd_x = R_bias_x * R_step_x + 64  -- R00对应(64,64)
    local lcd_y = R_bias_y * R_step_y + 64

    print("lcd",lcd_x,lcd_y)
    lcd.drawPoint(math.floor(lcd_x),math.floor(lcd_x),0xF000)

    lcd.fill(0,129,128,160,0xFFFF)
    lcd.setFont(lcd.font_opposansm8)
    lcd.drawStr(0,145,N_angle)

    return lcd_x,lcd_y
end

-- raw2angle_y(300,400,300,-100,400,0)