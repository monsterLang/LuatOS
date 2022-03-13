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
function demo_imgbtn()
    --创建一个 Image
    imgbtn = lvgl.imgbtn_create(lvgl.scr_act(), nil)
    --设置 Image 的内容
    lvgl.imgbtn_set_src(imgbtn, lvgl.BTN_STATE_RELEASED, "/lua/0.jpg")
    lvgl.imgbtn_set_src(imgbtn, lvgl.BTN_STATE_PRESSED, "/lua/0.jpg")
    --设置 Image 的位置
    lvgl.obj_align(imgbtn, nil, lvgl.ALIGN_CENTER, 0, 0)

    log.info("scr_load",lvgl.scr_load(imgbtn))

end

function air105demo()
    lvgl.disp_set_bg_color(nil, 0xFFFFFF)
    local scr = lvgl.obj_create(nil, nil)
    local btn = lvgl.btn_create(scr)
    
    lvgl.obj_align(btn, lvgl.scr_act(), lvgl.ALIGN_CENTER, 0, 0)
    local label = lvgl.label_create(btn)
    
    --有中文字体的才能显示中文
    lvgl.label_set_text(label, "LuatOS!")
    -- lvgl.label_set_text(label, "你好!")
    lvgl.scr_load(scr)
end

function draw_lvgl_keyboard()
    local cont_keyboard = lvgl.cont_create(lvgl.scr_act(), nil)
    lvgl.obj_set_size(cont_keyboard,128,45)
    lvgl.obj_set_auto_realign(cont_keyboard, true)
    lvgl.obj_align_origo(cont_keyboard, nil, lvgl.ALIGN_IN_TOP_MID, 0, 0)  --This parametrs will be sued when realigned*/
    lvgl.cont_set_fit(cont_keyboard, lvgl.FIT_NONE)
    -- lvgl.cont_set_layout(cont_keyboard, lvgl.LAYOUT_COLUMN_LEFT)
    log.info("scr_load",lvgl.scr_load(cont_keyboard))

    local btn_Q = lvgl.btn_create(cont_keyboard)
    lvgl.obj_set_size(btn_Q,10,10)
    lvgl.obj_set_x(btn_Q,20)
    lvgl.obj_set_y(btn_Q,20)

    lvgl.obj_align(btn_Q, lvgl.scr_act(), lvgl.ALIGN_CENTER, 0, 0)
    local label_Q = lvgl.label_create(btn_Q)
    lvgl.label_set_text(label_Q, "Q")

    -- sys.wait(3000)

end

local function event_handler(obj, event)
    if(event == lvgl.EVENT_VALUE_CHANGED) then
            local txt = lvgl.btnmatrix_get_active_btn_text(obj)
            print(string.format("%s was pressed\n", txt))
    end
end

function keyboard_demo()
    --Create a text area. The keyboard will write here
    btnm_ta  = lvgl.textarea_create(lvgl.scr_act(), nil);
    lvgl.obj_align(btnm_ta, nil, lvgl.ALIGN_IN_TOP_MID, 0, lvgl.DPI / 16);
    lvgl.obj_set_event_cb(btnm_ta, ta_event_cb);
    lvgl.textarea_set_text(btnm_ta, "");
    local LV_VER_RES = lvgl.disp_get_ver_res(lvgl.disp_get_default())
    local max_h = LV_VER_RES / 2 - lvgl.DPI / 8;
    if(lvgl.obj_get_height(btnm_ta) > max_h) then lvgl.obj_set_height(btnm_ta, max_h)end;

    -- kb_create();
end

function create_btnm_cont()
    btnm_cont = lvgl.cont_create(lvgl.scr_act(), nil)
    lvgl.obj_set_size(btnm_cont,128,160)
    lvgl.obj_set_auto_realign(btnm_cont, true)                    --Auto realign when the size changes*/
    lvgl.obj_align_origo(btnm_cont, nil, lvgl.ALIGN_CENTER, 0, 0)  --This parametrs will be sued when realigned*/
    -- lvgl.cont_set_fit(demo_img_symble_cont, lvgl.FIT_TIGHT)     --此时cont依据内容拓展，容易左右超过界限
    -- lvgl.cont_set_fit(demo_img_symble_cont, lvgl.FIT_MAX)
    lvgl.cont_set_fit(btnm_cont, lvgl.FIT_NONE)   --此时cont未设置自适应状态，则内容在cont中
    -- lvgl.cont_set_layout(demo_img_symble_cont, lvgl.LAYOUT_COLUMN_MID)--字符布局居中
    -- lvgl.cont_set_layout(demo_img_symble_cont, lvgl.LAYOUT_COLUMN_LEFT) --布局靠左
    --}

    log.info("scr_load",lvgl.scr_load(btnm_cont))

    btnmatrix_demo_text()
    btnmatrix_demo_keyboard()
end

function btnmatrix_demo_text()
    btnm_ta = lvgl.textarea_create(btnm_cont, nil)
    -- lvgl.obj_align(btnm_ta, nil, lvgl.ALIGN_IN_TOP_MID, 0, lvgl.DPI)
    lvgl.obj_set_size(btnm_ta, 128, 49)
    lvgl.obj_set_pos(btnm_ta, 0, 0)
    lvgl.obj_set_event_cb(btnm_ta, ta_event_cb)
    lvgl.textarea_set_text(btnm_ta, "textarea")
    
    -- log.info("scr_load: btnm_ta",lvgl.scr_load(btnm_kb))
