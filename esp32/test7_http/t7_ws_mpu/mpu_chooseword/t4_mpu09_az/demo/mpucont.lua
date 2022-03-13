--- 模块功能：lvgl display mpu6050 xyz value
-- @module display mpucont value
-- @author youkai
-- @release 2022.02.03

require("mpu6xxx_nolocal")

-- 看起来label只能在初始化的时候调用，不确定是不是lua兼容的问题
-- function init_mpu6050_label()
--     --初始化
--     --{
--     label_mpu6050 = lvgl.label_create(lvgl.scr_act(), nil)    ---创建滑动条
--     -- lvgl.label_set_static_text(label_mpu6050, "0%")
--     lvgl.label_set_text(label_mpu6050, "0%")
--     -- lvgl.obj_set_width(label_mpu6050, 150);
--     -- lvgl.label_set_align(label_mpu6050, lvgl.LABEL_ALIGN_CENTER)
--     lvgl.obj_align(label_mpu6050, nil, lvgl.ALIGN_CENTER, 0, 0);
--     -- lvgl.obj_align(label_label, label, lvgl.ALIGN_OUT_BOTTOM_MID, 0, 10)
--     --}

--     log.info("scr_load",lvgl.scr_load(label_mpu6050))     --显示

--     sys.wait(2000)
--     -- lvgl.label_set_static_text(label_label, string.toValue(67).."%")
--     lvgl.label_set_text(label_label, "67%")

--     log.info("lvgl demo: label_mpu6050")
--     return label_mpu6050
-- end

-- function set_label_value(range_max,range_min,value)
--     -- 这里的temp值是用于获取传感器的数值动态显示的
--     value_temp = value
--     value_range_min,value_range_max = range_max,range_min
--     value_temp2perc = (value_temp- value_range_min)/(value_range_max - value_range_min)
--     value_perc2slider = math.floor(value_temp2perc * range_slider + range_slider_min)


--     log.info(value_perc2slider)
--     return value_perc2slider
--     -- lvgl.slider_set_value(slider, value_perc2slider, lvgl.ANIM_OFF)
--     -- log.info("scr_load",lvgl.scr_load(slider))     --显示
--     -- value_temp = temp_value
--     -- value_range_min,value_range_max = 0,50
--     -- value_temp2perc = value_temp/(value_range_max - value_range_min)
--     -- value_perc2slider = value_temp2perc * range_slider + range_slider_min


--     -- lvgl.slider_set_value(slider, value_perc2slider, lvgl.ANIM_OFF)   --直接设置不需要再执行scr_loadl 
-- end

function init_mpu6050_cont()
    -- 初始化容器cont
    --{
    mpu6050_cont = lvgl.cont_create(lvgl.scr_act(), nil)
    lvgl.obj_set_size(mpu6050_cont,128,160)
    lvgl.obj_set_auto_realign(mpu6050_cont, true)                    --Auto realign when the size changes*/
    lvgl.obj_align_origo(mpu6050_cont, nil, lvgl.ALIGN_IN_TOP_MID, 0, 0)  --This parametrs will be sued when realigned*/
    -- lvgl.cont_set_fit(mpu6050_cont, lvgl.FIT_TIGHT)     --此时cont依据内容拓展，容易左右超过界限
    -- lvgl.cont_set_fit(mpu6050_cont, lvgl.FIT_MAX)
    lvgl.cont_set_fit(mpu6050_cont, lvgl.FIT_NONE)   --此时cont未设置自适应状态，则内容在cont中
    -- lvgl.cont_set_layout(mpu6050_cont, lvgl.LAYOUT_COLUMN_MID)--字符布局居中
    -- lvgl.cont_set_layout(mpu6050_cont, lvgl.LAYOUT_COLUMN_LEFT) --布局靠左
    --}

    log.info("scr_load",lvgl.scr_load(mpu6050_cont))     --显示   容器

    label_mpu = lvgl.label_create(mpu6050_cont,nil)
    lvgl.label_set_text(label_mpu,"xyz accel value")
    lvgl.obj_align(label_mpu, nil,lvgl.ALIGN_IN_TOP_MID,0,0)

    -- label_test = lvgl.label_create(mpu6050_cont,nil)
    -- lvgl.label_set_text(label_test,"7")
    -- lvgl.obj_set_pos(label_test, 64, 130)

    -- sys.wait(2000)
    -- lvgl.label_set_text(label_test,"8")

    return mpu6050_cont
