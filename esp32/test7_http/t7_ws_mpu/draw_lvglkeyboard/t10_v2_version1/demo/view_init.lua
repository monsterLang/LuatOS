
view_list = {
    view_id = 2,    -- 1聊天界面 2输入界面

    v1_focus = 1,   -- 1 聊天内容   2 输入框    3 发送按钮
    v1_focus_status = 0, -- 0 选中，高亮    1 按下，触发不同事件
    v1_ta_value = "",   -- 显示聊天框内容
    v1_cont = nil,
    v1_textarea = nil,
    v1_keyboard = nil,

    v2_focus = 0,   -- 键盘按钮id 0-13
    v2_kb_mode = 2, -- 1 数字   2 小写  3 大写
    v2_kb_choosed = 0,   -- 0去选择9个字符 1选择3个字符
    v2_c_char3 = 1, -- 1/2/3 第N字符   abc，1则选a
    v2_9btn_num = 0,-- 0-8 存储当前选择的值，仅在v2_mode=2/3使用
    v2_ta_value = "input word" ,   -- 显示文本框内容0-126字节
    v2_cont = nil,
    v2_textarea = nil,
    v2_keyboard = nil
}

-- 窗口初始化
function view1_init()

    
end

function view2_display()
    log.info("scr_load view1",lvgl.scr_load(view_list.v1_cont))
end

function view2_init()
    -- 初始化v2 容器，用于存放键盘和文本框
    v2_cont_init()
    -- 初始化键盘
    v2_keyboard_init()
    -- 初始化文本框
    v2_textarea_init()
end

function view2_display()
    log.info("scr_load view2",lvgl.scr_load(view_list.v2_cont))
end

function judge_view()
    if view_list.view_id == 1 then
        print("in view1")
    elseif view_list.view_id == 2 then
        print("in view2")
    else
        print("error view")
    end

    return view_list.view_id
end



------------------------ view1 ----------------------------
-- 创建v1 容器
function v1_cont_init()
    view_list.v1_cont = lvgl.cont_create(lvgl.scr_act(), nil)
    lvgl.obj_set_size(view_list.v1_cont,128,160)
    lvgl.obj_set_auto_realign(view_list.v1_cont, true)                    --Auto realign when the size changes*/
    lvgl.obj_align_origo(view_list.v1_cont, nil, lvgl.ALIGN_CENTER, 0, 0)  --This parametrs will be sued when realigned*/
    -- lvgl.cont_set_fit(demo_img_symble_cont, lvgl.FIT_TIGHT)     --此时cont依据内容拓展，容易左右超过界限
    -- lvgl.cont_set_fit(demo_img_symble_cont, lvgl.FIT_MAX)
    lvgl.cont_set_fit(view_list.v1_cont, lvgl.FIT_NONE)   --此时cont未设置自适应状态，则内容在cont中
    -- lvgl.cont_set_layout(demo_img_symble_cont, lvgl.LAYOUT_COLUMN_MID)--字符布局居中
    -- lvgl.cont_set_layout(demo_img_symble_cont, lvgl.LAYOUT_COLUMN_LEFT) --布局靠左
    --}
    log.info("scr_load",lvgl.scr_load(view_list.v1_cont))
end








------------------------ view2 ----------------------------

-- 创建v2 容器
function v2_cont_init()
    view_list.v2_cont = lvgl.cont_create(lvgl.scr_act(), nil)
    lvgl.obj_set_size(view_list.v2_cont,128,160)
    lvgl.obj_set_auto_realign(view_list.v2_cont, true)                    --Auto realign when the size changes*/
    lvgl.obj_align_origo(view_list.v2_cont, nil, lvgl.ALIGN_CENTER, 0, 0)  
    lvgl.cont_set_fit(view_list.v2_cont, lvgl.FIT_NONE)   --此时cont未设置自适应状态，则内容在cont中
    log.info("scr_load",lvgl.scr_load(view_list.v2_cont))
end


-- 创建文本输入框
-- 文本框响应事件
function eh_ta(obj, event)
    print("btnmatrix_demo_text has click")
    if(event == lvgl.EVENT_VALUE_CHANGED) then
            local txt = lvgl.btnmatrix_get_active_btn_text(obj)
            print(string.format("%s was pressed\n", txt))
    end
end

