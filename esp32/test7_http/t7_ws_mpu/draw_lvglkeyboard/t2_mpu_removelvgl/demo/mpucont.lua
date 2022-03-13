--- 模块功能：display mpu6050 xyz value
-- @module display mpucont value
-- @author youkai
-- @release 2022.02.03

require("mpu6050")

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

function display_mpu_value()

    save_mpu_value()
    -- log.info("temp_x",temp_x)
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
    --初始化
    --{
    range_slider_min_x= 0 -- slider最小值
    range_slider_max_x =100 -- slider最大值
    range_slider = range_slider_max_x - range_slider_min_x

    return slider_mpu6050_x
end

function init_mpu6050_slider_y()
    --初始化
    --{
    range_slider_min_y= 0 -- slider最小值
    range_slider_max_y =100 -- slider最大值
    range_slider = range_slider_max_y - range_slider_min_y

    return slider_mpu6050_y
end

function init_mpu6050_slider_z()
    --初始化
    --{

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