end

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

function init_bar_x()
    --初始化
    --{
    bar_x_table["bar"] = lvgl.bar_create(mpu6050_cont, nil)  -- 创建进度条
    lvgl.obj_set_size(bar_x_table["bar"], 115, 5)            -- 设置尺寸
    -- lvgl.obj_align(bar_x_table["bar"], NULL, lvgl.ALIGN_IN_TOP_MID, 0, 0)-- 设置位置居中
    lvgl.obj_set_pos(bar_x_table["bar"], 5, 5)
    --}

    lvgl.bar_set_value(bar_x_table["bar"], 0, lvgl.ANIM_OFF)-- 设置加载到的值，默认范围为0-100
    log.info("scr_load",lvgl.scr_load(bar_x_table["bar"]))     --显示
    
    
    bar_x_lab = lvgl.label_create(mpu6050_cont, nil)
    -- lvgl.obj_set_size(bar_x_lab, 10, 10)
    lvgl.label_set_text(bar_x_lab,"x")
    -- lvgl.obj_set_auto_realign(bar_x_lab, true)
    lvgl.obj_align(bar_x_lab, bar_x_table["bar"], lvgl.ALIGN_OUT_BOTTOM_MID, 0, 0)
    -- lvgl.obj_set_pos(bar_x_lab,0,20)
    -- lvgl.label_set_text(bar_x_lab,"x")
    -- log.info("scr_load",lvgl.disp_load_scr(bar_x_lab))
    -- log.info("scr_load",lvgl.scr_load(bar_x_lab))
    
    -- range_bar_min_x= 0 -- bar最小值
    -- range_bar_max_x =100 -- bar最大值
    -- range_bar = range_bar_max_x - range_bar_min_x
    bar_x_table["range_min"] = 0
    bar_x_table["range_max"] = 100
    lvgl.bar_set_range(bar_x_table["bar"], bar_x_table["range_min"],bar_x_table["range_max"])  

    -- log.info("x range",bar_x_table["range_min"],bar_x_table["range_max"])
    -- log.info("x range",bar_list["x"]["range_min"],bar_list["x"]["range_max"])

    -- bar_x_table["range_max"] = 1000
    -- log.info("x range",bar_x_table["range_min"],bar_x_table["range_max"])
    -- log.info("x range",bar_list["x"]["range_min"],bar_list["x"]["range_max"])

    -- return bar_x_table
end

function init_bar_xyz()
    init_bar("x")
    init_bar("y")
    init_bar("z")
    -- si_x = init_mpu6050_slider_x()
    -- si_y = init_mpu6050_slider_y()
    -- si_z = init_mpu6050_slider_z()
end


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

function display_mpu_value()

    save_mpu_value()
    -- log.info("temp_x",temp_x)
    -- temp_x = set_slider_value(value_range[1][1],value_range[1][2],temp_a.x)
    -- temp_y = set_slider_value(value_range[2][1],value_range[2][2],temp_a.y,"y")
    -- temp_z = set_slider_value(value_range[3][1],value_range[3][2],temp_a.z)

    lvgl.bar_set_value(bar_list["x"]["bar"], temp_x, lvgl.ANIM_OFF)
    lvgl.bar_set_value(bar_list["y"]["bar"], temp_y, lvgl.ANIM_OFF)
    lvgl.bar_set_value(bar_list["z"]["bar"], temp_z, lvgl.ANIM_OFF)
    -- lvgl.slider_set_value(si_x, temp_x, lvgl.ANIM_OFF)
    -- lvgl.slider_set_value(si_y, temp_y, lvgl.ANIM_OFF)
    -- lvgl.slider_set_value(si_z, temp_z, lvgl.ANIM_OFF)

    -- log.debug("get-------",lvgl.slider_get_value(si_1))
    -- log.info("layout update")
end

