
-- """
-- GGS_WGS_ddmm转换为BD09
-- :param lng:WGS_ddmm坐标经度
-- :param lat:WGS_ddmm坐标纬度
-- :return: BD09经度纬度
-- youkai
-- """


-- lng经度 x
-- lat维度 y
function ddmm2BD(lng,lat)
	wgs84_to_bd09(ddmm2ddd(lng,lat))
end

function ddmm2ddd(lng,lat)

    print("ddmm",lng,lat)
    temp = string.format("%.10f", lng)
    -- print("temp: ",temp)
    local ddd_lng_int = math.floor(temp/100)
    local ddd_lng_float = (temp%100)*100/60
    local ddd_lng = ddd_lng_int + ddd_lng_float/100
    -- print(ddd_lng_int,ddd_lng_float)

    temp = string.format("%.10f", lat)
    -- print("temp: ",temp)
    local ddd_lat_int = math.floor(temp/100)
    local ddd_lat_float = (temp%100)*100/60
    local ddd_lat = ddd_lat_int + ddd_lat_float/100

    print("ddmm2ddd",ddd_lng,ddd_lat)
    return ddd_lng,ddd_lat
end
-- ddmm2ddd(lng_ddmmmm,lat_ddmmmm)

-- function  ddmmsstodd(lng, lat)
-- 	-- #度分秒转度（带°′"符号，如120°25′17"）
-- 	lng = re.split("°|′|″", lng)[:3]
-- 	lat = re.split("°|′|″", lat)[:3]
-- 	olng = list(map(int, lng))
-- 	olat = list(map(int, lat))
-- 	return (olng[0] + olng[1] / 60 + olng[2] / 3600), (olat[0] + olat[1] / 60 + olat[2] / 3600)
-- end

x_pi = 3.14159265358979324 * 3000.0 / 180.0
pi = 3.1415926535897932384626  -- π
a = 6378245.0  -- 长半轴
ee = 0.00669342162296594323  -- 扁率



function out_of_china(lng, lat)
	-- """
	-- 判断是否在国内，不在国内不做偏移
	-- :param lng:
	-- :param lat:
	-- :return:
	-- """
    local temp = not (lng > 73.66 and lng < 135.05 and lat > 3.86 and lat < 53.55)
    -- print("type(temp)",type(temp))
	return temp
end


function   _transformlat(lng, lat)
	local ret = -100.0 + 2.0 * lng + 3.0 * lat + 0.2 * lat * lat +  0.1 * lng * lat + 0.2 * math.sqrt(math.abs(lng))
	ret = ret + (20.0 * math.sin(6.0 * lng * pi) + 20.0 * math.sin(2.0 * lng * pi)) * 2.0 / 3.0
	ret = ret + (20.0 * math.sin(lat * pi) + 40.0 * math.sin(lat / 3.0 * pi)) * 2.0 / 3.0
	ret = ret + (160.0 * math.sin(lat / 12.0 * pi) + 320 * math.sin(lat * pi / 30.0)) * 2.0 / 3.0
	return ret
end


function   _transformlng(lng, lat)
	local ret = 300.0 + lng + 2.0 * lat + 0.1 * lng * lng + 0.1 * lng * lat + 0.1 * math.sqrt(math.abs(lng))
	ret = ret + (20.0 * math.sin(6.0 * lng * pi) + 20.0 * math.sin(2.0 * lng * pi)) * 2.0 / 3.0
	ret = ret + (20.0 * math.sin(lng * pi) + 40.0 * math.sin(lng / 3.0 * pi)) * 2.0 / 3.0
	ret = ret + (150.0 * math.sin(lng / 12.0 * pi) + 300.0 * math.sin(lng / 30.0 * pi)) * 2.0 / 3.0
	return ret
end

function wgs84_to_bd09(lng, lat)
	lng, lat = wgs84_to_gcj02(lng, lat)
    print("wgs84_to_gcj02: ",lng,lat)
    lng2, lat2 = gcj02_to_bd09(lng, lat)
    print("gcj02_to_bd09:  ",lng2,lat2)
	return lng2, lat2
