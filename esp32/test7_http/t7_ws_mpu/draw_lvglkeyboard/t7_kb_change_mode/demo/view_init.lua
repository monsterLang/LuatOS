
view_list = {
    view_id = 1,    -- 1聊天界面 2输入界面

    v1_focus = 1,   -- 1 聊天内容   2 输入框    3 发送按钮
    v1_focus_status = 0, -- 0 选中，高亮    1 按下，触发不同事件
    v1_ta_value = "",   -- 显示聊天框内容
    v1_cont = nil,
    v1_textarea = nil,
    v1_keyboard = nil,

    v2_focus = 0,   -- 键盘按钮id 0-13
    v2_mode = 1,    -- 1 数字   2 小写  3 大写
    v2_c_char3 = 1, -- 1 数字   2 小写  3 大写
    v2_9btn_num = 0,-- 0-8 存储当前选择的值，仅在v2_mode=2/3使用
    v2_ta_value = "input word" ,   -- 显示文本框内容0-126字节
    v2_cont = nil,
    v2_textarea = nil,
    v2_keyboard = nil
}

-- 窗口初始化
function view1_init()

    
end

function view2_init()
    -- 初始化v2 容器，用于存放键盘和文本框
    v2_cont_init()
    -- 初始化键盘
    v2_keyboard_init()
    -- 初始化文本框
    v2_textarea_init()
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
    lvgl.obj_align_origo(view_list.v2_cont, nil, lvgl.ALIGN_CENTER, 0, 0)  --This parametrs will be sued when realigned*/
    -- lvgl.cont_set_fit(demo_img_symble_cont, lvgl.FIT_TIGHT)     --此时cont依据内容拓展，容易左右超过界限
    -- lvgl.cont_set_fit(demo_img_symble_cont, lvgl.FIT_MAX)
    lvgl.cont_set_fit(view_list.v2_cont, lvgl.FIT_NONE)   --此时cont未设置自适应状态，则内容在cont中
    -- lvgl.cont_set_layout(demo_img_symble_cont, lvgl.LAYOUT_COLUMN_MID)--字符布局居中
    -- lvgl.cont_set_layout(demo_img_symble_cont, lvgl.LAYOUT_COLUMN_LEFT) --布局靠左
    --}
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

view_list.v2_ta_value = "textarea"
function v2_textarea_init()
    view_list.v2_textarea = lvgl.textarea_create(view_list.v2_cont, nil)
    -- lvgl.obj_align(view_list.v2_textarea, nil, lvgl.ALIGN_IN_TOP_MID, 0, lvgl.DPI)
    lvgl.obj_set_size(view_list.v2_textarea, 128, 50)
    -- lvgl.obj_set_pos(view_list.v2_textarea, 0, 0)
    lvgl.obj_align(view_list.v2_textarea, nil, lvgl.ALIGN_IN_TOP_MID, 0, 0)
    
    -- 设置初始值
    lvgl.textarea_set_text(view_list.v2_textarea, view_list.v2_ta_value)

    -- lvgl.obj_set_event_cb(view_list.v2_textarea, eh_ta)    -- 等event_send好了再加
    -- log.info("scr_load: view_list.v2_textarea",lvgl.scr_load(view_list.v2_keyboard))
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





kb_num = 0

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

function kb_focused_btn()
    
    if kb_num < 0 then
        kb_num = 13
    elseif kb_num > 13 then
        kb_num = 0
    end

    lvgl.btnmatrix_set_focused_btn(view_list.v2_keyboard, kb_num)
end

mode_word = 0   -- 0选择9个按键，1选择3个数值

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
    kb_num = kb_num+1

    if kb_num > 13 then
        kb_num = 0
    elseif kb_num < 0 then
        kb_num = 13
    end

    if mode_word == 1 then
        print("choose 3 char")

        num_save = kb_num
        
        if kb_num < 9 then
            kb_num = 11
        elseif kb_num > 11 then
            kb_num = 9
        end
    end

    kb_focused_btn()
    -- ta_add_value("R")
    -- current_key = current_key+1
  --lvgl.label_set_text(label_event,"right")
end

