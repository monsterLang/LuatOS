

-- 创建文本输入框
-- 文本框响应事件
function eh_ta(obj, event)
    print("btnmatrix_demo_text has click")
    if(event == lvgl.EVENT_VALUE_CHANGED) then
            local txt = lvgl.btnmatrix_get_active_btn_text(obj)
            print(string.format("%s was pressed\n", txt))
    end
end

btnm_ta_value = "textarea"
function btnmatrix_demo_text()
    btnm_ta = lvgl.textarea_create(btnm_cont, nil)
    -- lvgl.obj_align(btnm_ta, nil, lvgl.ALIGN_IN_TOP_MID, 0, lvgl.DPI)
    lvgl.obj_set_size(btnm_ta, 128, 50)
    -- lvgl.obj_set_pos(btnm_ta, 0, 0)
    lvgl.obj_align(btnm_ta, nil, lvgl.ALIGN_IN_TOP_MID, 0, 0)
    -- lvgl.obj_set_event_cb(btnm_ta, eh_ta)
    lvgl.textarea_set_text(btnm_ta, btnm_ta_value)

    -- log.info("scr_load: btnm_ta",lvgl.scr_load(btnm_kb))
end

-- 输入框内追加字符，用于输入按键值
function ta_add_value(str)
    btnm_ta_value = btnm_ta_value..str

    -- 限制写入的字符数目
    if #btnm_ta_value > 20 then
        btnm_ta_value = ""
    end
    lvgl.textarea_set_text(btnm_ta, btnm_ta_value)
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

    lvgl.btnmatrix_set_focused_btn(btnm_kb, kb_num)
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
    local temp_x = lvgl.btnmatrix_get_btn_text(btnm_kb, kb_num)
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
        lvgl.btnmatrix_set_focused_btn(btnm_kb, num_save)

        lvgl.btnmatrix_set_btn_ctrl(btnm_kb, kb_num, lvgl.BTNMATRIX_CTRL_CHECK_STATE)

        sys.wait(500)

        lvgl.btnmatrix_clear_btn_ctrl(btnm_kb, kb_num, lvgl.BTNMATRIX_CTRL_CHECK_STATE)

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
        local temp_x = lvgl.btnmatrix_get_btn_text(btnm_kb, kb_num)
        print("temp_x",temp_x)

        mode_choose3(temp_x)

        lvgl.btnmatrix_set_btn_ctrl(btnm_kb, kb_num, lvgl.BTNMATRIX_CTRL_CHECK_STATE)
    end


    

    -- lvgl.btnmatrix_set_one_check(btnm_kb, kb_num)
    -- lvgl.btnmatrix_set_btn_ctrl(btnm_kb, num, lvgl.KEY_ENTER)

    -- lvgl.btnmatrix_set_btn_ctrl(btnm_kb, num, lvgl.BTNMATRIX_CTRL_CHECK_STATE)

    -- local temp_x = lvgl.btnmatrix_get_btn_text(btnm_kb, num)
    -- print("temp_x",temp_x)

    -- lvgl.btnmatrix_set_btn_ctrl(btnm, btn_id, lvgl.BTNM_CTRL_CHECKABLE)


    -- lvgl.btnmatrix_set_btn_ctrl(btnm_kb, kb_num, lvgl.KEY_ENTER)
    -- 设置切换状态



    -- ta_add_value("U")

end

function kb_choose_down()

    if kb_num < 0 then
        kb_num = 13
    elseif kb_num > 13 then
        kb_num = 0
    end
    -- lvgl.btnmatrix_set_one_check(btnm_kb, kb_num)
    -- lvgl.btnmatrix_set_btn_ctrl(btnm_kb, num, lvgl.KEY_ENTER)

    
    -- lvgl.btnmatrix_set_btn_ctrl(btnm_kb, num, lvgl.BTNMATRIX_CTRL_CHECKABLE)

    -- lvgl.btnmatrix_set_btn_ctrl(btnm_kb, kb_num, lvgl.KEY_ENTER)


    -- 清除切换状态
    lvgl.btnmatrix_clear_btn_ctrl(btnm_kb, kb_num, lvgl.BTNMATRIX_CTRL_CHECK_STATE)

    -- ta_add_value("D")

    mode_word = 0

end

function btnmatrix_demo_keyboard()
    local btnm_map_keyboard = { 
        -- "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "\n",
                        "YZ0", "ABC", "DEF", "\n",
                        "GHI", "JKL", "MNO", "\n",
                        "PQR", "STU", "VWX", "\n",
                        "1", "2", "3", "Y", "X",
                        ""}

    btnm_kb = lvgl.btnmatrix_create(btnm_cont, nil)
    lvgl.obj_set_size(btnm_kb,128,110)

    -- 设置键盘在屏幕的位置，两个会起冲突
    -- lvgl.obj_set_pos(btnm_kb, 0, 50)     --设置起始位置
    lvgl.obj_align(btnm_kb, nil, lvgl.ALIGN_IN_BOTTOM_MID, 0, 0)      -- 设置屏幕居中ALIGN_CENTER,屏幕底部ALIGN_IN_BOTTOM_MID
    -- lvgl.obj_align_origo(btnm_kb, nil, lvgl.ALIGN_IN_TOP_MID, 0, 0)  --This parametrs will be sued when realigned*/
    -- lvgl.obj_set_x(btnm_kb,0)
    -- lvgl.obj_set_y(btnm_kb,0)

    -- 设置键盘按键显示内容
    lvgl.btnmatrix_set_map(btnm_kb, btnm_map_keyboard)

    -- 设置按键状态
    -- 按键1设置按下时响应
    -- lvgl.btnmatrix_set_btn_ctrl(btnm_kb, 1, lvgl.BTNMATRIX_CTRL_CLICK_TRIG)

    -- 按键1切换状态
    lvgl.btnmatrix_set_btn_ctrl(btnm_kb, 1, lvgl.BTNMATRIX_CTRL_CHECKABLE)

    
    -- lvgl.btnmatrix_set_btn_ctrl(btnm_kb, 0, lvgl.BTNMATRIX_CTRL_CHECK_STATE)
    -- lvgl.btnmatrix_set_btn_width(btnm_kb, 5, 1)        --Make "Action1" twice as wide as "Action2"
    -- lvgl.btnmatrix_set_btn_width(btnm_kb, 4, 1)        --Make "Action1" twice as wide as "Action2"
    -- lvgl.btnmatrix_set_btn_ctrl(btnm_kb, 6, lvgl.BTNMATRIX_CTRL_CHECKABLE)
    -- lvgl.btnmatrix_set_btn_width(btnm_kb,)

    -- local style_btnm_kb = lvgl.style_create()
    -- lvgl.style_set_text_font(btnm_kb, lvgl.STATE_DEFAULT, lvgl.font_get("opposans_m_8"))
	-- lvgl.obj_add_style(btnm_kb, lvgl.LABEL_PART_MAIN, style_btnm_kb)

    -- 为键盘设置事件响应
    lvgl.obj_set_event_cb(btnm_kb, eh_kb)

    -- 绑定键盘和文本框
    lvgl.keyboard_set_textarea(btnm_kb, btnm_ta)
    -- lvgl.keyboard_set_cursor_manage(btnm_kb, true)
    -- 显示键盘
    -- log.info("scr_load:btnm_kb",lvgl.scr_load(btnm_kb))

    -- group

end

-- function create_group()
--     group_btnm_kb = lvgl.group_create()
--     lvgl.group_add_obj(group_btnm_kb, btnm_kb)
--     lvgl.indev_set_group( ,group_btnm_kb)
-- end


-- function kb_create_()
    
-- end



