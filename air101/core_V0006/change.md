## LuatOS-SoC@Air101 V0006

1.  新增:  lcd添加位图显示 可以显示各种自定义图片字体了
2.  更新:  i2c.send接口data参数支持integer,string,table,兼容air系列i2c接口
3.  新增:  pin库 例如pin.PB11 再也不用对比gpio号了
4.  更新:  启动时就不再出现xxx r not found日志 避免误导
5.  更新:  pwm支持更高分辨率的占空比 
6.  修正:  spi启用dma，demo频率默认设置20M,sfud配置半双工模式 更快更好用
7.  更新:  统一xmake，彻底不用管lib了 更方便
8.  新增:  添加对otp库的适配
9.  新增:  启用luadb
10.  修正:  修正i2c停止信号问题

