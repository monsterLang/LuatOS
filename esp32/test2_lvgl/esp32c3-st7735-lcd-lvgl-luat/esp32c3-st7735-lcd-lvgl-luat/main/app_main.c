#include <esp_err.h>
#include <esp_log.h>

#include <freertos/FreeRTOS.h>
#include <freertos/task.h>

#include "lv_port_disp.h"
#include "lv_port_tick.h"
#include "lv_port_indev.h"

static const char *TAG = "main";

static void event_handler(lv_event_t * e)
{
    lv_event_code_t code = lv_event_get_code(e);
    lv_obj_t * obj = lv_event_get_target(e);
    if(code == LV_EVENT_VALUE_CHANGED) {
        uint32_t id = lv_btnmatrix_get_selected_btn(obj);
        const char * txt = lv_btnmatrix_get_btn_text(obj, id);

        ESP_LOGI(TAG, "%s was pressed", txt);
    }
}

static const char * btnm_map[] = {"1", "2", "3", "4", "\n",
                                  "5", "6", "7", "8", ""};

void lv_example_btnmatrix_1(void)
{
    lv_obj_t * btnm1 = lv_btnmatrix_create(lv_scr_act());
    lv_btnmatrix_set_map(btnm1, btnm_map);
    lv_obj_align(btnm1, LV_ALIGN_CENTER, 0, 0);
    lv_obj_set_size(btnm1, 160, 80);
    lv_obj_add_event_cb(btnm1, event_handler, LV_EVENT_ALL, NULL);

    lv_group_t * group = lv_group_create();
    lv_group_add_obj(group, btnm1);
    lv_indev_set_group(indev_keypad, group);
}

void app_main(void)
{
    TickType_t xLastWakeTime;
    const TickType_t xPeriod = pdMS_TO_TICKS(10);
    
	lv_init();
    lv_port_disp_init();
    lv_port_indev_init();
    lv_create_tick();
    
    lv_example_btnmatrix_1();

    ESP_LOGI(TAG, "free heap:%.1fkb", (float)esp_get_free_internal_heap_size()/1024);

    while(1) {
        lv_task_handler();
        vTaskDelayUntil(&xLastWakeTime, xPeriod);
    }
}
