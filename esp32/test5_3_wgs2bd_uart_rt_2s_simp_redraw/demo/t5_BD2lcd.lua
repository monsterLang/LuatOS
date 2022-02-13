-- 输入BD09转化为lcd画点坐标（0，0）-（128，128）

status_redraw = 0

-- 变量
cur_BD = {120.534322,31.30762}-- 120.53389100,31.31025800 /xn,yn
cur_BD_bias = {}
cur_Ref = {}
cur_LCD = {}

-- 固定量，若固定量改变则所有的都要变
P00_BD = {120.54127500 ,31.31075200 } --120.53802300,31.30925600 /x0,y0
scale_max = 0.00738400  --BD最大偏移值，2scale_max 映射 128        这是图像精度，变小则图像在lcd上绘制大
LCD_max = 64     --64/128
-- LCD_max_x = 
-- LCD_max_y = 
P00_LCD = {64,64}   --64，64（参照点在屏幕中心） / 128，0（这个是参照点在屏幕左上角）    -- x0，y0在lcd上坐标偏移
P00_Ref = {0,0}     --暂时用不上，默认起始点对应0,0

BD_x_max = 0
BD_x_min = 0
BD_y_max = 0
BD_y_min = 0

-- lcd坐标范围
LCD_x_max = 128
LCD_x_min = 0
LCD_y_max = 128
LCD_y_min = 0

status_over_lcd = 0

LCD_cur_x = 0
LCD_cur_y = 0

-- 存储画点数据
LCD_list = {}
LCD_list_temp_num = 0
LCD_list_temp_num_max = 0
xy_list_BD = { 

}
xy_list_BD_num = 0
xy_list_BD_num_max = 0

-- init
function init_P00(x,y)
    P00_BD[1] = x
    P00_BD[2] = y
    print("init_P00 BD",x,y)

    BD_x_max = x
    BD_x_min = x
    BD_y_max = y
    BD_y_min = y
    print("BD_range",BD_x_max,BD_x_min,BD_y_max,BD_y_min)

    return x,y
end

function set_cur(x,y)
    cur_BD[1] = x
    cur_BD[2] = y 
    print("set_cur",x,y)
    return x,y
end

function set_scale_max(max)
    scale_max = max
    print("scale_max is:",scale_max)
    return 1
end

function judge_BD_range(x_c,y_c)
    -- log.info("judge_BD_range 1 ---------------")
    -- print(x_c,y_c)
    if x_c>BD_x_max then
        BD_x_max = x_c
    else if x_c<BD_x_min  then
        BD_x_min = x_c
    end
    end

    if y_c>BD_y_max then
        BD_y_max = y_c
    else if y_c<BD_y_min  then
        BD_y_min = y_c
    end
    end

    -- print("BD_range",BD_x_max,BD_x_min,BD_y_max,BD_y_min)
end

-- change
function BD_cur_bias(x_c,y_c,x_0,y_0)
    -- 取当前坐标最值
    

    -- 计算基于起始点的BD偏移
    if  type(x_0) == "nil" or type(y_0) == "nil"  then
        -- print("Please set start xy.")
    else
        print("now start xy is ",x_0.." , "..y_0)
    end

    if type(x_c) == "nil" or type(y_c) == "nil"then
        -- print("BD_cur_bias no input")
        -- print("P00_BD",table.concat( P00_BD , ","))
        -- print("cur_BD",table.concat( cur_BD , ","))
        BD_bias_x = cur_BD[1]-P00_BD[1]
        BD_bias_y = cur_BD[2]-P00_BD[2]
        judge_BD_range(cur_BD[1],cur_BD[2])
    else
        -- print("BD_cur_bias has input")
        BD_bias_x = x_c - x_0
        BD_bias_y = y_c - y_0
        judge_BD_range(x_c,y_c)
    end 

    print("BD",cur_BD[1],cur_BD[2],P00_BD[1],P00_BD[2])
    -- 存储当前BD偏移
    cur_BD_bias[1] = BD_bias_x
    cur_BD_bias[2] = BD_bias_y

    print("BD_cur_bias",table.concat(cur_BD_bias,','))
    -- print(BD_bias_x,BD_bias_y)
    return BD_bias_x,BD_bias_y
    
end

