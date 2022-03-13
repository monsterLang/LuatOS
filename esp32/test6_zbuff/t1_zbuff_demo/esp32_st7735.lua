-- 1. display: st735
function init_esp32_st7735 ()
    -- spi test ok
    -- spi clk is io2, cs is IO7
    spi_lcd = spi.deviceSetup(2,7,0,0,8,20000000,spi.MSB,1,1)

    log.info("SPI OK")

    log.info("lcd.init",
    -- st7735 + esp32
    lcd.init("st7735",{port = "device",pin_dc = 6, pin_pwr = 11,pin_rst = 10,direction = 0,w = 128,h = 160,xoffset = 0,yoffset = 0},spi_lcd))

    log.info("LCD OK")
end

function display_line ()
    log.info("lcd.drawLine", lcd.drawLine(20,20,150,20,0x001F))
    log.info("lcd.drawRectangle", lcd.drawRectangle(20,40,120,70,0xF800))
    log.info("lcd.drawCircle", lcd.drawCircle(50,50,20,0x0CE0))
    -- sys.wait(1500)
    log.info("display demo")
end

function display_str ()
    lcd.setFont(lcd.font_opposansm12)
    lcd.drawStr(40,10,"drawStr")
    lcd.setFont(lcd.font_opposansm16_chinese)
    lcd.drawStr(40,40,"drawStr测试")
end

function lvgl_button()
    log.info("lvgl", lvgl.init(128,160))
    lvgl.disp_set_bg_color(nil, 0xFFFFFF)
    local scr = lvgl.obj_create(nil, nil)
    local btn = lvgl.btn_create(scr)
    lvgl.obj_align(btn, lvgl.scr_act(), lvgl.ALIGN_CENTER, 0, 0)
    local label = lvgl.label_create(btn)
    lvgl.label_set_text(label, "LuatOS!")
    lvgl.scr_load(scr)
end

function lvgl_button2()
    log.info("lvgl", lvgl.init())
    lvgl.disp_set_bg_color(nil, 0xFFFFFF)
    scr = lvgl.obj_create(nil, nil)
    btn = lvgl.btn_create(scr)
    lvgl.obj_align(btn, lvgl.scr_act(), lvgl.ALIGN_CENTER, 0, 0)
    label = lvgl.label_create(btn)
    lvgl.label_set_text(label, "LuatOS!")
    lvgl.scr_load(scr)
end

function lvgl_image1( picture)
    log.info("lvgl", lvgl.init())
    lvgl.disp_set_bg_color(nil, 0xFFFFFF)

    -- lvgl.obj_set_size(test_bmp,128,160)
    -- lvgl.img_set_scr(test_bmp,"test2.bmp")

    local scr = lvgl.obj_create(nil, nil)
    local btn = lvgl.btn_create(scr)
    lvgl.obj_align(btn, lvgl.scr_act(), lvgl.ALIGN_CENTER, 0, 0)
    local label = lvgl.label_create(btn)
    lvgl.label_set_text(label, "LuatOS!")
    lvgl.scr_load(scr)    
end


function lvgl_image( picture)
    picture = "test2.bmp"
    log.info("lvgl", lvgl.init())
    -- lvgl.disp_set_bg_color(nil, 0xFFFFFF)
    local scr = lvgl.obj_create(nil, nil)
    lvgl.obj_set_size(test_bmp,128,160)
    lvgl.img_set_scr(test_bmp,picture)
    lvgl.scr_load(scr)    

end

calendar_demo = {}
function calendar_demo.demo()
    log.info("lvgl", lvgl.init())
    local calendar = lvgl.calendar_create(lvgl.scr_act(), nil);
    lvgl.obj_set_size(calendar, 235, 235);
    lvgl.obj_align(calendar, nil, lvgl.ALIGN_CENTER, 0, 0);
    lvgl.obj_set_event_cb(calendar, event_handler);

    --Make the date number smaller to be sure they fit into their area
    lvgl.obj_set_style_local_text_font(calendar, lvgl.CALENDAR_PART_DATE, lvgl.STATE_DEFAULT, lvgl.theme_get_font_small());

    --Set today's date
    local today = lvgl.calendar_date_t()
    today.year = 2018;
    today.month = 10;
    today.day = 23;

    lvgl.calendar_set_today_date(calendar, today);
    lvgl.calendar_set_showed_date(calendar, today);

    local highlighted_days1 = lvgl.calendar_date_t()
    highlighted_days1.year = 2018;
    highlighted_days1.month = 10;
    highlighted_days1.day = 6;

    local highlighted_days2 = lvgl.calendar_date_t()
    highlighted_days2.year = 2018;
    highlighted_days2.month = 10;
    highlighted_days2.day = 11;

    local highlighted_days3 = lvgl.calendar_date_t()
    highlighted_days3.year = 2018;
    highlighted_days3.month = 10;
    highlighted_days3.day = 12;

    local highlighted_days = {highlighted_days1,highlighted_days2,highlighted_days3}
    lvgl.calendar_set_highlighted_dates(calendar, highlighted_days, 3);
end