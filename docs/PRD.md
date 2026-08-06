# 项目需求规格 (PRD) — Tasmota CC1101 多功能网关

> 文档状态：草稿完成，待评审
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
- 在 Tasmota 固件框架内实现全部业务逻辑与 WebUI，实现方式不做强制限制（可使用 Berry 脚本、C 扩展驱动，或二者混合，优先选择可靠性高、易于维护的方案）
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
| **CC1101** | TI 生产的 sub-GHz 射频收发器芯片，本项目默认使用 433MHz 频段可切换 868/915MHz |
| **ASK/OOK** | 幅移键控/通断键控，433MHz 遥控器与门磁常用调制方式 |
| **RCSwitch** | 开源 433MHz 协议库，支持协议 1~24 的固定码解码与发送 |
| **GDO0 / GDO2** | CC1101 的通用数字输出引脚，GDO0 用于数据包中断，GDO2 用于状态/辅助中断 |
| **UFS** | Tasmota 的用户文件系统（基于 ESP32 flash 分区），用于持久化数据 |
| **Berry** | Tasmota 内嵌的 Python 风格脚本语言，用于扩展 Tasmota 功能（本项目的可选实现方式之一） |
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

#### 2.1.1 CC1101 驱动移植
- 将 SmartRF-IDF 中已验证的 CC1101 C 驱动移植为 Tasmota 风格的 xdrv 驱动
- 实现 ASK/OOK 模式配置（参考 [CC1101_DEBUG_LOG.md](./CC1101_DEBUG_LOG.md) 中的寄存器值）
- 433.92MHz 频率配置（FREQ=0x10B071）
- 提供发送（TX）与接收（RX）基础 API
- 提供芯片版本检测（接受 VERSION=4 或 VERSION=20）

#### 2.1.2 RCSwitch 协议解码
- 移植 RCSwitch 协议库，支持协议 1~24 的固定码解码与发送
- 通过 GDO0 中断捕获信号时序
- 支持协议自动识别与回放

#### 2.1.3 遥控器管理
- 信号录制：进入录制模式后捕获新信号并自动识别协议
- 遥控器列表：分页/搜索查看所有已录制遥控器
- 遥控器编辑：修改名称、分组、关联标签
- 信号发射：单次发射、批量发射、延时发射
- 原始波形保存：对未知协议支持原始高低电平时序数组保存与回放

#### 2.1.4 门磁管理
- 门磁接入：通过录制匹配或手动输入 24 位固定码绑定门磁
- 状态监听：实时监听门磁开/关事件
- 联动触发：开/关事件触发预设动作（发射遥控器、MQTT 发布、WebUI 通知）
- 门磁配对：通过"学习模式"快速捕获并绑定新门磁
- 防抖处理：单次事件在 5 秒内去重

#### 2.1.5 WebUI 定制
- 主页：CC1101 状态、最近事件、快捷按钮
- 遥控器管理页：列表、新增、编辑、删除、发射
- 门磁管理页：列表、新增、编辑、删除、状态实时刷新
- 联动配置页：门磁-遥控器联动规则配置
- 录制页：信号录制向导
- 实时事件流：SSE 或 AJAX 轮询展示最近事件

#### 2.1.6 数据持久化
- 遥控器数据持久化（名称、协议、码值、位数、原始波形）
- 门磁数据持久化（名称、固定码、当前状态、最后触发时间）
- 联动规则持久化（门磁 ID、触发条件、目标遥控器 ID）
- 设备重启后数据不丢失
- 通过 UFS 文件系统存储（`path.write_file()`）或 Berry `persist` 模块

#### 2.1.7 MQTT 与 Home Assistant 集成
- 门磁状态通过 MQTT 发布（state_topic，payload_on/off）
- 遥控器发射触发通过 MQTT 命令（command_topic）
- 利用 Tasmota 内置 HA Discovery 自动注册二进制传感器（门磁）与按钮（遥控器）
- 设备识别采用统一的 Tasmota topic 前缀

