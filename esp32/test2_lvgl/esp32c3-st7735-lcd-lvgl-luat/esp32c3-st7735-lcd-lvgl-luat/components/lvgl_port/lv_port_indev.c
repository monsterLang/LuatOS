#include "lv_port_indev.h"
#include "bsp_key.h"

lv_indev_t *indev_keypad;

static void keypad_read(lv_indev_drv_t *indev_drv, lv_indev_data_t *data)
{
    static uint32_t last_key = 0;

    /*Translate the keys to LVGL control characters according to your key definitions*/
    if(gpio_get_level(BSP_KEY_UP) == 0) {
        data->state = LV_INDEV_STATE_PR;
        data->key = LV_KEY_UP;
    } else if(gpio_get_level(BSP_KEY_DOWN) == 0) {
        data->state = LV_INDEV_STATE_PR;
        data->key = LV_KEY_DOWN;
    } else if(gpio_get_level(BSP_KEY_LEFT) == 0) {
        data->state = LV_INDEV_STATE_PR;
        data->key = LV_KEY_LEFT;
    } else if(gpio_get_level(BSP_KEY_RIGHT) == 0) {
        data->state = LV_INDEV_STATE_PR;
        data->key = LV_KEY_RIGHT;
    } else if(gpio_get_level(BSP_KEY_OK) == 0) {
        data->state = LV_INDEV_STATE_PR;
        data->key = LV_KEY_ENTER;
    } else {
        data->state = LV_INDEV_STATE_REL;
        data->key = last_key;
    }

    last_key = data->key;
}

void lv_port_indev_init(void)
{
    static lv_indev_drv_t indev_drv;

    bsp_key_init();

    lv_indev_drv_init(&indev_drv);
    indev_drv.type = LV_INDEV_TYPE_KEYPAD;
    indev_drv.read_cb = keypad_read;
    indev_keypad = lv_indev_drv_register(&indev_drv);
}

