#include "bsp_lcd.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <esp_system.h>
#include <esp_log.h>
#include <driver/gpio.h>
#include <driver/ledc.h>
#include <driver/spi_master.h>
#include <freertos/FreeRTOS.h>

const static char *TAG = "bsp_lcd";

/**
 * @brief SPI传输指令结构体，由于传输函数返回时SPI控制器仍在使用DMA传输，因此使用静态变量在全局区申请
 * 以保证在函数返回时此变量依然可用。
 */
static spi_transaction_t lcd_trans[6]; //5个指令传输+1个数据传输

static void lcd_spi_pre_transfer_callback(spi_transaction_t *spi);

/**
 * @brief SPI总线配置
 */
static const spi_bus_config_t lcd_spi_bus_config = {
   .miso_io_num = -1, //未使用
   .mosi_io_num = LCD_PIN_MOSI,
   .sclk_io_num = LCD_PIN_CLK,
   .quadwp_io_num = -1, //未使用
   .quadhd_io_num = -1, //未使用
   .max_transfer_sz = LCD_X_PIXELS*LCD_Y_PIXELS*2, //最大传输大小为整个屏幕的像素数*2个字节
};

/**
 * @brief LCD外设配置
 */
static const spi_device_interface_config_t lcd_spi_driver_config = {
   .clock_speed_hz = LCD_SPI_CLOCK_MHZ*1000000, //SPI总线时钟频率，Hz
   .mode = 0, //SPI模式0，CPOL=0，CPHA=0
   .spics_io_num = LCD_PIN_CS, //CS引脚
   .queue_size = sizeof(lcd_trans)/sizeof(spi_transaction_t), //传输队列深度
   .pre_cb = lcd_spi_pre_transfer_callback, //SPI每次传输前的回调函数，用于控制D/C脚
};

/**
 * @brief 初始化LCD所用的总线，并返回SPI句柄
 * 
 * @return SPI句柄
 */
static spi_device_handle_t lcd_bus_init()
{
   /* 初始化非SPI的GPIO */
   gpio_reset_pin(LCD_PIN_DC); //复位GPIO至默认状态，防止GPIO上电默认状态为JTAG时无法由程序控制
   gpio_set_direction(LCD_PIN_DC, GPIO_MODE_OUTPUT); //DC引脚为输出模式

   /* 创建SPI句柄 */
   spi_device_handle_t spi;

   /* 根据buscfg的内容初始化SPI总线 */
   ESP_ERROR_CHECK(
      spi_bus_initialize(LCD_SPI_HOST, &lcd_spi_bus_config, SPI_DMA_CH_AUTO)
   );

   /* 根据lcdcfg的内容将LCD挂载到SPI总线上 */
   ESP_ERROR_CHECK(
      spi_bus_add_device(LCD_SPI_HOST, &lcd_spi_driver_config, &spi)
   );

   return spi;
}

/**
 * @brief SPI开始一次传输前的回调函数，用于控制D/C引脚
 * 
 * @param spi SPI传输指令结构体
 */
static void lcd_spi_pre_transfer_callback(spi_transaction_t *trans)
{
   uint32_t dc = (uint32_t)(trans->user);
   /* 设置D/C引脚的电平 */
   gpio_set_level(LCD_PIN_DC, dc);
}

/**
 * @brief 使用查询方式向LCD发送一个指令，用于LCD初始化阶段
 * 
 * @param spi SPI句柄
 * @param cmd 要发送的指令字节
 */
static void lcd_send_cmd(spi_device_handle_t spi, const uint8_t cmd)
{
   /* 创建并初始化SPI传输指令结构体 */
   spi_transaction_t trans;
   memset(&trans, 0, sizeof(trans));

   /* 配置传输 */
   trans.length = 8; //指令为1字节8位
   trans.tx_buffer = &cmd; //指令字节的地址
   trans.user = (void*)0; //D/C=0

   /* 启动传输 */
   ESP_ERROR_CHECK(
      spi_device_polling_transmit(spi, &trans)
   );
}

/**
 * @brief 使用查询方式向LCD发送一组数据，用于LCD初始化阶段
 * 
 * @param spi SPI句柄
 * @param data 要发送的数据指针
 * @param len 数据长度
 */
static void lcd_send_data(spi_device_handle_t spi, const uint8_t *data, uint8_t len)
{
   /* 创建并初始化SPI传输指令结构体 */
   spi_transaction_t trans;
   memset(&trans, 0, sizeof(trans));

   /* 由于DMA传输要求缓冲区位于内部内存中，因此申请一段可用于DMA的内存并将数据拷入 */
   uint8_t *buff = heap_caps_malloc(len, MALLOC_CAP_DMA); //申请可用于DMA的内存
   memcpy(buff, data, len);

   /* 配置传输。 */
   trans.length = len*8; //数据长度，单位为位
   trans.tx_buffer = buff;
   trans.user = (void*)1; //D/C=1
   
   /* 启动传输 */
   ESP_ERROR_CHECK(
      spi_device_polling_transmit(spi, &trans)
   );

   /* 释放内存 */
   free(buff);
}