### 2.2 范围外（Out of Scope）

- **滚动码遥控器**：不支持 KeeLoq 等滚动码协议解码与重放
- **LVGL 显示界面**：本硬件无屏幕，不做 LVGL UI
- **多设备集群**：不做多网关协同、跨设备同步
- **加密通信**：不对 RF 信号做加密/解密处理
- **非固定码传感器**：温湿度传感器等非门磁类 433 设备不在本期支持范围
- **OTA 在线烧录 CC1101 固件**：CC1101 无独立固件，无需 OTA
- **能量监测/统计**：不做遥控器使用频率统计、电池电量等
- **商业级稳定性**：不做大规模量产、抗压、防入侵等商业要求

---

## 3. 用户场景与用例

### 3.1 角色定义

| 角色 | 描述 | 主要操作 |
|------|------|----------|
| **家庭用户** | 拥有 433MHz 遥控器与门磁设备的普通用户 | WebUI 配置、录制遥控器、绑定门磁、查看状态 |
| **Home Assistant 用户** | 已部署 HA 的智能家居用户 | 通过 HA 界面查看门磁状态、触发遥控器发射 |
| **开发者/维护者** | 负责固件编译、烧录、调试 | 编译固件、查看串口日志、调整 CC1101 寄存器 |

### 3.2 核心用例

#### UC-1：录制新遥控器
1. 用户登录 Tasmota WebUI，进入"遥控器管理"→"录制"
2. 点击"开始录制"，系统进入 RX 监听模式
3. 用户按下物理遥控器按键
4. 系统通过 RCSwitch 解码得到（协议、码值、位数）
5. 用户填写名称、分组后保存
6. 系统持久化到 UFS
7. **预期结果**：遥控器出现在列表中，可发射

#### UC-2：发射遥控器信号
1. 用户在"遥控器管理"列表中点击"发射"按钮
2. 系统切换 CC1101 到 TX 模式，按协议发送信号
3. 系统切回 RX 模式
4. **预期结果**：被控设备响应；WebUI 显示"已发射"事件

#### UC-3：绑定门磁传感器
1. 用户进入"门磁管理"→"添加门磁"
2. 选择"学习模式"，系统进入 RX 监听
3. 用户触发门磁（开门/关门），系统捕获固定码
4. 用户填写名称、安装位置后保存
5. **预期结果**：门磁出现在列表中，状态实时更新

#### UC-4：配置门磁联动
1. 用户进入"联动配置"→"新增规则"
2. 选择触发门磁、触发条件（开/关）、目标动作（发射某遥控器 / MQTT 发布）
3. 保存规则
4. **预期结果**：门磁事件发生时自动执行动作；HA 中触发对应按钮

#### UC-5：Home Assistant 自动发现
1. 用户在 Tasmota 中配置好 MQTT 服务器（支持 IPv6，详见 [IPV6_CONFIG.md](./IPV6_CONFIG.md)）
2. 启用 Tasmota 的 HA Discovery（`SetOption19 1`）
3. HA 自动发现门磁为二进制传感器、遥控器为按钮实体
4. **预期结果**：HA 中可直接查看门磁状态、点击按钮触发遥控器

#### UC-6：远程触发遥控器（MQTT）
1. HA 或其他 MQTT 客户端向 `cmnd/<device>/rf_send` 发布 `{"id":1}`
2. 系统查询本地数据库，找到对应遥控器
3. 切换 CC1101 到 TX 模式发射
4. **预期结果**：被控设备响应；系统通过 `stat/<device>/RESULT` 返回结果

---

## 4. 功能需求

### 4.1 遥控器管理

