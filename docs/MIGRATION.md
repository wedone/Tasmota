# SmartRF-IDF 迁移计划（自 Tasmota Berry 主线）

## 背景

长期路线确定为 `SmartRF-IDF`（ESP-IDF v5.1.2 + CC1101 + RCSwitch）。
Tasmota Berry 版作为功能对照与回退分支保留，不再投入新功能开发。

Tasmota 版在 solo1 上出现的主要问题是：Berry 动态生成大页面、低 Heap 下
偶发整机卡死，录制/编辑遥控时 `app.css` 获取失败。IDF 版采用静态 SPA +
JSON API，页面渲染在浏览器完成，固件不承担大字符串拼接。

## 功能对照

| 功能 | Tasmota Berry | SmartRF-IDF 现状 | 迁移目标 |
| --- | --- | --- | --- |
| 多按钮遥控 | 有（按钮组、图标、逐个录制/重录/编辑） | 单按钮 | 统一设备模型 |
| 门磁 | 单码 + bit0 状态判定，统一进设备 | 开/关双码 | 统一设备模型 |
| 设备管理 | 搜索、编辑、删除、添加流程 | 遥控/门磁分离 | 统一管理 |
| 虚拟设备 | 有（ON/OFF 触发序列） | 无 | 补齐 |
| 门磁联动 | 有（开门/关门触发 RF/MQTT） | 无 | 补齐 |
| 事件日志 | 有（标准时间、延迟落盘） | 无 | 补齐 |
| 备份/恢复 | RfBackup/RfRestore JSON | 无 | 补齐 |
| MQTT | `cmnd/<topic>/RfSend` 等 Tasmota 命令 | `SmartRF/<id>/cmnd/#` 自定义 JSON | 对齐 |
| HA Discovery | button/binary_sensor/switch/sequence | button | 对齐 |
| 存储 | JSON 文件 | NVS | SPIFFS + JSON 文件 |

## 架构决策

1. 数据存储改用 SPIFFS，设备按文件保存，避免整库 JSON 载入内存：
   - `/spiffs/meta.json`：`next_remote_id`、`next_door_id`
   - `/spiffs/devices/remote_<id>.json`、`/spiffs/devices/door_<id>.json`
   - `/spiffs/events.log`：JSON 行日志，保留最近 100 条
2. 遥控与门磁统一为设备：
   - `kind=remote`：名称、分组、图标、备注、按钮数组
   - `kind=door`：名称、位置、图标、备注、编码/位数/协议、状态
3. 数据以数字 ID 引用，改名不影响序列、联动、MQTT/HA。
4. 页面层继续使用静态 SPA + JSON API，不在固件里拼接大 HTML。
5. RF 接收支持多监听器，避免 MQTT 与门磁/联动互相覆盖回调。

## 实施阶段

### 阶段 1：统一设备模型与存储（当前）

- 添加 SPIFFS 分区与挂载
- 新增 `device_manager`：设备 CRUD、按钮、门磁状态、日志
- 重构 `rf_manager`：多监听器、协议/脉宽/重复发送、可查询学习结果
- 迁移 web_server / mqtt / discovery / sequence / logic 的遥控、门磁接口
- 保持旧 SPA 兼容，同时暴露新 `/api/devices`、`/api/learn_event`、`/api/logs`

### 阶段 2：APP UI 迁移

- 首页设备 4 列，遥控点击滑出按钮组
- 添加设备：类型选择 -> 按钮数量 -> 逐个录制
- 设备管理：搜索、编辑、长按按钮编辑射频数据、删除
- 场景、虚拟设备、联动、日志页面
- 备份/恢复

### 阶段 3：MQTT / HA 对齐

- Tasmota 兼容 topic：`cmnd/<topic>/RfSend`、`RfSequence`、`RfVDevice`
- HA：button（遥控按钮/场景）、binary_sensor（门磁）、switch（虚拟设备）
- 上线/离线 LWT 与状态 topic

### 阶段 4：稳定性与性能

- solo1 单核下任务栈、Heap 审计
- 日志/设备落盘批量化
- OTA 升级、备份恢复验证

## 对照仓库

- Tasmota Berry 驱动：`D:\VC\Tasmota\tasmota\berry\drivers\cc1101_gateway.be`
- Tasmota APP UI：`D:\VC\Tasmota\tasmota\berry\drivers\cc1101_webapp.be`
