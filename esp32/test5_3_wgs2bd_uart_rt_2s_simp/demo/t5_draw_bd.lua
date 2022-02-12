
require("t5_wgs2lcd")

-- init status
xy_list_BD_temp = {
    {119.477546,32.20058},
    {119.473719,32.206519},
    {119.472255,32.206282},
    {119.472237,32.202448},
    {119.47795,32.197712},
    {119.478418,32.196398},
    {119.481714,32.197773},
    {119.481481,32.198377},
    {119.48069,32.198453}
}
xy_list_BD_temp_num = 0
xy_list_BD_temp_num_max = 0
function table_leng(t)
    local leng=0
    for k, v in pairs(t) do
        leng=leng+1
    end
    log.info("xy_list_BD_temp len = ",xy_list_BD_temp_num)
    return leng
end

LCD_list = {}
LCD_list_temp_num = 0

function draw_line()
    -- lcd.clear()
    -- sys.wait(1000)

    -- 画点,圆半径为2
    -- log.info("lcd.drawCircle", lcd.drawCircle(cur_LCD[1],cur_LCD[2],1,0xF800))
    log.info("lcd.drawCircle", lcd.drawCircle(LCD_list[2*xy_list_BD_temp_num-1],LCD_list[2*xy_list_BD_temp_num],1,0xF800))

    -- 显示坐标信息（lcd/经纬度）
    m = cur_BD[1].." , "..cur_BD[2]
    -- log.info(type(m),m)

    lcd.fill(0, 130, 129, 160)  -- 清除显示文本内容
    lcd.setFont(lcd.font_opposansm8)    --设置字体
    lcd.drawStr(0,140,m)            -- 显示经纬度

    log.info("xy_list_BD_temp_num",xy_list_BD_temp_num)

    -- -- 首尾相接
    if xy_list_BD_temp_num == xy_list_BD_temp_num_max then

        print("xxxxx ebd",xy_list_BD_temp_num)
        print(LCD_list[3],LCD_list[4],LCD_list[2*xy_list_BD_temp_num-1],LCD_list[2*xy_list_BD_temp_num])
        log.info("lcd.drawLine", lcd.drawLine(LCD_list[3],LCD_list[4],LCD_list[2*xy_list_BD_temp_num-1],LCD_list[2*xy_list_BD_temp_num],0x001F))

        -- print(LCD_list[2*xy_list_BD_temp_num-3],LCD_list[2*xy_list_BD_temp_num-2],LCD_list[2*xy_list_BD_temp_num-1],LCD_list[2*xy_list_BD_temp_num])
        log.info("lcd.drawLine", lcd.drawLine(LCD_list[2*xy_list_BD_temp_num-1],LCD_list[2*xy_list_BD_temp_num],LCD_list[2*xy_list_BD_temp_num-3],LCD_list[2*xy_list_BD_temp_num-2],0x001F))

    end

    -- -- 绘制线
    if xy_list_BD_temp_num > 1 and xy_list_BD_temp_num < xy_list_BD_temp_num_max  then

        print("xxxxx",xy_list_BD_temp_num)

        log.info(LCD_list[2*xy_list_BD_temp_num-3],LCD_list[2*xy_list_BD_temp_num-2],LCD_list[2*xy_list_BD_temp_num-1],LCD_list[2*xy_list_BD_temp_num])

        log.info("lcd.drawLine", lcd.drawLine(LCD_list[2*xy_list_BD_temp_num-3],LCD_list[2*xy_list_BD_temp_num-2],LCD_list[2*xy_list_BD_temp_num-1],LCD_list[2*xy_list_BD_temp_num],0x001F))

        m_lcd = LCD_list[2*xy_list_BD_temp_num-3]..","..LCD_list[2*xy_list_BD_temp_num-2].."  "..LCD_list[2*xy_list_BD_temp_num-1]..","..LCD_list[2*xy_list_BD_temp_num]
        lcd.drawStr(0,155,m_lcd)
    end

    sys.wait(100)  -- 为什么删了就会清空屏幕
end


function init_status()
    log.info("init_status 1 ---------------")
    -- 首先要设置起始点
    init_P00( 119.478979,32.199603 )
    set_scale_max( 0.01012100  )

    -- 仅用于测试计算该值
    xy_list_BD_temp_num_max = table_leng(xy_list_BD_temp)
    xy_list_BD_num_max = xy_list_BD_temp_num_max
    
    log.info("init_status 0 ---------------")
end

function test_lib()
    log.info("test 1 ---------------")

    for i = 1, xy_list_BD_temp_num_max, 1 do
        xy_list_BD_temp_num = xy_list_BD_temp_num + 1 -- 记录了多少个点
        cur_BD[1] = xy_list_BD_temp[i][1]     -- 测试，从表中取出点
        cur_BD[2] = xy_list_BD_temp[i][2]

        -- 设置当前值
        log.info("---------lcd point",i,cur_BD[1],cur_BD[2])
        a , b = BD2lcd()
        -- print(a , b)
        -- table.insert(LCD_list,a)
        -- table.insert(LCD_list,b)


        -- draw_line()
        realtime_draw_line()

        print("LCD_list:"..table.concat( LCD_list, ","))
        
        -- GGA_bias2lcd_point()                        -- 执行转换坐标函数

        -- 若最大值更新执行
        -- redraw_line()
        -- sys.wait(1000)
    end
    print("LCD_list:"..table.concat( LCD_list, ","))

    -- 加上判定
    redraw_pic()

    -- log.info("xy_list_BD_temp_num",xy_list_BD_temp_num)

    log.info("test 0 ---------------")
end

function redraw_pic()

    -- print("BD_range",BD_x_max,BD_x_min,BD_y_max,BD_y_min)
    range_x = BD_x_max-BD_x_min
    range_y = BD_y_max-BD_y_min
    
    if range_x > range_y then
        range_bias = range_x
        Map_size_max_x = 128
        Map_size_max_y = range_y/range_bias*128
    else
        range_bias = range_y
        Map_size_max_x = range_x/range_bias*128
        Map_size_max_y = 128
    end


    if range_bias ~= scale_max then
        status_redraw = 1
        lcd.clear()
        set_scale_max( range_bias )
        LCD_max = 128
        P00_LCD[1] = math.floor((P00_BD[1]-BD_x_min)/range_x*128)
        P00_LCD[2] = math.floor((BD_y_max-P00_BD[2])/range_y*128)
        -- set_scale_max( 0.00738400*2 )
        -- LCD_max = 64
        -- P00_LCD = {64,64}
        print("P00_LCD",table.concat(P00_LCD , " , "  ))
        LCD_list  = {}
        -- LCD_list = {}
        xy_list_BD_temp_num = 0
        LCD_list_num = 0
        LCD_list_temp_num = 0
        test()
    else
        return
    end

end