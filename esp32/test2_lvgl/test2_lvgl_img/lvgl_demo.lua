--代码来源--https://doc.openluat.com/wiki/21?wiki_page_id=2561
-- 整理：youkai
-- 注意事项：部分函数中存在wait，需要在sys.taskInit中调用。

function clear_lvgl()
    -- lcd.clear(0xFFFFFF)
    -- lcd.draw()
    sys.wait(2000)
end

function arc()
    -- 1. 初始化
    --{
    scr = lvgl.obj_create(nil, nil)
    arc = lvgl.arc_create(scr, nil)  -- 创建曲线
    -- arc = lvgl.arc_create(lvgl.scr_act(), nil)  -- 创建曲线
    lvgl.obj_set_size(arc, 128, 128)            -- 设置尺寸
    lvgl.obj_align(arc, nil, lvgl.ALIGN_CENTER, 0, 0)-- 设置位置居中
    -- 绘制弧度
    -- lvgl.arc_set_end_angle(arc, 100)
    -- }

    -- -- 方法1：直接是设置固定角度
    -- -- 绘制背景角度
    -- lvgl.arc_set_bg_angles(arc, 0, 180) --背景0-180度
    -- -- 绘制前景角度（填充的）
    -- lvgl.arc_set_angles(arc, 0, 90)     --前景0-90度
    -- log.info("scr_load",lvgl.scr_load(arc))--显示

    -- -- 方法2：设置背景角度后，设置背景范围，通过传入数值显示
    -- lvgl.arc_set_bg_angles(arc, 150, 30) --背景0-180度
    -- lvgl.arc_set_range(arc, 0, 100)      --设置数值范围
    -- lvgl.arc_set_value(arc, 30)          --传入数值
    -- log.info("scr_load",lvgl.scr_load(arc))--显示

    -- 方法3：隔1s显示不同数值
    lvgl.arc_set_bg_angles(arc, 150, 30) --背景0-180度
    lvgl.arc_set_adjustable(arc, true)   --允许输入
    lvgl.arc_set_value(arc, 30)          --传入数值
    log.info("scr_load",lvgl.scr_load(arc))--显示

    sys.wait(1000)                       -- 等1s传入新值
    lvgl.arc_set_value(arc, 50)          --传入数值

    -- m = lvgl.scr_load(arc)
    -- log.info(m)
    log.info("scr_load",lvgl.scr_load(arc))
    sys.wait(1000) 

    log.info("lvgl demo: arc")

    -- -- test
    -- y = 0
    -- log.info(y)

    -- -- temp_status = lvgl.obj_clean(scr)
    -- -- temp_status = lvgl.obj_del(arc)
    -- temp_status = lvgl.obj_clean(arc)
    -- log.info(temp_status)    --清除其内容

    -- x = 1
    -- log.info(x)
    -- -- log.info("scr_load",lvgl.scr_load(arc))--显示
    -- -- lvgl.obj_del(arc)           --删除
end
-- arc() 

function bar()
    --初始化
    --{
    bar = lvgl.bar_create(lvgl.scr_act(), nil)  -- 创建进度条
    lvgl.obj_set_size(bar, 128, 20)            -- 设置尺寸
    lvgl.obj_align(bar, NULL, lvgl.ALIGN_CENTER, 0, 0)-- 设置位置居中
    --}

    -- --方法1：2s加载完
    -- lvgl.bar_set_anim_time(bar, 2000)       -- 设置加载完成时间
    -- lvgl.bar_set_value(bar, 100, lvgl.ANIM_ON)-- 设置加载到的值，默认范围为0-100
    -- log.info("scr_load",lvgl.scr_load(bar))     --显示

    --方法2：设置范围为100-200，等待2s后开始加载，加载到150停止（中点）
    lvgl.bar_set_range(bar, 100, 200)   --设置范围
    lvgl.bar_set_start_value(bar, 100, lvgl.ANIM_ON)-- 设置进度条起始值
    sys.wait(2000)
    lvgl.bar_set_anim_time(bar, 2000)-- 设置加载完成时间
    lvgl.bar_set_value(bar, 150, lvgl.ANIM_ON)-- 设置加载到的值
    log.info("scr_load",lvgl.scr_load(bar))     --显示    

    log.info("lvgl demo: bar")

    sys.wait(1000)
    -- lvgl.obj_clean(bar)
    --lvgl.obj_del(bar)           --删除
end

