--- 模块功能：mpu6xxx
-- @module mpu6xxx
-- @author Dozingfiretruck
-- @license MIT
-- @copyright OpenLuat.com
-- @release 2020.12.22

--支持mpu6500，mpu6050，mpu9250，icm2068g，icm20608d，自动判断器件id，只需要配置i2c id就可以

require("lvgl_keyboard")

-- mpu 初始化
i2cid = 0 --i2cid

i2cslaveaddr = MPU6XXX_ADDRESS_AD0_LOW
deviceid = MPU6050_WHO_AM_I

local MPU6XXX_ADDRESS_AD0_LOW     =   0x68 -- address pin low (GND), default for InvenSense evaluation board
local MPU6XXX_ADDRESS_AD0_HIGH    =   0x69 -- address pin high (VCC)

---器件通讯地址
local MPU6050_WHO_AM_I            =   0x68 -- mpu6050
local MPU6500_WHO_AM_I            =   0x70 -- mpu6500
local MPU9250_WHO_AM_I            =   0x71 -- mpu9250
local ICM20608G_WHO_AM_I          =   0xAF -- icm20608G
local ICM20608D_WHO_AM_I          =   0xAE -- icm20608D

local MPU6XXX_ACCEL_SEN           =   16384
local MPU6XXX_GYRO_SEN            =   1310

local MPU60X0_TEMP_SEN            =   340
local MPU60X0_TEMP_OFFSET         =   36.5

local MPU6500_TEMP_SEN            =   333.87
local MPU6500_TEMP_OFFSET         =   21

--- MPU6XXX所用地址
local MPU6XXX_RA_ACCEL_XOUT_H     =   0x3B
local MPU6XXX_RA_ACCEL_XOUT_L     =   0x3C
local MPU6XXX_RA_ACCEL_YOUT_H     =   0x3D
local MPU6XXX_RA_ACCEL_YOUT_L     =   0x3E
local MPU6XXX_RA_ACCEL_ZOUT_H     =   0x3F
local MPU6XXX_RA_ACCEL_ZOUT_L     =   0x40
local MPU6XXX_RA_TEMP_OUT_H       =   0x41
local MPU6XXX_RA_TEMP_OUT_L       =   0x42
local MPU6XXX_RA_GYRO_XOUT_H      =   0x43
local MPU6XXX_RA_GYRO_XOUT_L      =   0x44
local MPU6XXX_RA_GYRO_YOUT_H      =   0x45
local MPU6XXX_RA_GYRO_YOUT_L      =   0x46
local MPU6XXX_RA_GYRO_ZOUT_H      =   0x47
local MPU6XXX_RA_GYRO_ZOUT_L      =   0x48

