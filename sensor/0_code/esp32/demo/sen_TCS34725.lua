-- 色彩传感器
-- 初始化spi
function TCS34725_init_spi(t_spi_id,t_addr,t_speed)
    if i2c.setup(t_spi_id, t_speed, -1, 1) ~= t_speed then
        log.error("i2c", "setup fail", addr_TCS34725)
        return
    end
    addr_TCS34725 = t_addr
end

-- 读取数据
function TCS34725_send(...)
    sys.wait(10)
    if not addr_TCS34725 then 
        log.info("i2c", "addr_TCS34725 err")
        return 
    end
    local t = {...}
    if i2c.send(i2cid, addr_TCS34725, t) ~= #t then
        log.error("i2c", "send fail", #t)
        return
    end
    return true
end

-- 发送数据
function TCS34725_read(n)
    sys.wait(10)
    if not addr_TCS34725 then 
        log.info("i2c", "addr_TCS34725 err")
        return "\x00" 
    end
    val = i2c.recv(i2cid, addr_TCS34725, n)
    if val and #val>0 then
        return val
    end
    return "\x00"
end

-- 初始化
function TCS34725_init(t_spi_id,t_speed)
    TCS34725_init_spi(t_spi_id,0x29,t_speed)  -- addr默认为0x29
    TCS34725_send(0x83, 0xff)
    TCS34725_send(0x81, 0x00)
    TCS34725_send(0x8f, 0x00)
    TCS34725_send(0x80, 0x03)
end

-- 颜色识别传感器
function TCS34725_get()

    -- 发送命令
    TCS34725_send(0x94)

    -- 接收数据
    _, c, red, green, blue = pack.unpack(TCS34725_read(8), "<HHHH")

    -- 判定结果
    if red and green and blue then
        lux = (-0.32466 * red) + (1.57837 * green) + (-0.73191 * blue)
        log.info("red", red)
        log.info("green", green)
        log.info("blue", blue)
        log.info("c, lux", c, lux)
    else
        log.info("TCS34725", "err")
    end

    return lux

end