-- view_list.v2_ta_value = "textarea"
function v2_textarea_init()
    view_list.v2_textarea = lvgl.textarea_create(view_list.v2_cont, nil)
    lvgl.obj_set_size(view_list.v2_textarea, 128, 50)
    lvgl.obj_align(view_list.v2_textarea, nil, lvgl.ALIGN_IN_TOP_MID, 0, 0)
    
    -- 设置初始值
    lvgl.textarea_set_text(view_list.v2_textarea, view_list.v2_ta_value)

    sys.wait(1000)

    view_list.v2_ta_value = ""
    lvgl.textarea_set_text(view_list.v2_textarea, view_list.v2_ta_value)
end

-- 输入框内追加字符，用于输入按键值
function ta_add_value(str)
    view_list.v2_ta_value = view_list.v2_ta_value..str

    -- 限制写入的字符数目
    if #view_list.v2_ta_value > 126 then
        view_list.v2_ta_value = ""
    end
    lvgl.textarea_set_text(view_list.v2_textarea, view_list.v2_ta_value)
end







-- keyboard事件

function kb_judge_range()
    if view_list.v2_focus > 13 then
        view_list.v2_focus = 0
    elseif view_list.v2_focus < 0 then
        view_list.v2_focus = 13
    end
end

function kb_focused_btn()
    -- print("choose key"..view_list.v2_focus)
    lvgl.btnmatrix_set_focused_btn(view_list.v2_keyboard, view_list.v2_focus)
end

function kb_get_focus_value()
    local temp_x = lvgl.btnmatrix_get_btn_text(view_list.v2_keyboard, view_list.v2_focus)
    return temp_x
end



function mode_choose3(str)
    local char3 = str
    -- print(char3)
    list_char = {}
    list_char[1] = string.sub(char3,1,1)
    list_char[2] = string.sub(char3,2,2)
    list_char[3] = string.sub(char3,3,3)
    print(table.concat(list_char,"-"))

end

function kb_choose_right()

    -- 未选中字符，加一，不超过范围就行
    view_list.v2_focus = view_list.v2_focus-1
    kb_judge_range()

    -- 选中了字符，则只能在9-11中选择
    if view_list.v2_kb_choosed == 1 then
        print("choose 3 char,kb_choose_right")
        -- view_list.v2_9btn_num = view_list.v2_focus
        if view_list.v2_focus < 9 then
            view_list.v2_focus = 11
        elseif view_list.v2_focus > 11 then
            view_list.v2_focus = 9
        end
    end

    kb_focused_btn()
end

function kb_choose_left()
    view_list.v2_focus = view_list.v2_focus+1
    kb_judge_range()

    if view_list.v2_kb_choosed == 1 then
        -- print("choose 3 char,kb_choose_left")
        
        if view_list.v2_focus < 9 then
            view_list.v2_focus = 11
        elseif view_list.v2_focus > 11 then
            view_list.v2_focus = 9
        end
    end

    kb_focused_btn()
end

