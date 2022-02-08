--- 模块功能：lvgldemo
-- @module lvgl
-- @author Dozingfiretruck
-- @release 2021.01.25

-- LuaTools需要PROJECT和VERSION这两个信息
PROJECT = "lvgldemo"
VERSION = "1.0.0"

LV_LOG_LEVEL  = 3

log.info("main", PROJECT, VERSION)

-- sys库是标配
_G.sys = require("sys")

require("esp32_st7735s") -- 背景是黑色
require("esp32_st7735") -- 背景是白色 暂时先用st7735，不过屏幕主控芯片是7735s
require("lvgl_demo")


log.info("hello luatos")

log.info("start----------------")

init_esp32_st7735 ()

LCD_W, LCD_H = 128,160
-- LCD_W, LCD_H = spi_lcd.getSize()
log.info("lcd", "size", LCD_W, LCD_H )


-- log.info(spi_lcd.w)

log.info("init lvgl")
-- log.info("lvgl", lvgl.init(128,160))
-- m = lvgl.init(128,160)
-- if ( m == true )
if ( lvgl.init(128,160) == true )

then
    log.debug("lvgl init ok.")
else
    log.debug("lvgl init error.")
end







function imgxxxx()
    -- img依赖label控件 copyhome.lua
    local scr = lvgl.obj_create(nil, nil)   --创建空白屏幕对象
    -- local label = lvgl.label_create(scr, nil)   --create label, parm form obj

    -- local lab = lvgl.label_create(scr, nil)

    log.info("create img")
    local img_png = lvgl.img_create(scr, nil)   --创建图像

    log.info("setscr")
    -- lvgl.img_set_src(img_png,"/t22.bmp")  --设置图片资源
    -- lvgl.img_set_pivot(img_png, 0,0)        --设置图片转动中心点
    -- lvgl.img_set_angle(img_png, 0)          --设置转动角度

    log.info(lvgl.img_set_src(img_png,"/luadb/t1.png"))
    log.info(lvgl.img_set_pivot(img_png, 0,0) )
    log.info(lvgl.img_set_angle(img_png, 0))
    -- log.info("img style")
    -- -- 创建图片样式
    -- img_png_style = lvgl.style_create()
    -- lvgl.style_set_image_recolor(img_png_style, lvgl.STATE_DEFAULT, lvgl.color_make(0xff, 0xff, 0xff))
    -- lvgl.style_set_image_recolor_opa(img_png_style, lvgl.STATE_DEFAULT, 0)
    -- lvgl.style_set_image_opa(img_png_style, lvgl.STATE_DEFAULT, 255)

    -- lvgl.obj_add_style(img_png, lvgl.IMG_PART_MAIN, img_png_style)  --将样式传给图像
    -- lvgl.obj_set_size(scr, 128, 160)        --设置屏幕大小
    -- lvgl.obj_set_pos(scr, 0, 0)             --设置起始坐标点
    -- -- lvgl.obj_set_click(img_png, true)    --是否支持图片点击事件
    log.info("scr_load")
    lvgl.scr_load(scr)                      --加载屏幕（显示）

end

-- local img1 = lvgl.img_create(lvgl.scr_act(), nil);
-- lvgl.img_set_src(img1, "/test3.bmp");
-- lvgl.obj_align(img1, nil, lvgl.ALIGN_CENTER, 0, -20);
-- lvgl.scr_load(img1)



-- local img1 = lvgl.img_create(lvgl.scr_act())
-- lvgl.img_set_src(img1, "/test2.bmp")

-- lvgl.obj_set_x(img1, 0)
-- lvgl.obj_set_y(img1, 0)

-- lvgl.scr_load(img1)


-- lvgl.disp_set_bg_color(nil, 0xFFFFFF)
-- local scr = lvgl.obj_create(nil, nil)
-- logo = lvgl.img_create(lvgl.scr_act(), nil)
-- lvgl.img_set_src(logo, "/logo.jpg")
-- -- local btn = lvgl.btn_create(scr)