#### 4.1.1 信号录制
- **FR-1.1.1**：通过 WebUI 或 MQTT 命令 `cmnd/<dev>/rf_record` 进入录制模式
- **FR-1.1.2**：进入录制模式后 CC1101 切换为 RX，最长监听 30 秒
- **FR-1.1.3**：捕获到信号后通过 RCSwitch 解码，得到（protocol、value、bits）
- **FR-1.1.4**：若解码失败（未知协议），自动保存为原始波形（high/low 时序数组）
- **FR-1.1.5**：录制成功后通过 `stat/<dev>/RESULT` 返回 JSON：`{"Record":{"protocol":1,"value":11747249,"bits":24}}`
- **FR-1.1.6**：录制超时无信号时返回 `{"Record":"timeout"}`

#### 4.1.2 遥控器列表与管理
- **FR-1.2.1**：WebUI 提供遥控器列表页，展示名称、分组、协议、码值（截断）、最后发射时间
- **FR-1.2.2**：支持按名称、分组搜索过滤
- **FR-1.2.3**：支持删除遥控器（同步删除联动规则中引用）
- **FR-1.2.4**：支持导出/导入 JSON 备份
- **FR-1.2.5**：单设备遥控器条目上限 64 条

#### 4.1.3 遥控器编辑
- **FR-1.3.1**：可修改名称、分组、备注
- **FR-1.3.2**：可修改发射参数：脉冲长度（PulseLength）、重发次数（Repeat，默认 10）
- **FR-1.3.3**：不允许直接修改码值（防止误操作），如需修改需重新录制

#### 4.1.4 信号发射
- **FR-1.4.1**：WebUI 列表页"发射"按钮触发单次发射
- **FR-1.4.2**：MQTT 命令 `cmnd/<dev>/rf_send {"id":1}` 按 ID 触发发射
- **FR-1.4.3**：MQTT 命令 `cmnd/<dev>/rf_send {"value":11747249,"bits":24,"protocol":1}` 直接发射
- **FR-1.4.4**：发射前 CC1101 切换为 TX，发射完成后切回 RX
- **FR-1.4.5**：发射结果通过 `stat/<dev>/RESULT` 返回 `{"Send":"ok"}` 或 `{"Send":"error","reason":"..."}`
- **FR-1.4.6**：支持批量发射 `{"id":[1,2,3]}` 与延时发射 `{"id":1,"delay":500}`

### 4.2 门磁管理

#### 4.2.1 门磁接入与监听
- **FR-2.1.1**：CC1101 默认处于 RX 监听模式，持续接收 433MHz 信号
- **FR-2.1.2**：捕获到信号后查询门磁数据库，匹配固定码（24 位）识别为已知门磁
- **FR-2.1.3**：识别后通过 RCSwitch 协议位判定开/关状态（按协议 1 默认 24 位编码）
- **FR-2.1.4**：状态变化通过 `tele/<dev>/SENSOR` 与 `stat/<dev>/RESULT` 发布 JSON：`{"Door1":{"State":"OPEN","Code":11747249}}`
- **FR-2.1.5**：5 秒内同码值事件去重，防抖处理

#### 4.2.2 门磁触发联动
- **FR-2.2.1**：联动规则结构：`{door_id, trigger_state(open/close), action_type(rf_send/mqtt_publish), action_payload}`
- **FR-2.2.2**：门磁状态变化时检查所有匹配规则并执行
- **FR-2.2.3**：`action_type=rf_send` 时调用 4.1.4 发射逻辑
- **FR-2.2.4**：`action_type=mqtt_publish` 时向 `tele/<dev>/trigger` 发布自定义 payload
- **FR-2.2.5**：联动执行结果记入事件日志，可在 WebUI 查看

#### 4.2.3 门磁配对与管理
- **FR-2.3.1**：WebUI"门磁管理"→"添加门磁"提供"学习模式"：进入 RX 监听 30 秒，捕获首个未知码自动填入
- **FR-2.3.2**：支持手动输入 24 位固定码绑定
- **FR-2.3.3**：可修改名称、安装位置、备注
- **FR-2.3.4**：可删除门磁（同步删除联动规则中引用）
- **FR-2.3.5**：单设备门磁条目上限 32 条