function slider()
    --初始化
    --{
    slider = lvgl.slider_create(lvgl.scr_act(), nil)    ---创建滑动条
    lvgl.obj_set_size(slider, 128, 5)            -- 设置尺寸
    lvgl.obj_align(slider, nil, lvgl.ALIGN_CENTER, 0, 0)--设置居中
    --}

    -- --方法1：设置范围
    -- lvgl.slider_set_range(slider, 100, 200)         --设置范围，默认0-100
    -- lvgl.slider_set_value(slider, 150, lvgl.ANIM_OFF)
    -- log.info("scr_load",lvgl.scr_load(slider))     --显示

    -- -- 方法2：3s滑动到中间
    -- lvgl.slider_set_range(slider, 100, 200)         --设置范围，默认0-100
    -- lvgl.slider_set_anim_time(slider, 3000)-- 设置加载完成时间
    -- lvgl.slider_set_value(slider, 150, lvgl.ANIM_ON)
    -- log.info("scr_load",lvgl.scr_load(slider))     --显示 


    -- --方法3：设置回调函数显示滑动条数值 -- 未实现
    -- slider_event_cb = function(obj, event)
    --     log.info("enter event")
    --     if event == lvgl.EVENT_VALUE_CHANGED then 
    --         local val = (lvgl.slider_get_value(obj) or "0").."%"
    --         log.info("slider_get_value",string.toValue(str))
    --         lvgl.label_set_text(slider_label, val)
    --         lvgl.obj_align(slider_label, obj, lvgl.ALIGN_OUT_BOTTOM_MID, 0, 10)
    --         log.info("scr_load",lvgl.scr_load(slider_label))     --显示
    --     end
    -- end
    
    -- lvgl.obj_set_event_cb(slider, slider_event_cb) --设置事件监听

    -- --创建标签，显示当前
    -- slider_label = lvgl.label_create(lvgl.scr_act(), nil)
    -- lvgl.label_set_text(slider_label, "0%")
    -- lvgl.obj_align(slider_label, slider, lvgl.ALIGN_OUT_BOTTOM_MID, 0, 10)
    -- log.info("scr_load",lvgl.scr_load(slider_label))     --显示

    -- lvgl.slider_set_range(slider, 100, 200)         --设置范围，默认0-100
    -- lvgl.slider_set_anim_time(slider, 3000)-- 设置加载完成时间
    -- lvgl.slider_set_value(slider, 150, lvgl.ANIM_ON)
    -- log.info("scr_load",lvgl.scr_load(slider))     --显示 

    -- sys.wait(1000)
    -- lvgl.slider_set_value(slider, 180, lvgl.ANIM_ON)
    --存疑，定时滑动到中间，无法触发滑动事件变动？

    -- -- --方法4：获取数据设置滑动条位置
    -- range_slider_min= 100 -- slider最小值
    -- range_slider_max =200 -- slider最大值
    -- range_slider = range_slider_max - range_slider_min

    -- -- 这里的temp值是用于获取传感器的数值动态显示的
    -- value_temp = 10
    -- value_range_min,value_range_max = 0,50
    -- value_temp2perc = value_temp/(value_range_max - value_range_min)
    -- value_perc2slider = value_temp2perc * range_slider + range_slider_min

    -- lvgl.slider_set_range(slider, range_slider_min, range_slider_max)         --设置范围，默认0-100
    -- lvgl.slider_set_value(slider, value_perc2slider, lvgl.ANIM_OFF)
    -- log.info("scr_load",lvgl.scr_load(slider))     --显示

    -- sys.wait(2000)

    -- lvgl.slider_set_value(slider, 180, lvgl.ANIM_OFF)   --直接设置不需要再执行scr_loadl 
    
    --方法5：事件监听未实现，实现了设置变量数据
    -- slider_event_cb = function(obj, event)  -- error
    --     log.info("slider event ")
    --     if event == lvgl.EVENT_VALUE_CHANGED then 
    --         local val = (lvgl.slider_get_value(obj) or "0").."%"
    --         lvgl.label_set_text(slider_label, val)
    --         lvgl.obj_align(slider_label, obj, lvgl.ALIGN_OUT_BOTTOM_MID, 0, 10)
    --     end
    -- end
    -- lvgl.obj_set_event_cb(slider, slider_event_cb)

    slider_label = lvgl.label_create(lvgl.scr_act(), nil)
    lvgl.label_set_text(slider_label, "0%")
    lvgl.obj_align(slider_label, slider, lvgl.ALIGN_OUT_BOTTOM_MID, 0, 10)

    range_slider_min= 100 -- slider最小值
    range_slider_max =200 -- slider最大值
    range_slider = range_slider_max - range_slider_min

    -- 这里的temp值是用于获取传感器的数值动态显示的
    value_temp = 10
    value_range_min,value_range_max = 0,50
    value_temp2perc = value_temp/(value_range_max - value_range_min)
    value_perc2slider = value_temp2perc * range_slider + range_slider_min

    lvgl.slider_set_range(slider, range_slider_min, range_slider_max)         --设置范围，默认0-100
    lvgl.slider_set_value(slider, value_perc2slider, lvgl.ANIM_OFF)
    log.info("scr_load",lvgl.scr_load(slider))     --显示

    sys.wait(2000)

    lvgl.slider_set_value(slider, 180, lvgl.ANIM_OFF)   --直接设置不需要再执行scr_loadl 
    -- lvgl.event_send

    log.info("lvgl demo: slider")

    sys.wait(1000)
    -- lvgl.obj_clean(slider)
    --lvgl.obj_del(slider)           --删除,====error
