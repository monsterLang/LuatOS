require("t5_BD2lcd")
require("t5_wgs2BD")



function wgs2lcd(x,y)
    -- wgs ddmm格式转为BD09
    BD_x , BD_y = ddmm2BD(x,y)
    print(BD_x , BD_y )
    set_cur(BD_x,BD_y)
    temp_lcd_x ,temp_lcd_y = BD2lcd()

    return temp_lcd_x ,temp_lcd_y 
end

-- wgs2lcd(lng_ddmmmm,lat_ddmmmm)