local MPU6XXX_RA_SMPLRT_DIV     =   0x19   --陀螺仪采样率，典型值：0x07(125Hz)
local MPU6XXX_RA_CONFIG         =   0x1A   --低通滤波频率，典型值：0x06(5Hz)
local MPU6XXX_RA_GYRO_CONFIG    =   0x1B   --陀螺仪自检及测量范围，典型值：0x18(不自检，2000deg/s)
local MPU6XXX_RA_ACCEL_CONFIG   =   0x1C   --加速计自检、测量范围及高通滤波频率，典型值：0x01(不自检，2G，5Hz)
local MPU6XXX_RA_FIFO_EN        =   0x23   --fifo使能
local MPU6XXX_RA_INT_PIN_CFG    =   0x37   --int引脚有效电平
local MPU6XXX_RA_INT_ENABLE     =   0x38   --中断使能
local MPU6XXX_RA_USER_CTRL      =   0x6A
local MPU6XXX_RA_PWR_MGMT_1     =   0x6B   --电源管理，典型值：0x00(正常启用)
local MPU6XXX_RA_PWR_MGMT_2     =   0x6C
local MPU6XXX_RA_WHO_AM_I       =   0x75
--器件ID检测
function mpu6xxx_check()
    i2c.send(i2cid, MPU6XXX_ADDRESS_AD0_LOW, MPU6XXX_RA_WHO_AM_I)--读器件地址
    sys.wait(50)
    local revData = i2c.recv(i2cid, MPU6XXX_ADDRESS_AD0_LOW, 1)
    if revData:byte() ~= nil then
        i2cslaveaddr = MPU6XXX_ADDRESS_AD0_LOW
    else
        i2c.send(i2cid, MPU6XXX_ADDRESS_AD0_HIGH, MPU6XXX_RA_WHO_AM_I)--读器件地址
        sys.wait(50)
        revData = i2c.recv(i2cid, MPU6XXX_ADDRESS_AD0_HIGH, 1)
        if revData:byte() ~= nil then
            i2cslaveaddr = MPU6XXX_ADDRESS_AD0_HIGH
        else
            log.info("i2c", "Can't find device")
            return 1
        end
    end
    i2c.send(i2cid, i2cslaveaddr, MPU6XXX_RA_WHO_AM_I)--读器件地址
    sys.wait(50)
    revData = i2c.recv(i2cid, i2cslaveaddr, 1)
    log.info("Device i2c address is#:", revData:toHex())
    if revData:byte() == MPU6050_WHO_AM_I then
        deviceid = MPU6050_WHO_AM_I
        log.info("Device i2c id is: MPU6050")
    elseif revData:byte() == MPU6500_WHO_AM_I then
        deviceid = MPU6500_WHO_AM_I
        log.info("Device i2c id is: MPU6500")
    elseif revData:byte() == MPU9250_WHO_AM_I then
        deviceid = MPU9250_WHO_AM_I
        log.info("Device i2c id is: MPU9250")
    elseif revData:byte() == ICM20608G_WHO_AM_I then
        deviceid = ICM20608G_WHO_AM_I
        log.info("Device i2c id is: ICM20608G")
    elseif revData:byte() == ICM20608D_WHO_AM_I then
        deviceid = ICM20608D_WHO_AM_I
        log.info("Device i2c id is: ICM20608D")
    else
        log.info("i2c", "Can't find device")
        return 1
    end
    return 0
end

--器件初始化
function mpu6xxx_init()
    i2c.send(i2cid, i2cslaveaddr, {MPU6XXX_RA_PWR_MGMT_1, 0x80})--复位
    sys.wait(100)
    i2c.send(i2cid, i2cslaveaddr, {MPU6XXX_RA_PWR_MGMT_1, 0x00})--唤醒
    sys.wait(100)
    i2c.send(i2cid, i2cslaveaddr, {MPU6XXX_RA_SMPLRT_DIV, 0x07})--陀螺仪采样率，典型值：0x07(125Hz)
    i2c.send(i2cid, i2cslaveaddr, {MPU6XXX_RA_CONFIG, 0x06})--低通滤波频率，典型值：0x06(5Hz)
    i2c.send(i2cid, i2cslaveaddr, {MPU6XXX_RA_GYRO_CONFIG, 0x18})--陀螺仪自检及测量范围，典型值：0x18(不自检，2000deg/s)
    i2c.send(i2cid, i2cslaveaddr, {MPU6XXX_RA_ACCEL_CONFIG, 0x01})--加速计自检、测量范围及高通滤波频率，典型值：0x01(不自检，2G，5Hz)
    --i2c.send(i2cid, i2cslaveaddr, {MPU6XXX_RA_FIFO_EN, 0x00})--关闭fifo
    --i2c.send(i2cid, i2cslaveaddr, {MPU6XXX_RA_INT_ENABLE, 0x00})--关闭所有中断
    --i2c.send(i2cid, i2cslaveaddr, {MPU6XXX_RA_USER_CTRL, 0x00})--I2C主模式关闭
    i2c.send(i2cid, i2cslaveaddr, {MPU6XXX_RA_PWR_MGMT_1, 0x01})--设置x轴的pll为参考
    i2c.send(i2cid, i2cslaveaddr, {MPU6XXX_RA_PWR_MGMT_2, 0x00})--加速度计与陀螺仪开启
    log.info("i2c init_ok")