end


symble = {
    "\xef\x80\x81", "\xef\x80\x88", "\xef\x80\x8b", "\xef\x80\x8c",
    "\xef\x80\x8d", "\xef\x80\x91", "\xef\x80\x93", "\xef\x80\x95",
    "\xef\x80\x99", "\xef\x80\x9c", "\xef\x80\xa1", "\xef\x80\xa6",
    "\xef\x80\xa7", "\xef\x80\xa8", "\xef\x80\xbe", "\xef\x8C\x84",
    "\xef\x81\x88", "\xef\x81\x8b", "\xef\x81\x8c", "\xef\x81\x8d",
    "\xef\x81\x91", "\xef\x81\x92", "\xef\x81\x93", "\xef\x81\x94",
    "\xef\x81\xa7", "\xef\x81\xa8", "\xef\x81\xae", "\xef\x81\xb0",
    "\xef\x81\xb1", "\xef\x81\xb4", "\xef\x81\xb7", "\xef\x81\xb8",
    "\xef\x81\xb9", "\xef\x81\xbb", "\xef\x82\x93", "\xef\x82\x95",
    "\xef\x83\x84", "\xef\x83\x85", "\xef\x83\x87", "\xef\x83\xa7",
    "\xef\x83\xAA", "\xef\x83\xb3", "\xef\x84\x9c", "\xef\x84\xa4",
    "\xef\x85\x9b", "\xef\x87\xab", "\xef\x89\x80", "\xef\x89\x81",
    "\xef\x89\x82", "\xef\x89\x83", "\xef\x89\x84", "\xef\x8a\x87",
    "\xef\x8a\x93", "\xef\x8B\xAD", "\xef\x95\x9A", "\xef\x9F\x82",
}
function img_symble()
    -- 注意需要创建cont才能创建symble

    -- 初始化容器cont
    --{
    local cont = lvgl.cont_create(lvgl.scr_act(), nil)
    lvgl.obj_set_size(cont,128,160)
    lvgl.obj_set_auto_realign(cont, true)                    --Auto realign when the size changes*/
    lvgl.obj_align_origo(cont, nil, lvgl.ALIGN_CENTER, 0, 0)  --This parametrs will be sued when realigned*/
    -- lvgl.cont_set_fit(cont, lvgl.FIT_TIGHT)     --此时cont依据内容拓展，容易左右超过界限
    -- lvgl.cont_set_fit(cont, lvgl.FIT_MAX)
    lvgl.cont_set_fit(cont, lvgl.FIT_NONE)   --此时cont未设置自适应状态，则内容在cont中
    -- lvgl.cont_set_layout(cont, lvgl.LAYOUT_COLUMN_MID)--字符布局居中
    -- lvgl.cont_set_layout(cont, lvgl.LAYOUT_COLUMN_LEFT) --布局靠左
    --}

    log.info("scr_load",lvgl.scr_load(cont))     --显示。注意要显示的是cont而不是img

    -- img = lvgl.img_create(cont, nil)
    lvgl.cont_set_layout(cont, lvgl.LAYOUT_GRID)
    for i=1, #symble do
        img = lvgl.img_create(cont, nil)
        lvgl.img_set_src(img, symble[i])
    end

    log.info("lvgl demo: img_symble")

    sys.wait(3000)
    -- lvgl.obj_clean(img)
    --lvgl.obj_del(img)           --删除
end