end

function btnmatrix_demo_keyboard()
    -- local btnm_map = {"1", "2", "3", "4", "5", "\n",
    --                 "6", "7", "8", "9", "0", "\n",
    --                 "Action1", "Action2",""}
    -- local btnm_map = {  "1", "2", "3", "\n",
    --                     "4", "5", "6", "\n",
    --                     "7", "8", "9", "\n",
    --                     -- "0", "Action1", "Action2",
    --                     ""}

    local btnm_map_keyboard = { 
        -- "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "\n",
                        "YZ0", "ABC", "DEF", "\n",
                        "GHI", "JKL", "MNO", "\n",
                        "PQR", "STU", "VWX", "\n",
                        "1", "2", "3",
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
        lvgl.btnmatrix_set_btn_ctrl(btnm_kb, 0, lvgl.BTNMATRIX_CTRL_CHECK_STATE)
    -- lvgl.btnmatrix_set_btn_width(btnm_kb, 5, 1)        --Make "Action1" twice as wide as "Action2"
    -- lvgl.btnmatrix_set_btn_width(btnm_kb, 4, 1)        --Make "Action1" twice as wide as "Action2"
    -- lvgl.btnmatrix_set_btn_ctrl(btnm_kb, 6, lvgl.BTNMATRIX_CTRL_CHECKABLE)
    -- lvgl.btnmatrix_set_btn_width(btnm_kb,)

    -- local style_btnm_kb = lvgl.style_create()
    -- lvgl.style_set_text_font(btnm_kb, lvgl.STATE_DEFAULT, lvgl.font_get("opposans_m_8"))
	-- lvgl.obj_add_style(btnm_kb, lvgl.LABEL_PART_MAIN, style_btnm_kb)

    -- 为键盘设置事件响应
    lvgl.obj_set_event_cb(btnm_kb, event_handler)

    -- 显示键盘
    -- log.info("scr_load:btnm_kb",lvgl.scr_load(btnm_kb))
end


function img()
    -- img_path = "/luadb/keyboard_bg.bin"
    -- img_path = "/lua/0.jpg"

    -- local img = lvgl.img_create(cont_keyboard,nil)			--
    -- local style_img = lvgl.style_create()

	-- lvgl.style_set_image_recolor(style_img, lvgl.STATE_DEFAULT, lvgl.color_make(0xff, 0xff, 0xff))
	-- lvgl.style_set_image_recolor_opa(style_img, lvgl.STATE_DEFAULT, 0)
	-- lvgl.style_set_image_opa(style_img, lvgl.STATE_DEFAULT, 255)
	-- lvgl.obj_add_style(img, lvgl.IMG_PART_MAIN, style_img)
	-- lvgl.obj_set_pos(img, 0, 0)
	-- lvgl.obj_set_size(img, 128, 45)

    -- lvgl.img_set_src(img, img_path)
	-- lvgl.img_set_pivot(img, 0,0)
	-- lvgl.img_set_angle(img, 0)
end

function demo_img_symble()
    -- 注意需要创建cont才能创建symble

    -- 初始化容器cont
    --{
    local demo_img_symble_cont = lvgl.cont_create(lvgl.scr_act(), nil)
    lvgl.obj_set_size(demo_img_symble_cont,128,160)
    lvgl.obj_set_auto_realign(demo_img_symble_cont, true)                    --Auto realign when the size changes*/
    lvgl.obj_align_origo(demo_img_symble_cont, nil, lvgl.ALIGN_CENTER, 0, 0)  --This parametrs will be sued when realigned*/
    -- lvgl.cont_set_fit(demo_img_symble_cont, lvgl.FIT_TIGHT)     --此时cont依据内容拓展，容易左右超过界限
    -- lvgl.cont_set_fit(demo_img_symble_cont, lvgl.FIT_MAX)
    lvgl.cont_set_fit(demo_img_symble_cont, lvgl.FIT_NONE)   --此时cont未设置自适应状态，则内容在cont中
    -- lvgl.cont_set_layout(demo_img_symble_cont, lvgl.LAYOUT_COLUMN_MID)--字符布局居中
    -- lvgl.cont_set_layout(demo_img_symble_cont, lvgl.LAYOUT_COLUMN_LEFT) --布局靠左
    --}

    log.info("scr_load",lvgl.scr_load(demo_img_symble_cont))     --显示。注意要显示的是cont而不是img

    -- demo_img_symble = lvgl.img_create(demo_img_symble_cont, nil)
    lvgl.cont_set_layout(demo_img_symble_cont, lvgl.LAYOUT_GRID)
    for i=1, #symble do
        demo_img_symble = lvgl.img_create(demo_img_symble_cont, nil)
        lvgl.img_set_src(demo_img_symble, symble[i])
    end

    log.info("lvgl demo: img_symble")

    sys.wait(3000)
    -- lvgl.obj_clean(demo_img_symble)
    --lvgl.obj_del(demo_img_symble)           --删除
end