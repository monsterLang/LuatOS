
TCS34725_i2c_id = 0

-- 色彩传感器
-- 初始化spi
function TCS34725_init_spi(t_i2c_id,t_addr,t_speed)
    if i2c.setup(t_i2c_id, t_speed, -1, 1) ~= t_speed then
        log.error("i2c", "setup fail", TCS34725_i2c_addr)
        return
    end
    TCS34725_i2c_addr = t_addr
    TCS34725_i2c_id = t_i2c_id
end

-- 读取数据
function TCS34725_send(...)
    sys.wait(10)
    if not TCS34725_i2c_addr then
        log.info("i2c", "TCS34725_i2c_addr err")
        return 
    end
    local t = {...}
    if i2c.send(TCS34725_i2c_id, TCS34725_i2c_addr, t) ~= true then
        log.error("i2c", "send fail", #t)
        return
    end
    return true
end

-- 发送数据
function TCS34725_read(n)
    sys.wait(10)
    if not TCS34725_i2c_addr then 
        log.info("i2c", "TCS34725_i2c_addr err")
        return "\x00" 
    end
    val = i2c.recv(TCS34725_i2c_id, TCS34725_i2c_addr, n)
    if val and #val>0 then
        return val
    end
    return "\x00"
end

-- 初始化
function TCS34725_init(t_i2c_id,t_speed)
    TCS34725_init_spi(t_i2c_id,0x29,t_speed)  -- addr默认为0x29
    TCS34725_send(0x83, 0xff)
    TCS34725_send(0x81, 0x00)
    TCS34725_send(0x8f, 0x00)
    TCS34725_send(0x80, 0x03)
end

-- 颜色识别传感器
function TCS34725_get()
    sys.wait(4000)
    -- 发送命令
    TCS34725_send(0x94)

    -- 接收数据
    _, c, red, green, blue = pack.unpack(TCS34725_read(8), "<HHHH")

    print("red",red,"green",green,"blue",blue)

    R = math.floor(red/c* 31 * 2048)
    G = math.floor(green/c* 63 * 32)
    B = math.floor(blue/c* 31 * 1)

    temp_rgb16 = R+G+B
    print(red/c* 255,green/c* 255,blue/c* 255)
    

    print(19498)
    print(temp_rgb16)
    -- lcd.fill(0,129,128,160,temp_rgb16)

    max = red
    if green>max then
        max = green
    end
    if blue>max then
        max = blue
    end 

    R = math.floor(red/c* 31 )
    G = math.floor(green/c* 63 )
    B = math.floor(blue/c* 31)

    -- temp_r,temp_g,temp_b = red/c* 31,green/c* 63,blue/c* 31 
    -- R = math.floor(temp_r * 2048)
    -- G = math.floor(temp_g * 32)
    -- B = math.floor(temp_b * 1)
    temp_rgb16 = R* 2048+G* 32+B * 1

    lcd.clear()
    lcd.fill(0,129,128,160,0xFFFF)
    lcd.setFont(lcd.font_opposansm8)
    lcd.drawStr(0,25,"R:  "..red)
    lcd.drawStr(65,25,R)
    lcd.drawStr(0,50,"G:  "..green)
    lcd.drawStr(65,50,G)
    lcd.drawStr(0,75,"B:  "..blue)
    lcd.drawStr(65,75,B)
    lcd.drawStr(0,100,"C:  "..c)
    lcd.fill(0,129,128,160,temp_rgb16)

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