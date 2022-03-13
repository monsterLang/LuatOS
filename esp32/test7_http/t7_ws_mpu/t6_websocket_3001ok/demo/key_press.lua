
require("view_init")

function view_change()
    if view_list.view_id == 1 then
        view_list.view_id = 2
        view2_display()
        -- view2_init()
    elseif view_list.view_id == 2 then
        view_list.view_id = 1
        view1_display()
        -- view1_init()
    else
        print("error view mode")
    end
end

function v1_send_word()
    flag_send = true
    temp_msg_send_a = view_list.v2_ta_value
end

function view1_judge()
    print("enter view1")

    -- 选中了对话框，且按下了按键
    if view_list.v1_focus == 1 then
        print("up/down to read chat history")
    end

    -- 选中了输入框，且按下了按键，则切换界面
    if view_list.v1_focus == 2 then
        view_change()
    end

    -- 如果选中了发送按钮，则发送文本框内容
    if view_list.v1_focus == 3 then
        v1_send_word()
    end
end

-- 数字模式，直接追加字符到文本框
function v2_kb_mode_0()
    -- 高亮一下
    press_focus()

    ta_add_value(kb_get_focus_value())
end

function v2_kb_Aa_unchoosed()
    

    -- 存当前focus值
    view_list.v2_9btn_num = view_list.v2_focus

    -- 存储9键的字符
    v2_kb_choosed_3t1()

    -- 高亮当前按键0-8
    lvgl.btnmatrix_set_btn_ctrl(view_list.v2_keyboard, view_list.v2_focus, lvgl.BTNMATRIX_CTRL_CHECK_STATE)

    -- 选中数字1，并聚焦
    view_list.v2_focus = 9
    kb_focused_btn()

    view_list.v2_kb_choosed = 1
end

function press_focus()
    lvgl.btnmatrix_set_btn_ctrl(view_list.v2_keyboard, view_list.v2_focus, lvgl.BTNMATRIX_CTRL_CHECK_STATE)

    sys.wait(200)

    lvgl.btnmatrix_clear_btn_ctrl(view_list.v2_keyboard, view_list.v2_focus, lvgl.BTNMATRIX_CTRL_CHECK_STATE)
end

-- 已选中了再次按下，存储字符并清除之前的高亮
function v2_kb_Aa_choosed()
    -- print("choosed 3 char")    

    -- 高亮当前的按键0.5s，然后清除，表示按下
    press_focus()

    -- -- 获取当前数值并存储到文本框
    kb_choose_char3()

    -- 回到之前的按键，并清除选择的字符
    view_list.v2_focus = view_list.v2_9btn_num

    lvgl.btnmatrix_clear_btn_ctrl(view_list.v2_keyboard, view_list.v2_focus, lvgl.BTNMATRIX_CTRL_CHECK_STATE)

    -- 选中上一个，聚焦
    kb_focused_btn()

    view_list.v2_kb_choosed = 0
end


-- 大小写模式
function v2_kb_mode_aA()
    if view_list.v2_kb_choosed == 0 then
        v2_kb_Aa_unchoosed()

    elseif view_list.v2_kb_choosed == 1 then
        v2_kb_Aa_choosed()

    else
        print("error v2_kb_choosed")
    end
end

function view2_judge()
    print("enter view2")
    -- 如果按到了v2_keyboard id 12，则转换键盘大小写模式  -- ok
    if view_list.v2_focus == 12 then
        press_focus()
        v2_kb_change_mode()
        return
    end
    
    -- 如果按到了v2_keyboard id 13，则转换view模式 
    if view_list.v2_focus == 13 then
        -- 测试
        press_focus()
        v1_send_word()

        -- 更换窗口
        -- view_change()
        return
    end

    
    if view_list.v2_kb_mode == 1 then
        -- 数字模式
        -- print("in num")
        v2_kb_mode_0()
    elseif view_list.v2_kb_mode == 2 then
        -- 小写模式
        -- print("in small")
        v2_kb_mode_aA()
    elseif view_list.v2_kb_mode ==3 then
        -- 大写模式
        -- print("in big")
        v2_kb_mode_aA()
    else
        print("error v2_kb_mode")
    end

end

-- 检测到key/light按下
function key_press()

    if view_list.view_id == 1 then
        view1_judge()
    elseif view_list.view_id == 2 then
        view2_judge()
    else
        print("error view mode")
    end

end


