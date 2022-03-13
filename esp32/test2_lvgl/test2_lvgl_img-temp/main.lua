--- 模块功能: lvgl img
-- @module lcd
-- @author youkai
-- @release 2022.02.19

-- LuaTools需要PROJECT和VERSION这两个信息
PROJECT = "esp32_lvgl_img_test_display"
VERSION = "1.0.0"

log.info("main", PROJECT, VERSION)

-- sys库是标配
_G.sys = require("sys")

require("t1_display")
require("t2_lvgl_demo")

-- function init_esp32_st7735()
--     spi_lcd = spi.deviceSetup(2,7,0,0,8,96*1000*1000,spi.MSB,1,1)
--     log.info("lcd.init",
--     -- st7735 + esp32
--     lcd.init("st7735",{port = "device",pin_dc = 6, pin_pwr = 11,pin_rst = 10,direction = 0,w = 128,h = 160,xoffset = 0,yoffset = 0},spi_lcd))
-- end

-- function init_lvgl()
--     log.info("init lvgl")
--     if lvgl.init(128,160) == true then
--         log.debug("lvgl init ok.")
--     else
--         log.debug("lvgl init error.")
--     end
-- end

-- function lvgl_img_test(file_path)
--     print("in lvgl_img_test")
--     local demo_img_label = lvgl.label_create(lvgl.scr_act(), nil)
--     lvgl.obj_set_size(demo_img_label,128,160)
--     print("demo_img_label",demo_img_label)
--     local img = lvgl.img_create(demo_img_label,nil)			--
--     print("img",img)
--     log.info("img_set_src",lvgl.img_set_src(img, file_path))		--设置图片来源

--     log.info("obj_align",lvgl.obj_align(img, lvgl.scr_act(), lvgl.ALIGN_CENTER, 0, 0)) 	--图片居中
--     log.info("scr_load",lvgl.scr_load(demo_img_label))
--     log.info("lvgl demo: img_png")
-- end

function lvgl_img(file_path)
    print("in lvgl_img")
    local demo_img_cont = lvgl.cont_create(lvgl.scr_act(), nil)
    lvgl.obj_set_size(demo_img_cont,128,160)
    print("demo_img_cont",demo_img_cont)
    local img = lvgl.img_create(demo_img_cont,nil)			--
    print("img",img)
    log.info("img_set_src",lvgl.img_set_src(img, file_path))		--设置图片来源

    log.info("obj_align",lvgl.obj_align(img, lvgl.scr_act(), lvgl.ALIGN_CENTER, 0, 0)) 	--图片居中
    log.info("scr_load",lvgl.scr_load(demo_img_cont))
    log.info("lvgl demo: img_png")
end


function lvgl_img_test(file_path)
    -- print("in lvgl_img")
    -- local demo_img_cont = lvgl.cont_create(lvgl.scr_act(), nil)
    -- lvgl.obj_set_size(demo_img_cont,128,160)
    -- print("demo_img_cont",demo_img_cont)
    -- local img = lvgl.img_create(demo_img_cont,nil)			--
    -- print("img",img)
    -- log.info("img_set_src",lvgl.img_set_src(img, file_path))		--设置图片来源

    -- log.info("obj_align",lvgl.obj_align(img, lvgl.scr_act(), lvgl.ALIGN_CENTER, 0, 0)) 	--图片居中
    -- log.info("scr_load",lvgl.scr_load(demo_img_cont))
    -- log.info("lvgl demo: img_png")

    scr = lvgl.obj_create()
    img = lvgl.img_create(scr,nil)			--
    style_img = lvgl.style_create()

	lvgl.style_set_image_recolor(style_img, lvgl.STATE_DEFAULT, lvgl.color_make(0xff, 0xff, 0xff))
	lvgl.style_set_image_recolor_opa(style_img, lvgl.STATE_DEFAULT, 0)
	lvgl.style_set_image_opa(style_img, lvgl.STATE_DEFAULT, 125)
	lvgl.obj_add_style(img, lvgl.IMG_PART_MAIN, style_img)
	lvgl.obj_set_pos(img, 0, 0)
	lvgl.obj_set_size(img, 128, 160)
	-- lvgl.obj_set_click(img, true)
	lvgl.img_set_src(img,file_path)
	lvgl.img_set_pivot(img, 0,0)
	lvgl.img_set_angle(img, 0)

    log.info("scr_load",lvgl.scr_load(scr))

    -- lvgl.img_set_src(img, file_path)		--设置图片来源
    -- lvgl.obj_align(img, lvgl.scr_act(), lvgl.ALIGN_CENTER, 0, 0) 	--图片居中
    -- log.info("scr_load",lvgl.scr_load(scr))
    -- log.info("lvgl demo: img_bmp")
end


log.info("end require")

--添加硬狗防止程序卡死
-- wdt.init(15000)--初始化watchdog设置为15s
-- sys.timerLoopStart(wdt.feed, 10000)--10s喂一次狗

-- 初始化屏幕
init_esp32_st7735 ()
init_lvgl()

sys.taskInit(function()
    -- ps:有wait不能放在外面
    -- demo_img_symble()

    -- sys.wait(5000)
    -- print("xxx")
    -- -- img_path = "/luadb/bbb.bin"
    -- img_path = "/luadb/0.jpg"
    img_path = "/luadb/logo.jpg"
    -- -- img_path = "/luadb/test3.bmp"
    -- -- img_path = "/luadb/RedPack_.jpg"

    log.info("fsize:"..img_path, fs.fsize(img_path))

    lvgl_img_test(img_path)

    while 1 do
        sys.wait(10)
    end
end)

sys.run()