### 4.3 WebUI 定制

- **FR-3.1**：注册以下自定义页面路由（通过 Tasmota WebHandler 机制，Berry `webserver.on()` 或 C `FUNC_WEB_ADD_HANDLER` 均可）：
  - `/rf` — 遥控器管理主页
  - `/rf/record` — 录制页
  - `/rf/edit?id=N` — 编辑页
  - `/door` — 门磁管理主页
  - `/door/edit?id=N` — 门磁编辑页
  - `/link` — 联动配置页
- **FR-3.2**：通过 `web_add_main_button()` 回调（Berry 或 C）在 Tasmota 主页添加"433 网关"快捷入口按钮
- **FR-3.3**：主页 `web_sensor()` 中追加 CC1101 状态行：`{s}CC1101{m}Ready (RX){e}` 或 `{s}CC1101{m}Not installed{e}`
- **FR-3.4**：列表页支持 AJAX 刷新，无需整页刷新
- **FR-3.5**：所有按钮动作通过 `la("&cmd=...")` 触发，遵循 Tasmota WebUI 风格
- **FR-3.6**：页面样式继承 Tasmota 默认暗色主题（CSS 变量 `--c_bg` 等）
- **FR-3.7**：最近事件列表通过 SSE（`HTTP_SCRIPT_ROOT_SSE`）或 1 秒轮询刷新

### 4.4 数据存储

- **FR-4.1**：使用 UFS 文件系统（`path.write_file()` / C 文件 API）或 Berry `persist` 模块存储元数据（计数器、最后操作时间）
- **FR-4.2**：使用 UFS 文件系统存储主数据：
  - `/rf_remotes.json` — 遥控器列表
  - `/rf_doors.json` — 门磁列表
  - `/rf_links.json` — 联动规则列表
  - `/rf_events.log` — 最近 100 条事件日志（环形覆盖）
- **FR-4.3**：每次新增/编辑/删除操作后立即写盘（`persist.save()`、`path.write_file()` 或 C 文件 API）
- **FR-4.4**：启动时读取并校验 JSON 完整性，损坏时备份为 `.bak` 并重新初始化
- **FR-4.5**：JSON 字段使用 UTF-8 编码，名称最长 32 字符，备注最长 128 字符
- **FR-4.6**：提供 `cmnd/<dev>/rf_backup` 导出全部数据为单个 JSON 文件
- **FR-4.7**：提供 `cmnd/<dev>/rf_restore` 从上传文件恢复

### 4.5 MQTT 与 Home Assistant 集成

- **FR-5.1**：MQTT topic 遵循 Tasmota 默认前缀规则（`cmnd/`、`stat/`、`tele/`）
- **FR-5.2**：支持 IPv6 MQTT 服务器（详见 [IPV6_CONFIG.md](./IPV6_CONFIG.md)）
- **FR-5.3**：门磁状态发布到 `tele/<dev>/SENSOR`，HA Discovery 注册为 `binary_sensor`：
  - `state_topic`: `tele/<dev>/SENSOR`
  - `value_template`: `{{value_json.Door1.State}}`
  - `payload_on`: `OPEN`
  - `payload_off`: `CLOSE`
- **FR-5.4**：遥控器通过 `cmnd/<dev>/rf_send` 触发，HA Discovery 注册为 `button` 实体
- **FR-5.5**：每个门磁与遥控器作为独立 HA 实体，name 格式：`<device_name>_<remote_name>`
- **FR-5.6**：HA Discovery 主题：`homeassistant/binary_sensor/<dev>_<door_id>/config`、`homeassistant/button/<dev>_<remote_id>/config`
- **FR-5.7**：MQTT 断线自动重连，重连后补发门磁当前状态（retain=true）
- **FR-5.8**：远程命令处理优先级：本地 WebUI > MQTT，避免冲突时基于时间戳

---

## 5. 非功能需求

