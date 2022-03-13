#ifndef __BSP_KEY_H
#define __BSP_KEY_H

#include <esp_log.h>
#include <esp_err.h>
#include <driver/gpio.h>

#define BSP_KEY_UP 8
#define BSP_KEY_DOWN 13
#define BSP_KEY_LEFT 5
#define BSP_KEY_RIGHT 9
#define BSP_KEY_OK 4

void bsp_key_init();

#endif
