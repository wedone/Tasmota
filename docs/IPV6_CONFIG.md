# ESP32 IPv6 配置指南

## 📋 概述

本指南介绍如何在 ESP32 项目中配置和使用 IPv6，特别是用于连接只有 IPv6 地址的 MQTT 服务器。

---

## 1. 为什么需要 IPv6

### 1.1 使用场景

- **自建 MQTT 服务器**: 只有 IPv6 地址（AAAA 记录）
- **IPv6 Only 网络**: 某些网络环境仅支持 IPv6
- **未来兼容性**: IPv4 地址耗尽，IPv6 是趋势

### 1.2 ESP32 IPv6 优势

相比 ESP8266，ESP32 具有更好的 IPv6 支持：

| 特性 | ESP8266 | ESP32 |
|------|---------|-------|
| **IPv6 支持** | ❌ 不支持 | ✅ 完整支持 |
| **Dual Stack** | ❌ | ✅ 支持 |
| **mLD** | ❌ | ✅ 支持 |
| **ICMPv6** | ❌ | ✅ 支持 |

---

## 2. PlatformIO 配置

### 2.1 编译标志

在 `platformio.ini` 中添加：

```ini
[env:esp32-solo]
build_flags = 
    -D LWIP_IPV6=1
    -D LWIP_IPV6_DUP_DETECT_ATTEMPTS=0
```

**完整配置**: 见 [`PROJECT_CONFIG.md`](d:\VC\SmartRF-dev\PROJECT_CONFIG.md)

### 2.2 配置说明

| 宏定义 | 说明 | 推荐值 |
|--------|------|--------|
| `LWIP_IPV6=1` | 启用 LwIP IPv6 协议栈 | 必须 |
| `LWIP_IPV6_DUP_DETECT_ATTEMPTS=0` | 禁用重复地址检测 | 推荐 0 |

**为什么禁用重复检测**:
- 减少连接延迟（从 1-2 秒降到毫秒级）
- 家庭网络环境通常没有地址冲突
- 如需安全性可设置为 1-3 次

### 2.3 为什么需要 IPv6

**我的使用场景**:
- 自建 MQTT 服务器域名只有 IPv6 地址（AAAA 记录）
- ESP8266 不支持 IPv6 ❌
- ESP32 完整支持 IPv6 ✅
- 这是迁移到 ESP32 的关键原因之一

---

## 3. WiFi 连接配置

### 3.1 启用 IPv6

```cpp
#include <WiFi.h>

void setup() {
    Serial.begin(115200);
    
    // 连接 WiFi
    WiFi.begin("your_ssid", "your_password");
    
    while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.print(".");
    }
    
    Serial.println("\nWiFi connected");
    Serial.print("IPv4: ");
    Serial.println(WiFi.localIP());
    
    // 等待 IPv6 地址分配（通常几秒内完成）
    delay(2000);
    
    // 打印 IPv6 地址
    if (WiFi.localIPv6()) {
        Serial.print("IPv6: ");
        Serial.println(WiFi.localIPv6());
    } else {
        Serial.println("No IPv6 address");
    }
}
```

### 3.2 IPv6 地址类型

ESP32 可能获取到多个 IPv6 地址：

1. **Link-Local** (fe80::/10): 本地链路地址，始终存在
2. **Global Unicast** (2000::/3): 全局单播地址，路由器分配
3. **Unique Local** (fc00::/7): 唯一本地地址

**优先使用 Global Unicast 地址**（如果有）

---

## 4. MQTT over IPv6

### 4.1 基本配置

**参考**: [`API_DOCUMENTATION.md`](d:\VC\SmartRF-dev\API_DOCUMENTATION.md) - MQTT 配置

```cpp
#include <WiFi.h>
#include <PubSubClient.h>

WiFiClient espClient;
PubSubClient mqttClient(espClient);

const char* mqtt_server = "mqtt.example.com";  // 域名（AAAA 记录）
const int mqtt_port = 1883;

void setup() {
    // ... WiFi 连接代码 ...
    
    mqttClient.setServer(mqtt_server, mqtt_port);
    connectMQTT();
}

void connectMQTT() {
    Serial.print("Connecting to MQTT server...");
    
    while (!mqttClient.connected()) {
        if (mqttClient.connect("ESP32_Client")) {
            Serial.println("connected");
        } else {
            Serial.print("failed, rc=");
            Serial.print(mqttClient.state());
            delay(2000);
        }
    }
}
```