### 5.1 性能与容量
- **NFR-1.1**：CC1101 SPI 时钟默认 38400 频段速度（参考 `cc1101.h` `CFREQ_433`、`CSPEED_38400`），可配置
- **NFR-1.2**：从按下遥控器到 WebUI 显示事件 ≤ 1 秒
- **NFR-1.3**：从 MQTT 命令到发射完成 ≤ 500ms
- **NFR-1.4**：单次发射时长 ≤ 500ms（含重发 10 次）
- **NFR-1.5**：遥控器条目上限 64，门磁上限 32，联动规则上限 64
- **NFR-1.6**：UFS 数据文件总大小 ≤ 32KB
- **NFR-1.7**：业务模块（Berry 或 C）运行时占用堆内存 ≤ 30KB
- **NFR-1.8**：WebUI 页面首屏渲染 ≤ 1 秒（局域网环境）

### 5.2 可靠性与异常处理
- **NFR-2.1**：CC1101 初始化失败时 WebUI 显示"未安装"，业务降级（仅显示提示，不阻塞其他 Tasmota 功能）
- **NFR-2.2**：CC1101 在连续 60 秒无信号时自动校准（重启 RX）
- **NFR-2.3**：JSON 文件损坏时自动备份并重建，不影响系统启动
- **NFR-2.4**：MQTT 断线时本地联动规则继续执行，缓存事件 10 条，重连后补发
- **NFR-2.5**：业务代码异常时通过日志记录错误，不导致系统重启
- **NFR-2.6**：发射过程中断 RX 监听不超过 1 秒，避免门磁事件长时间丢失
- **NFR-2.7**：所有写盘操作失败时返回明确错误码，不静默丢失数据
- **NFR-2.8**：使用 TasAutoMutex 保护 CC1101 SPI 访问，避免多任务竞态

### 5.3 硬件约束
- **NFR-3.1**：仅支持 ESP32-Solo1 单核（`CONFIG_FREERTOS_UNICORE=y`）
- **NFR-3.2**：CC1101 必须由 3.3V 供电（严禁 5V，详见 [硬件规格文档.md](./硬件规格文档.md)）
- **NFR-3.3**：CC1101 引脚固定为 VSPI 配置：
  - MOSI=GPIO23, MISO=GPIO19, SCK=GPIO18, CS=GPIO5
  - GDO0=GPIO4, GDO2=GPIO22
- **NFR-3.4**：禁止使用 GPIO 6-11（内部 Flash）与 GPIO 2（板载 LED，避免与 GDO2 冲突）
- **NFR-3.5**：Flash 总容量 4MB，分区表需为 UFS 文件系统预留 ≥ 320KB（如使用 Berry 则需额外预留脚本存储空间）
- **NFR-3.6**：CC1101 模块型号 HL-RF433A16-B V2.1，固定 433.92MHz

---

## 6. 验收标准

### 6.1 各功能验收点

#### 6.1.1 CC1101 驱动
- [ ] 启动日志输出 `CC1101 初始化成功`（参考 [CC1101_DEBUG_LOG.md](./CC1101_DEBUG_LOG.md) 测试结果格式）
- [ ] 主页 WebUI 显示 `CC1101 Ready (RX)`
- [ ] 拔掉 CC1101 模块重启，WebUI 显示 `Not installed`，系统其他功能正常

#### 6.1.2 遥控器管理
- [ ] 录制模式按下遥控器后 5 秒内返回解码结果
- [ ] 列表页正确显示已录制遥控器，可分页搜索
- [ ] 编辑名称/分组后刷新页面数据保留
- [ ] 删除后联动规则中引用同步删除
- [ ] 单次发射能成功控制目标设备（实测验证）
- [ ] MQTT `cmnd/<dev>/rf_send {"id":1}` 触发成功，返回 `{"Send":"ok"}`
- [ ] 重启后遥控器数据完整不丢失