/**
 * @brief 初始化ST7735s控制器的寄存器
 * 
 * @param spi SPI句柄
 */
static void lcd_reg_init_st7735s(spi_device_handle_t spi)
{
    lcd_send_cmd(spi, 0x11); //退出睡眠模式

    lcd_send_cmd(spi, 0xB1);
    lcd_send_data(spi, (uint8_t[]){0x05, 0x3C, 0x3C}, 3);

    lcd_send_cmd(spi, 0xB2);
    lcd_send_data(spi, (uint8_t[]){0x05, 0x3C, 0x3C}, 3);

    lcd_send_cmd(spi, 0xB3);
    lcd_send_data(spi, (uint8_t[]){0x05, 0x3C, 0x3C, 0x05, 0x3C, 0x3C}, 6);

    lcd_send_cmd(spi, 0xB4);
    lcd_send_data(spi, (uint8_t[]){0x03}, 1);

    lcd_send_cmd(spi, 0xC0);
    lcd_send_data(spi, (uint8_t[]){0x0E, 0x0E, 0x04}, 3);

    lcd_send_cmd(spi, 0xC1);
    lcd_send_data(spi, (uint8_t[]){0xC5}, 1);

    lcd_send_cmd(spi, 0xC2);
    lcd_send_data(spi, (uint8_t[]){0x0D, 0x00}, 2);

    lcd_send_cmd(spi, 0xC3);
    lcd_send_data(spi, (uint8_t[]){0x8D, 0x2A}, 2);

    lcd_send_cmd(spi, 0xC4);
    lcd_send_data(spi, (uint8_t[]){0x8D, 0xEE}, 2);

    lcd_send_cmd(spi, 0xC5);
    lcd_send_data(spi, (uint8_t[]){0x06}, 1);

    lcd_send_cmd(spi, 0x36); //方向控制
    lcd_send_data(spi, (uint8_t[]){0x78}, 1); //0x08 0xC8 0x78 0xA8

    lcd_send_cmd(spi, 0x3A);
    lcd_send_data(spi, (uint8_t[]){0x55}, 1);

    lcd_send_cmd(spi, 0xE0);
    lcd_send_data(spi, (uint8_t[]){0x0B, 0x17, 0x0A, 0x0D, 0x1A, 0x19, 0x16, 0x1D, 0x21, 0x26, 0x37, 0x3C, 0x00, 0x09, 0x05, 0x10}, 16);

    lcd_send_cmd(spi, 0xE1);
    lcd_send_data(spi, (uint8_t[]){0x0C, 0x19, 0x09, 0x0D, 0x1B, 0x19, 0x15, 0x1D, 0x21, 0x26, 0x39, 0x3E, 0x00, 0x09, 0x05, 0x10}, 16);
}

/**
 * @brief 在LCD上绘制矩形区域，使用DMA传输
 * 
 * @param spi SPI句柄
 * @param x0 矩形的左上角横坐标
 * @param y0 矩阵的左上角纵坐标
 * @param x1 矩形的右下角横坐标
 * @param y1 矩形的右下角纵坐标
 * @param dat 要显示的数据，必须存储在内部RAM中，否则idf会重新申请内存并拷贝数据
 */
