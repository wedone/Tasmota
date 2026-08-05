# CC1101 驱动调试记录

本文档记录了 ESP-IDF 下 CC1101 驱动的调试过程和解决方案。

## 目录

1. [问题 1: 芯片版本检测失败](#1-芯片版本检测失败)
2. [问题 2: 无法接收遥控信号](#2-无法接收遥控信号)
3. [最终解决方案](#最终解决方案)

---

## 1. 芯片版本检测失败

### 问题现象

```
I (321) CC1101: CC1101_PARTNUM 0
I (321) CC1101: CC1101_VERSION 4
E (321) CC1101: CC1101 not installed
```

驱动检测 VERSION=20，但实际芯片 VERSION=4。

### 原因分析

驱动代码中版本检测逻辑过于严格：

```c
// 原始代码
if (CHIP_PARTNUM != 0 || CHIP_VERSION != 20) {
    ESP_LOGE(TAG, "CC1101 not installed");
    return ESP_FAIL;
}
```

### 解决方案

修改 [cc1101.c](components/cc1101/cc1101.c) 第 515 行，接受 VERSION=4 或 VERSION=20：

```c
if (CHIP_PARTNUM != 0 || (CHIP_VERSION != 4 && CHIP_VERSION != 20)) {
    ESP_LOGE(TAG, "CC1101 not installed (PARTNUM=%d, VERSION=%d)", CHIP_PARTNUM, CHIP_VERSION);
    return ESP_FAIL;
}
```

### 相关文件

- [cc1101.c#L515](components/cc1101/cc1101.cc1101.c#L515)

---

## 2. 无法接收遥控信号

### 问题现象

- RSSI 稳定在 -75 dBm（底噪）
- 按遥控器时 RSSI 无变化
- RCSwitch 无法解码

### 排查过程

#### 2.1 ASK/OOK 调制配置

尝试配置 CC1101 为 ASK/OOK 模式，但未成功。

#### 2.2 频率问题

发现关键问题：**频率不匹配**！

| 配置 | 频率值 | 实际频率 |
|------|--------|----------|
| 默认 ESP-IDF 驱动 | FREQ=0x10A762 | 433.00 MHz |
| Arduino SmartRC | FREQ=0x10B071 | **433.92 MHz** |

大多数遥控器使用 433.92 MHz！

### 最终寄存器值

从正常工作的 Arduino 版本读取的确切寄存器值：

| 寄存器 | 值 | 说明 |
|--------|-----|------|
| IOCFG0 | 0x0D | GDO0 输出配置 |
| IOCFG2 | 0x0D | GDO2 输出配置 |
| PKTCTRL0 | 0x32 | 包控制 |
| MDMCFG2 | 0x32 | ASK 调制 |
| MDMCFG3 | 0x43 | 数据速率 |
| MDMCFG4 | 0x06 | 调制带宽 |
| DEVIATN | 0x47 | 频率偏差 |
| FREQ0 | 0x71 | 频率低字节 |
| FREQ1 | 0xB0 | 频率中字节 |
| FREQ2 | 0x10 | 频率高字节 |

### 频率计算公式

```
Fcarrier = { Fxosc / 2^16 } * FREQ[23:0]

例如 433.92 MHz:
FREQ = round(433.92 * 2^16 / 26) = 0x10B071
```

---

## 最终解决方案

### setAskOokMode() 函数

在 [cc1101.c](components/cc1101/cc1101.c) 中添加 ASK/OOK 配置函数：

```c
void setAskOokMode(void)
{
    cmdStrobe(CC1101_SIDLE);
    
    writeReg(CC1101_IOCFG0, 0x0D);
    writeReg(CC1101_IOCFG2, 0x0D);
    writeReg(CC1101_PKTCTRL0, 0x32);
    writeReg(CC1101_MDMCFG2, 0x32);
    writeReg(CC1101_MDMCFG3, 0x43);
    writeReg(CC1101_MDMCFG4, 0x06);
    writeReg(CC1101_DEVIATN, 0x47);
    writeReg(CC1101_FREQ0, 0x71);
    writeReg(CC1101_FREQ1, 0xB0);
    writeReg(CC1101_FREQ2, 0x10);
}
```

### 使用方法

```c
// 初始化 CC1101
init(CFREQ_433, CSPEED_38400);

// 配置为 ASK/OOK 模式
setAskOokMode();

// 进入接收模式
setRxState();

// RCSwitch 解码
RCSWITCH_t RCSwitch;
initSwich(&RCSwitch);
enableReceive(&RCSwitch, GDO0_GPIO);

if (available(&RCSwitch)) {
    unsigned long value = getReceivedValue(&RCSwitch);
    // 处理接收到的代码
}
```

---

## 测试结果

```
I (321) SmartRF: CC1101 初始化成功
I (331) SmartRF: CC1101 进入 RX 模式
I (361) SmartRF: 系统就绪，等待遥控信号...

I (123991) SmartRF: 收到信号: 代码=11747249, 位数=24, 协议=1
I (125201) SmartRF: 收到信号: 代码=11747256, 位数=24, 协议=1
```

---

## 硬件连接

| CC1101 | ESP32 |
|--------|-------|
| VCC | 3.3V |
| GND | GND |
| SCK | GPIO 18 |
| MISO | GPIO 19 |
| MOSI | GPIO 23 |
| CSN | GPIO 5 |
| GDO0 | GPIO 4 |

---

## 参考资料

- [TI CC1101 数据手册](https://www.ti.com/product/CC1101)
- [SmartRC-CC1101-Driver-Lib](https://github.com/simonfromhardcore/SmartRC-CC1101-Driver-Lib)
- [esp-idf-cc1101](https://github.com/nopnop2002/esp-idf-cc1101)
- [esp-idf-rc-switch](https://github.com/nopnop2002/esp-idf-rc-switch)