-- lvgl.obj_align(btn, lvgl.scr_act(), lvgl.ALIGN_CENTER, 0, 0)
-- -- local label = lvgl.label_create(btn)

-- --有中文字体的才能显示中文
-- --lvgl.label_set_text(label, "LuatOS!")
-- lvgl.label_set_text(label, "111!")
-- lvgl.scr_load(scr)


-- scr = lvgl.obj_create(nil, nil)
-- logo = lvgl.img_create(lvgl.scr_act(), nil)
-- lvgl.img_set_src(logo, "/logo.jpg")
-- lvgl.obj_align(logo, nil, lvgl.ALIGN_CENTER, 0, -40)
-- lvgl.scr_load(logo)


-- c = lvgl.cont_create(nil, nil)
-- img = lvgl.img_create(c, nil)
-- lvgl.img_set_src(img, "/t2.bmp")
-- lvgl.obj_align(img, nil, lvgl.ALIGN_CENTER, 0, 0)
-- lvgl.scr_load(c)



-- local style = lvgl.style_t()
-- lvgl.style_init(style);
-- lvgl.style_set_image_recolor_opa(style, lvgl.STATE_PRESSED, lvgl.OPA_30);
-- lvgl.style_set_image_recolor(style, lvgl.STATE_PRESSED, lvgl.color_make(0x00, 0x00, 0x00));
-- lvgl.style_set_text_color(style, lvgl.STATE_DEFAULT, lvgl.color_make(0xFF, 0xFF, 0xFF));

-- local imgbtn1 = lvgl.imgbtn_create(lvgl.scr_act(), nil);
-- lvgl.imgbtn_set_src(imgbtn1, lvgl.BTN_STATE_RELEASED, "/img/imgbtn_green.png");
-- lvgl.imgbtn_set_src(imgbtn1, lvgl.BTN_STATE_PRESSED, "/img/imgbtn_green.png");
-- lvgl.imgbtn_set_src(imgbtn1, lvgl.BTN_STATE_CHECKED_RELEASED, "/img/imgbtn_blue.png");
-- lvgl.imgbtn_set_src(imgbtn1, lvgl.BTN_STATE_CHECKED_PRESSED, "/img/imgbtn_blue.png");
-- lvgl.imgbtn_set_checkable(imgbtn1, true);
-- lvgl.obj_add_style(imgbtn1, lvgl.IMGBTN_PART_MAIN, style);
-- lvgl.obj_align(imgbtn1, nil, lvgl.ALIGN_CENTER, 0, -40);

-- local imgbtn1 = lvgl.imgbtn_create(lvgl.scr_act(), nil);
-- lvgl.imgbtn_set_src(imgbtn1,  "/test2.jpg");

-- lvgl.imgbtn_set_checkable(imgbtn1, true);
-- lvgl.obj_add_style(imgbtn1, lvgl.IMGBTN_PART_MAIN, style);
-- lvgl.obj_align(imgbtn1, nil, lvgl.ALIGN_CENTER, 0, -40);
-- scr0 = lvgl.cont_create(nil, nil)



-- local img1 = lvgl.img_create(lvgl.scr_act(), nil);
-- lvgl.img_set_src(img1,  "/test2.bmp");
-- lvgl.obj_align(img1, nil, lvgl.ALIGN_CENTER, 0, -20);

-- local img2 = lvgl.img_create(lvgl.scr_act(), nil);
-- lvgl.img_set_src(img2, LV_SYMBOL_OK.."Accept");
-- lvgl.obj_align(img2, img1, lvgl.ALIGN_OUT_BOTTOM_MID, 0, 20);

-- --  display button
-- lvgl.disp_set_bg_color(nil, 0xFFFFFF)
-- local scr = lvgl.obj_create(nil, nil)
-- local btn = lvgl.btn_create(scr)
-- lvgl.obj_align(btn, lvgl.scr_act(), lvgl.ALIGN_CENTER, 0, 0)
-- local label = lvgl.label_create(btn)
-- lvgl.label_set_text(label, "LuatOS!")
-- lvgl.scr_load(scr)


