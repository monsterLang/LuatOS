--- 模块功能：BH1750
-- @module BH1750
-- @author Dozingfiretruck ,youkai
-- @license MIT
-- @copyright OpenLuat.com
-- @release 2021.03.14

-- 源码https://doc.openluat.com/wiki/21?wiki_page_id=2668

-- require"utils"
-- require"bit"

-- pm.wake("BH1750")

local BH1750_i2c_id = 0 --BH1750_i2c_id       esp32 i2c 0

local BH1750_ADDRESS_AD0_LOW     =   0x23 -- address pin low (GND), default for InvenSense evaluation board
local BH1750_ADDRESS_AD0_HIGH    =   0x24 -- address pin high (VCC)

local BH1750_i2c_slaveaddr = BH1750_ADDRESS_AD0_LOW     -- ADDRES

-- BH1750 registers define
local BH1750_POWER_DOWN   	    =   0x00	-- power down
local BH1750_POWER_ON			=   0x01	-- power on
local BH1750_RESET			    =   0x07	-- reset
local BH1750_CON_H_RES_MODE	    =   0x10	-- Continuously H-Resolution Mode
local BH1750_CON_H_RES_MODE2	=   0x11	-- Continuously H-Resolution Mode2
local BH1750_CON_L_RES_MODE	    =   0x13	-- Continuously L-Resolution Mode
local BH1750_ONE_H_RES_MODE	    =   0x20	-- One Time H-Resolution Mode
local BH1750_ONE_H_RES_MODE2	=   0x21	-- One Time H-Resolution Mode2
local BH1750_ONE_L_RES_MODE	    =   0x23	-- One Time L-Resolution Mode

local function BH1750_i2c_send(data)
    i2c.send(BH1750_i2c_id, BH1750_i2c_slaveaddr, data)
end
local function BH1750_i2c_recv(num)
    local revData = i2c.recv(BH1750_i2c_id, BH1750_i2c_slaveaddr, num)
    return revData
end

local function BH1750_power_on()
    BH1750_i2c_send(BH1750_POWER_ON)
end

local function BH1750_power_down()
    BH1750_i2c_send(BH1750_POWER_DOWN)
end

local function BH1750_set_measure_mode(mode,time)
    BH1750_i2c_send(BH1750_RESET)
    BH1750_i2c_send(mode)
    sys.wait(time)
end

local function BH1750_read_light()
    BH1750_set_measure_mode(BH1750_CON_H_RES_MODE2, 180)
    _,light = pack.unpack(BH1750_i2c_recv(2),">h")
    light = light / 1.2
    return light;
end

function BH1750_init(t_i2c_id)
    BH1750_i2c_id = t_i2c_id
    -- log.info("BH1750_i2c_id",BH1750_i2c_id)
    -- mpu has init
    -- if i2c.setup(t_i2c_id,i2c.SLOW) ~= i2c.SLOW then
    --     log.error("I2c.init","fail")
    --     return
    -- else
    --     print("BH1750_init ok.")
    -- end

    BH1750_power_on()
end


function BH1750_get()
    local temp_light_value =BH1750_read_light()*10
    -- log.info("BH1750_read_light", temp_light_value)
    sys.wait(100)
    return temp_light_value
end
