#ifdef USE_CC1101_GATEWAY

#define XDRV_74             74

#include <SPI.h>
#include <RCSwitch.h>

#define CC1101_GDO0_DEFAULT     4
#define CC1101_CS_DEFAULT       5
#define CC1101_SCK          18
#define CC1101_MOSI         23
#define CC1101_MISO         19

#define CC1101_SRES         0x30
#define CC1101_SRX          0x34
#define CC1101_STX          0x35
#define CC1101_SIDLE        0x36
#define CC1101_SFRX         0x3A
#define CC1101_SFTX         0x3B
#define CC1101_SNOP         0x3D

#define CC1101_IOCFG2       0x00
#define CC1101_IOCFG0       0x02
#define CC1101_PKTCTRL0     0x08
#define CC1101_FREQ2        0x0D
#define CC1101_FREQ1        0x0E
#define CC1101_FREQ0        0x0F
#define CC1101_MDMCFG4      0x10
#define CC1101_MDMCFG3      0x11
#define CC1101_MDMCFG2      0x12
#define CC1101_DEVIATN      0x15
#define CC1101_MCSM0        0x18
#define CC1101_FREND0       0x22
#define CC1101_FSCAL3       0x23
#define CC1101_FSCAL2       0x24
#define CC1101_FSCAL1       0x25
#define CC1101_FSCAL0       0x26
#define CC1101_TEST2        0x2C
#define CC1101_TEST1        0x2D
#define CC1101_TEST0        0x2E
#define CC1101_PARTNUM      0x30
#define CC1101_VERSION      0x31
#define CC1101_MARCSTATE    0x35
#define CC1101_TXFIFO       0x3F
#define CC1101_RXFIFO       0x3F
#define CC1101_PATABLE      0x3E

#define CC1101_WRITE_SINGLE 0x00
#define CC1101_READ_SINGLE  0x80
#define CC1101_READ_BURST   0xC0
#define CC1101_WRITE_BURST  0x40

static SPIClass *cc1101_spi = nullptr;
static RCSwitch cc1101_rcswitch;

static struct {
  uint64_t value;
  unsigned int bits;
  unsigned int protocol;
  unsigned int delay;
  bool available;
  uint32_t timestamp;
} rf_rx_data;

static struct {
  bool initialized;
  uint8_t version;
  uint8_t partnum;
  bool in_tx;
  uint32_t last_rx_time;
} cc1101_status;

static int cc1101_cs_pin = CC1101_CS_DEFAULT;

static void cc1101_select(void) {
  digitalWrite(cc1101_cs_pin, LOW);
}

static void cc1101_deselect(void) {
  digitalWrite(cc1101_cs_pin, HIGH);
}

static void cc1101_wait_miso(void) {
  uint32_t timeout = millis() + 100;
  while (digitalRead(CC1101_MISO) && !TimeReached(timeout)) {
    delay(1);
  }
}

static void cc1101_write_reg(uint8_t addr, uint8_t value) {
  cc1101_select();
  cc1101_wait_miso();
  cc1101_spi->transfer(addr);
  cc1101_spi->transfer(value);
  cc1101_deselect();
}

static uint8_t cc1101_read_reg(uint8_t addr) {
  uint8_t value;
  cc1101_select();
  cc1101_wait_miso();
  cc1101_spi->transfer(addr | CC1101_READ_SINGLE);
  value = cc1101_spi->transfer(0x00);
  cc1101_deselect();
  return value;
}

static uint8_t cc1101_read_status(uint8_t addr) {
  uint8_t value;
  cc1101_select();
  cc1101_wait_miso();
  cc1101_spi->transfer(addr | CC1101_READ_BURST);
  value = cc1101_spi->transfer(0x00);
  cc1101_deselect();
  return value;
}

static void cc1101_cmd_strobe(uint8_t cmd) {
  cc1101_select();
  cc1101_wait_miso();
  cc1101_spi->transfer(cmd);
  cc1101_deselect();
}

static void cc1101_reset(void) {
  cc1101_deselect();
  delayMicroseconds(5);
  cc1101_select();
  delayMicroseconds(10);
  cc1101_deselect();
  delayMicroseconds(41);
  cc1101_select();
  cc1101_wait_miso();
  cc1101_spi->transfer(CC1101_SRES);
  cc1101_wait_miso();
  cc1101_deselect();
}

