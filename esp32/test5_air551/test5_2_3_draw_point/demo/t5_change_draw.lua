
-- -- version 1 
-- -- {
-- data_GGA_WGS_mm_0 = {x0,y0}
-- data_GGA_WGS_dd_0 = {x0_dd,y0_dd}
-- -- data_GGA_BD_dd_0 = {x0_bd_dd,y0_bd_dd}
-- data_GGA_BD_dd_0 = {120.541275,31.31075200}

-- data_GGA_WGS_mm_temp = {x_temp_mm,y_temp_mm}
-- data_GGA_WGS_dd_temp = {x_temp_dd,y_temp_dd}
-- -- data_GGA_BD_dd_temp = {x_temp_bd_dd,y_temp_bd_dd}
-- data_GGA_BD_dd_temp = {120.53432200 ,31.30762000 }


-- GGA_BD_xy_list = { {120.541275,31.31075200},
-- {120.533891,31.310258},
-- {120.534322,31.30762},
-- {120.541599,31.308268},
-- {120.538922,31.309857}}

-- LCD_xy_list={}

-- temp_xy = {}

-- -- 归一化
-- Max_xy = 0.00738400

-- -- -- {
-- -- -- 计算与原点的偏移值
-- -- Map_size_max = 128

-- -- lcd_bias = 128

-- -- -- 加上原点坐标计算最终显示点位
-- -- Origin_x = 128
-- -- Origin_y = 0 + lcd_bias  -- 0才是对应的坐标，但是为了加上128让坐标为正数
-- -- -- }

-- -- 计算与原点的偏移值
-- Map_size_max = 128 --64/128

-- lcd_bias = 0

-- -- 加上原点坐标计算最终显示点位
-- Origin_x = 128   -- 64/128
-- Origin_y = 0 + lcd_bias  --64/0
-- -- 0才是对应的坐标，但是为了加上128让坐标为正数

-- function GGA_bias2lcd_point()
--     -- 计算与初始经纬度（原点）的偏差
--     GGA_BD_dd_bias_temp_x = data_GGA_BD_dd_temp[1]-data_GGA_BD_dd_0[1]
--     GGA_BD_dd_bias_temp_y = data_GGA_BD_dd_temp[2]-data_GGA_BD_dd_0[2]

--     -- 归一化
--     GGA_BD_dd_bias_normal_temp_x = GGA_BD_dd_bias_temp_x/Max_xy
--     GGA_BD_dd_bias_normal_temp_y = GGA_BD_dd_bias_temp_y/Max_xy

-- -- 计算与原点的偏移值
--     GGA_BD_dd_bias_normal_lcdbias_temp_x = math.floor(GGA_BD_dd_bias_normal_temp_x * Map_size_max)
--     GGA_BD_dd_bias_normal_lcdbias_temp_y = math.floor(GGA_BD_dd_bias_normal_temp_y * Map_size_max)

--     -- 加上原点坐标计算最终显示点位
--     GGA_BD_dd_bias_normal_lcdbias_end_temp_x = GGA_BD_dd_bias_normal_lcdbias_temp_x + Origin_x
--     GGA_BD_dd_bias_normal_lcdbias_end_temp_y = -GGA_BD_dd_bias_normal_lcdbias_temp_y + Origin_y

--     print(GGA_BD_dd_bias_normal_lcdbias_end_temp_x,GGA_BD_dd_bias_normal_lcdbias_end_temp_y)
--     -- temp_xy[1] = GGA_BD_dd_bias_normal_lcdbias_end_temp_x
--     -- temp_xy[2] = GGA_BD_dd_bias_normal_lcdbias_end_temp_y
--     -- log.info(temp_xy[1],temp_xy[2])
--     if GGA_BD_dd_bias_normal_lcdbias_end_temp_x < 0 then
--         GGA_BD_dd_bias_normal_lcdbias_end_temp_x = 0
--     end
--     if GGA_BD_dd_bias_normal_lcdbias_end_temp_x > 128 then
--         GGA_BD_dd_bias_normal_lcdbias_end_temp_x = 128
--     end
--     if GGA_BD_dd_bias_normal_lcdbias_end_temp_y < 0 then
--         GGA_BD_dd_bias_normal_lcdbias_end_temp_y = 0
--     end
--     if GGA_BD_dd_bias_normal_lcdbias_end_temp_y > 128 then
--         GGA_BD_dd_bias_normal_lcdbias_end_temp_y = 128
--     end
--     table.insert(LCD_xy_list,GGA_BD_dd_bias_normal_lcdbias_end_temp_x)
--     table.insert(LCD_xy_list,GGA_BD_dd_bias_normal_lcdbias_end_temp_y)
-- end

-- function test_change()

--     for i = 1, 5, 1 do
--         data_GGA_BD_dd_temp = GGA_BD_xy_list[i]
--         GGA_bias2lcd_point()
--         -- log.info("lcd.drawPoint", lcd.drawPoint(GGA_BD_dd_bias_normal_lcdbias_end_temp_x,GGA_BD_dd_bias_normal_lcdbias_end_temp_y,0x0CE0))
--         -- log.info("lcd.drawLine", lcd.drawLine(LCD_xy_list[i],LCD_xy_list[i],LCD_xy_list[i],LCD_xy_list[i],0x001F))
--     end

--     for i = 1, 4, 1 do

--         -- log.info("lcd.drawPoint", lcd.drawPoint(GGA_BD_dd_bias_normal_lcdbias_end_temp_x,GGA_BD_dd_bias_normal_lcdbias_end_temp_y,0x0CE0))
--         log.info("lcd.drawLine", lcd.drawLine(LCD_xy_list[2*i-1],LCD_xy_list[2*i],LCD_xy_list[2*i+1],LCD_xy_list[2*i+2],0x001F))
--     end

-- end

-- -- }