function kb_choose_left()
    kb_num = kb_num-1

    if kb_num > 13 then
        kb_num = 0
    elseif kb_num < 0 then
        kb_num = 13
    end

    if mode_word == 1 then
        print("choose 3 char")
        
        if kb_num < 9 then
            kb_num = 11
        elseif kb_num > 11 then
            kb_num = 9
        end
    end

    kb_focused_btn()
    -- ta_add_value("L")
    -- current_key = current_key-1
  --lvgl.label_set_text(label_event,"left")
end

function kb_choose_char3()
    local temp_x = lvgl.btnmatrix_get_btn_text(view_list.v2_keyboard, kb_num)
    -- print("temp_x",temp_x)
    temp_x = tonumber(temp_x)
    -- print(temp_x)
    print("choose char",list_char[temp_x])
    if list_char[temp_x] ~= nil then
        ta_add_value(list_char[temp_x])
    end
    

end

num_save = 0

function kb_choose_up()
  --lvgl.label_set_text(label_event,"up")

    if mode_word == 1 then
        print("choose 3 char")
        
        -- if kb_num < 9 then
        --     kb_num = 11
        -- elseif kb_num > 11 then
        --     kb_num = 9
        -- end

        kb_choose_char3()

        mode_word = 0

        kb_num = num_save
        lvgl.btnmatrix_set_focused_btn(view_list.v2_keyboard, num_save)

        lvgl.btnmatrix_set_btn_ctrl(view_list.v2_keyboard, kb_num, lvgl.BTNMATRIX_CTRL_CHECK_STATE)

        sys.wait(500)

        lvgl.btnmatrix_clear_btn_ctrl(view_list.v2_keyboard, kb_num, lvgl.BTNMATRIX_CTRL_CHECK_STATE)

    elseif mode_word == 0 then
        print("choose 9 key")


        num_save = kb_num
        print("save",num_save)
        

        if kb_num < 0 then
            kb_num = 13
        elseif kb_num > 13 then
            kb_num = 0
        end

        mode_word = 1

        -- 获取该按钮的显示值
        local temp_x = lvgl.btnmatrix_get_btn_text(view_list.v2_keyboard, kb_num)
        print("temp_x",temp_x)

        mode_choose3(temp_x)

        lvgl.btnmatrix_set_btn_ctrl(view_list.v2_keyboard, kb_num, lvgl.BTNMATRIX_CTRL_CHECK_STATE)
    end


    

    -- lvgl.btnmatrix_set_one_check(view_list.v2_keyboard, kb_num)
    -- lvgl.btnmatrix_set_btn_ctrl(view_list.v2_keyboard, num, lvgl.KEY_ENTER)

    -- lvgl.btnmatrix_set_btn_ctrl(view_list.v2_keyboard, num, lvgl.BTNMATRIX_CTRL_CHECK_STATE)

    -- local temp_x = lvgl.btnmatrix_get_btn_text(view_list.v2_keyboard, num)
    -- print("temp_x",temp_x)

    -- lvgl.btnmatrix_set_btn_ctrl(btnm, btn_id, lvgl.BTNM_CTRL_CHECKABLE)


    -- lvgl.btnmatrix_set_btn_ctrl(view_list.v2_keyboard, kb_num, lvgl.KEY_ENTER)
    -- 设置切换状态



    -- ta_add_value("U")

end

function kb_choose_down()

    if kb_num < 0 then
        kb_num = 13
    elseif kb_num > 13 then
        kb_num = 0
    end
    -- lvgl.btnmatrix_set_one_check(view_list.v2_keyboard, kb_num)
    -- lvgl.btnmatrix_set_btn_ctrl(view_list.v2_keyboard, num, lvgl.KEY_ENTER)

    
    -- lvgl.btnmatrix_set_btn_ctrl(view_list.v2_keyboard, num, lvgl.BTNMATRIX_CTRL_CHECKABLE)

    -- lvgl.btnmatrix_set_btn_ctrl(view_list.v2_keyboard, kb_num, lvgl.KEY_ENTER)


    -- 清除切换状态
    lvgl.btnmatrix_clear_btn_ctrl(view_list.v2_keyboard, kb_num, lvgl.BTNMATRIX_CTRL_CHECK_STATE)

    -- ta_add_value("D")

    mode_word = 0

end

