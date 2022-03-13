#include "bsp_key.h"

void bsp_key_init()
{
    gpio_config_t io_conf;
    /* 关闭中断 */
    io_conf.intr_type = GPIO_INTR_DISABLE;
    io_conf.mode = GPIO_MODE_INPUT;
    io_conf.pin_bit_mask = 1ull<<BSP_KEY_UP | 1ull<<BSP_KEY_DOWN | 1ull<<BSP_KEY_LEFT | 1ull<<BSP_KEY_RIGHT | 1ull<<BSP_KEY_OK;
    /* 开启上拉，关闭下拉 */
    io_conf.pull_up_en = 1;
    io_conf.pull_down_en = 0;
    
    gpio_config(&io_conf);
    
    gpio_set_level(BSP_KEY_UP, 1);
    gpio_set_level(BSP_KEY_DOWN, 1);
    gpio_set_level(BSP_KEY_LEFT, 1);
    gpio_set_level(BSP_KEY_RIGHT, 1);
    gpio_set_level(BSP_KEY_OK, 1);
}