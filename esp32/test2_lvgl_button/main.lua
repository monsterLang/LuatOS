--- 模块功能：lvgldemo_button
-- @module lvgl
-- @author Dozingfiretruck,youkai
-- @release 2022.01.25

-- LuaTools需要PROJECT和VERSION这两个信息
PROJECT = "lvgldemo"
VERSION = "1.0.0"

log.info("main", PROJECT, VERSION)

-- sys库是标配
_G.sys = require("sys")
require("esp32_st7735")

log.info("hello luatos")

init_esp32_st7735 ()
log.info("lvgl", lvgl.init(128,160))
lvgl.disp_set_bg_color(nil, 0xFFFFFF)
local scr = lvgl.obj_create(nil, nil)
local btn = lvgl.btn_create(scr)
lvgl.obj_align(btn, lvgl.scr_act(), lvgl.ALIGN_CENTER, 0, 0)
local label = lvgl.label_create(btn)
lvgl.label_set_text(label, "LuatOS!")
lvgl.scr_load(scr)


sys.taskInit(function()
    while 1 do
        sys.wait(1000)
    end
end)


-- 用户代码已结束---------------------------------------------
-- 结尾总是这一句
sys.run()
-- sys.run()之后后面不要加任何语句!!!!!
