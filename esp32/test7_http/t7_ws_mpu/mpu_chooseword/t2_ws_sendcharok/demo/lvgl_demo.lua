--代码来源--https://doc.openluat.com/wiki/21?wiki_page_id=2561
-- 整理：youkai
-- 注意事项：部分函数中存在wait，需要在sys.taskInit中调用。

function init_lvgl()
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
    
end

function clear_lvgl()
    -- lcd.clear(0xFFFFFF)
    -- lcd.draw()
    sys.wait(2000)
end