end
--获取温度的原始数据
function mpu6xxx_get_temp_raw()
    i2c.send(i2cid, i2cslaveaddr,MPU6XXX_RA_TEMP_OUT_H)--获取的地址
    buffer = i2c.recv(i2cid, i2cslaveaddr, 2)--获取2字节
    temp = string.unpack(">h",buffer)
    --log.info("get_temp_raw type: "..type(buffer).." hex: "..buffer:toHex().." temp: "..temp)
    return temp or 0
end
--获取加速度计的原始数据
function mpu6xxx_get_accel_raw()
    accel={x=nil,y=nil,z=nil}
    i2c.send(i2cid, i2cslaveaddr,MPU6XXX_RA_ACCEL_XOUT_H)--获取的地址
    x = i2c.recv(i2cid, i2cslaveaddr, 2)--获取6字节
    accel.x = string.unpack(">h",x)
    i2c.send(i2cid, i2cslaveaddr,MPU6XXX_RA_ACCEL_YOUT_H)--获取的地址
    y = i2c.recv(i2cid, i2cslaveaddr, 2)--获取6字节
    accel.y = string.unpack(">h",y)
    i2c.send(i2cid, i2cslaveaddr,MPU6XXX_RA_ACCEL_ZOUT_H)--获取的地址
    z = i2c.recv(i2cid, i2cslaveaddr, 2)--获取6字节
    accel.z = string.unpack(">h",z)
    --log.info("get_accel_raw: x="..x:toHex().." y="..y:toHex().." z="..z:toHex())
    return accel or 0
end
--获取陀螺仪的原始数据
function mpu6xxx_get_gyro_raw()
    gyro={x=nil,y=nil,z=nil}
    i2c.send(i2cid, i2cslaveaddr,MPU6XXX_RA_GYRO_XOUT_H)--获取的地址
    x = i2c.recv(i2cid, i2cslaveaddr, 2)--获取6字节
    gyro.x = string.unpack(">h",x)
    i2c.send(i2cid, i2cslaveaddr,MPU6XXX_RA_GYRO_YOUT_H)--获取的地址
    y = i2c.recv(i2cid, i2cslaveaddr, 2)--获取6字节
    gyro.y = string.unpack(">h",y)
    i2c.send(i2cid, i2cslaveaddr,MPU6XXX_RA_GYRO_ZOUT_H)--获取的地址
    z = i2c.recv(i2cid, i2cslaveaddr, 2)--获取6字节
    gyro.z = string.unpack(">h",z)
    return gyro or 0
end
--获取温度的原始数据
function mpu6xxx_get_temp()
    temp=nil
    tmp = mpu6xxx_get_temp_raw()
    if deviceid == MPU6050_WHO_AM_I then
        temp = tmp / MPU60X0_TEMP_SEN + MPU60X0_TEMP_OFFSET
    else
        temp = tmp / MPU6500_TEMP_SEN + MPU6500_TEMP_OFFSET
    end
    return temp
end
--获取加速度计的数据，单位: mg
function mpu6xxx_get_accel()
    accel={x=nil,y=nil,z=nil}
    tmp = mpu6xxx_get_accel_raw()
    accel.x = tmp.x*1000/MPU6XXX_ACCEL_SEN
    accel.y = tmp.y*1000/MPU6XXX_ACCEL_SEN
    accel.z = tmp.z*1000/MPU6XXX_ACCEL_SEN
    return accel
end
--获取陀螺仪的数据，单位: deg / 10s
function mpu6xxx_get_gyro()
    gyro={x=nil,y=nil,z=nil}
    tmp = mpu6xxx_get_gyro_raw()
    gyro.x = tmp.x*100/MPU6XXX_GYRO_SEN
    gyro.y = tmp.y*100/MPU6XXX_GYRO_SEN
    gyro.z = tmp.z*100/MPU6XXX_GYRO_SEN
    return gyro
