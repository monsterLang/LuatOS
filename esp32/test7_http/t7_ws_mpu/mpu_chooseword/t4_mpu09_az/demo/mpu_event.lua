
require("mpucont")

function table_leng(t)
    local leng=0
    for k, v in pairs(t) do
      leng=leng+1
    end
    return leng;
end

-- keyboard_list = {"1","2","3","4","5","6","7","8","9","0","a"}
keyboard_list = {'!','#','$','%','&','"','(',')','*','+',',','-','.','/','0','1','2','3','4','5','6','7','8','9',':',';','<','=','>','?','@','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','[',']','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','|','~','_' }
keyboard_list_Max = table_leng(keyboard_list)
-- print("keyboard_list",keyboard_list_Max)
keyboard_value = {"please input:"}

function trigger_event()
   -- -- log.info("in trigger")
    judge_keyboard()
    sys.wait(500)
end

function mpu_event_right()
   -- -- log.info("event -> right")
    keyboard_temp_num = keyboard_temp_num+1
    lvgl.label_set_text(label_event,"right")
end

function mpu_event_left()
   -- -- log.info("event <- left")
    keyboard_temp_num = keyboard_temp_num-1
    lvgl.label_set_text(label_event,"left")
end

function mpu_event_up()
   -- -- log.info("event |` up")
    lvgl.label_set_text(label_event,"up")
    table.insert(keyboard_value,keyboard_list[keyboard_temp_num])
   -- -- log.info("choose word:",table.concat(keyboard_value))
    lvgl.label_set_text(label_keyboard_value,table.concat(keyboard_value))
end

function mpu_event_down()
   -- -- log.info("event |_ down")
    lvgl.label_set_text(label_event,"down")
    if keyboard_value[1] ~= nil then
        table.remove(keyboard_value)
    end
    
   -- -- log.info("choose word:",table.concat(keyboard_value))
    lvgl.label_set_text(label_keyboard_value,table.concat(keyboard_value))
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
    keyboard_temp_num = 1

    init_keyboard_label()
end

function init_keyboard_label()
    label_keyboard_input = lvgl.label_create(mpu6050_cont,nil)
    lvgl.obj_set_pos(label_keyboard_input,5,140)
    lvgl.label_set_text(label_keyboard_input,keyboard_list[keyboard_temp_num])


    label_keyboard_value = lvgl.label_create(mpu6050_cont,nil)
    lvgl.obj_set_pos(label_keyboard_value,5,120)
    lvgl.label_set_text(label_keyboard_value,table.concat(keyboard_value)) --table.concat(list_name)????????????????????????????????????

end

function judge_keyboard()
    if keyboard_temp_num < 1 then
        keyboard_temp_num = keyboard_list_Max
    elseif keyboard_temp_num > keyboard_list_Max  then
        keyboard_temp_num = 1
    end
    lvgl.label_set_text(label_keyboard_input,keyboard_list[keyboard_temp_num])

     
end