### 4.2 DNS 解析 IPv6

PubSubClient 会自动处理 DNS 解析：

- 如果域名有 AAAA 记录，会解析为 IPv6
- 如果域名有 A 记录，会解析为 IPv4
- 如果同时有，优先使用 IPv6（ESP32 默认行为）

**我的配置**:
- MQTT 服务器域名只有 AAAA 记录（IPv6）
- ESP32 会自动解析并连接 IPv6 地址
- 无需手动处理 DNS 解析

### 4.3 直接使用 IPv6 地址

```cpp
// 直接使用 IPv6 地址
const char* mqtt_server = "2001:db8::1";

// 或者从配置读取
String mqtt_server_str = getConfig().mqtt_server;
mqttClient.setServer(mqtt_server_str.c_str(), mqtt_port);
```

### 4.4 IPv6 连接测试

```cpp
void testIPv6MQTT() {
    Serial.println("=== IPv6 MQTT Test ===");
    
    // 检查 IPv6 地址
    if (WiFi.localIPv6()) {
        Serial.print("IPv6: ");
        Serial.println(WiFi.localIPv6());
    } else {
        Serial.println("No IPv6 address!");
        return;
    }
    
    // 测试 DNS 解析
    IPAddress resolved;
    if (WiFi.hostByName("mqtt.example.com", resolved)) {
        if (resolved.type() == IPv6) {
            Serial.print("DNS resolved to IPv6: ");
            Serial.println(resolved);
        } else {
            Serial.println("ERROR: DNS resolved to IPv4, not IPv6!");
        }
    } else {
        Serial.println("DNS resolution failed!");
    }
    
    // 测试 MQTT 连接
    if (mqttClient.connected()) {
        Serial.println("MQTT connected over IPv6!");
    } else {
        Serial.println("MQTT connection failed!");
    }
}
```

---

## 5. 连接测试

### 5.1 测试代码

```cpp
void testIPv6Connection() {
    Serial.println("=== IPv6 Connection Test ===");
    
    // 1. 检查 WiFi 连接
    if (WiFi.status() != WL_CONNECTED) {
        Serial.println("WiFi not connected");
        return;
    }
    
    // 2. 打印 IP 地址
    Serial.print("IPv4: ");
    Serial.println(WiFi.localIP());
    
    IPv6Address ipv6 = WiFi.localIPv6();
    if (ipv6) {
        Serial.print("IPv6: ");
        Serial.println(ipv6);
    } else {
        Serial.println("No IPv6 address");
    }
    
    // 3. 测试 DNS 解析
    IPAddress resolved;
    if (WiFi.hostByName("mqtt.example.com", resolved)) {
        if (resolved.type() == IPv6) {
            Serial.print("DNS resolved to IPv6: ");
            Serial.println(resolved);
        } else {
            Serial.print("DNS resolved to IPv4: ");
            Serial.println(resolved);
        }
    } else {
        Serial.println("DNS resolution failed");
    }
    
    // 4. 测试 MQTT 连接
    if (mqttClient.connected()) {
        Serial.println("MQTT connected");
    } else {
        Serial.println("MQTT not connected");
    }
}
```

### 5.2 调试输出

启用详细日志：

```cpp
// 在 setup() 中添加
esp_log_level_set("wifi", ESP_LOG_DEBUG);
esp_log_level_set("mqtt", ESP_LOG_DEBUG);
```

---

## 6. 常见问题

### 6.1 无法获取 IPv6 地址

**症状**: `WiFi.localIPv6()` 返回空

**可能原因**:
1. 路由器不支持 IPv6
2. 路由器未启用 IPv6
3. ISP 未提供 IPv6

**解决方法**:
```cpp
// 检查路由器是否支持 IPv6
ping6 ipv6.google.com

// 手动启用 IPv6（某些路由器需要）
// 登录路由器管理界面，启用 IPv6
```

### 6.2 MQTT 连接超时