-- -- version 2 ： 重绘坐标完成
-- -- {
--     data_GGA_WGS_mm_0 = {x0,y0}
--     data_GGA_WGS_dd_0 = {x0_dd,y0_dd}
--     -- data_GGA_BD_dd_0 = {x0_bd_dd,y0_bd_dd}
--     data_GGA_BD_dd_0 = {120.541275,31.31075200}
    
--     data_GGA_WGS_mm_temp = {x_temp_mm,y_temp_mm}
--     data_GGA_WGS_dd_temp = {x_temp_dd,y_temp_dd}
--     -- data_GGA_BD_dd_temp = {x_temp_bd_dd,y_temp_bd_dd}
--     data_GGA_BD_dd_temp = {120.53432200 ,31.30762000 }
    
--     GGA_BD_xy_list_num = 0
--     GGA_BD_xy_list = { {120.541275,31.31075200},
--     {120.533891,31.310258},
--     {120.534322,31.30762},
--     {120.541599,31.308268},
--     {120.538922,31.309857}}
    
--     LCD_xy_list={}
    
--     temp_xy = {}
    
--     -- 归一化
--     Max_xy = 0.00738400
    
--     -- -- {
--     -- -- 计算与原点的偏移值
--     -- Map_size_max = 128
    
--     -- lcd_bias = 128
    
--     -- -- 加上原点坐标计算最终显示点位
--     -- Origin_x = 128
--     -- Origin_y = 0 + lcd_bias  -- 0才是对应的坐标，但是为了加上128让坐标为正数
--     -- -- }
    
--     -- 计算与原点的偏移值
--     Map_size_max = 128 --64/128
    
--     lcd_bias = 0
    
--     -- 加上原点坐标计算最终显示点位
--     Origin_x = 128   -- 64/128
--     Origin_y = 0 + lcd_bias  --64/0
--     -- 0才是对应的坐标，但是为了加上128让坐标为正数
    
--     function GGA_bias2lcd_point()
--         -- 计算与初始经纬度（原点）的偏差
--         GGA_BD_dd_bias_temp_x = data_GGA_BD_dd_temp[1]-data_GGA_BD_dd_0[1]
--         GGA_BD_dd_bias_temp_y = data_GGA_BD_dd_temp[2]-data_GGA_BD_dd_0[2]
            
--         -- 归一化
--         GGA_BD_dd_bias_normal_temp_x = GGA_BD_dd_bias_temp_x/Max_xy
--         GGA_BD_dd_bias_normal_temp_y = GGA_BD_dd_bias_temp_y/Max_xy
    
--     -- 计算与原点的偏移值
--         GGA_BD_dd_bias_normal_lcdbias_temp_x = math.floor(GGA_BD_dd_bias_normal_temp_x * Map_size_max)
--         GGA_BD_dd_bias_normal_lcdbias_temp_y = math.floor(GGA_BD_dd_bias_normal_temp_y * Map_size_max)
    
--         -- 加上原点坐标计算最终显示点位
--         GGA_BD_dd_bias_normal_lcdbias_end_temp_x = GGA_BD_dd_bias_normal_lcdbias_temp_x + Origin_x
--         GGA_BD_dd_bias_normal_lcdbias_end_temp_y = -GGA_BD_dd_bias_normal_lcdbias_temp_y + Origin_y
    
--         print(GGA_BD_dd_bias_normal_lcdbias_end_temp_x,GGA_BD_dd_bias_normal_lcdbias_end_temp_y)
--         -- temp_xy[1] = GGA_BD_dd_bias_normal_lcdbias_end_temp_x
--         -- temp_xy[2] = GGA_BD_dd_bias_normal_lcdbias_end_temp_y
--         -- log.info(temp_xy[1],temp_xy[2])
--         if GGA_BD_dd_bias_normal_lcdbias_end_temp_x < 0 then
--             GGA_BD_dd_bias_normal_lcdbias_end_temp_x = 0
--         end
--         if GGA_BD_dd_bias_normal_lcdbias_end_temp_x > 128 then
--             GGA_BD_dd_bias_normal_lcdbias_end_temp_x = 128
--         end
--         if GGA_BD_dd_bias_normal_lcdbias_end_temp_y < 0 then
--             GGA_BD_dd_bias_normal_lcdbias_end_temp_y = 0
--         end
--         if GGA_BD_dd_bias_normal_lcdbias_end_temp_y > 128 then
--             GGA_BD_dd_bias_normal_lcdbias_end_temp_y = 128
--         end
--         table.insert(LCD_xy_list,GGA_BD_dd_bias_normal_lcdbias_end_temp_x)
--         table.insert(LCD_xy_list,GGA_BD_dd_bias_normal_lcdbias_end_temp_y)
--     end
    
--     function test_change()
    
--         for i = 1, 5, 1 do
--             GGA_BD_xy_list_num = GGA_BD_xy_list_num + 1
--             data_GGA_BD_dd_temp = GGA_BD_xy_list[i]
--             GGA_bias2lcd_point()
--             -- log.info("lcd.drawPoint", lcd.drawPoint(GGA_BD_dd_bias_normal_lcdbias_end_temp_x,GGA_BD_dd_bias_normal_lcdbias_end_temp_y,0x0CE0))
--             -- log.info("lcd.drawLine", lcd.drawLine(LCD_xy_list[i],LCD_xy_list[i],LCD_xy_list[i],LCD_xy_list[i],0x001F))
--         end

--         log.info("GGA_BD_xy_list_num",GGA_BD_xy_list_num)
    
--         -- for i = 1, 4, 1 do
    
--         --     -- log.info("lcd.drawPoint", lcd.drawPoint(GGA_BD_dd_bias_normal_lcdbias_end_temp_x,GGA_BD_dd_bias_normal_lcdbias_end_temp_y,0x0CE0))
--         --     log.info("lcd.drawLine", lcd.drawLine(LCD_xy_list[2*i-1],LCD_xy_list[2*i],LCD_xy_list[2*i+1],LCD_xy_list[2*i+2],0x001F))
--         -- end
--         redraw_line()
--     end
    
--     function redraw_line()
--         for i = 1, GGA_BD_xy_list_num-1, 1 do
--             if i <2 then
--                 log.info("lcd.drawPoint", lcd.drawPoint(LCD_xy_list[2*i-1],LCD_xy_list[2*i],0x0CE0))
--             end
--             -- log.info("lcd.drawPoint", lcd.drawPoint(GGA_BD_dd_bias_normal_lcdbias_end_temp_x,GGA_BD_dd_bias_normal_lcdbias_end_temp_y,0x0CE0))
--             log.info("lcd.drawLine", lcd.drawLine(LCD_xy_list[2*i-1],LCD_xy_list[2*i],LCD_xy_list[2*i+1],LCD_xy_list[2*i+2],0x001F))
--         end
--     end
--     -- }