static void cc1101_set_ask_ook(void) {
  cc1101_cmd_strobe(CC1101_SIDLE);
  cc1101_write_reg(CC1101_IOCFG2, 0x0D);
  cc1101_write_reg(CC1101_IOCFG0, 0x0D);
  cc1101_write_reg(CC1101_PKTCTRL0, 0x32);
  cc1101_write_reg(CC1101_MDMCFG4, 0x06);
  cc1101_write_reg(CC1101_MDMCFG3, 0x43);
  cc1101_write_reg(CC1101_MDMCFG2, 0x32);
  cc1101_write_reg(CC1101_DEVIATN, 0x47);
  cc1101_write_reg(CC1101_FREQ2, 0x10);
  cc1101_write_reg(CC1101_FREQ1, 0xB0);
  cc1101_write_reg(CC1101_FREQ0, 0x71);
  cc1101_write_reg(CC1101_FREND0, 0x11);
  cc1101_write_reg(CC1101_MCSM0, 0x18);
  cc1101_write_reg(CC1101_FSCAL3, 0xE9);
  cc1101_write_reg(CC1101_FSCAL2, 0x2A);
  cc1101_write_reg(CC1101_FSCAL1, 0x00);
  cc1101_write_reg(CC1101_FSCAL0, 0x1F);
  cc1101_write_reg(CC1101_TEST2, 0x88);
  cc1101_write_reg(CC1101_TEST1, 0x31);
  cc1101_write_reg(CC1101_TEST0, 0x09);
  cc1101_write_reg(CC1101_PATABLE, 0x60);
  cc1101_cmd_strobe(CC1101_SRX);
}

static void cc1101_set_idle(void) {
  cc1101_cmd_strobe(CC1101_SIDLE);
  cc1101_cmd_strobe(CC1101_SFTX);
  cc1101_cmd_strobe(CC1101_SFRX);
}

static void cc1101_set_rx(void) {
  cc1101_set_idle();
  cc1101_cmd_strobe(CC1101_SRX);
  cc1101_status.in_tx = false;
}

static void cc1101_set_tx(void) {
  cc1101_set_idle();
  cc1101_cmd_strobe(CC1101_STX);
  cc1101_status.in_tx = true;
}

bool cc1101_init_hw(void) {
  int cs_pin = Pin(GPIO_CC1101_CS);
  int gdo0_pin = Pin(GPIO_CC1101_GDO0);
  int gdo2_pin = Pin(GPIO_CC1101_GDO2);
  if (cs_pin < 0) cs_pin = CC1101_CS_DEFAULT;
  if (gdo0_pin < 0) gdo0_pin = CC1101_GDO0_DEFAULT;
  cc1101_cs_pin = cs_pin;

  if (cc1101_spi == nullptr) {
    cc1101_spi = new SPIClass(VSPI);
    cc1101_spi->begin(CC1101_SCK, CC1101_MISO, CC1101_MOSI, cs_pin);
  }

  pinMode(cs_pin, OUTPUT);
  pinMode(gdo0_pin, INPUT);
  if (gdo2_pin >= 0) {
    pinMode(gdo2_pin, INPUT);
  } else {
    AddLog(LOG_LEVEL_INFO, PSTR("CC1: GDO2 not configured, TX may not work"));
  }

  cc1101_deselect();
  delay(100);

  cc1101_reset();
  delay(10);

  cc1101_status.partnum = cc1101_read_status(CC1101_PARTNUM);
  cc1101_status.version = cc1101_read_status(CC1101_VERSION);

  if (cc1101_status.partnum != 0 || (cc1101_status.version != 4 && cc1101_status.version != 20)) {
    AddLog(LOG_LEVEL_ERROR, PSTR("CC1: CC1101 not found (PARTNUM=%d, VERSION=%d)"),
      cc1101_status.partnum, cc1101_status.version);
    cc1101_status.initialized = false;
    return false;
  }

  cc1101_set_ask_ook();
  delay(10);

  cc1101_rcswitch.enableReceive(gdo0_pin);
  cc1101_rcswitch.setReceiveTolerance(60);

  cc1101_status.initialized = true;
  cc1101_status.in_tx = false;
  cc1101_status.last_rx_time = 0;

  AddLog(LOG_LEVEL_INFO, PSTR("CC1: CC1101 init OK (VERSION=%d)"), cc1101_status.version);
  return true;
}

void cc1101_send_rf(uint64_t value, unsigned int bits, unsigned int protocol,
                    unsigned int pulse_length, unsigned int repeat) {
  if (!cc1101_status.initialized) return;

  int gdo0_pin = Pin(GPIO_CC1101_GDO0);
  int gdo2_pin = Pin(GPIO_CC1101_GDO2);
  if (gdo0_pin < 0) gdo0_pin = CC1101_GDO0_DEFAULT;

  int tx_pin = (gdo2_pin >= 0) ? gdo2_pin : gdo0_pin;

  cc1101_set_idle();
  cc1101_rcswitch.disableReceive();

  pinMode(tx_pin, OUTPUT);
  cc1101_rcswitch.enableTransmit(tx_pin);

  cc1101_rcswitch.setProtocol(protocol);
  cc1101_rcswitch.setRepeatTransmit(repeat);
  if (pulse_length > 0) {
    cc1101_rcswitch.setPulseLength(pulse_length);
  }

  cc1101_rcswitch.send(value, bits);

  delay(50);

  cc1101_rcswitch.disableTransmit();
  pinMode(gdo0_pin, INPUT);
  cc1101_rcswitch.enableReceive(gdo0_pin);
  cc1101_set_ask_ook();
}