function v2_kb_change_mode()
    print("keyboard change mode: "..view_list.v2_mode)
    view_list.v2_mode = view_list.v2_mode+1

    if view_list.v2_mode >3 then
        view_list.v2_mode = 1
    end

    v2_kb_updata_mode()
end

function v2_kb_updata_mode()
    if view_list.v2_mode == 1 then
        lvgl.btnmatrix_set_map(view_list.v2_keyboard, v2_kb_map_0)
    elseif view_list.v2_mode == 2 then
        lvgl.btnmatrix_set_map(view_list.v2_keyboard, v2_kb_map_a)
    elseif view_list.v2_mode == 3 then
        lvgl.btnmatrix_set_map(view_list.v2_keyboard, v2_kb_map_A)
    else
        print("error view_list.v2_mode")
    end
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
                "+", "-", "/", "0", "X",
                ""}

function v2_keyboard_init()


    view_list.v2_keyboard = lvgl.btnmatrix_create(view_list.v2_cont, nil)
    lvgl.obj_set_size(view_list.v2_keyboard,128,110)

    -- 设置键盘在屏幕的位置，两个会起冲突
    -- lvgl.obj_set_pos(view_list.v2_keyboard, 0, 50)     --设置起始位置
    lvgl.obj_align(view_list.v2_keyboard, nil, lvgl.ALIGN_IN_BOTTOM_MID, 0, 0)      -- 设置屏幕居中ALIGN_CENTER,屏幕底部ALIGN_IN_BOTTOM_MID
    -- lvgl.obj_align_origo(view_list.v2_keyboard, nil, lvgl.ALIGN_IN_TOP_MID, 0, 0)  --This parametrs will be sued when realigned*/
    -- lvgl.obj_set_x(view_list.v2_keyboard,0)
    -- lvgl.obj_set_y(view_list.v2_keyboard,0)

    -- 设置键盘按键显示内容
    lvgl.btnmatrix_set_map(view_list.v2_keyboard, v2_kb_map_A)

    -- 设置按键状态
    -- 按键1设置按下时响应
    -- lvgl.btnmatrix_set_btn_ctrl(view_list.v2_keyboard, 1, lvgl.BTNMATRIX_CTRL_CLICK_TRIG)

    -- 按键1切换状态
    lvgl.btnmatrix_set_btn_ctrl(view_list.v2_keyboard, 1, lvgl.BTNMATRIX_CTRL_CHECKABLE)

    
    -- lvgl.btnmatrix_set_btn_ctrl(view_list.v2_keyboard, 0, lvgl.BTNMATRIX_CTRL_CHECK_STATE)
    -- lvgl.btnmatrix_set_btn_width(view_list.v2_keyboard, 5, 1)        --Make "Action1" twice as wide as "Action2"
    -- lvgl.btnmatrix_set_btn_width(view_list.v2_keyboard, 4, 1)        --Make "Action1" twice as wide as "Action2"
    -- lvgl.btnmatrix_set_btn_ctrl(view_list.v2_keyboard, 6, lvgl.BTNMATRIX_CTRL_CHECKABLE)
    -- lvgl.btnmatrix_set_btn_width(view_list.v2_keyboard,)

    -- local style_btnm_kb = lvgl.style_create()
    -- lvgl.style_set_text_font(view_list.v2_keyboard, lvgl.STATE_DEFAULT, lvgl.font_get("opposans_m_8"))
	-- lvgl.obj_add_style(view_list.v2_keyboard, lvgl.LABEL_PART_MAIN, style_btnm_kb)

    -- 为键盘设置事件响应
    lvgl.obj_set_event_cb(view_list.v2_keyboard, eh_kb)

    -- 绑定键盘和文本框
    lvgl.keyboard_set_textarea(view_list.v2_keyboard, view_list.v2_textarea)
    -- lvgl.keyboard_set_cursor_manage(view_list.v2_keyboard, true)
    -- 显示键盘
    -- log.info("scr_load:view_list.v2_keyboard",lvgl.scr_load(view_list.v2_keyboard))

    -- group

end

-- function create_group()
--     group_btnm_kb = lvgl.group_create()
--     lvgl.group_add_obj(group_btnm_kb, view_list.v2_keyboard)
--     lvgl.indev_set_group( ,group_btnm_kb)
-- end


-- function kb_create_()
    
-- end