-- -- version 3 ： 画点再连线
-- -- {
--     data_GGA_WGS_mm_0 = {x0,y0}
--     data_GGA_WGS_dd_0 = {x0_dd,y0_dd}
--     -- data_GGA_BD_dd_0 = {x0_bd_dd,y0_bd_dd}
--     data_GGA_BD_dd_0 = {120.541275,31.31075200}
    
--     data_GGA_WGS_mm_temp = {x_temp_mm,y_temp_mm}
--     data_GGA_WGS_dd_temp = {x_temp_dd,y_temp_dd}
--     -- data_GGA_BD_dd_temp = {x_temp_bd_dd,y_temp_bd_dd}
--     data_GGA_BD_dd_temp = {120.53432200 ,31.30762000 }
    
--     GGA_BD_xy_list_num = 0
--     GGA_BD_xy_list = { {120.541275,31.31075200},
--     {120.533891,31.310258},
--     {120.534322,31.30762},
--     {120.541599,31.308268},
    
--     {120.538922,31.309857}}
    
--     LCD_xy_list={}
    
--     temp_xy = {}
    
--     -- 归一化
--     -- Max_xy = 0.00000001
--     Max_xy = 0.00738400
    
--     -- -- {
--     -- -- 计算与原点的偏移值
--     -- Map_size_max = 128
    
--     -- lcd_bias = 128
    
--     -- -- 加上原点坐标计算最终显示点位
--     -- Origin_x = 128
--     -- Origin_y = 0 + lcd_bias  -- 0才是对应的坐标，但是为了加上128让坐标为正数
--     -- -- }
    
--     -- 计算与原点的偏移值
--     Map_size_max = 64 --64/128
    
--     lcd_bias = 0
    
--     -- 加上原点坐标计算最终显示点位
--     Origin_x = 64   -- 64/128
--     Origin_y = 64 + lcd_bias  --64/0
--     -- 0才是对应的坐标，但是为了加上128让坐标为正数
    
--     function GGA_bias2lcd_point()
--         -- 计算与初始经纬度（原点）的偏差
--         GGA_BD_dd_bias_temp_x = data_GGA_BD_dd_temp[1]-data_GGA_BD_dd_0[1]
--         GGA_BD_dd_bias_temp_y = data_GGA_BD_dd_temp[2]-data_GGA_BD_dd_0[2]
        
--         -- temp_abs = math.abs( GGA_BD_dd_bias_temp_x )
--         -- if Max_xy < temp_abs then
--         --     Max_xy = temp_abs
--         -- end
--         -- temp_abs = math.abs( GGA_BD_dd_bias_temp_y )
--         -- if Max_xy < temp_abs then
--         --     Max_xy = temp_abs
--         -- end
--         -- log.info("Max_xy = ",Max_xy)

--         -- 归一化
--         GGA_BD_dd_bias_normal_temp_x = GGA_BD_dd_bias_temp_x/Max_xy
--         GGA_BD_dd_bias_normal_temp_y = GGA_BD_dd_bias_temp_y/Max_xy
    
--     -- 计算与原点的偏移值
--         GGA_BD_dd_bias_normal_lcdbias_temp_x = math.floor(GGA_BD_dd_bias_normal_temp_x * Map_size_max)
--         GGA_BD_dd_bias_normal_lcdbias_temp_y = math.floor(GGA_BD_dd_bias_normal_temp_y * Map_size_max)
    
--         -- 加上原点坐标计算最终显示点位
--         GGA_BD_dd_bias_normal_lcdbias_end_temp_x = GGA_BD_dd_bias_normal_lcdbias_temp_x + Origin_x
--         GGA_BD_dd_bias_normal_lcdbias_end_temp_y = -GGA_BD_dd_bias_normal_lcdbias_temp_y + Origin_y
    
--         print(GGA_BD_dd_bias_normal_lcdbias_end_temp_x,GGA_BD_dd_bias_normal_lcdbias_end_temp_y)
--         -- temp_xy[1] = GGA_BD_dd_bias_normal_lcdbias_end_temp_x
--         -- temp_xy[2] = GGA_BD_dd_bias_normal_lcdbias_end_temp_y
--         -- log.info(temp_xy[1],temp_xy[2])
--         if GGA_BD_dd_bias_normal_lcdbias_end_temp_x < 0 then
--             GGA_BD_dd_bias_normal_lcdbias_end_temp_x = 0
--         end
--         if GGA_BD_dd_bias_normal_lcdbias_end_temp_x > 128 then
--             GGA_BD_dd_bias_normal_lcdbias_end_temp_x = 128
--         end
--         if GGA_BD_dd_bias_normal_lcdbias_end_temp_y < 0 then
--             GGA_BD_dd_bias_normal_lcdbias_end_temp_y = 0
--         end
--         if GGA_BD_dd_bias_normal_lcdbias_end_temp_y > 128 then
--             GGA_BD_dd_bias_normal_lcdbias_end_temp_y = 128
--         end
--         table.insert(LCD_xy_list,GGA_BD_dd_bias_normal_lcdbias_end_temp_x)
--         table.insert(LCD_xy_list,GGA_BD_dd_bias_normal_lcdbias_end_temp_y)

--         draw_line()
--     end
    
--     function test_change()
    
--         for i = 1, 5, 1 do
--             GGA_BD_xy_list_num = GGA_BD_xy_list_num + 1 -- 记录了多少个点
--             data_GGA_BD_dd_temp = GGA_BD_xy_list[i]     -- 测试，从表中取出点
--             GGA_bias2lcd_point()                        -- 执行转换坐标函数
            
--             -- log.info("lcd.drawPoint", lcd.drawPoint(GGA_BD_dd_bias_normal_lcdbias_end_temp_x,GGA_BD_dd_bias_normal_lcdbias_end_temp_y,0x0CE0))
--             -- log.info("lcd.drawLine", lcd.drawLine(LCD_xy_list[i],LCD_xy_list[i],LCD_xy_list[i],LCD_xy_list[i],0x001F))

--             -- 若最大值更新执行
--             -- redraw_line()
--             sys.wait(1000)
--         end

--         log.info("GGA_BD_xy_list_num",GGA_BD_xy_list_num)

        
--     end
    
--     function draw_line()
--         -- lcd.clear()
--         -- sys.wait(1000)

--         -- 画点
--         log.info("lcd.drawCircle", lcd.drawCircle(GGA_BD_dd_bias_normal_lcdbias_end_temp_x,GGA_BD_dd_bias_normal_lcdbias_end_temp_y,1,0x0CE0))

--         if GGA_BD_xy_list_num > 1 then
--             log.info("lcd.drawLine", lcd.drawLine(LCD_xy_list[2*GGA_BD_xy_list_num-3],LCD_xy_list[2*GGA_BD_xy_list_num-2],LCD_xy_list[2*GGA_BD_xy_list_num-1],LCD_xy_list[2*GGA_BD_xy_list_num],0x001F))
--         end
        

--     end

--     -- 用于最大值更新后再执行
--     function redraw_line()
--         -- lcd.clear()
--         -- sys.wait(1000)
--         for i = 1, GGA_BD_xy_list_num-1, 1 do
--             if 2*i-1 < 0 then
--                 log.info("lcd.drawPoint", lcd.drawPoint(LCD_xy_list[1],LCD_xy_list[2],0x0CE0))
--             else
--                 -- log.info("lcd.drawPoint", lcd.drawPoint(GGA_BD_dd_bias_normal_lcdbias_end_temp_x,GGA_BD_dd_bias_normal_lcdbias_end_temp_y,0x0CE0))
--                 log.info("lcd.drawLine", lcd.drawLine(LCD_xy_list[2*i-1],LCD_xy_list[2*i],LCD_xy_list[2*i+1],LCD_xy_list[2*i+2],0x001F))
--             end

--         end
--     end
--     -- }