function v2_kb_delete()

    view_list.v2_ta_value = string.sub(view_list.v2_ta_value, 1 ,#view_list.v2_ta_value - 1)

    lvgl.textarea_set_text(view_list.v2_textarea, view_list.v2_ta_value)
end

function kb_choose_char3()
    local temp_x = lvgl.btnmatrix_get_btn_text(view_list.v2_keyboard, view_list.v2_focus)
    -- print("temp_x",temp_x)
    temp_x = tonumber(temp_x)
    -- print(temp_x)
    print("choose char",list_char[temp_x],temp_x)

    print("view_list.v2_9btn_num",view_list.v2_9btn_num,list_char[temp_x])
    if view_list.v2_9btn_num == 0 then
        print("view_list.v2_9btn_num = 0")
        if temp_x == 3 then
            print("temp_x == 3")
            v2_kb_delete()
            return
        end
    end

    if list_char[temp_x] ~= nil then
        ta_add_value(list_char[temp_x])
    end
end

function v2_kb_choosed_3t1()
    -- 获取该按钮的显示值
    local temp_x = lvgl.btnmatrix_get_btn_text(view_list.v2_keyboard, view_list.v2_focus)
    print("temp_x",temp_x)

    mode_choose3(temp_x)
end

function kb_choose_up()
    --lvgl.label_set_text(label_event,"up")
    view_list.v2_focus = view_list.v2_focus+3
    kb_judge_range()

    if view_list.v2_kb_choosed == 1 then
        print("choose 3 char,kb_choose_left")
        
        if view_list.v2_focus < 9 then
            view_list.v2_focus = 11
        elseif view_list.v2_focus > 11 then
            view_list.v2_focus = 9
        end
    end

    kb_focused_btn()

end

function kb_choose_down()

    view_list.v2_focus = view_list.v2_focus-3
    kb_judge_range()

    if view_list.v2_kb_choosed == 1 then
        print("choose 3 char,kb_choose_left")
        
        if view_list.v2_focus < 9 then
            view_list.v2_focus = 11
        elseif view_list.v2_focus > 11 then
            view_list.v2_focus = 9
        end
    end

    kb_focused_btn()
end





-- keyboard初始化
-- 更换键盘显示模式
function v2_kb_change_mode()
    print("keyboard change mode: "..view_list.v2_kb_mode)
    view_list.v2_kb_mode = view_list.v2_kb_mode+1

    if view_list.v2_kb_mode >3 then
        view_list.v2_kb_mode = 1
    end

    v2_kb_updata_mode()
end

function v2_kb_updata_mode()
    if view_list.v2_kb_mode == 1 then
        lvgl.btnmatrix_set_map(view_list.v2_keyboard, v2_kb_map_0)
        -- 选择数字不需要复选
    elseif view_list.v2_kb_mode == 2 then
        lvgl.btnmatrix_set_map(view_list.v2_keyboard, v2_kb_map_a)
    elseif view_list.v2_kb_mode == 3 then
        lvgl.btnmatrix_set_map(view_list.v2_keyboard, v2_kb_map_A)
    else
        print("error view_list.v2_kb_mode")
    end

    -- 只要模式切换就清除选中状态
    view_list.v2_kb_choosed = 0
end

v2_kb_map_A = { 
    -- "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "\n",
                    "YZ0", "ABC", "DEF", "\n",
                    "GHI", "JKL", "MNO", "\n",
                    "PQR", "STU", "VWX", "\n",
                    "1", "2", "3", "A", "X",
                    ""}

v2_kb_map_a = { 
    -- "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "\n",
                    "yz0", "abc", "def", "\n",
                    "ghi", "jkl", "mno", "\n",
                    "pqr", "stu", "vmw", "\n",
                    "1", "2", "3", "a", "X",
                    ""}

v2_kb_map_0 = { 
                "1", "2", "3", "\n",
                "4", "5", "6", "\n",
                "7", "8", "9", "\n",
                "+", "0", "-", "10", "X",
                ""}

--E:\elecfans\LuatOS-master\LuatOS\components\lvgl\gen\lv_widgets\luat_lv_btnmatrix.c

-- 创建键盘
-- 键盘响应事件 event handle keyboard
function eh_kb(obj, event)
    print("btnmatrix_demo_keyboard has click")
    if(event == lvgl.EVENT_VALUE_CHANGED) then
            local txt = lvgl.btnmatrix_get_active_btn_text(obj)
            print(string.format("%s was pressed\n", txt))
    end
end

function v2_keyboard_init()

    view_list.v2_keyboard = lvgl.btnmatrix_create(view_list.v2_cont, nil)
    lvgl.obj_set_size(view_list.v2_keyboard,128,110)

    -- 设置键盘在屏幕的位置，两个会起冲突
    -- lvgl.obj_set_pos(view_list.v2_keyboard, 0, 50)     --设置起始位置
    lvgl.obj_align(view_list.v2_keyboard, nil, lvgl.ALIGN_IN_BOTTOM_MID, 0, 0)      -- 设置屏幕居中ALIGN_CENTER,屏幕底部ALIGN_IN_BOTTOM_MID

    -- 设置键盘按键显示内容
    lvgl.btnmatrix_set_map(view_list.v2_keyboard, v2_kb_map_a)

    -- 设置按键状态
    -- 按键1设置按下时响应
    -- lvgl.btnmatrix_set_btn_ctrl(view_list.v2_keyboard, 1, lvgl.BTNMATRIX_CTRL_CLICK_TRIG)

    -- 按键1切换状态
    lvgl.btnmatrix_set_btn_ctrl(view_list.v2_keyboard, 1, lvgl.BTNMATRIX_CTRL_CHECKABLE)

    -- 为键盘设置事件响应
    lvgl.obj_set_event_cb(view_list.v2_keyboard, eh_kb)

    -- 绑定键盘和文本框
    lvgl.keyboard_set_textarea(view_list.v2_keyboard, view_list.v2_textarea)

end