#### 6.1.3 门磁管理
- [ ] 学习模式下触发门磁后 5 秒内自动填入码值
- [ ] 门磁开/关状态在 WebUI 实时刷新
- [ ] 5 秒内重复触发被正确去重
- [ ] 联动规则触发发射遥控器成功
- [ ] MQTT `tele/<dev>/SENSOR` 正确发布 `{"Door1":{"State":"OPEN"}}`
- [ ] 重启后门磁数据与状态保留

#### 6.1.4 WebUI
- [ ] 主页"433 网关"按钮可见可点击
- [ ] 6 个自定义路由页面均可访问
- [ ] 列表页 AJAX 刷新正常，无整页刷新抖动
- [ ] 暗色主题样式与 Tasmota 原生页面一致

#### 6.1.5 数据持久化
- [ ] `/rf_remotes.json`、`/rf_doors.json`、`/rf_links.json` 文件存在且内容正确
- [ ] 手动损坏任一 JSON 后重启，系统自动重建为空数据并备份原文件为 `.bak`
- [ ] `rf_backup` 命令导出的 JSON 可被 `rf_restore` 完整恢复

#### 6.1.6 MQTT 与 HA
- [ ] HA 启用 Discovery 后门磁自动出现为 `binary_sensor`，状态正确
- [ ] 遥控器自动出现为 `button`，点击触发发射
- [ ] MQTT 断线 30 秒后重连成功，门磁状态补发
- [ ] 支持 IPv6 MQTT 服务器连接（参考 [IPV6_CONFIG.md](./IPV6_CONFIG.md) 验收清单）

### 6.2 MVP 边界

**MVP 必须包含**：
- CC1101 驱动移植与初始化（FR-1.x 基础）
- 遥控器录制、列表、单次发射（FR-1.1、FR-1.2、FR-1.4.1~3）
- 门磁学习模式与状态监听（FR-2.1、FR-2.3.1）
- 基础 WebUI 页面（FR-3.1、FR-3.2、FR-3.3）
- JSON 数据持久化（FR-4.1、FR-4.2、FR-4.3）
- MQTT 状态发布（FR-5.1、FR-5.3）
- HA Discovery 自动注册（FR-5.5、FR-5.6）

**MVP 可暂缓**：
- 原始波形保存与回放（FR-1.1.4）
- 批量/延时发射（FR-1.4.6）
- 联动规则配置 UI（FR-2.2 完整版仅保留 `rf_send` 类型）
- SSE 实时事件流（FR-3.7，先用 1 秒轮询代替）
- 备份/恢复命令（FR-4.6、FR-4.7）
- 自动校准（NFR-2.2）

---

## 7. 附录

### 7.1 数据模型草案

#### 7.1.1 遥控器（`/rf_remotes.json`）

```json
{
  "version": 1,
  "items": [
    {
      "id": 1,
      "name": "客厅灯",
      "group": "灯光",
      "protocol": 1,
      "value": 11747249,
      "bits": 24,
      "pulse_length": 350,
      "repeat": 10,
      "raw": null,
      "note": "",
      "last_sent_at": 1714838400
    }
  ]
}
```

| 字段 | 类型 | 说明 |
|------|------|------|
| id | int | 主键，自增 |
| name | string | 名称，最长 32 字符 |
| group | string | 分组，最长 16 字符 |
| protocol | int | RCSwitch 协议号 1~24，未知为 0 |
| value | int | 解码后的码值 |
| bits | int | 码长（位） |
| pulse_length | int | 脉冲长度（μs） |
| repeat | int | 重发次数，默认 10 |
| raw | list/null | 原始波形 `[high,low,high,low,...]`，未知协议时使用 |
| note | string | 备注，最长 128 字符 |
| last_sent_at | int | 最后发射 Unix 时间戳 |

#### 7.1.2 门磁（`/rf_doors.json`）

```json
{
  "version": 1,
  "items": [
    {
      "id": 1,
      "name": "大门",
      "location": "一楼入口",
      "code": 11747256,
      "bits": 24,
      "protocol": 1,
      "state": "CLOSE",
      "last_event_at": 1714838400,
      "note": ""
    }
  ]
}
```

