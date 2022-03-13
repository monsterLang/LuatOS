#ifndef __BSP_LCD_H
#define __BSP_LCD_H

#include "driver/spi_master.h"

/* 屏幕总线参数 */
#define LCD_SPI_HOST       SPI2_HOST //即VSPI
#define LCD_SPI_CLOCK_MHZ  30

/* 屏幕硬件连接 */
#define LCD_PIN_CS   7
#define LCD_PIN_CLK  2
#define LCD_PIN_MOSI 3
#define LCD_PIN_DC   6
#define LCD_PIN_RST  10

/* 屏幕分辨率 */
#define LCD_X_PIXELS 160
#define LCD_Y_PIXELS 80

spi_device_handle_t lcd_init();
void lcd_display_switch(spi_device_handle_t spi, bool status);

void lcd_draw_rect(spi_device_handle_t spi, uint16_t x0, uint16_t y0, uint16_t x1,
                    uint16_t y1, const uint8_t *dat);
void lcd_draw_rect_wait_busy(spi_device_handle_t spi);

#endif
