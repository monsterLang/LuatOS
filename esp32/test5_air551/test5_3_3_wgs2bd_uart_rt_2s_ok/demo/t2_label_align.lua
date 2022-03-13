function labtest( ... )
    scr = lvgl.obj_create(nil,nil)
    lvgl.obj_set_size(scr,128,160)
    -- lvgl.obj_set_pos(scr,64,80)
    lvgl.scr_load(scr)

    lab_style = lvgl.style_create()
    lvgl.style_set_text_color(lab_style, lvgl.STATE_DEFAULT, lvgl.color_make(0xff, 0x00, 0x00))

    lab_test1 = lvgl.label_create(scr, nil)
    lvgl.label_set_text(lab_test1,"ABC\nDEF\nGHI")
    lvgl.obj_add_style(lab_test1,lvgl.LABEL_PART_MAIN,lab_style)
    lvgl.obj_set_pos(lab_test1,50,60)
    -- lvgl.obj_align(lab_test1, bar_x_lab, lvgl.ALIGN_OUT_RIGHT_MID, 10, 0)

    lab_style2 = lvgl.style_create()
    lvgl.style_set_text_color(lab_style2, lvgl.STATE_DEFAULT, lvgl.color_make(0x00, 0xff, 0x00))
    -- lvgl.style_set_text_font(lab_style2, lvgl.STATE_DEFAULT, lvgl.font_get("opposans_m_48"))

    lab_test2 = lvgl.label_create(scr, nil)
    lvgl.obj_add_style(lab_test2,lvgl.LABEL_PART_MAIN,lab_style2)

    -- lvgl.label_set_text(lab_test2,"ALIGN_IN_TOP_LEFT")
    -- lvgl.obj_align(lab_test2, lab_test1, lvgl.ALIGN_IN_TOP_LEFT, 0, 0)

    -- lvgl.label_set_text(lab_test2,"TOP_LEFT")
    -- lvgl.obj_align(lab_test2, lab_test1, lvgl.ALIGN_OUT_TOP_LEFT, 0, 0)

    -- lvgl.label_set_text(lab_test2,"TOP_RIGHT")
    -- lvgl.obj_align(lab_test2, lab_test1, lvgl.ALIGN_OUT_TOP_RIGHT, 0, 0)

    -- lvgl.label_set_text(lab_test2,"TOP_MID")
    -- lvgl.obj_align(lab_test2, lab_test1, lvgl.ALIGN_OUT_TOP_MID, 0, 0)

    -- lvgl.label_set_text(lab_test2,"BOTTOM_LEFT")
    -- lvgl.obj_align(lab_test2, lab_test1, lvgl.ALIGN_OUT_BOTTOM_LEFT, 0, 0)

    -- lvgl.label_set_text(lab_test2,"LEFT_TOP")
    -- lvgl.obj_align(lab_test2, lab_test1, lvgl.ALIGN_OUT_LEFT_TOP, 0, 0)

    lvgl.label_set_text(lab_test2,"LEFT_MID")
    lvgl.obj_align(lab_test2, lab_test1, lvgl.ALIGN_OUT_LEFT_MID, 0, 0)

end


-- {"ALIGN_OUT_TOP_LEFT", NULL, LV_ALIGN_OUT_TOP_LEFT},\

-- {"ALIGN_OUT_TOP_MID", NULL, LV_ALIGN_OUT_TOP_MID},\

-- {"ALIGN_OUT_TOP_RIGHT", NULL, LV_ALIGN_OUT_TOP_RIGHT},\

-- {"ALIGN_OUT_BOTTOM_LEFT", NULL, LV_ALIGN_OUT_BOTTOM_LEFT},\

-- {"ALIGN_OUT_BOTTOM_MID", NULL, LV_ALIGN_OUT_BOTTOM_MID},\

-- {"ALIGN_OUT_BOTTOM_RIGHT", NULL, LV_ALIGN_OUT_BOTTOM_RIGHT},\

-- {"ALIGN_OUT_LEFT_TOP", NULL, LV_ALIGN_OUT_LEFT_TOP},\

-- {"ALIGN_OUT_LEFT_MID", NULL, LV_ALIGN_OUT_LEFT_MID},\

-- {"ALIGN_OUT_LEFT_BOTTOM", NULL, LV_ALIGN_OUT_LEFT_BOTTOM},\

-- {"ALIGN_OUT_RIGHT_TOP", NULL, LV_ALIGN_OUT_RIGHT_TOP},\

-- {"ALIGN_OUT_RIGHT_MID", NULL, LV_ALIGN_OUT_RIGHT_MID},\

-- {"ALIGN_OUT_RIGHT_BOTTOM", NULL, LV_ALIGN_OUT_RIGHT_BOTTOM},\


function lvgl_screen_shot()
    
end