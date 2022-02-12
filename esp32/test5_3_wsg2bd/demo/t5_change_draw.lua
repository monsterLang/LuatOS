require("t5_uart_air551")

lng_ddmmmm = "3114.474413632" --经度 x 与赤道垂直
lat_ddmmmm = "12128.43953236" --维度 y 与赤道平行

function ddmmmm2dd(a,b)

    temp = string.format("%.10f", lng_ddmmmm)  -- 字符转浮点
    print("temp: ",temp)
    local dd_lng_int = math.floor(temp/100)
    local dd_lng_float = (temp%100)*100/60
    print(dd_lng_int,dd_lng_float)
    return dd_lng_int,dd_lng_float
end

ddmmmm2dd(lng_ddmmmm,lat_ddmmmm)

-- GGA_list["x"] = data_longitude
-- GGA_list["y"] = data_latitude
function GGA_ok()
    temp_lng,temp_lat = ddmmmm2dd(GGA_list["x"],GGA_list["y"])
    
end