-- disp.clear()
-- disp.putimage("test2",0,0)
-- disp.update()
-- lvgl_button2()
-- log.info("lvgl", lvgl.init(128,160))


-- local img_demo = {}

-- --demo1
-- function img_demo.demo()

-- end


-- local img1 = lvgl.img_create(lvgl.scr_act(), nil);
-- lvgl.img_set_src(img1, "/img_cogwheel_argb.png");
-- -- lvgl.obj_align(img1, nil, lvgl.ALIGN_CENTER, 0, -20);
-- lvgl.obj_set_x(img1, 0)
-- lvgl.obj_set_y(img1, 0)

-- -- lvgl.scr_load(img1)
-- lvgl.obj_align(img1, nil, lvgl.ALIGN_CENTER, 0, -20);

-- lvgl.scr_load(img1)
-- -- local img2 = lvgl.img_create(lvgl.scr_act(), nil);
-- lvgl.img_set_src(img2, LV_SYMBOL_OK.."Accept");
-- lvgl.obj_align(img2, img1, lvgl.ALIGN_OUT_BOTTOM_MID, 0, 20);


-- img_demo.demo()

-- scr = lvgl.obj_create("/test2.bmp", nil)
-- img_bmp = lvgl.img_create(nil, nil)
-- lvgl.obj_set_pos(img_bmp, 0, 0)
-- lvgl.obj_set_size(img_bmp, 128,160)


-- lvgl.img_set_scr(img_bmp,"/test2.bmp")
-- local btn = lvgl.btn_create(scr)
-- lvgl.obj_align(btn, lvgl.scr_act(), lvgl.ALIGN_CENTER, 0, 0)
-- local label = lvgl.label_create(btn)
-- lvgl.label_set_text(label, "LuatOS!")
-- lvgl.scr_load(src)
-- calendar_demo.demo()
log.info("end----------------")

-- x = lvgl.theme_set_act("mono")
-- log.info(x)

sys.taskInit(function()
    --ok{

    -- arc()
    -- clear_lvgl()

    -- bar()
    -- clear_lvgl()

    -- slider()
    -- clear_lvgl()

    -- img_symble()
    -- clear_lvgl()

    -- cont()
    -- clear_lvgl()


    --}

    imgxxxx()
    -- img_symble()

    -- arc()
    -- bar()
    -- slider()
    -- img_symble()
    -- cont()
    -- img_symble()
    -- img_png()
    -- img_png_demo()
    -- lvgl_img()

    while 1 do
        sys.wait(1000)
    end
end)


-- 用户代码已结束---------------------------------------------
-- 结尾总是这一句
sys.run()
-- sys.run()之后后面不要加任何语句!!!!!

-- sys.taskInit(function()
--     sys.wait(100)
--     log.info("lvgl", lvgl.init())
--     -- lvgl.disp_set_bg_color(nil, lvgl.color_hex(0x999999))
--     if lvgl.theme_set_act then
--         -- 切换主题
--         -- lvgl.theme_set_act("default")
--         -- lvgl.theme_set_act("mono")
--         lvgl.theme_set_act("empty")
--         -- lvgl.theme_set_act("material_light")
--         -- lvgl.theme_set_act("material_dark")
--         -- lvgl.theme_set_act("material_no_transition")
--         -- lvgl.theme_set_act("material_no_focus")
--     end
--     local scr = lvgl.obj_create()
--     local btn = lvgl.btn_create(scr)
--     lvgl.obj_align(btn, lvgl.scr_act(), lvgl.ALIGN_CENTER, 0, 0)
--     local label = lvgl.label_create(btn)
--     lvgl.label_set_text(label, "LuatOS!")
--     lvgl.scr_load(scr)
-- end)