end

function   bd09_to_wgs84(bd_lng, bd_lat)
	lng, lat = bd09_to_gcj02(bd_lng, bd_lat)
    lng2, lat2 = gcj02_to_wgs84(lng, lat)
	return lng2, lat2
end


function   gcj02_to_bd09(lng, lat)
	-- """
	-- 火星坐标系(GCJ-02)转百度坐标系(BD-09)
	-- 谷歌、高德——>百度
	-- :param lng:火星坐标经度
	-- :param lat:火星坐标纬度
	-- :return:
	-- """
	z = math.sqrt(lng * lng + lat * lat) + 0.00002 * math.sin(lat * x_pi)
	theta = math.atan(lat, lng) + 0.000003 * math.cos(lng * x_pi)
	bd_lng = z * math.cos(theta) + 0.0065
	bd_lat = z * math.sin(theta) + 0.006
	return bd_lng, bd_lat
end

function   bd09_to_gcj02(bd_lng, bd_lat)
	-- """
	-- 百度坐标系(BD-09)转火星坐标系(GCJ-02)
	-- 百度——>谷歌、高德
	-- :param bd_lat:百度坐标纬度
	-- :param bd_lng:百度坐标经度
	-- :return:转换后的坐标列表形式
	-- """
	x = bd_lng - 0.0065
	y = bd_lat - 0.006
	z = math.sqrt(x * x + y * y) - 0.00002 * math.sin(y * x_pi)
	theta = math.atan(y, x) - 0.000003 * math.cos(x * x_pi)
	gg_lng = z * math.cos(theta)
	gg_lat = z * math.sin(theta)
	return gg_lng, gg_lat
end


function wgs84_to_gcj02(lng, lat)
	-- """
	-- WGS84转GCJ02(火星坐标系)
	-- :param lng:WGS84坐标系的经度
	-- :param lat:WGS84坐标系的纬度
	-- :return:
	-- """
	if out_of_china(lng, lat)then
        -- # 判断是否在国内
		return lng, lat
    end

	dlat = _transformlat(lng - 105.0, lat - 35.0)
	dlng = _transformlng(lng - 105.0, lat - 35.0)
	radlat = lat / 180.0 * pi
	magic = math.sin(radlat)
	magic = 1 - ee * magic * magic
	sqrtmagic = math.sqrt(magic)
	dlat = (dlat * 180.0) / ((a * (1 - ee)) / (magic * sqrtmagic) * pi)
	dlng = (dlng * 180.0) / (a / sqrtmagic * math.cos(radlat) * pi)
	mglat = lat + dlat
	mglng = lng + dlng
	return mglng, mglat
end

function gcj02_to_wgs84(lng, lat)
	-- """
	-- GCJ02(火星坐标系)转GPS84
	-- :param lng:火星坐标系的经度
	-- :param lat:火星坐标系纬度
	-- :return:
	-- """
	if out_of_china(lng, lat) then
        return lng, lat
    end
		
	dlat = _transformlat(lng - 105.0, lat - 35.0)
	dlng = _transformlng(lng - 105.0, lat - 35.0)
	radlat = lat / 180.0 * pi
	magic = math.sin(radlat)
	magic = 1 - ee * magic * magic
	sqrtmagic = math.sqrt(magic)
	dlat = (dlat * 180.0) / ((a * (1 - ee)) / (magic * sqrtmagic) * pi)
	dlng = (dlng * 180.0) / (a / sqrtmagic * math.cos(radlat) * pi)
	mglat = lat + dlat
	mglng = lng + dlng
	return lng * 2 - mglng, lat * 2 - mglat
end

lng_ddmmmm = "12128.43953236" --经度 x 与赤道垂直
lat_ddmmmm = "3114.474413632" --维度 y 与赤道平行

-- temp_lng , temp_lat = ddmm2ddd(lng_ddmmmm,lat_ddmmmm)
-- wgs84_to_bd09(temp_lng , temp_lat)
-- temp_lng , temp_lat = 


-- print("wgs84_to_bd09",)

-- wgs84_to_bd09	121.48507277467	31.245149369259