-- -- version 4 ： 显示当前经纬度坐标、lcd坐标
-- -- {
--     data_GGA_WGS_mm_0 = {x0,y0}
--     data_GGA_WGS_dd_0 = {x0_dd,y0_dd}
--     -- data_GGA_BD_dd_0 = {x0_bd_dd,y0_bd_dd}
--     data_GGA_BD_dd_0 = {120.541275,31.31075200}
    
--     data_GGA_WGS_mm_temp = {x_temp_mm,y_temp_mm}
--     data_GGA_WGS_dd_temp = {x_temp_dd,y_temp_dd}
--     -- data_GGA_BD_dd_temp = {x_temp_bd_dd,y_temp_bd_dd}
--     data_GGA_BD_dd_temp = {120.53432200 ,31.30762000 }
    
--     GGA_BD_xy_list_num = 0
--     GGA_BD_xy_list = { {120.541275,31.31075200},
    
--     {120.534322,31.30762},
--     {120.541599,31.308268},
--     {120.533891,31.310258},
--     {120.538922,31.309857}}
    
--     LCD_xy_list={}
    
--     temp_xy = {}

--     m = ""
    
--     -- 归一化
--     -- Max_xy = 0.00000001
--     Max_xy = 0.00738400
    
--     -- -- {
--     -- -- 计算与原点的偏移值
--     -- Map_size_max = 128
    
--     -- lcd_bias = 128
    
--     -- -- 加上原点坐标计算最终显示点位
--     -- Origin_x = 128
--     -- Origin_y = 0 + lcd_bias  -- 0才是对应的坐标，但是为了加上128让坐标为正数
--     -- -- }
    
--     -- 计算与原点的偏移值
--     Map_size_max = 64 --64/128
    
--     lcd_bias = 0
    
--     -- 加上原点坐标计算最终显示点位
--     Origin_x = 64   -- 64/128
--     Origin_y = 64 + lcd_bias  --64/0
--     -- 0才是对应的坐标，但是为了加上128让坐标为正数
    
--     function GGA_bias2lcd_point()
--         -- 计算与初始经纬度（原点）的偏差
--         GGA_BD_dd_bias_temp_x = data_GGA_BD_dd_temp[1]-data_GGA_BD_dd_0[1]
--         GGA_BD_dd_bias_temp_y = data_GGA_BD_dd_temp[2]-data_GGA_BD_dd_0[2]
        
--         -- temp_abs = math.abs( GGA_BD_dd_bias_temp_x )
--         -- if Max_xy < temp_abs then
--         --     Max_xy = temp_abs
--         -- end
--         -- temp_abs = math.abs( GGA_BD_dd_bias_temp_y )
--         -- if Max_xy < temp_abs then
--         --     Max_xy = temp_abs
--         -- end
--         -- log.info("Max_xy = ",Max_xy)

--         -- 归一化
--         GGA_BD_dd_bias_normal_temp_x = GGA_BD_dd_bias_temp_x/Max_xy
--         GGA_BD_dd_bias_normal_temp_y = GGA_BD_dd_bias_temp_y/Max_xy
    
--     -- 计算与原点的偏移值
--         GGA_BD_dd_bias_normal_lcdbias_temp_x = math.floor(GGA_BD_dd_bias_normal_temp_x * Map_size_max)
--         GGA_BD_dd_bias_normal_lcdbias_temp_y = math.floor(GGA_BD_dd_bias_normal_temp_y * Map_size_max)
    
--         -- 加上原点坐标计算最终显示点位
--         GGA_BD_dd_bias_normal_lcdbias_end_temp_x = GGA_BD_dd_bias_normal_lcdbias_temp_x + Origin_x
--         GGA_BD_dd_bias_normal_lcdbias_end_temp_y = -GGA_BD_dd_bias_normal_lcdbias_temp_y + Origin_y
    
--         print(GGA_BD_dd_bias_normal_lcdbias_end_temp_x,GGA_BD_dd_bias_normal_lcdbias_end_temp_y)
--         -- temp_xy[1] = GGA_BD_dd_bias_normal_lcdbias_end_temp_x
--         -- temp_xy[2] = GGA_BD_dd_bias_normal_lcdbias_end_temp_y
--         -- log.info(temp_xy[1],temp_xy[2])
--         if GGA_BD_dd_bias_normal_lcdbias_end_temp_x < 0 then
--             GGA_BD_dd_bias_normal_lcdbias_end_temp_x = 0
--         end
--         if GGA_BD_dd_bias_normal_lcdbias_end_temp_x > 128 then
--             GGA_BD_dd_bias_normal_lcdbias_end_temp_x = 128
--         end
--         if GGA_BD_dd_bias_normal_lcdbias_end_temp_y < 0 then
--             GGA_BD_dd_bias_normal_lcdbias_end_temp_y = 0
--         end
--         if GGA_BD_dd_bias_normal_lcdbias_end_temp_y > 128 then
--             GGA_BD_dd_bias_normal_lcdbias_end_temp_y = 128
--         end
--         table.insert(LCD_xy_list,GGA_BD_dd_bias_normal_lcdbias_end_temp_x)
--         table.insert(LCD_xy_list,GGA_BD_dd_bias_normal_lcdbias_end_temp_y)

--         draw_line()
--     end
    
--     function test_change()
    
--         for i = 1, 5, 1 do
--             GGA_BD_xy_list_num = GGA_BD_xy_list_num + 1 -- 记录了多少个点
--             data_GGA_BD_dd_temp = GGA_BD_xy_list[i]     -- 测试，从表中取出点
--             GGA_bias2lcd_point()                        -- 执行转换坐标函数
            
--             -- log.info("lcd.drawPoint", lcd.drawPoint(GGA_BD_dd_bias_normal_lcdbias_end_temp_x,GGA_BD_dd_bias_normal_lcdbias_end_temp_y,0x0CE0))
--             -- log.info("lcd.drawLine", lcd.drawLine(LCD_xy_list[i],LCD_xy_list[i],LCD_xy_list[i],LCD_xy_list[i],0x001F))

--             -- 若最大值更新执行
--             -- redraw_line()
--             sys.wait(1000)
--         end

--         log.info("GGA_BD_xy_list_num",GGA_BD_xy_list_num)

        
--     end
    
--     function draw_line()
--         -- lcd.clear()
--         -- sys.wait(1000)

--         -- 画点
--         log.info("lcd.drawCircle", lcd.drawCircle(GGA_BD_dd_bias_normal_lcdbias_end_temp_x,GGA_BD_dd_bias_normal_lcdbias_end_temp_y,1,0xF800))
--         -- log.info(type(GGA_BD_dd_bias_normal_lcdbias_end_temp_x),type(GGA_BD_dd_bias_normal_lcdbias_end_temp_y),GGA_BD_dd_bias_normal_lcdbias_end_temp_x,GGA_BD_dd_bias_normal_lcdbias_end_temp_y)

--         -- 显示坐标信息（lcd/经纬度）
--         -- m = GGA_BD_dd_bias_normal_lcdbias_end_temp_x..","..GGA_BD_dd_bias_normal_lcdbias_end_temp_y
--         m = data_GGA_BD_dd_temp[1].." , "..data_GGA_BD_dd_temp[2]
--         log.info(type(m),m)

--         lcd.fill(0, 130, 129, 160)
--         lcd.setFont(lcd.font_opposansm8)
--         lcd.drawStr(0,140,m)

--         if GGA_BD_xy_list_num > 1 then
--             log.info("lcd.drawLine", lcd.drawLine(LCD_xy_list[2*GGA_BD_xy_list_num-3],LCD_xy_list[2*GGA_BD_xy_list_num-2],LCD_xy_list[2*GGA_BD_xy_list_num-1],LCD_xy_list[2*GGA_BD_xy_list_num],0x001F))
--         end
        

--     end

--     -- 用于最大值更新后再执行
--     function redraw_line()
--         -- lcd.clear()
--         -- sys.wait(1000)
--         for i = 1, GGA_BD_xy_list_num-1, 1 do
--             if 2*i-1 < 0 then
--                 log.info("lcd.drawPoint", lcd.drawPoint(LCD_xy_list[1],LCD_xy_list[2],0x0CE0))
--             else
--                 -- log.info("lcd.drawPoint", lcd.drawPoint(GGA_BD_dd_bias_normal_lcdbias_end_temp_x,GGA_BD_dd_bias_normal_lcdbias_end_temp_y,0x0CE0))
--                 log.info("lcd.drawLine", lcd.drawLine(LCD_xy_list[2*i-1],LCD_xy_list[2*i],LCD_xy_list[2*i+1],LCD_xy_list[2*i+2],0x001F))
--             end

--         end
--     end
--     -- }