function init_bar(xyz)
    
    --初始化
    --{
    bar_list[xyz]["bar"] = lvgl.bar_create(mpu6050_cont, nil)  -- 创建进度条
    lvgl.obj_set_size(bar_list[xyz]["bar"], 115, 5)            -- 设置尺寸
    -- lvgl.obj_align(bar_x_table["bar"], NULL, lvgl.ALIGN_IN_TOP_MID, 0, 0)-- 设置位置居中
    if xyz == "x"then
        lvgl.obj_set_pos(bar_list[xyz]["bar"], 5, 30)
    elseif xyz == "y" then
        lvgl.obj_set_pos(bar_list[xyz]["bar"], 5, 60)
    elseif xyz == "z" then
        lvgl.obj_set_pos(bar_list[xyz]["bar"], 5, 90)
    end
    --}

    lvgl.bar_set_value(bar_list[xyz]["bar"], 0, lvgl.ANIM_OFF)-- 设置加载到的值，默认范围为0-100

    bar_list[xyz]["label"] = lvgl.label_create(mpu6050_cont, nil)
    lvgl.label_set_text(bar_list[xyz]["label"],xyz)
    -- lvgl.obj_set_auto_realign(bar_x_lab, true)
    lvgl.obj_align(bar_list[xyz]["label"], bar_list[xyz]["bar"], lvgl.ALIGN_OUT_BOTTOM_MID, 0, 0)
    -- lvgl.obj_set_pos(bar_x_lab,0,20)
    -- lvgl.label_set_text(bar_x_lab,"x")
    -- log.info("scr_load",lvgl.disp_load_scr(bar_x_lab))
    -- log.info("scr_load",lvgl.scr_load(bar_x_lab))

    -- -- 创建label显示当前值
    label_list[xyz]  = lvgl.label_create(mpu6050_cont, nil)
    lvgl.label_set_text(label_list[xyz]," : "..tostring(value_perc2slider))
    lvgl.obj_align(label_list[xyz], bar_list[xyz]["label"], lvgl.ALIGN_OUT_RIGHT_MID, 0, 0)

    -- bar_list[xyz]["range_min"] = 0
    -- bar_list[xyz]["range_max"] = 100
    lvgl.bar_set_range(bar_list[xyz]["bar"], bar_list[xyz]["range_min"],bar_list[xyz]["range_max"])  
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
    lvgl.label_set_text(label_list[xyz]," : "..tostring(V_str_per2slider))      -- 设置bar对应label的显示内容，如果不显示bar则需要删除该项，否则回导致运行异常（bar没有被创建却被设值）,所以另外创建一个函数专门只存储数据

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
    -- lvgl.label_set_text(label_list[xyz]," : "..tostring(V_str_per2slider))

    list_mpu_tempvalue[xyz] =  V_str_per2slider
    -- log.info(value_perc2slider)
    return value_perc2slider
end

function init_mpu6050_slider_x()
    --初始化
    --{
    slider_mpu6050_x = lvgl.slider_create(mpu6050_cont, nil)    ---创建滑动条
    lvgl.obj_set_size(slider_mpu6050_x, 100, 5)            -- 设置尺寸
    lvgl.obj_align(slider_mpu6050_x, nil, lvgl.ALIGN_CENTER, 0, -50)--设置居中
    --}

    range_slider_min_x= 0 -- slider最小值
    range_slider_max_x =100 -- slider最大值
    range_slider = range_slider_max_x - range_slider_min_x

    lvgl.slider_set_range(slider_mpu6050_x, range_slider_min_x, range_slider_max_x)         --设置范围，默认0-100
    lvgl.slider_set_value(slider_mpu6050_x, 0, lvgl.ANIM_OFF)

    log.info("scr_load",lvgl.scr_load(slider_mpu6050_x))     --显示

    -- lvgl.slider_set_value(slider_mpu6050_x, 67, lvgl.ANIM_OFF)

    log.info("lvgl demo: slider_mpu6050_x")
    return slider_mpu6050_x
end

