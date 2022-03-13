--[[
接线要求:

SPI 使用常规4线解法
Air105开发板         TF模块
PB03(SPI2_CSN)        CS
PB02(SPI2_CLK)       CLK
PB05(SPI2_MISO)      MOSI
PB04(SPI2_MOSI)      MISO
5V                   VCC
GND                  GND
]]

function fatfs_105_test()
    -- sys.wait(1000) -- 启动延时

    print("enter fatfs_105_test")


    -- if spi_id ~= 0 and spi_id ~= 1 and spi_id ~= 2 and spi_id ~= 5 then
    --     print("error spi_id, air105 support 0/1/2/5")
    --     return 
    -- else
    --     spiId = spi_id
    -- end
    -- if spiId == 0 then
    --     spiCS = pin.PB13
    -- else if spiId == 1 then
    --     spiCS = pin.PA07
    -- else if spiId == 2 then
    --     spiCS = pin.PB03
    -- else if spiId == 5 then
    --     spiCS = pin.PC14
    -- end
    -- end
    -- end
    -- end




    spiId = 2
    spiCS = pin.PB03    --GPIO19
    print("spiId is "..spiId,"spics is "..spiCS)

    print("setup spi")
    local result = spi.setup(
        spiId,--串口id
        spiCS, -- 不使用默认CS脚
        0,--CPHA
        0,--CPOL
        8,--数据宽度
        400*1000  -- 初始化时使用较低的频率
    )
    print("spi.setup result ",result)   -- 返回0表示spi初始化成功
    -- local TF_CS = pin.PB3   -- spi2的cs为PB03
    gpio.setup(spiCS, 1)


    print("start fatfs")
    -- fatfs.debug(1) -- 若挂载失败,可以尝试打开调试信息,查找原因
    print("fatfs debug")
    fatfs.mount("SD", 1, spiCS)     -- spi2: 2/19
    local data, err = fatfs.getfree("SD")
    if data then
        log.info("fatfs", "getfree", json.encode(data))
    else
        log.info("fatfs", "err", err)
    end

    -- 重新设置spi,使用更高速率
    spi.close(spiId)
    sys.wait(100)
    spi.setup(spiId, TF_CS, 0, 0, 8, 10*1000*1000)

    -- #################################################
    -- 文件操作测试
    -- #################################################
    local f = io.open("/sd/boottime", "rb")
    local c = 0
    if f then
        local data = f:read("*a")
        log.info("fs", "data", data, data:toHex())
        c = tonumber(data)
        f:close()
    end
    log.info("fs", "boot count", c)
    c = c + 1
    f = io.open("/sd/boottime", "wb")
    if f ~= nil then
        log.info("fs", "write c to file", c, tostring(c))
        f:write(tostring(c))
        f:close()
    else
        log.warn("sdio", "mount not good?!")
    end
    if fs then
        log.info("fsstat", fs.fsstat("/"))
        log.info("fsstat", fs.fsstat("/sd"))
    end

    -- 测试一下追加, fix in 2021.12.21
    os.remove("/sd/test_a")
    sys.wait(50)
    f = io.open("/sd/test_a", "w")
    if f then
        f:write("ABC")
        f:close()
    end
    f = io.open("/sd/test_a", "a+")
    if f then
        f:write("def")
        f:close()
    end
    f = io.open("/sd/test_a", "r")
    if  f then
        local data = f:read("*a")
        log.info("data", data, data == "ABCdef")
        f:close()
    end

    -- 测试一下按行读取, fix in 2022-01-16
    f = io.open("/sd/testline", "w")
    if f then
        f:write("abc\n")
        f:write("123\n")
        f:write("wendal\n")
        f:close()
    end
    sys.wait(100)
    f = io.open("/sd/testline", "r")
    if f then
        log.info("sdio", "line1", f:read("*l"))
        log.info("sdio", "line2", f:read("*l"))
        log.info("sdio", "line3", f:read("*l"))
        f:close()
    end

    -- #################################################

end


function sdio_105_test()
    log.info("sdio", "call sdio.init")
    spiId = 2
    print(sdio.init(spiId))

    log.info("sdio", "call sdio.sd_mount")
    sdio.sd_mount(spiId, "/sd")
    local f = io.open("/sd/boottime", "rb")
    local c = 0
    if f then
        local data = f:read("*a")
        log.info("fs", "data", data, data:toHex())
        c = tonumber(data)
        f:close()
    end
    log.info("fs", "boot count", c)
    c = c + 1
    f = io.open("/sd/boottime", "wb")
    if f ~= nil then
        log.info("fs", "write c to file", c, tostring(c))
        f:write(tostring(c))
        f:close()
    else
        log.warn("sdio", "mount not good?!")
    end
    if fs then
        log.info("fsstat", fs.fsstat("/"))
        log.info("fsstat", fs.fsstat("/sd"))
    end

    -- 测试一下追加, fix in 2021.12.21
    os.remove("/sd/test_a")
    sys.wait(50)
    f = io.open("/sd/test_a", "w")
    if f then
        f:write("ABC")
        f:close()
    end
    f = io.open("/sd/test_a", "a+")
    if f then
        f:write("def")
        f:close()
    end
    f = io.open("/sd/test_a", "r")
    if  f then
        local data = f:read("*a")
        log.info("data", data, data == "ABCdef")
        f:close()
    end

    -- 测试一下按行读取, fix in 2022-01-16
    f = io.open("/sd/testline", "w")
    if f then
        f:write("abc\n")
        f:write("123\n")
        f:write("wendal\n")
        f:close()
    end
    sys.wait(100)
    f = io.open("/sd/testline", "r")
    if f then
        log.info("sdio", "line1", f:read("*l"))
        log.info("sdio", "line2", f:read("*l"))
        log.info("sdio", "line3", f:read("*l"))
        f:close()
    end
end

--[[	
    spi名称    | spi号
    spi0        0       GPIOB_13
    spi1        1       GPIOA_07
    spi2        2       GPIOB_03
    hspi        5       GPIOC_14
    luat_spi_air105.c       luat_spi_setup
]]
function sfud_105(spi_id)
    print(spi_id)
    if spi_id ~= 0 and spi_id ~= 1 and spi_id ~= 2 and spi_id ~= 5 then
        print("error spi_id, air105 support 0/1/2/5")
        return 
    else
        spiId = spi_id
    end
    if spiId == 0 then
        spiCS = pin.PB13
    else if spiId == 1 then
        spiCS = pin.PA07
    else if spiId == 2 then
        spiCS = pin.PB03
    else if spiId == 5 then
        spiCS = pin.PC14
    end
    end
    end
    end

    print("spiId is "..spiId,"spics is "..spiCS)
    
    spi_flash = spi.deviceSetup(spiId,spiCS,0,0,8,2*100*1000,spi.MSB,1,0)--PA7
    log.info("sfud.init",sfud.init(spi_flash))
    log.info("sfud.getDeviceNum",sfud.getDeviceNum())
    sfud_device = sfud.getDeviceTable()
    log.info("sfud.write",sfud.write(sfud_device,1024,"sfud"))
    log.info("sfud.read",sfud.read(sfud_device,1024,4))
    log.info("sfud.mount",sfud.mount(sfud_device,"/sfud"))
    log.info("fsstat", fs.fsstat("/sfud"))

end