void lcd_draw_rect(spi_device_handle_t spi, uint16_t x0, uint16_t y0, uint16_t x1,
                  uint16_t y1, const uint8_t *dat)
{
   /* 由于存储在静态全局区，因此每次传输都需要初始化SPI传输指令结构体 */
   memset(&lcd_trans, 0, sizeof(lcd_trans)); //前5个传输用于设置区域命令，第6个传输用于传输矩形的显示数据

   /**
    * SPI使用DMA传输，而DMA只支持内部RAM作为buffer。若传入的指针为非内部RAM区（PSRAM/ROM），
    * 则idf会自动重新申请一段位于DMA可用区域的内存，并将传入的数据复制到新申请的内存中。
    * 该内存在spi_device_get_trans_result函数中被释放，因此传输完成后必须调用传输结束函数。
    */
   if(!esp_ptr_dma_capable(dat)) {
      ESP_LOGW(TAG, "data at 0x%08X is not capable for dma transfer, "
      "malloc new buffer and copy", (uint32_t)dat);
   }

   y0 += 24; y1 += 24; //偏移

   /* 第1次传输：指令，设置Column地址 */
   lcd_trans[0].tx_data[0] = 0x2A;
   lcd_trans[0].length = 8; //传输长度：1字节8位
   lcd_trans[0].user = (void*)0; //D/C=0，指令
   lcd_trans[0].flags = SPI_TRANS_USE_TXDATA; //发送tx_data内的数据
   ESP_ERROR_CHECK(
      spi_device_queue_trans(spi, &lcd_trans[0], 0) //队列长度足够，不阻塞直接发送，提高速度
   );

   /* 第2次传输：数据，Column范围 */
   lcd_trans[1].tx_data[0] = x0>>8; //起始地址高8位
   lcd_trans[1].tx_data[1] = x0&0xFF; //起始地址高8位
   lcd_trans[1].tx_data[2] = x1>>8; //结束地址高8位
   lcd_trans[1].tx_data[3] = x1&0xFF; //结束地址高8位
   lcd_trans[1].length = 4*8;
   lcd_trans[1].user = (void*)1; //D/C=1，数据
   lcd_trans[1].flags = SPI_TRANS_USE_TXDATA;
   ESP_ERROR_CHECK(
      spi_device_queue_trans(spi, &lcd_trans[1], 0)
   );

   /* 第3次传输：指令，设置Page地址 */
   lcd_trans[2].tx_data[0] = 0x2B;
   lcd_trans[2].length = 8;
   lcd_trans[2].user = (void*)0;
   lcd_trans[2].flags = SPI_TRANS_USE_TXDATA;
   ESP_ERROR_CHECK(
      spi_device_queue_trans(spi, &lcd_trans[2], 0)
   );

   /* 第4次传输：数据，Page范围 */
   lcd_trans[3].tx_data[0] = y0>>8;
   lcd_trans[3].tx_data[1] = y0&0xFF;
   lcd_trans[3].tx_data[2] = y1>>8;
   lcd_trans[3].tx_data[3] = y1&0xFF;
   lcd_trans[3].length = 4*8;
   lcd_trans[3].user = (void*)1;
   lcd_trans[3].flags = SPI_TRANS_USE_TXDATA;
   ESP_ERROR_CHECK(
      spi_device_queue_trans(spi, &lcd_trans[3], 0)
   );

   /* 第5次传输：指令，开始写入图像数据 */
   lcd_trans[4].tx_data[0] = 0x2C;
   lcd_trans[4].length = 8;
   lcd_trans[4].user = (void*)0;
   lcd_trans[4].flags = SPI_TRANS_USE_TXDATA;
   ESP_ERROR_CHECK(
      spi_device_queue_trans(spi, &lcd_trans[4], 0)
   );

   /* 第6次传输：数据，图像数据 */
   lcd_trans[5].tx_buffer = dat;
   lcd_trans[5].length = ((x1-x0+1)*(y1-y0+1)*2)*8;
   lcd_trans[5].user = (void*)1;
   lcd_trans[5].flags = 0; //发送tx_buffer指向的地址
   ESP_ERROR_CHECK(
      spi_device_queue_trans(spi, &lcd_trans[5], 0)
   );

   /**
    * 此处所有指令已经写入队列，SPI控制器正在后台使用DMA进行发送。在下一次传输之前，需要调用
    * lcd_draw_rect_wait_busy()函数来等待上次传输完成并释放内存。
    */
}

/**
 * @brief 等待LCD矩形区域绘制完成，并释放内存
 * 
 * @param spi SPI句柄
 */
void lcd_draw_rect_wait_busy(spi_device_handle_t spi)
{
   /**
    * @brief 保存传输结果的指令结构体，会返回指向存放接收到数据的指针，由于驱动LCD的SPI总线是只写的，
    * 因此此结构体只做占位之用。
    */
   spi_transaction_t *rtrans;

   /* 查询并阻塞等待所有传输结束 */
   for(int i = 0; i < sizeof(lcd_trans)/sizeof(spi_transaction_t); i ++) {
      ESP_ERROR_CHECK(
         spi_device_get_trans_result(spi, &rtrans, portMAX_DELAY)
      );
   }
}

/**
 * @brief 开关LCD的显示
 * 
 * @param spi SPI句柄
 * @param status 真或假控制LCD的开或关
 */
void lcd_display_switch(spi_device_handle_t spi, bool status)
{
   if(status) {
      lcd_send_cmd(spi, 0x29); //开显示
      ESP_LOGW(TAG, "lcd display on");
   } else {
      lcd_send_cmd(spi, 0x28); //关显示
      ESP_LOGW(TAG, "lcd display off");
   }
}

/**
 * @brief 初始化LCD
 * 
 * @return spi_device_handle_t 用于控制LCD的SPI句柄
 */
spi_device_handle_t lcd_init()
{
   /* 初始化复位引脚 */
   gpio_config_t io_conf;
   io_conf.intr_type = GPIO_INTR_DISABLE;
   io_conf.mode = GPIO_MODE_OUTPUT;
   io_conf.pin_bit_mask = 1ull<<LCD_PIN_RST;
   io_conf.pull_up_en = 0;
   io_conf.pull_down_en = 0;
   gpio_config(&io_conf);
   gpio_set_level(LCD_PIN_RST, 1);

   /* 初始化总线 */
   spi_device_handle_t spi = lcd_bus_init();
   
   /* 初始化LCD控制器寄存器 */
   lcd_reg_init_st7735s(spi);

   ESP_LOGI(TAG, "lcd bus & regs initialized");
   return spi;
}