function init_mpu6050_slider_y()
    --初始化
    --{
    slider_mpu6050_y = lvgl.slider_create(mpu6050_cont, nil)    ---创建滑动条
    lvgl.obj_set_size(slider_mpu6050_y, 100, 5)            -- 设置尺寸
    -- lvgl.obj_align(slider_mpu6050_y, nil, lvgl.ALIGN_CENTER, 0, 0)--设置居中
    lvgl.obj_align(slider_mpu6050_y, slider_mpu6050_x, lvgl.ALIGN_OUT_BOTTOM_MID, 0, 50)--设置居中
    --}

    range_slider_min_y= 0 -- slider最小值
    range_slider_max_y =100 -- slider最大值
    range_slider = range_slider_max_y - range_slider_min_y

    lvgl.slider_set_range(slider_mpu6050_y, range_slider_min_y, range_slider_max_y)         --设置范围，默认0-100
    lvgl.slider_set_value(slider_mpu6050_y, 0, lvgl.ANIM_OFF)

    log.info("scr_load",lvgl.scr_load(slider_mpu6050_y))     --显示

    -- lvgl.slider_set_value(slider_mpu6050_y, 67, lvgl.ANIM_OFF)

    log.info("lvgl demo: slider_mpu6050_y")
    return slider_mpu6050_y
end

function init_mpu6050_slider_z()
    --初始化
    --{
    slider_mpu6050_z = lvgl.slider_create(mpu6050_cont, nil)    ---创建滑动条
    lvgl.obj_set_size(slider_mpu6050_z, 100, 5)            -- 设置尺寸
    lvgl.obj_align(slider_mpu6050_z, nil, lvgl.ALIGN_CENTER, 0, 50)--设置居中
    --}

    range_slider_min_z= 0 -- slider最小值
    range_slider_max_z =100 -- slider最大值
    range_slider = range_slider_max_z - range_slider_min_z

    lvgl.slider_set_range(slider_mpu6050_z, range_slider_min_z, range_slider_max_z)         --设置范围，默认0-100
    lvgl.slider_set_value(slider_mpu6050_z, 0, lvgl.ANIM_OFF)

    log.info("scr_load",lvgl.scr_load(slider_mpu6050_z))     --显示

    -- lvgl.slider_set_value(slider_mpu6050_z, 67, lvgl.ANIM_OFF)

    log.info("lvgl demo: slider_mpu6050_z")
    return slider_mpu6050_z
end
-- function init_mpu6050_slider()
--     --初始化
--     --{
--     slider = lvgl.slider_create(lvgl.scr_act(), nil)    ---创建滑动条
--     lvgl.obj_set_size(slider, 128, 5)            -- 设置尺寸
--     lvgl.obj_align(slider, nil, lvgl.ALIGN_CENTER, 0, 0)--设置居中
--     --}

--     range_slider_min= 0 -- slider最小值
--     range_slider_max =100 -- slider最大值
--     range_slider = range_slider_max - range_slider_min

--     lvgl.slider_set_range(slider, range_slider_min, range_slider_max)         --设置范围，默认0-100
--     lvgl.slider_set_value(slider, 0, lvgl.ANIM_OFF)

--     log.info("scr_load",lvgl.scr_load(slider))     --显示

--     -- lvgl.slider_set_value(slider, 67, lvgl.ANIM_OFF)

--     log.info("lvgl demo: slider")
-- end

function set_slider_value(range_max,range_min,value)
    -- 这里的temp值是用于获取传感器的数值动态显示的
    value_temp = value
    value_range_min,value_range_max = range_max,range_min
    value_temp2perc = (value_temp- value_range_min)/(value_range_max - value_range_min)
    range_slider_min = 0 -- xyz需要三种最小值，该函数无法兼容，先强制设定
    value_perc2slider = math.floor(value_temp2perc * range_slider + range_slider_min)


    -- log.info(value_perc2slider)
    return value_perc2slider
    -- lvgl.slider_set_value(slider, value_perc2slider, lvgl.ANIM_OFF)
    -- log.info("scr_load",lvgl.scr_load(slider))     --显示
    -- value_temp = temp_value
    -- value_range_min,value_range_max = 0,50
    -- value_temp2perc = value_temp/(value_range_max - value_range_min)
    -- value_perc2slider = value_temp2perc * range_slider + range_slider_min


    -- lvgl.slider_set_value(slider, value_perc2slider, lvgl.ANIM_OFF)   --直接设置不需要再执行scr_loadl 
end