| 字段 | 类型 | 说明 |
|------|------|------|
| id | int | 主键，自增 |
| name | string | 名称，最长 32 字符 |
| location | string | 安装位置，最长 32 字符 |
| code | int | 固定码值（用于匹配接收信号） |
| bits | int | 码长（位） |
| protocol | int | RCSwitch 协议号 |
| state | string | `OPEN` / `CLOSE` |
| last_event_at | int | 最后事件 Unix 时间戳 |
| note | string | 备注 |

#### 7.1.3 联动规则（`/rf_links.json`）

```json
{
  "version": 1,
  "items": [
    {
      "id": 1,
      "door_id": 1,
      "trigger_state": "OPEN",
      "action_type": "rf_send",
      "action_payload": {"remote_id": 2},
      "enabled": true,
      "last_triggered_at": 0
    }
  ]
}
```

| 字段 | 类型 | 说明 |
|------|------|------|
| id | int | 主键 |
| door_id | int | 关联门磁 ID |
| trigger_state | string | `OPEN` / `CLOSE` |
| action_type | string | `rf_send` / `mqtt_publish` |
| action_payload | object | `rf_send`：`{"remote_id":N}`；`mqtt_publish`：`{"topic":"...","payload":"..."}` |
| enabled | bool | 是否启用 |
| last_triggered_at | int | 最后触发 Unix 时间戳 |

#### 7.1.4 事件日志（`/rf_events.log`，环形 100 条）

```json
{"ts":1714838400,"type":"record","remote_id":1,"detail":"protocol=1,value=11747249"}
{"ts":1714838500,"type":"send","remote_id":1,"detail":"ok"}
{"ts":1714838600,"type":"door","door_id":1,"detail":"OPEN"}
{"ts":1714838700,"type":"link","link_id":1,"detail":"rf_send remote_id=2"}
```

#### 7.1.5 MQTT topic 一览

| Topic | 方向 | Payload 示例 |
|-------|------|--------------|
| `cmnd/<dev>/rf_record` | 入 | `{"timeout":30}` |
| `stat/<dev>/RESULT` | 出 | `{"Record":{"protocol":1,"value":11747249,"bits":24}}` |
| `cmnd/<dev>/rf_send` | 入 | `{"id":1}` 或 `{"value":11747249,"bits":24,"protocol":1}` |
| `cmnd/<dev>/rf_backup` | 入 | `1` |
| `cmnd/<dev>/rf_restore` | 入 | `<JSON 内容>` |
| `tele/<dev>/SENSOR` | 出 | `{"Door1":{"State":"OPEN","Code":11747249}}` |
| `tele/<dev>/trigger` | 出 | 联动自定义 payload |
| `homeassistant/binary_sensor/<dev>_<door_id>/config` | 出 | HA Discovery 配置 |
| `homeassistant/button/<dev>_<remote_id>/config` | 出 | HA Discovery 配置 |

### 7.2 相关文档与代码位置

#### 7.2.1 项目内文档（`docs/`）
- [硬件规格文档.md](./硬件规格文档.md) — ESP32-Solo1 与 CC1101 引脚、电源规格
- [cc1101模块引脚表.md](./cc1101模块引脚表.md) — CC1101 模块 8 针引脚定义
- [CC1101_DEBUG_LOG.md](./CC1101_DEBUG_LOG.md) — ASK/OOK 寄存器配置与调试过程
- [IPV6_CONFIG.md](./IPV6_CONFIG.md) — ESP32 IPv6 与 MQTT 配置