void cc1101_every_50ms(void) {
  if (!cc1101_status.initialized) return;

  if (cc1101_rcswitch.available()) {
    uint64_t value = cc1101_rcswitch.getReceivedValue();
    unsigned int bits = cc1101_rcswitch.getReceivedBitlength();
    unsigned int protocol = cc1101_rcswitch.getReceivedProtocol();
    unsigned int delay_val = cc1101_rcswitch.getReceivedDelay();

    if (value > 0) {
      uint32_t now = millis();
      if (now - rf_rx_data.timestamp > 1000 || rf_rx_data.value != value) {
        rf_rx_data.value = value;
        rf_rx_data.bits = bits;
        rf_rx_data.protocol = protocol;
        rf_rx_data.delay = delay_val;
        rf_rx_data.available = true;
        rf_rx_data.timestamp = now;
        cc1101_status.last_rx_time = now;

        AddLog(LOG_LEVEL_DEBUG, PSTR("CC1: RX value=%llu bits=%u proto=%u delay=%u"),
          value, bits, protocol, delay_val);
      }
    }
    cc1101_rcswitch.resetAvailable();
  }
}

#include <berry.h>

extern "C" {

  int be_cc1101_send(struct bvm *vm) {
    if (be_top(vm) < 4 || !be_isint(vm, 1) || !be_isint(vm, 2) || !be_isint(vm, 3)) {
      be_pushbool(vm, 0);
      be_return(vm);
    }
    uint64_t value = (uint64_t)be_toint(vm, 1);
    int bits = be_toint(vm, 2);
    int protocol = be_toint(vm, 3);
    int pulse = (be_top(vm) >= 5 && be_isint(vm, 5)) ? be_toint(vm, 5) : 0;
    int repeat = (be_top(vm) >= 4 && be_isint(vm, 4)) ? be_toint(vm, 4) : 10;

    cc1101_send_rf(value, bits, protocol, pulse, repeat);
    be_pushbool(vm, 1);
    be_return(vm);
  }

  int be_cc1101_receive(struct bvm *vm) {
    char buf[128];
    if (!rf_rx_data.available || !cc1101_status.initialized) {
      snprintf(buf, sizeof(buf), "{\"Value\":0,\"Bits\":0,\"Protocol\":0,\"Pulse\":0}");
    } else {
      snprintf(buf, sizeof(buf), "{\"Value\":%llu,\"Bits\":%d,\"Protocol\":%d,\"Pulse\":%d}",
        (unsigned long long)rf_rx_data.value, rf_rx_data.bits, rf_rx_data.protocol, rf_rx_data.delay);
      rf_rx_data.available = false;
    }
    be_pushstring(vm, buf);
    be_return(vm);
  }

  int be_cc1101_status(struct bvm *vm) {
    char buf[64];
    snprintf(buf, sizeof(buf), "{\"Initialized\":%d,\"Version\":%d,\"Partnum\":%d}",
      cc1101_status.initialized ? 1 : 0, cc1101_status.version, cc1101_status.partnum);
    be_pushstring(vm, buf);
    be_return(vm);
  }

  int be_cc1101_set_rx(struct bvm *vm) {
    cc1101_set_rx();
    be_pushbool(vm, 1);
    be_return(vm);
  }

  int be_cc1101_flush_rx(struct bvm *vm) {
    rf_rx_data.available = false;
    rf_rx_data.value = 0;
    cc1101_rcswitch.resetAvailable();
    if (cc1101_status.initialized) {
      cc1101_set_rx();
    }
    be_pushbool(vm, 1);
    be_return(vm);
  }
}

static void cc1101_register_berry_funcs(void) {
  if (berry.vm == nullptr) return;
  bvm *vm = berry.vm;
  be_regfunc(vm, "cc1101_send", be_cc1101_send);
  be_regfunc(vm, "cc1101_receive", be_cc1101_receive);
  be_regfunc(vm, "cc1101_status", be_cc1101_status);
  be_regfunc(vm, "cc1101_set_rx", be_cc1101_set_rx);
  be_regfunc(vm, "cc1101_flush_rx", be_cc1101_flush_rx);
}

void Cc1101Init(void) {
  if (!PinUsed(GPIO_CC1101_GDO0) && !PinUsed(GPIO_CC1101_GDO2)) {
    return;
  }
  if (cc1101_init_hw()) {
    cc1101_register_berry_funcs();
  }
}

void Cc1101Every50ms(void) {
  cc1101_every_50ms();
}

bool Xdrv74(uint32_t function) {
  if (!PinUsed(GPIO_CC1101_GDO0) && !PinUsed(GPIO_CC1101_GDO2)) {
    return false;
  }

  bool result = false;

  switch (function) {
    case FUNC_INIT:
      Cc1101Init();
      result = true;
      break;
    case FUNC_EVERY_50_MSECOND:
      Cc1101Every50ms();
      break;
    case FUNC_ACTIVE:
      result = cc1101_status.initialized;
      break;
  }

  return result;
}

#endif