function Ref_cur_bias(x,y,lcdmax,scalemax)
    -- 归一化，计算基于 0，0的参考偏移
    if type(x) == "nil" or type(y) == "nil" or  type(lcdmax) == "nil" or type(scalemax) == "nil" then
        -- print("Ref_cur_bias no input")
        Ref_bias_x = math.floor(cur_BD_bias[1]*LCD_max/(scale_max))   -- + P00_Ref[1]
        Ref_bias_y = math.floor(cur_BD_bias[2]*LCD_max/(scale_max))   -- + P00_Ref[2]
    else
        Ref_bias_x = math.floor(x*lcdmax/(scalemax))   -- + P00_Ref[1]
        Ref_bias_y = math.floor(y*lcdmax/(scalemax))   -- + P00_Ref[2]
    end

    -- 存储参考偏移
    cur_Ref[1] = Ref_bias_x
    cur_Ref[2] = Ref_bias_y

    -- print("Ref_cur_bias",table.concat(cur_Ref,','))
    return Ref_bias_x,Ref_bias_y
end

function close_uart()
    status_over_lcd = 1
    uart_re_open = 0
    
end

function LCD_cur(x_c,y_c,x_0,y_0)
    -- 归一化，计算基于 0，0的参考偏移

    if type(x_c) == "nil" or type(y_c) == "nil" or type(x_0) == "nil" or type(y_0) == "nil" then
        -- print("LCD_cur no input")
        LCD_x = P00_LCD[1]+cur_Ref[1]
        LCD_y = P00_LCD[2]-cur_Ref[2]
    else
        LCD_x = x_0+x_c
        LCD_y = y_0-y_c
    end

    print("lcd: P00",P00_LCD[1],P00_LCD[2],cur_Ref[1],cur_Ref[2])

    LCD_cur_x = LCD_x
    LCD_cur_y = LCD_y
    print("LCD_cur",LCD_x..' , '..LCD_y)

    -- 防止超出屏幕
    if LCD_x > LCD_x_max  then
        LCD_x = LCD_x_max
        close_uart()
    elseif LCD_x < LCD_x_min then
        LCD_x = LCD_x_min
        close_uart()
    end

    if LCD_y > LCD_y_max  then
        LCD_y = LCD_y_max
        close_uart()
    elseif LCD_y < LCD_y_min then
        LCD_y = LCD_y_min
        close_uart()
    end

    print("status_over_lcd",status_over_lcd)

    -- 存储参数
    cur_LCD[1] = LCD_x
    cur_LCD[2] = LCD_y


    table.insert(LCD_list,LCD_x)
    table.insert(LCD_list,LCD_y)
    LCD_list_temp_num = LCD_list_temp_num + 1

    if LCD_list_temp_num > LCD_list_temp_num_max then
        LCD_list_temp_num_max = LCD_list_temp_num
    end
    print("LCD_list_temp_num: ", LCD_list_temp_num,"LCD_list_temp_num_max: "..LCD_list_temp_num_max)         -- 显示当前记录的点个数

    -- print("LCD_cur",table.concat(cur_LCD,' , '))
    return LCD_x,LCD_y
end

-- function BD2lcd(temp_P00_BD , temp_cur_BD, temp_scale_max , temp_LCD_max , temp_P00_LCD)
    

-- end

-- 直接基于全局变量运算
function BD2lcd()
    -- 计算基于起始点的经纬度偏移
    BD_cur_bias()

    -- 归一化当前lcd坐标
    Ref_cur_bias()

    -- 返回计算的lcd坐标
    return LCD_cur()
end

-- 方法1：直接对全局变量进行处理
-- BD2lcd()

-- 方法2：对入参进行处理
-- LCD_cur(Ref_cur_bias(BD_cur_bias(cur_BD[1],cur_BD[2],P00_BD[1],P00_BD[2]),scale_max,LCD_max),P00_LCD[1],P00_LCD[2])

-- 方法3：传入数组处理，相当于1
-- function input_all_value(cutBD,P00BD,scalemax,lcdmax,P00lcd)
--     LCD_cur(Ref_cur_bias(BD_cur_bias(cutBD[1],cutBD[2],P00BD[1],P00BD[2]),scalemax,lcdmax),P00lcd[1],P00lcd[2])
-- end

-- input_all_value(cur_BD,P00_BD,scale_max,LCD_max,P00_LCD)

-- 用于当lcd画线时，横纵坐标相同时从小的点画到大的点
function judge_lcd_xy_same(x1,y1,x2,y2)
    if x1 == x2 then
        if y1>y2 then
            temp = y1
            y1 = y2
            y2 = temp
        end
    end
    if y1 == y2 then
        if x1>x2 then
            temp = x1
            x1 = x2
            x2 = temp
        end
    end
    return x1,y1,x2,y2
    
end