#### 7.2.2 Tasmota 开发参考（`.doc_for_ai/`）
- `BERRY_LANGUAGE_REFERENCE.md` — Berry 语法参考
- `BERRY_TASMOTA.md` — Tasmota Berry 模块（mqtt/webserver/persist/path）
- `BERRY_C_EXTENSION_REFERENCE.md` — Berry C 扩展（用于 CC1101 驱动对接）
- `TASMOTA_WEBUI_CODING_GUIDE.md` — WebUI HTML/CSS/JS 编码规范
- `TASMOTA_SUPPORT_DEEP_ANALYSIS.md` — Tasmota 支持能力分析（看门狗、设置、命令系统）
- `DOC_DEEP_ANALYSIS.md` — Tasmota 文档深度分析
- `FOR_DEVELOPERS.md` — 开发者指南

#### 7.2.3 上游驱动来源（SmartRF-IDF 仓库）
- CC1101 C 驱动：`https://github.com/wedone/SmartRF-IDF/tree/main/components/cc1101/`
- RCSwitch 协议库：`https://github.com/wedone/SmartRF-IDF/tree/main/components/RCSwitch/`

#### 7.2.4 Tasmota 关键源码位置（移植参考）
- Berry 引擎驱动（可选实现方式）：[tasmota/tasmota_xdrv_driver/xdrv_52_9_berry.ino](../tasmota/tasmota_xdrv_driver/xdrv_52_9_berry.ino)
- C 驱动框架示例（业务实现参考）：[tasmota/tasmota_xdrv_driver/xdrv_74_cc1101.ino](../tasmota/tasmota_xdrv_driver/xdrv_74_cc1101.ino)
- Web 服务器：[tasmota/tasmota_xdrv_driver/xdrv_01_9_webserver.ino](../tasmota/tasmota_xdrv_driver/xdrv_01_9_webserver.ino)
- HA Discovery：[tasmota/tasmota_xdrv_driver/xdrv_12_home_assistant.ino](../tasmota/tasmota_xdrv_driver/xdrv_12_home_assistant.ino)
- MQTT：[tasmota/tasmota_xdrv_driver/xdrv_02_9_mqtt.ino](../tasmota/tasmota_xdrv_driver/xdrv_02_9_mqtt.ino)
- 设置/持久化：[tasmota/tasmota_support/settings.ino](../tasmota/tasmota_support/settings.ino)
- HTML 模板：[tasmota/html_uncompressed/](../tasmota/html_uncompressed/)
- 现有 CC1101 库（参考）：[lib/lib_rf/cc1101/](../lib/lib_rf/cc1101/)
- 现有 RCSwitch 库（参考）：[lib/lib_rf/rc-switch/](../lib/lib_rf/rc-switch/)
- Tasmota CC1101 驱动（参考）：[tasmota/tasmota_xdrv_driver/xdrv_46_ccloader.ino](../tasmota/tasmota_xdrv_driver/xdrv_46_ccloader.ino)

#### 7.2.5 配置文件位置
- 编译选项：[tasmota/my_user_config.h](../tasmota/my_user_config.h)
- 用户覆盖：[tasmota/user_config_override_sample.h](../tasmota/user_config_override_sample.h)
- PlatformIO：[platformio.ini](../platformio.ini) / [platformio_tasmota32.ini](../platformio_tasmota32.ini)
- 分区表：[partitions/](../partitions/)
- 板子定义：[boards/esp32-solo1.json](../boards/esp32-solo1.json)

#### 7.2.6 GitHub Actions
- 主构建：[.github/workflows/Tasmota_build_master.yml](../.github/workflows/Tasmota_build_master.yml)
- 开发构建：[.github/workflows/Tasmota_build_devel.yml](../.github/workflows/Tasmota_build_devel.yml)
- 全量构建：[.github/workflows/build_all_the_things.yml](../.github/workflows/build_all_the_things.yml)

---

**文档版本**: 1.0
**创建日期**: 2026-08-05
**适用硬件**: Yuzuki ESP32 SOLO + HL-RF433A16-B (433.92MHz)
**适用平台**: Tasmota ESP32（业务实现方式：C 驱动与 Berry 脚本混合，不受限）
**状态**: 草稿完成，待评审