end
function check_i2c()
    if i2c.setup(i2cid,i2c.SLOW) ~= i2c.SLOW then
        log.error("testI2c.init","fail")
        return
    end
    if mpu6xxx_check()~= 0 then
        return
    end
end

function init_mpu6050()
    log.info("init_mpu6050 start---------------")
    sys.wait(1000)
    check_i2c()
    mpu6xxx_init()
    log.info("init_mpu6050 end---------------")

    -- -- judge value range
    -- x_max =0
    -- x_min =0
    -- y_max =0
    -- y_min =0
    -- z_max =0
    -- z_min =0
    -- temp_a_ymax   = 0
    value_range = {{1100,-994},{1020,-1090},{1590,-1320}}
    -- log.info(value_range[2][2])
end

-- judge value range
function judge_x(temp)
    if temp > x_max then
        x_max = temp
        return
    end
    if temp < x_min then
        x_min = temp
        return
    end
end

function judge_y(temp)
    if temp > y_max then
        y_max = temp
        return
    end
    if temp < y_min then
        y_min = temp
        return
    end
end

function judge_z(temp)
    if temp > z_max then
        z_max = temp
        return
    end
    if temp < z_min then
        z_min = temp
        return
    end
end

function get_mpu6xxx_value()
    t = mpu6xxx_get_temp()
    -- log.info("6050temptest", t)
    a = mpu6xxx_get_accel()
    -- log.info("6050acceltest", "accel.x",a.x,"accel.y",a.y,"accel.z",a.z)
    g = mpu6xxx_get_gyro()
    -- log.info("6050gyrotest", "gyro.x",g.x,"gyro.y",g.y,"gyro.z",g.z)

    -- judge value range
    -- judge_x(a.x)
    -- judge_y(a.y)
    -- judge_z(a.z)
    -- log.info("x",x_max,x_min,"y",y_max,y_min,"z",z_max,z_min)
    return a
end



-- mpu value
-- x=1,y=2,z=3
bar_x_table = {}
bar_y_table = {}
bar_z_table = {}

bar_list = {}
bar_list["x"] = bar_x_table
bar_list["y"] = bar_y_table
bar_list["z"] = bar_z_table

bar_x_table["range_min"] = 0
bar_x_table["range_max"] = 100
bar_y_table["range_min"] = 0
bar_y_table["range_max"] = 100
bar_z_table["range_min"] = 0
bar_z_table["range_max"] = 100

label_list = {}
label_list["x"] = nil
label_list["y"] = nil
label_list["z"] = nil

list_mpu_tempvalue = {}
list_mpu_tempvalue["x"] = nil
list_mpu_tempvalue["y"] = nil
list_mpu_tempvalue["z"] = nil

bar_x_table["range_min"] = 0
bar_x_table["range_max"] = 100

function save_mpu_temp_value()
    temp_x = set_mpu6050_temp_value(value_range[1][1],value_range[1][2],temp_a.x,"x")
    temp_y = set_mpu6050_temp_value(value_range[2][1],value_range[2][2],temp_a.y,"y")
    temp_z = set_mpu6050_temp_value(value_range[3][1],value_range[3][2],temp_a.z,"z")

    -- log.info("exit save_mpu_value")
end

function save_mpu_value()
    temp_x = set_bar_value(value_range[1][1],value_range[1][2],temp_a.x,"x")
    temp_y = set_bar_value(value_range[2][1],value_range[2][2],temp_a.y,"y")
    temp_z = set_bar_value(value_range[3][1],value_range[3][2],temp_a.z,"z")
end