-- version 4 ： 更新最大值
-- {
    data_GGA_WGS_mm_0 = {x0,y0}
    data_GGA_WGS_dd_0 = {x0_dd,y0_dd}
    -- data_GGA_BD_dd_0 = {x0_bd_dd,y0_bd_dd}

    -- 起始点位置
    -- data_GGA_BD_dd_0 = {120.541275,31.31075200} -- 公司
    data_GGA_BD_dd_0 =  {119.478979,32.199603}  -- 学校
                        

    data_GGA_WGS_mm_temp = {x_temp_mm,y_temp_mm}
    data_GGA_WGS_dd_temp = {x_temp_dd,y_temp_dd}
    -- data_GGA_BD_dd_temp = {x_temp_bd_dd,y_temp_bd_dd}
    data_GGA_BD_dd_temp = {119.477546,32.20058 } -- 公司
    
    GGA_BD_xy_list_num = 0

    GGA_BD_xy_list = { 
        -- 学校
        {119.477546,32.20058},
        {119.473719,32.206519},
        {119.472255,32.206282},
        {119.472237,32.202448},
        {119.47795,32.197712},
        {119.478418,32.196398},
        {119.481714,32.197773},
        {119.481481,32.198377},
        {119.48069,32.198453}

        -- -- 公司
        -- {120.541275,31.31075200},
        -- {120.533891,31.310258},
        -- {120.534322,31.30762},
        -- {120.541599,31.308268},
        -- {120.538922,31.309857}
    }

    log.info(data_GGA_BD_dd_0[1],data_GGA_BD_dd_0[2])
    GGA_BD_xy_list_x_max = data_GGA_BD_dd_0[1]
    GGA_BD_xy_list_x_min = data_GGA_BD_dd_0[1]
    GGA_BD_xy_list_y_max = data_GGA_BD_dd_0[2]
    GGA_BD_xy_list_y_min = data_GGA_BD_dd_0[2]
    log.info(GGA_BD_xy_list_x_max,GGA_BD_xy_list_x_min,GGA_BD_xy_list_y_max,GGA_BD_xy_list_y_min)

    -- 计算表的数据个数，并查找最大值
    function table_leng(t)
        local leng=0
        for k, v in pairs(t) do
            leng=leng+1

            if GGA_BD_xy_list[leng][1]>GGA_BD_xy_list_x_max then
                GGA_BD_xy_list_x_max = GGA_BD_xy_list[leng][1]
            else if GGA_BD_xy_list[leng][1]<GGA_BD_xy_list_x_min  then
                GGA_BD_xy_list_x_min = GGA_BD_xy_list[leng][1]
            end
            end

            if GGA_BD_xy_list[leng][2]>GGA_BD_xy_list_y_max then
                GGA_BD_xy_list_y_max = GGA_BD_xy_list[leng][2]
            else if GGA_BD_xy_list[leng][2]<GGA_BD_xy_list_x_min  then
                GGA_BD_xy_list_y_min = GGA_BD_xy_list[leng][2]
            end
            end
        end
        return leng
    end
    GGA_BD_xy_list_num_max = table_leng(GGA_BD_xy_list)
    log.info("table list len",GGA_BD_xy_list_num_max)

    -- log.info(GGA_BD_xy_list_x_max-data_GGA_BD_dd_0[1],GGA_BD_xy_list_x_min-data_GGA_BD_dd_0[1],GGA_BD_xy_list_y_max-data_GGA_BD_dd_0[2],GGA_BD_xy_list_y_min-data_GGA_BD_dd_0[2])
    log.info(GGA_BD_xy_list_x_max,GGA_BD_xy_list_x_min,GGA_BD_xy_list_y_max,GGA_BD_xy_list_y_min)
    
    
    LCD_xy_list={}
    
    temp_xy = {}

    m = ""
    
    -- 用于将图片绘制最大
    -- 坐标和原点的最大差值
    normal_x_max = 0.00273500 
    normal_x_min = -0.00674200 
    normal_x_range = normal_x_max-normal_x_min
    normal_y_max = 0.00691600  
    normal_y_min = -0.00320500 
    normal_y_range = normal_y_max-normal_y_min

    normal_range = 0
    if normal_y_range > normal_x_range then
        normal_range = normal_y_range
        Map_size_max_x = normal_x_range/normal_range*128
        Map_size_max_y = 128

    else
        normal_range = normal_x_range
        Map_size_max_x = 128
        Map_size_max_y = normal_y_range/normal_range*128
    end

    Max_xy = normal_range

    Origin_x = normal_x_max/normal_x_range *128
    Origin_y = normal_y_max/normal_y_range *128
    -- GGA_BD_xy_list


    -- 归一化
    -- Max_xy = 0.00000001
    -- Max_xy = 0.00738400 --公司
    -- Max_xy = 0.01012100 


    
    -- -- {
    -- -- 计算与原点的偏移值
    -- Map_size_max = 128
    
    -- lcd_bias = 128
    
    -- -- 加上原点坐标计算最终显示点位
    -- Origin_x = 128
    -- Origin_y = 0 + lcd_bias  -- 0才是对应的坐标，但是为了加上128让坐标为正数
    -- -- }
    
    -- 计算与原点的偏移值

    lcd_bias = 0
    
    -- 加上原点坐标计算最终显示点位
    Origin_x = 91   -- 64/128
    Origin_y = 87 + lcd_bias  --64/0
    -- 0才是对应的坐标，但是为了加上128让坐标为正数
    
    function GGA_bias2lcd_point()
        -- 计算与初始经纬度（原点）的偏差
        GGA_BD_dd_bias_temp_x = data_GGA_BD_dd_temp[1]-data_GGA_BD_dd_0[1]
        GGA_BD_dd_bias_temp_y = data_GGA_BD_dd_temp[2]-data_GGA_BD_dd_0[2]
        
        -- temp_abs = math.abs( GGA_BD_dd_bias_temp_x )
        -- if Max_xy < temp_abs then
        --     Max_xy = temp_abs
        -- end
        -- temp_abs = math.abs( GGA_BD_dd_bias_temp_y )
        -- if Max_xy < temp_abs then
        --     Max_xy = temp_abs
        -- end
        -- log.info("Max_xy = ",Max_xy)

        -- 归一化
        GGA_BD_dd_bias_normal_temp_x = GGA_BD_dd_bias_temp_x/Max_xy
        GGA_BD_dd_bias_normal_temp_y = GGA_BD_dd_bias_temp_y/Max_xy
    
    -- 计算与原点的偏移值
        GGA_BD_dd_bias_normal_lcdbias_temp_x = math.floor(GGA_BD_dd_bias_normal_temp_x * Map_size_max_x)
        GGA_BD_dd_bias_normal_lcdbias_temp_y = math.floor(GGA_BD_dd_bias_normal_temp_y * Map_size_max_y)
    
        -- 加上原点坐标计算最终显示点位
        GGA_BD_dd_bias_normal_lcdbias_end_temp_x = GGA_BD_dd_bias_normal_lcdbias_temp_x + Origin_x
        GGA_BD_dd_bias_normal_lcdbias_end_temp_y = -GGA_BD_dd_bias_normal_lcdbias_temp_y + Origin_y
    
        print(GGA_BD_dd_bias_normal_lcdbias_end_temp_x,GGA_BD_dd_bias_normal_lcdbias_end_temp_y)
        -- temp_xy[1] = GGA_BD_dd_bias_normal_lcdbias_end_temp_x
        -- temp_xy[2] = GGA_BD_dd_bias_normal_lcdbias_end_temp_y
        -- log.info(temp_xy[1],temp_xy[2])
        if GGA_BD_dd_bias_normal_lcdbias_end_temp_x < 0 then
            GGA_BD_dd_bias_normal_lcdbias_end_temp_x = 0
        end
        if GGA_BD_dd_bias_normal_lcdbias_end_temp_x > 128 then
            GGA_BD_dd_bias_normal_lcdbias_end_temp_x = 128
        end
        if GGA_BD_dd_bias_normal_lcdbias_end_temp_y < 0 then
            GGA_BD_dd_bias_normal_lcdbias_end_temp_y = 0
        end
        if GGA_BD_dd_bias_normal_lcdbias_end_temp_y > 128 then
            GGA_BD_dd_bias_normal_lcdbias_end_temp_y = 128
        end
        table.insert(LCD_xy_list,GGA_BD_dd_bias_normal_lcdbias_end_temp_x)
        table.insert(LCD_xy_list,GGA_BD_dd_bias_normal_lcdbias_end_temp_y)

        draw_line()
    end
    
    function test_change()
    
        for i = 1, GGA_BD_xy_list_num_max, 1 do
            GGA_BD_xy_list_num = GGA_BD_xy_list_num + 1 -- 记录了多少个点
            data_GGA_BD_dd_temp = GGA_BD_xy_list[i]     -- 测试，从表中取出点
            GGA_bias2lcd_point()                        -- 执行转换坐标函数
            
            -- log.info("lcd.drawPoint", lcd.drawPoint(GGA_BD_dd_bias_normal_lcdbias_end_temp_x,GGA_BD_dd_bias_normal_lcdbias_end_temp_y,0x0CE0))
            -- log.info("lcd.drawLine", lcd.drawLine(LCD_xy_list[i],LCD_xy_list[i],LCD_xy_list[i],LCD_xy_list[i],0x001F))

            -- 若最大值更新执行
            -- redraw_line()
            sys.wait(1000)
        end

        log.info("GGA_BD_xy_list_num",GGA_BD_xy_list_num)

        
    end
    
    function draw_line()
        -- lcd.clear()
        -- sys.wait(1000)

        -- 画点,圆半径为2
        log.info("lcd.drawCircle", lcd.drawCircle(GGA_BD_dd_bias_normal_lcdbias_end_temp_x,GGA_BD_dd_bias_normal_lcdbias_end_temp_y,2,0xF800))
        -- log.info(type(GGA_BD_dd_bias_normal_lcdbias_end_temp_x),type(GGA_BD_dd_bias_normal_lcdbias_end_temp_y),GGA_BD_dd_bias_normal_lcdbias_end_temp_x,GGA_BD_dd_bias_normal_lcdbias_end_temp_y)

        -- 显示坐标信息（lcd/经纬度）
        -- m = GGA_BD_dd_bias_normal_lcdbias_end_temp_x..","..GGA_BD_dd_bias_normal_lcdbias_end_temp_y
        m = data_GGA_BD_dd_temp[1].." , "..data_GGA_BD_dd_temp[2]
        log.info(type(m),m)

        lcd.fill(0, 130, 129, 160)  -- 清除显示文本内容
        lcd.setFont(lcd.font_opposansm8)    --设置字体
        lcd.drawStr(0,140,m)            -- 显示经纬度


        log.info("GGA_BD_xy_list_num",GGA_BD_xy_list_num)

        -- 首尾相接
        if GGA_BD_xy_list_num == GGA_BD_xy_list_num_max then
            log.info("lcd.drawLine", lcd.drawLine(LCD_xy_list[3],LCD_xy_list[4],LCD_xy_list[2*GGA_BD_xy_list_num-1],LCD_xy_list[2*GGA_BD_xy_list_num],0x001F))
        end

        -- 绘制线
        if GGA_BD_xy_list_num > 2  then
            log.info(LCD_xy_list[2*GGA_BD_xy_list_num-3],LCD_xy_list[2*GGA_BD_xy_list_num-2],LCD_xy_list[2*GGA_BD_xy_list_num-1],LCD_xy_list[2*GGA_BD_xy_list_num])

            log.info("lcd.drawLine", lcd.drawLine(LCD_xy_list[2*GGA_BD_xy_list_num-3],LCD_xy_list[2*GGA_BD_xy_list_num-2],LCD_xy_list[2*GGA_BD_xy_list_num-1],LCD_xy_list[2*GGA_BD_xy_list_num],0x001F))

            m_lcd = LCD_xy_list[2*GGA_BD_xy_list_num-3]..","..LCD_xy_list[2*GGA_BD_xy_list_num-2].."  "..LCD_xy_list[2*GGA_BD_xy_list_num-1]..","..LCD_xy_list[2*GGA_BD_xy_list_num]
            lcd.drawStr(0,155,m_lcd)
        end


        

    end

    -- 用于最大值更新后再执行
    function redraw_line()
        -- lcd.clear()
        -- sys.wait(1000)
        for i = 1, GGA_BD_xy_list_num-1, 1 do
            if 2*i-1 < 0 then
                log.info("lcd.drawPoint", lcd.drawPoint(LCD_xy_list[1],LCD_xy_list[2],0x0CE0))
            else
                -- log.info("lcd.drawPoint", lcd.drawPoint(GGA_BD_dd_bias_normal_lcdbias_end_temp_x,GGA_BD_dd_bias_normal_lcdbias_end_temp_y,0x0CE0))
                log.info("lcd.drawLine", lcd.drawLine(LCD_xy_list[2*i-1],LCD_xy_list[2*i],LCD_xy_list[2*i+1],LCD_xy_list[2*i+2],0x001F))
            end

        end
    end
    -- }