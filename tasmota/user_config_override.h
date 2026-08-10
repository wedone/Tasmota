/*
  user_config_override.h - user configuration overrides my_user_config.h for Tasmota

  Copyright (C) 2021  Theo Arends

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#ifndef _USER_CONFIG_OVERRIDE_H_
#define _USER_CONFIG_OVERRIDE_H_

// ============================================================================
// 构建策略：不定义 FIRMWARE_xxx 变体，以 my_user_config.h 默认配置为基础。
// platformio_override.ini 只负责 tasmota32solo1 环境和文件系统打包；
// 本文件（最后被包含）负责：
//   1) 加回本项目必需的功能 (UFILESYS / RC_SWITCH / BERRY)
//   2) 关闭 my_user_config.h 默认开启但本项目不需要的功能
// ============================================================================

// --- 加法：本项目必需的功能 --------------------------
#define USE_CC1101_GATEWAY                     // Enable CC1101 433MHz gateway driver
#define USE_RC_SWITCH                          // Enable RCSwitch protocol library (CC1101)
#define USE_UFILESYS                           // User file system (Berry scripts on LittleFS)
#define USE_BERRY                              // Berry scripting language (gateway logic)

// --- 减法：关闭 my_user_config.h 默认开启、本项目不需要的 ----
#undef USE_AUTOCONF                            // -12k, autoconf
#undef USE_EXTENSION_MANAGER                   // -11k, extension manager
// USE_WEBCLIENT_HTTPS 保留: Berry crypto 引擎 (HKDF/PBKDF2) 依赖 BearSSL, 同时触发 USE_TLS
#undef USE_DOMOTICZ                            // -6k,  Domoticz
#undef USE_TASMOTA_DISCOVERY                   // -2k,  Tasmota discovery (HA discovery done in Berry)
#undef USE_TIMERS                              // -2k2, timers
#undef USE_TIMERS_WEB                          // -4k5, timer webpage
#undef USE_SUNRISE                             // -16k, sunrise/sunset
#undef USE_RULES                               // -13k, rules engine (replaced by Berry)
#undef USE_SHUTTER                             // -11k, shutter
#undef USE_DEVICE_GROUPS                       // -5k5, device groups
  #undef USE_DEVICE_GROUPS_SEND                // -0k6
  #undef USE_PWM_DIMMER_REMOTE                 // -0k6
#undef USE_WS2812                              // -5k,  LED strips
#undef USE_EMULATION_HUE                       // -14k, Alexa Hue
#undef USE_EMULATION_WEMO                      // -6k,  Alexa WeMo
#undef USE_KNX_WEB_MENU                        // -8k3, KNX web menu
#undef USE_ESP32_SENSORS                       // ESP32 internal temp/hall sensors
#undef USE_GPIO_VIEWER                         // -5k6, GPIO viewer
#undef USE_ADC                                 // ADC support (not used)
#undef USE_NETWORK_LIGHT_SCHEMES               // light schemes via DDP (not used)
#undef USE_CSE7761                             // energy monitor chip (not used)

#endif  // _USER_CONFIG_OVERRIDE_H_
