require("t5_BD2lcd")
require("t5_wgs2BD")
require("t5_uart_air551")

function wgs2lcd(x,y)
    -- wgs ddmm格式转为BD09
    BD_x , BD_y = ddmm2BD(x,y)
    print(BD_x , BD_y )
    set_cur(BD_x,BD_y)
    temp_lcd_x ,temp_lcd_y = BD2lcd()

    return temp_lcd_x ,temp_lcd_y 
end

function rt_draw_line()

    if LCD_list_temp_num > 1 then

        -- -- 绘制线  and LCD_list_temp_num < xy_list_BD_num_max 
        if LCD_list_temp_num > 1  then

            print("normal draw line",LCD_list_temp_num)

            log.info(LCD_list[2*LCD_list_temp_num-3],LCD_list[2*LCD_list_temp_num-2],LCD_list[2*LCD_list_temp_num-1],LCD_list[2*LCD_list_temp_num])

            -- 同横纵坐标时交换x、y，从小值画到大值
            a,b,c,d = judge_lcd_xy_same(LCD_list[2*LCD_list_temp_num-3],LCD_list[2*LCD_list_temp_num-2],LCD_list[2*LCD_list_temp_num-1],LCD_list[2*LCD_list_temp_num])
            print(a,b,c,d)

            log.info("lcd.drawLine", lcd.drawLine(a,b,c,d,0x001F))

        end
    end

end

function rt_draw_circle()

    -- 画当前的点
    log.info("lcd.drawCircle", lcd.drawCircle(LCD_list[2*LCD_list_temp_num-1],LCD_list[2*LCD_list_temp_num],1,0xF800))

    -- 显示坐标信息（lcd/经纬度）
    m_BD = "BD:"..cur_BD[1].." , "..cur_BD[2]
    m_lcd = "lcd:"..LCD_list[2*LCD_list_temp_num-1].." , "..LCD_list[2*LCD_list_temp_num]
    -- log.info(type(m),m)

    lcd.fill(0, 130, 128, 145)  -- 清除显示文本内容
    lcd.fill(0, 145, 64, 160)
    lcd.setFont(lcd.font_opposansm8)    --设置字体
    lcd.drawStr(0,140,m_BD)            -- 显示经纬度
    lcd.drawStr(0,155,m_lcd)            -- 显示经纬度
    -- log.info("LCD_list_temp_num",LCD_list_temp_num)

    -- 画线
    rt_draw_line()

    sys.wait(100)  -- 为什么删了就会清空屏幕
end

function init_rt_test()
    -- 初始化uart
    rt_init_uart_air551()
    status_P00 = 0
    num_uart_re = 0
end

function rt_wgs2lcd()

    --获取当前经纬度及状态
    rt_x ,rt_y = GGA_list["x"],GGA_list["y"]    -- 待uart输入
    rt_status = GGA_list["status"]          

    -- print(num_rt_receive)
    lcd.fill(64, 145, 128, 160)
    lcd.setFont(lcd.font_opposansm8)
    lcd.drawStr(64,155,num_rt_receive)

    -- 注意此时状态为字符型
    if rt_status == "1" then

        -- 未定位起始点
        if status_P00 == 0 then
            -- print("P00_BD")
            print( "WGS_ddmm : ("..rt_x.." , "..rt_y..")" ,"status"..rt_status)
            init_P00(ddmm2BD(rt_x ,rt_y))
            set_scale_max( 0.0002  )

            -- 清空坐标表
            xy_list_BD = {}
            xy_list_BD_num = 0
            xy_list_BD_num_max = 0
            LCD_list = {}
            LCD_list_temp_num = 0

            cur_BD_bias = {}
            cur_Ref = {}
            cur_LCD = {}

            BD_x_max = 0
            BD_x_min = 0
            BD_y_max = 0
            BD_y_min = 0

            status_P00 = 1
        end

        -- 已经定位了起始点
        if status_P00 == 1 then
            print("************** point start****************")

            xy_list_BD_num = xy_list_BD_num+1
            -- 记录当前坐标个数
            if xy_list_BD_num_max < xy_list_BD_num then
                xy_list_BD_num_max = xy_list_BD_num
            end

            print( "WGS_ddmm : ("..rt_x.." , "..rt_y..")" ,"status"..rt_status)
            -- 转换位BD09
            BD_temp_x ,BD_temp_y = ddmm2BD(rt_x ,rt_y)
            -- 存储百度坐标
            table.insert( xy_list_BD, BD_temp_x )
            table.insert( xy_list_BD, BD_temp_y )
            -- 存储当前处理的百度坐标，后续运算直接用该值
            cur_BD[1] = BD_temp_x
            cur_BD[2] = BD_temp_y

            -- 打印当前的百度坐标
            print("BD_ddd   : ("..cur_BD[1].." , "..cur_BD[2]..")","LCD_list_temp_num : ",LCD_list_temp_num )
            -- log.info("**lcd point : ",LCD_list_temp_num,"("..cur_BD[1].." , "..cur_BD[2]..")")

            -- 百度坐标转换为lcd坐标
            rt_lcd_x , rt_lcd_y = BD2lcd()

            rt_draw_circle()
            print("LCD_list:"..table.concat( LCD_list, ","))

        print("************** point end****************")
        end

        rt_status = "0"
    else
        -- print("当前未定位")
    end

    -- 画一个点就重绘，用于及时放大
    -- rt_redraw_pic()
end

-- 获取uart数据并画点
function realtime_test()
    -- print("num_rt_receive",num_rt_receive,"num_uart_re",num_uart_re)
    if num_rt_receive > num_uart_re then
        num_uart_re = num_rt_receive
        rt_wgs2lcd()
    end
end

function rt_redraw_pic()

    -- print("BD_range",BD_x_max,BD_x_min,BD_y_max,BD_y_min)
    -- 计算所有百度坐标的经纬度最大差值（用于映射到lcd中）
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

    -- 重绘时如果当前的归一化度量小于最大偏移，就重新画坐标
    if range_bias ~= scale_max then
        print("重新绘制")
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
        xy_list_BD_temp_num = 0     -- 当前处理BD点数
        LCD_list_temp_num = 0       -- 当前处理的lcd点数
        -- test()
    else
        return
    end

end