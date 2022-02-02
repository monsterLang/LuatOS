--必须在这个位置定义PROJECT和VERSION变量
--PROJECT：ascii string类型，可以随便定义，只要不使用,就行
--VERSION：ascii string类型，如果使用Luat物联云平台固件升级的功能，必须按照"X.X.X"定义，X表示1位数字；否则可随便定义
PROJECT = "MPU6XXX"
VERSION = "1.0.0"


require "sys"

-- 加载I²C功能测试模块
require "mpu6xxx"
-- mpu6xxx()
-- -- 启动系统框架
sys.init(0, 0)
-- sys.taskInit(mpu6xxx)
sys.run()
