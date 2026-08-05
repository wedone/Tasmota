# 项目需求规格 (PRD) — Tasmota CC1101 多功能网关

> 文档状态：草稿起草中
> 最后更新：2026-08-05

---

## 1. 概述

### 1.1 项目背景与目标

#### 背景
本项目基于已有的 ESP32-Solo1 + CC1101 硬件平台。在独立仓库 `SmartRF-IDF`（ESP-IDF 工程）中，CC1101 的 ASK/OOK 驱动与 RCSwitch 协议解码已验证可用，能够稳定接收并重放 433MHz 固定码遥控器信号。

现需将该能力整合进 Tasmota 固件，构建一个 433MHz 多功能网关，集成以下能力：
- 遥控器信号录制、管理、重放
- 433MHz 无线门磁传感器接入、状态监听、联动触发
- WebUI 可视化管理
- MQTT 接入与 Home Assistant 自动发现

#### 目标
- 在不修改 Tasmota C++ 核心的前提下，通过 Berry 脚本扩展实现全部业务逻辑与 WebUI（CC1101 驱动移植除外）
- 复用已验证的 CC1101 + RCSwitch 驱动能力，缩短开发周期
- 设备重启后遥控器与门磁数据不丢失
- 通过 MQTT 接入 Home Assistant，实现门磁状态联动与遥控器重放触发

#### 非目标
- 不追求商业产品级的稳定性与多设备生产能力
- 不做滚动码遥控器支持（KeeLoq 等）
- 不做无屏硬件上的 LVGL 显示界面

### 1.2 术语定义

| 术语 | 说明 |
|------|------|
| **CC1101** | TI 生产的 sub-GHz 射频收发器芯片，本项目使用 433MHz 频段 |
| **ASK/OOK** | 幅移键控/通断键控，433MHz 遥控器与门磁常用调制方式 |
| **RCSwitch** | 开源 433MHz 协议库，支持协议 1~24 的固定码解码与发送 |
| **GDO0 / GDO2** | CC1101 的通用数字输出引脚，GDO0 用于数据包中断，GDO2 用于状态/辅助中断 |
| **UFS** | Tasmota 的用户文件系统（基于 ESP32 flash 分区），用于持久化数据 |
| **Berry** | Tasmota 内嵌的 Python 风格脚本语言，用于扩展功能而不修改 C++ 核心 |
| **xdrv** | Tasmota 的驱动框架编号前缀（如 xdrv_52 为 Berry 引擎） |
| **SSE** | Server-Sent Events，WebUI 动态数据推送机制 |
| **HA Discovery** | Home Assistant 自动发现机制，设备上线后自动注册实体 |
| **固定码** | 遥控器每次发送相同码值的协议（与滚动码相对） |
| **原始波形** | 不依赖协议解码，直接保存的信号高低电平时序数组 |

### 1.3 参考资料

#### 项目内文档
- [硬件规格文档.md](./硬件规格文档.md) — ESP32-Solo1 开发板与 CC1101 模块规格、引脚、电源
- [cc1101模块引脚表.md](./cc1101模块引脚表.md) — CC1101 模块引脚定义
- [CC1101_DEBUG_LOG.md](./CC1101_DEBUG_LOG.md) — CC1101 驱动调试过程与最终寄存器配置

#### Tasmota 开发参考（`.doc_for_ai/` 目录）
- `BERRY_LANGUAGE_REFERENCE.md` — Berry 语言参考
- `BERRY_TASMOTA.md` — Tasmota 中 Berry 编程指南
- `BERRY_C_EXTENSION_REFERENCE.md` — Berry C 扩展参考
- `TASMOTA_WEBUI_CODING_GUIDE.md` — WebUI 编码指南
- `TASMOTA_SUPPORT_DEEP_ANALYSIS.md` — Tasmota 支持能力深度分析

#### 上游仓库（驱动来源）
- `https://github.com/wedone/SmartRF-IDF/tree/main/components/cc1101/` — CC1101 C 驱动（ESP-IDF 风格，待移植）
- `https://github.com/wedone/SmartRF-IDF/tree/main/components/RCSwitch/` — RCSwitch 协议库（C 实现）

#### 外部资料
- [TI CC1101 数据手册](https://www.ti.com/product/CC1101)
- [SmartRC-CC1101-Driver-Lib](https://github.com/simonfromhardcore/SmartRC-CC1101-Driver-Lib)
- [Tasmota 官方文档](https://tasmota.github.io/docs/)

---

## 2. 范围界定

### 2.1 功能范围（In Scope）
[待填充]

### 2.2 范围外（Out of Scope）
[待填充]

---

## 3. 用户场景与用例

### 3.1 角色定义
[待填充]

### 3.2 核心用例
[待填充]

---

## 4. 功能需求

### 4.1 遥控器管理
#### 4.1.1 信号录制
#### 4.1.2 遥控器列表与管理
#### 4.1.3 遥控器编辑
#### 4.1.4 信号发射
[待填充]

### 4.2 门磁管理
#### 4.2.1 门磁接入与监听
#### 4.2.2 门磁触发联动
#### 4.2.3 门磁配对与管理
[待填充]

### 4.3 WebUI 定制
[待填充]

### 4.4 数据存储
[待填充]

### 4.5 MQTT 与 Home Assistant 集成
[待填充]

---

## 5. 非功能需求

### 5.1 性能与容量
[待填充]

### 5.2 可靠性与异常处理
[待填充]

### 5.3 硬件约束
[待填充]

---

## 6. 验收标准

### 6.1 各功能验收点
[待填充]

### 6.2 MVP 边界
[待填充]

---

## 7. 附录

### 7.1 数据模型草案
[待填充]

### 7.2 相关文档与代码位置
[待填充]