**症状**: 连接 IPv6 MQTT 服务器超时

**可能原因**:
1. 防火墙阻止 IPv6
2. MQTT 服务器未监听 IPv6
3. DNS 解析问题

**解决方法**:
```cpp
// 增加超时时间
mqttClient.setSocketTimeout(10); // 10 秒

// 直接使用 IPv6 地址测试
mqttClient.setServer("2001:db8::1", 1883);
```

### 6.3 连接不稳定

**症状**: IPv6 连接时断时续

**可能原因**:
1. IPv6 地址变化
2. 路由器 RA（Router Advertisement）配置问题

**解决方法**:
```cpp
// 使用静态 IPv6（如果路由器支持）
// 或在路由器中配置 DHCPv6 固定地址

// 增加重连逻辑
void reconnect() {
    while (!mqttClient.connected()) {
        if (mqttClient.connect("ESP32_Client")) {
            // 成功
        } else {
            delay(5000);
        }
    }
}
```

---

## 7. 完整示例

### 7.1 WiFi + MQTT IPv6 示例

```cpp
#include <WiFi.h>
#include <PubSubClient.h>

const char* ssid = "your_ssid";
const char* password = "your_password";
const char* mqtt_server = "mqtt.example.com";

WiFiClient espClient;
PubSubClient mqttClient(espClient);

void setup() {
    Serial.begin(115200);
    
    // 连接 WiFi
    WiFi.begin(ssid, password);
    Serial.print("Connecting to WiFi");
    while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.print(".");
    }
    Serial.println("\nWiFi connected");
    
    // 等待 IPv6
    delay(2000);
    
    // 打印 IP 地址
    Serial.print("IPv4: ");
    Serial.println(WiFi.localIP());
    
    if (WiFi.localIPv6()) {
        Serial.print("IPv6: ");
        Serial.println(WiFi.localIPv6());
    }
    
    // 配置 MQTT
    mqttClient.setServer(mqtt_server, 1883);
    
    // 连接 MQTT
    connectMQTT();
}

void loop() {
    if (!mqttClient.connected()) {
        connectMQTT();
    }
    mqttClient.loop();
}

void connectMQTT() {
    Serial.print("Connecting to MQTT...");
    while (!mqttClient.connected()) {
        if (mqttClient.connect("ESP32_Client")) {
            Serial.println("connected");
            mqttClient.subscribe("test/topic");
        } else {
            Serial.print("failed, rc=");
            Serial.print(mqttClient.state());
            delay(2000);
        }
    }
}
```

---

## 8. 验收清单

- [ ] WiFi 连接成功
- [ ] 获取到 IPv6 地址（Global Unicast）
- [ ] DNS 解析 IPv6 地址成功（AAAA 记录）
- [ ] MQTT 服务器连接成功（over IPv6）
- [ ] 可以发布/订阅消息
- [ ] 断线后能自动重连
- [ ] 重启后能正常连接
- [ ] **验证**: `testIPv6MQTT()` 测试通过

**验收详情**: 见 [`ESP32_PROJECT_PROMPT.md`](d:\VC\SmartRF-dev\ESP32_PROJECT_PROMPT.md) 验收标准

---

## 9. 参考资料

- **ESP32 IPv6 官方文档**: https://docs.espressif.com/projects/esp-idf/en/latest/esp32/api-guides/network.html#ipv6
- **LwIP IPv6 文档**: https://www.nongnu.org/lwip/2_1_x/group__ipv6.html
- **PubSubClient**: https://pubsubclient.knolleary.net/
- **IPv6 地址规划**: https://www.iana.org/assignments/ipv6-address-space/ipv6-address-space.xhtml
- **项目配置**: [`PROJECT_CONFIG.md`](d:\VC\SmartRF-dev\PROJECT_CONFIG.md)
- **AI Prompt**: [`ESP32_PROJECT_PROMPT.md`](d:\VC\SmartRF-dev\ESP32_PROJECT_PROMPT.md)

---

**文档版本**: 1.0  
**创建日期**: 2026-03-14  
**更新日期**: 2026-03-14  
**适用平台**: ESP32 Arduino + LwIP  
**使用场景**: 自建 MQTT 服务器（仅 IPv6）
