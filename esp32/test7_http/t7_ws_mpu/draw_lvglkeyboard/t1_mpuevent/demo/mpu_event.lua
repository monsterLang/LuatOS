
require("mpucont")

function trigger_event()
    -- log.info("in trigger")
    sys.wait(500)
end

function mpu_event_right()
    -- log.info("event -> right")
    lvgl.label_set_text(label_event,"right")
end

function mpu_event_left()
    -- log.info("event <- left")
    lvgl.label_set_text(label_event,"left")
end

function mpu_event_up()
    -- log.info("event |` up")
    lvgl.label_set_text(label_event,"up")
end

function mpu_event_down()
    -- log.info("event |_ down")
    lvgl.label_set_text(label_event,"down")
end

function judge_status()
    if list_mpu_tempvalue["x"] > 25 then
        mpu_event_right()
        trigger_event()
    elseif list_mpu_tempvalue["x"] <-25 then
        mpu_event_left()
        trigger_event()
    -- else
    --     ---- -- log.info("return x")
    --     return 0
    end

    if list_mpu_tempvalue["y"] > 25 then
        mpu_event_up()
        trigger_event()
    elseif list_mpu_tempvalue["y"] <-25 then
        mpu_event_down()
        trigger_event()
    -- else
    --     ---- -- log.info("return x")
    --     return 0
    end
end

function init_event_label()
    label_event = lvgl.label_create(mpu6050_cont,nil)
    lvgl.obj_set_pos(label_event,60,140)
    lvgl.label_set_text(label_event,"sss")
    -- lvgl.scr_load(label_event)
end