function set_bar_value(range_max,range_min,value,xyz)
    -- 这里的temp值是用于获取传感器的数值动态显示的
    -- log.info("in set_bar_value ")
    value_temp = value
    value_range_min,value_range_max = range_max,range_min
    value_temp2perc = (value_temp- value_range_min)/(value_range_max - value_range_min)
    bar_list[xyz]["range_min"] = 0 -- xyz需要三种最小值，该函数无法兼容，先强制设定
    value_perc2slider = math.floor(value_temp2perc * (bar_list[xyz]["range_max"]-bar_list[xyz]["range_min"]) + bar_list[xyz]["range_min"])

    V_str_per2slider = value_perc2slider-50

    list_mpu_tempvalue[xyz] =  V_str_per2slider
    -- log.info(value_perc2slider)
    return value_perc2slider
end

function set_mpu6050_temp_value(range_max,range_min,value,xyz)
    -- 这里的temp值是用于获取传感器的数值动态显示的
    -- log.info("in set_bar_value ")
    value_temp = value
    value_range_min,value_range_max = range_max,range_min
    value_temp2perc = (value_temp- value_range_min)/(value_range_max - value_range_min)
    bar_list[xyz]["range_min"] = 0 -- xyz需要三种最小值，该函数无法兼容，先强制设定
    value_perc2slider = math.floor(value_temp2perc * (bar_list[xyz]["range_max"]-bar_list[xyz]["range_min"]) + bar_list[xyz]["range_min"])

    V_str_per2slider = value_perc2slider-50

    list_mpu_tempvalue[xyz] =  V_str_per2slider
    -- log.info(value_perc2slider)
    return value_perc2slider
end

function init_mpu6050_slider_x()
    range_slider_min_x= 0 -- slider最小值
    range_slider_max_x =100 -- slider最大值
    range_slider = range_slider_max_x - range_slider_min_x

    return slider_mpu6050_x
end

function init_mpu6050_slider_y()
    range_slider_min_y= 0 -- slider最小值
    range_slider_max_y =100 -- slider最大值
    range_slider = range_slider_max_y - range_slider_min_y

    return slider_mpu6050_y
end

function init_mpu6050_slider_z()
    range_slider_min_z= 0 -- slider最小值
    range_slider_max_z =100 -- slider最大值
    range_slider = range_slider_max_z - range_slider_min_z

    return slider_mpu6050_z
end

function set_slider_value(range_max,range_min,value)
    -- 这里的temp值是用于获取传感器的数值动态显示的
    value_temp = value
    value_range_min,value_range_max = range_max,range_min
    value_temp2perc = (value_temp- value_range_min)/(value_range_max - value_range_min)
    range_slider_min = 0 -- xyz需要三种最小值，该函数无法兼容，先强制设定
    value_perc2slider = math.floor(value_temp2perc * range_slider + range_slider_min)

    -- log.info(value_perc2slider)
    return value_perc2slider
end

-- mpu event
function trigger_event()
    log.info("in trigger")
    sys.wait(500)
end

function mpu_event_right()
    log.info("event -> right")
    current_key = current_key+1
  --lvgl.label_set_text(label_event,"right")
end

function mpu_event_left()
    log.info("event <- left")
    current_key = current_key-1
  --lvgl.label_set_text(label_event,"left")
end

function mpu_event_up()
    log.info("event |` up")
  --lvgl.label_set_text(label_event,"up")
end

function mpu_event_down()
    log.info("event |_ down")
  --lvgl.label_set_text(label_event,"down")
end

function judge_status()
    if list_mpu_tempvalue["x"] > 25 then
        mpu_event_right()
        trigger_event()
    elseif list_mpu_tempvalue["x"] <-25 then
        mpu_event_left()
        trigger_event()
    -- else
    --     ---- -- log.info("return x")
    --     return 0
    end

    if list_mpu_tempvalue["y"] > 25 then
        mpu_event_up()
        trigger_event()
    elseif list_mpu_tempvalue["y"] <-25 then
        mpu_event_down()
        trigger_event()
    -- else
    --     ---- -- log.info("return x")
    --     return 0
    end
end