function img_png()
    -- 初始化
    --{
    local cont = lvgl.cont_create(lvgl.scr_act(), nil)
    lvgl.obj_set_size(cont,128,160)
    lvgl.obj_set_auto_realign(cont, true)                    --Auto realign when the size changes*/
    lvgl.obj_align_origo(cont, nil, lvgl.ALIGN_CENTER, 0, 0)  --This parametrs will be sued when realigned*/
    -- lvgl.cont_set_fit(cont, lvgl.FIT_TIGHT)     --此时cont依据内容拓展，容易左右超过界限
    -- lvgl.cont_set_fit(cont, lvgl.FIT_MAX)
    lvgl.cont_set_fit(cont, lvgl.FIT_NONE)   --此时cont未设置自适应状态，则内容在cont中
    -- lvgl.cont_set_layout(cont, lvgl.LAYOUT_COLUMN_MID)--字符布局居中
    -- lvgl.cont_set_layout(cont, lvgl.LAYOUT_COLUMN_LEFT) --布局靠左
    --}

    img = lvgl.img_create(cont, nil)-- 创建图片控件
    lvgl.img_set_src(img, "/img/t2.png")-- 设置图片路径
    lvgl.obj_align(img, nil, lvgl.ALIGN_CENTER, 0, 0)-- 图片居中
    
    log.info("scr_load",lvgl.scr_load(cont))     --显示。注意要显示的是cont而不是img

    sys.wait(1000)

    lvgl.img_set_angle(img, 900)
    
end


function lvgl_img()
    local scr = lvgl.obj_create()
    local img = lvgl.img_create(scr,nil)			--
    lvgl.img_set_src(img, "/lua/luatos.png")		--设置图片来源
    lvgl.obj_align(img, lvgl.scr_act(), lvgl.ALIGN_CENTER, 0, 0) 	--图片居中
    log.info("scr_load",lvgl.scr_load(cont))
    log.info("lvgl demo: img_png")
end


--demo1
function img_png_demo()
    -- local ui = lvgl.label_create(nil, nil)
    -- lvgl.obj_set_size(ui,128,160)
    -- local img1 = lvgl.img_create(ui, nil)
    local img1 = lvgl.img_create(lvgl.scr_act(), nil)
    lvgl.img_set_auto_size(img1, true)
    lvgl.img_set_src(img1, "/img/test3.bmp")
    -- lvgl.img_set_src(img2, _G.LV_SYMBOL_OK)--.."Accept"
    lvgl.obj_align(img1, nil, lvgl.ALIGN_CENTER, 0, -20)
    -- lvgl.obj_set_x(img1, 0)
    -- lvgl.obj_set_y(img1, 0)
    -- log.info("scr_load",lvgl.scr_load(ui))     --显示。注意要显示的是
    log.info("scr_load",lvgl.scr_load(img1))     --显示。注意要显示的是
    -- local img2 = lvgl.img_create(lvgl.scr_act(), nil)
    -- lvgl.img_set_src(img2, LV_SYMBOL_OK.."Accept")
    -- lvgl.obj_align(img2, img1, lvgl.ALIGN_OUT_BOTTOM_MID, 0, 20)
end


function cont()
    -- 初始化容器cont
    --{
    local cont = lvgl.cont_create(lvgl.scr_act(), nil)
    lvgl.obj_set_size(cont,128,160)
    lvgl.obj_set_auto_realign(cont, true)                    --Auto realign when the size changes*/
    lvgl.obj_align_origo(cont, nil, lvgl.ALIGN_CENTER, 0, 0)  --This parametrs will be sued when realigned*/
    -- lvgl.cont_set_fit(cont, lvgl.FIT_TIGHT)     --此时cont依据内容拓展，容易左右超过界限
    -- lvgl.cont_set_fit(cont, lvgl.FIT_MAX)
    lvgl.cont_set_fit(cont, lvgl.FIT_NONE)   --此时cont未设置自适应状态，则内容在cont中
    -- lvgl.cont_set_layout(cont, lvgl.LAYOUT_COLUMN_MID)--字符布局居中
    lvgl.cont_set_layout(cont, lvgl.LAYOUT_COLUMN_LEFT) --布局靠左
    --}

    --创建标签label
    local label = lvgl.label_create(cont, nil)
    lvgl.label_set_text(label, "Short text")

    log.info("scr_load",lvgl.scr_load(cont))     --显示   容器

    sys.wait(500)

    label = lvgl.label_create(cont, nil)
    lvgl.label_set_text(label, "It is a long text")

    sys.wait(500)

    label = lvgl.label_create(cont, nil)
    lvgl.label_set_text(label, "Here is an even longer text")

end
