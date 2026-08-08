#@ solidify:Cc1101Gateway

class Cc1101Gateway
  var remotes, doors, links, events
  var sequences, virtual_devices
  var next_remote_id, next_door_id, next_link_id
  var recording, record_timeout
  var learn_mode, learn_timeout, learn_result
  var last_event_ts
  var device_name

  static var _DATA_DIR = ""
  static var _FILE_REMOTES = "/rf_remotes.json"
  static var _FILE_DOORS = "/rf_doors.json"
  static var _FILE_LINKS = "/rf_links.json"
  static var _FILE_EVENTS = "/rf_events.log"
  static var _FILE_SEQUENCES = "/rf_sequences.json"
  static var _FILE_VDEVICES = "/rf_virtual_devices.json"
  static var _MAX_REMOTES = 64
  static var _MAX_DOORS = 32
  static var _MAX_LINKS = 64
  static var _MAX_EVENTS = 100
  static var _RECORD_TIMEOUT_MS = 30000
  static var _DEBOUNCE_MS = 5000
  static var _TIMER_RECORD = "cc1101_record"

  def init()
    self.remotes = []
    self.doors = []
    self.links = []
    self.events = []
    self.sequences = []
    self.virtual_devices = []
    self.next_remote_id = 1
    self.next_door_id = 1
    self.next_link_id = 1
    self.recording = false
    self.record_timeout = 0
    self.learn_mode = false
    self.learn_timeout = 0
    self.learn_result = nil
    self.last_event_ts = 0
    self.device_name = ""

    self.load_data()
    self.register_commands()
    self.publish_ha_discovery_all()

    log("CC1: Gateway initialized", 2)
  end

  def load_data()
    import path
    import json

    var data = self._load_json_file(self._FILE_REMOTES)
    if data != nil
      self.remotes = data.find("items", [])
      self.next_remote_id = data.find("next_id", 1)
    end

    data = self._load_json_file(self._FILE_DOORS)
    if data != nil
      self.doors = data.find("items", [])
      self.next_door_id = data.find("next_id", 1)
    end

    data = self._load_json_file(self._FILE_LINKS)
    if data != nil
      self.links = data.find("items", [])
      self.next_link_id = data.find("next_id", 1)
    end

    data = self._load_json_file(self._FILE_SEQUENCES)
    if data != nil
      self.sequences = data.find("items", [])
    end

    data = self._load_json_file(self._FILE_VDEVICES)
    if data != nil
      self.virtual_devices = data.find("items", [])
    end

    self._load_events()
  end

  def _load_json_file(filename)
    import path
    import json

    if !path.exists(filename)
      return nil
    end

    var content = nil
    try
      var f = open(filename, "r")
      content = f.read()
      f.close()
    except .. as e, m
      log(f"CC1: load {filename} failed: {e} {m}", 3)
      return nil
    end

    if content == nil || size(content) == 0
      return nil
    end

    var data = json.load(content)
    if data == nil
      log(f"CC1: JSON corrupt {filename}", 2)
      return nil
    end

    return data
  end

  def _save_json_file(filename, data)
    import json

    var content = json.dump(data)
    try
      var f = open(filename, "w")
      f.write(content)
      f.close()
    except .. as e, m
      log(f"CC1: save {filename} failed: {e} {m}", 3)
    end
  end

  def save_remotes()
    var data = {"version": 1, "next_id": self.next_remote_id, "items": self.remotes}
    self._save_json_file(self._FILE_REMOTES, data)
  end

  def save_doors()
    var data = {"version": 1, "next_id": self.next_door_id, "items": self.doors}
    self._save_json_file(self._FILE_DOORS, data)
  end

  def save_links()
    var data = {"version": 1, "next_id": self.next_link_id, "items": self.links}
    self._save_json_file(self._FILE_LINKS, data)
  end

  def save_sequences()
    var data = {"version": 1, "items": self.sequences}
    self._save_json_file(self._FILE_SEQUENCES, data)
  end

  def save_virtual_devices()
    var data = {"version": 1, "items": self.virtual_devices}
    self._save_json_file(self._FILE_VDEVICES, data)
  end

  def _load_events()
    import path
    import json

    if !path.exists(self._FILE_EVENTS)
      return
    end

    var content = nil
    try
      var f = open(self._FILE_EVENTS, "r")
      content = f.read()
      f.close()
    except .. as e, m
      log(f"CC1: load events failed: {e} {m}", 3)
      return
    end

    if content == nil
      return
    end

    self.events = []
    var lines = str(content).split("\n")
    for line : lines
      line = line.trim()
      if line != ""
        var evt = json.load(line)
        if evt != nil
          self.events.push(evt)
        end
      end
    end
  end

  def save_events()
    import json

    var lines = ""
    for evt : self.events
      lines += json.dump(evt) + "\n"
    end

    try
      var f = open(self._FILE_EVENTS, "w")
      f.write(lines)
      f.close()
    except .. as e, m
      log(f"CC1: save events failed: {e} {m}", 3)
    end
  end

  def add_event(evt_type, detail)
    var evt = {
      "ts": tasmota.rtc()["local"],
      "type": evt_type
    }
    for k : detail.keys()
      evt[k] = detail[k]
    end
    self.events.push(evt)

    if size(self.events) > self._MAX_EVENTS
      self.events = self.events[-(self._MAX_EVENTS) .. -1]
    end

    self.save_events()
  end

  def add_remote(name, group, protocol, value, bits, pulse_length, repeat, raw, note)
    var remote = {
      "id": self.next_remote_id,
      "name": name,
      "group": group,
      "protocol": protocol,
      "value": value,
      "bits": bits,
      "pulse_length": pulse_length,
      "repeat": repeat,
      "raw": raw,
      "note": note,
      "buttons": [],
      "last_sent_at": 0
    }
    self.remotes.push(remote)
    self.next_remote_id += 1
    self.save_remotes()
    self.add_event("record", {"remote_id": remote["id"], "detail": f"protocol={protocol},value={value}"})
    self.publish_ha_discovery_remote(remote)
    return remote
  end

  def send_remote_button(remote_id, button_id)
    var remote = self.find_remote(remote_id)
    if remote == nil || remote["buttons"] == nil
      return false
    end
    var button = nil
    for b : remote["buttons"]
      if b["id"] == button_id
        button = b
        break
      end
    end
    if button == nil
      return false
    end
    cc1101_send(button["value"], button["bits"], button["protocol"],
      button.find("repeat", 10), button.find("pulse_length", 0))
    self.add_event("send", {"remote_id": remote_id, "button_id": button_id, "detail": "button"})
    return true
  end

  def update_remote(id, updates)
    for remote : self.remotes
      if remote["id"] == id
        for k : updates.keys()
          remote[k] = updates[k]
        end
        self.save_remotes()
        return true
      end
    end
    return false
  end

  def delete_remote(id)
    var idx = 0
    while idx < size(self.remotes)
      if self.remotes[idx]["id"] == id
        self.remotes.remove(idx)
        self.save_remotes()

        var i = 0
        while i < size(self.links)
          if self.links[i]["action_type"] == "rf_send" && self.links[i]["action_payload"].find("remote_id", 0) == id
            self.links.remove(i)
          else
            i += 1
          end
        end
        self.save_links()
        self.add_event("delete", {"type": "remote", "id": id})
        return true
      end
      idx += 1
    end
    return false
  end

  def find_remote(id)
    for remote : self.remotes
      if remote["id"] == id
        return remote
      end
    end
    return nil
  end

  def add_door(name, location, code, bits, protocol, note)
    var door = {
      "id": self.next_door_id,
      "name": name,
      "location": location,
      "code": code,
      "bits": bits,
      "protocol": protocol,
      "state": "CLOSE",
      "last_event_at": 0,
      "note": note
    }
    self.doors.push(door)
    self.next_door_id += 1
    self.save_doors()
    self.add_event("door_add", {"door_id": door["id"], "code": code})
    self.publish_ha_discovery_door(door)
    self.publish_door_state(door)
    return door
  end

  def update_door(id, updates)
    for door : self.doors
      if door["id"] == id
        for k : updates.keys()
          door[k] = updates[k]
        end
        self.save_doors()
        self.publish_door_state(door)
        return true
      end
    end
    return false
  end

  def delete_door(id)
    var idx = 0
    while idx < size(self.doors)
      if self.doors[idx]["id"] == id
        self.doors.remove(idx)
        self.save_doors()

        var i = 0
        while i < size(self.links)
          if self.links[i]["door_id"] == id
            self.links.remove(i)
          else
            i += 1
          end
        end
        self.save_links()
        self.add_event("delete", {"type": "door", "id": id})
        return true
      end
      idx += 1
    end
    return false
  end

  def find_door(id)
    for door : self.doors
      if door["id"] == id
        return door
      end
    end
    return nil
  end

  def find_door_by_code(code)
    for door : self.doors
      if door["code"] == code
        return door
      end
    end
    return nil
  end

  def add_link(door_id, trigger_state, action_type, action_payload)
    var link = {
      "id": self.next_link_id,
      "door_id": door_id,
      "trigger_state": trigger_state,
      "action_type": action_type,
      "action_payload": action_payload,
      "enabled": true,
      "last_triggered_at": 0
    }
    self.links.push(link)
    self.next_link_id += 1
    self.save_links()
    return link
  end

  def update_link(id, updates)
    for link : self.links
      if link["id"] == id
        for k : updates.keys()
          link[k] = updates[k]
        end
        self.save_links()
        return true
      end
    end
    return false
  end

  def delete_link(id)
    var idx = 0
    while idx < size(self.links)
      if self.links[idx]["id"] == id
        self.links.remove(idx)
        self.save_links()
        return true
      end
      idx += 1
    end
    return false
  end

  def find_link(id)
    for link : self.links
      if link["id"] == id
        return link
      end
    end
    return nil
  end

  def register_commands()
    tasmota.add_cmd("RfRecord", def(cmd, idx, payload, payload_json)
      self.cmd_rf_record(payload, payload_json)
    end)
    tasmota.add_cmd("RfSend", def(cmd, idx, payload, payload_json)
      self.cmd_rf_send(payload, payload_json)
    end)
    tasmota.add_cmd("RfBackup", def(cmd, idx, payload, payload_json)
      self.cmd_rf_backup()
    end)
    tasmota.add_cmd("RfRestore", def(cmd, idx, payload, payload_json)
      self.cmd_rf_restore(payload, payload_json)
    end)
    tasmota.add_cmd("RfStatus", def(cmd, idx, payload, payload_json)
      self.cmd_rf_status()
    end)
  end

  def register_webui()
    import webserver

    webserver.on("/rf", def()
      self.handle_rf_page()
    end)
    webserver.on("/rf/record", def()
      self.handle_rf_record_page()
    end)
    webserver.on("/rf/edit", def()
      self.handle_rf_edit_page()
    end)
    webserver.on("/door", def()
      self.handle_door_page()
    end)
    webserver.on("/door/edit", def()
      self.handle_door_edit_page()
    end)
    webserver.on("/link", def()
      self.handle_link_page()
    end)
    webserver.on("/api/rf/event", def()
      self.handle_api_event()
    end)
  end

  def cmd_rf_record(payload, payload_json)
    var timeout = self._RECORD_TIMEOUT_MS
    if payload_json != nil && payload_json.find("timeout")
      timeout = payload_json["timeout"] * 1000
    end

    if payload == "stop"
      self.recording = false
      tasmota.remove_timer(self._TIMER_RECORD)
      tasmota.resp_cmnd_str('{"Record":"stopped"}')
      return
    end

    self.recording = true
    self.record_timeout = tasmota.millis() + timeout
    cc1101_flush_rx()

    tasmota.remove_timer(self._TIMER_RECORD)

    tasmota.set_timer(timeout, def()
      self.recording = false
      tasmota.resp_cmnd_str('{"Record":"timeout"}')
    end, self._TIMER_RECORD)

    tasmota.resp_cmnd_str('{"Record":"started"}')
  end

  def cmd_rf_send(payload, payload_json)
    if payload_json == nil
      tasmota.resp_cmnd_str('{"Send":"error","reason":"invalid_json"}')
      return
    end

    var ids = payload_json.find("id")
    var delay_ms = payload_json.find("delay", 0)
    if delay_ms == nil  delay_ms = 0  end

    if ids != nil
      if classname(ids) == "list"
        var idx = 0
        for id : ids
          if delay_ms > 0 && idx > 0
            tasmota.delay(delay_ms)
          end
          self._send_remote_by_id(id)
          idx += 1
        end
      else
        if delay_ms > 0
          tasmota.delay(delay_ms)
        end
        self._send_remote_by_id(ids)
      end
      tasmota.resp_cmnd_str('{"Send":"ok"}')
      return
    end

    var value = payload_json.find("value")
    var bits = payload_json.find("bits", 24)
    var protocol = payload_json.find("protocol", 1)
    var pulse = payload_json.find("pulse_length", 0)
    var repeat = payload_json.find("repeat", 10)

    if value != nil
      cc1101_send(value, bits, protocol, repeat, pulse)
      self.add_event("send", {"value": value, "detail": "direct"})
      tasmota.resp_cmnd_str('{"Send":"ok"}')
      return
    end

    tasmota.resp_cmnd_str('{"Send":"error","reason":"no_id_or_value"}')
  end

  def _send_remote_by_id(id)
    var remote = self.find_remote(id)
    if remote == nil
      return
    end

    var value = remote["value"]
    var bits = remote["bits"]
    var protocol = remote["protocol"]
    var pulse = remote.find("pulse_length", 0)
    var repeat = remote.find("repeat", 10)

    cc1101_send(value, bits, protocol, repeat, pulse)
    remote["last_sent_at"] = tasmota.rtc()["local"]
    self.save_remotes()
    self.add_event("send", {"remote_id": id, "detail": "ok"})
  end

  def _get_device_name()
    import json
    var resp = tasmota.cmd("DeviceName")
    if resp == nil
      return "tasmota"
    end
    if classname(resp) == "string"
      var r = json.load(resp)
      if r != nil && r.find("DeviceName") != nil
        return r["DeviceName"]
      end
    end
    return "tasmota"
  end

  def cmd_rf_backup()
    import json
    var backup = {
      "version": 1,
      "device": self._get_device_name(),
      "exported_at": tasmota.rtc()["local"],
      "remotes": self.remotes,
      "doors": self.doors,
      "links": self.links,
      "next_ids": {
        "remote": self.next_remote_id,
        "door": self.next_door_id,
        "link": self.next_link_id
      }
    }
    tasmota.resp_cmnd_str(json.dump(backup))
  end

  def cmd_rf_restore(payload, payload_json)
    import json
    if payload_json == nil
      tasmota.resp_cmnd_str('{"Restore":"error","reason":"invalid_json"}')
      return
    end

    if payload_json.find("remotes") != nil
      self.remotes = payload_json["remotes"]
    end
    if payload_json.find("doors") != nil
      self.doors = payload_json["doors"]
    end
    if payload_json.find("links") != nil
      self.links = payload_json["links"]
    end
    if payload_json.find("next_ids") != nil
      var n = payload_json["next_ids"]
      if n.find("remote") != nil  self.next_remote_id = n["remote"]  end
      if n.find("door") != nil    self.next_door_id = n["door"]      end
      if n.find("link") != nil    self.next_link_id = n["link"]      end
    end

    self.save_remotes()
    self.save_doors()
    self.save_links()
    self.publish_ha_discovery_all()
    tasmota.resp_cmnd_str('{"Restore":"ok"}')
  end

  def cmd_rf_status()
    import json
    var st = json.load(cc1101_status())
    var status = {
      "Initialized": st.find("Initialized", 0) == 1,
      "Version": st.find("Version", 0),
      "Remotes": size(self.remotes),
      "Doors": size(self.doors),
      "Links": size(self.links)
    }
    tasmota.resp_cmnd_str(json.dump(status))
  end

  def every_50ms()
    try
      self.check_rf_receive()
    except .. as e, m
      log(f"CC1: every_50ms error: {e} {m}", 3)
    end
  end

  def every_second()
    try
      if self.recording
        if tasmota.time_reached(self.record_timeout)
          self.recording = false
          tasmota.remove_timer(self._TIMER_RECORD)
        end
      end
      if self.learn_mode
        if tasmota.time_reached(self.learn_timeout)
          self.learn_mode = false
          self.learn_result = nil
          tasmota.remove_timer(self._TIMER_RECORD)
        end
      end
    except .. as e, m
      log(f"CC1: every_second error: {e} {m}", 3)
    end
  end

  def check_rf_receive()
    try
      import json
      var rx = json.load(cc1101_receive())
      var value = rx.find("Value", 0)
      var bits = rx.find("Bits", 0)
      var protocol = rx.find("Protocol", 0)
      var delay_val = rx.find("Pulse", 0)
      if value > 0
        if self.learn_mode
          self.learn_result = {"value": value, "bits": bits, "protocol": protocol, "pulse_length": delay_val}
          self.learn_mode = false
          tasmota.remove_timer(self._TIMER_RECORD)
        elif self.recording
          self.handle_recording(value, bits, protocol, delay_val)
        else
          self.handle_rx(value, bits, protocol, delay_val)
        end
      end
    except .. as e, m
      log(f"CC1: RF receive error: {e} {m}", 3)
    end
  end

  def handle_recording(value, bits, protocol, delay_val)
    self.recording = false
    tasmota.remove_timer(self._TIMER_RECORD)

    var result = {
      "Record": {
        "protocol": protocol,
        "value": value,
        "bits": bits,
        "pulse_length": delay_val
      }
    }
    import json
    tasmota.resp_cmnd_str(json.dump(result))
    log(f"CC1: Recorded value={value} bits={bits} proto={protocol}", 2)
  end

  def handle_rx(value, bits, protocol, delay_val)
    var now = tasmota.millis()
    if now - self.last_event_ts < self._DEBOUNCE_MS
      return
    end
    self.last_event_ts = now

    var door = self.find_door_by_code(value)
    if door != nil
      var new_state = "CLOSE"
      if protocol == 1
        var bit0 = value & 1
        if bit0 == 0
          new_state = "OPEN"
        end
      end

      if new_state != door["state"]
        door["state"] = new_state
        door["last_event_at"] = tasmota.rtc()["local"]
        self.save_doors()
        self.publish_door_state(door)
        self.add_event("door", {"door_id": door["id"], "detail": new_state})
        self.execute_links(door["id"], new_state)
      end
    end
  end

  def execute_links(door_id, state)
    import mqtt
    for link : self.links
      if link["enabled"]
        if link["door_id"] == door_id && link["trigger_state"] == state
          if link["action_type"] == "rf_send"
            var remote_id = link["action_payload"].find("remote_id", 0)
            if remote_id > 0
              self._send_remote_by_id(remote_id)
              link["last_triggered_at"] = tasmota.rtc()["local"]
              self.save_links()
              self.add_event("link", {"link_id": link["id"], "detail": f"rf_send remote_id={remote_id}"})
            end
          elif link["action_type"] == "mqtt_publish"
            var topic = link["action_payload"].find("topic", "")
            var payload = link["action_payload"].find("payload", "")
            if topic != ""
              mqtt.publish(topic, payload)
              link["last_triggered_at"] = tasmota.rtc()["local"]
              self.save_links()
              self.add_event("link", {"link_id": link["id"], "detail": f"mqtt topic={topic}"})
            end
          end
        end
      end
    end
  end

  def publish_door_state(door)
    import mqtt
    import json

    var dev = self._get_device_name()

    var payload = json.dump({door["name"]: {"State": door["state"], "Code": door["code"]}})
    mqtt.publish(f"tele/{dev}/SENSOR", payload)
  end

  def publish_ha_discovery_all()
    for door : self.doors
      self.publish_ha_discovery_door(door)
    end
    for remote : self.remotes
      self.publish_ha_discovery_remote(remote)
    end
  end

  def publish_ha_discovery_door(door)
    import mqtt
    import json
    var dev = self._get_device_name()

    var config = {
      "name": f"{dev}_{door['name']}",
      "device_class": "door",
      "state_topic": f"tele/{dev}/SENSOR",
      "value_template": f"{{{{value_json.{door['name']}.State}}}}",
      "payload_on": "OPEN",
      "payload_off": "CLOSE",
      "unique_id": f"{dev}_door_{door['id']}",
      "device": {
        "identifiers": [dev],
        "name": "CC1101 Gateway",
        "model": "Tasmota CC1101",
        "manufacturer": "Tasmota"
      }
    }
    mqtt.publish(f"homeassistant/binary_sensor/{dev}_door_{door['id']}/config", json.dump(config), true)
  end

  def publish_ha_discovery_remote(remote)
    import mqtt
    import json
    var dev = self._get_device_name()

    var config = {
      "name": f"{dev}_{remote['name']}",
      "command_topic": f"cmnd/{dev}/rf_send",
      "payload_press": json.dump({"id": remote["id"]}),
      "unique_id": f"{dev}_remote_{remote['id']}",
      "device": {
        "identifiers": [dev],
        "name": "CC1101 Gateway",
        "model": "Tasmota CC1101",
        "manufacturer": "Tasmota"
      }
    }
    mqtt.publish(f"homeassistant/button/{dev}_remote_{remote['id']}/config", json.dump(config), true)
  end

  def web_sensor()
    import webserver
    import json
    try
      var st = json.load(cc1101_status())
      if st.find("Initialized", 0) == 1
        tasmota.web_send("{s}CC1101{m}Ready (RX){e}")
      else
        tasmota.web_send("{s}CC1101{m}Not installed{e}")
      end
    except .. as e, m
      tasmota.web_send("{s}CC1101{m}Not installed{e}")
    end
  end

  def web_add_main_button()
    import webserver
    webserver.content_send("<p><form action='/rf' method='get' style='display:block;'><button>433 Gateway</button></form></p>")
  end

  def json_append()
    import json
    for door : self.doors
      tasmota.response_append(f',"{door["name"]}":{{"State":"{door["state"]}","Code":{door["code"]}}}')
    end
  end

  def save_before_restart()
    self.save_remotes()
    self.save_doors()
    self.save_links()
    self.save_events()
  end

  def web_add_handler()
    import webserver
    if webserver.has_arg("cc1101")
      webserver.redirect("/rf")
      return
    end
    self.register_webui()
  end

  def handle_rf_page()
    import webserver
    webserver.content_start("433 Gateway - Remotes")
    webserver.content_send_style()
    var html = ""

    html += "<div style='text-align:center;color:var(--c_ttl);'><h3>433 Gateway - Remotes</h3></div>"

    if webserver.has_arg("delete")
      var id = int(webserver.arg("delete"))
      self.delete_remote(id)
      html += "<p style='color:var(--c_txtscc);'>Remote deleted</p>"
    end

    if webserver.has_arg("send")
      var id = int(webserver.arg("send"))
      self._send_remote_by_id(id)
      html += "<p style='color:var(--c_txtscc);'>Signal sent</p>"
    end

    html += "<p></p><form action='/rf/record' method='get'><button>Record New Remote</button></form><p></p>"

    var search = ""
    if webserver.has_arg("search")
      search = webserver.arg("search")
    end

    html += "<form method='get' action='/rf'>"
    html += "<input id='search' name='search' placeholder='Search by name or group' value='" + webserver.html_escape(search) + "'>"
    html += "<p></p><button type='submit'>Search</button></form><p></p>"

    html += "<table style='width:100%'><tr><th>ID</th><th>Name</th><th>Group</th><th>Protocol</th><th>Actions</th></tr>"

    var count = 0
    for remote : self.remotes
      if search != ""
        var lower = str(search).lower()
        if str(remote["name"]).lower().find(lower) == nil && str(remote["group"]).lower().find(lower) == nil
          # skip
        else
          count += 1
          html += f"<tr><td>{remote['id']}</td><td>{webserver.html_escape(remote['name'])}</td>"
          html += f"<td>{webserver.html_escape(remote['group'])}</td><td>P{remote['protocol']}</td>"
          html += "<td>"
          html += f"<button onclick='la(\"&send={remote['id']}\");'>Send</button>"
          html += f"<button onclick='window.location.href=\"/rf/edit?id={remote['id']}\"'>Edit</button>"
          html += f"<button class='bred' onclick='if(confirm(\"Delete?\"))la(\"&delete={remote['id']}\");'>Delete</button>"
          html += "</td></tr>"
        end
      else
        count += 1
        html += f"<tr><td>{remote['id']}</td><td>{webserver.html_escape(remote['name'])}</td>"
        html += f"<td>{webserver.html_escape(remote['group'])}</td><td>P{remote['protocol']}</td>"
        html += "<td>"
        html += f"<button onclick='la(\"&send={remote['id']}\");'>Send</button>"
        html += f"<button onclick='window.location.href=\"/rf/edit?id={remote['id']}\"'>Edit</button>"
        html += f"<button class='bred' onclick='if(confirm(\"Delete?\"))la(\"&delete={remote['id']}\");'>Delete</button>"
        html += "</td></tr>"
      end
    end

    if count == 0
      html += "<tr><td colspan='5'>No remotes found</td></tr>"
    end

    html += "</table><p></p>"
    html += "<form action='/door' method='get'><button>Door Sensors</button></form>"
    html += "<form action='/link' method='get'><button>Linkage Rules</button></form>"
    html += "<form action='/' method='get'><button>Main Menu</button></form>"
    html += "<p></p>"

    if webserver.has_arg("send") || webserver.has_arg("delete")
      html += "<script>setTimeout(function(){window.location.href='/rf';},1500);</script>"
    end

    webserver.content_send(html)
    webserver.content_stop()
  end

  def handle_rf_record_page()
    import webserver
    webserver.content_start("Record Remote")
    webserver.content_send_style()
    var html = ""

    html += "<div style='text-align:center;color:var(--c_ttl);'><h3>Record Remote</h3></div>"

    if webserver.has_arg("name")
      var name = webserver.arg("name")
      var group = webserver.arg("group")
      var protocol = int(webserver.arg("protocol"))
      var value = int(webserver.arg("value"))
      var bits = int(webserver.arg("bits"))
      var pulse = int(webserver.arg("pulse_length"))
      var repeat = int(webserver.arg("repeat"))
      var note = webserver.arg("note")

      if value == nil  value = 0  end
      if bits == nil  bits = 0  end
      if protocol == nil  protocol = 0  end

      if name != "" && value > 0
        self.add_remote(name, group, protocol, value, bits, pulse, repeat, nil, note)
        html += "<p style='color:var(--c_txtscc);'>Remote saved!</p>"
        html += "<script>setTimeout(function(){window.location.href='/rf';},1000);</script>"
        webserver.content_send(html)
        webserver.content_stop()
        return
      end
    end

    if webserver.has_arg("start")
      self.learn_mode = true
      self.learn_timeout = tasmota.millis() + 30000
      self.learn_result = nil
      cc1101_flush_rx()
      tasmota.remove_timer(self._TIMER_RECORD)
      tasmota.set_timer(30000, def()
        if self.learn_mode
          self.learn_mode = false
          self.learn_result = nil
        end
      end, self._TIMER_RECORD)
      html += "<p style='color:var(--c_txtscc);'>Listening for 30 seconds... Press the remote button now.</p>"
      html += "<form action='/rf/record' method='get'><button class='bred'>Stop Recording</button></form>"
      html += "<script>"
      html += "var poll = setInterval(function(){"
      html += "  var x = new XMLHttpRequest();"
      html += "  x.open('GET', '/api/rf/event', true);"
      html += "  x.onreadystatechange = function(){"
      html += "    if(x.readyState==4 && x.status==200 && x.responseText!=''){"
      html += "      var d = JSON.parse(x.responseText);"
      html += "      if(d.value){"
      html += "        clearInterval(poll);"
      html += "        window.location.href = '/rf/record?value='+d.value+'&bits='+d.bits+'&protocol='+d.protocol+'&pulse_length='+d.pulse_length;"
      html += "      }"
      html += "    }"
      html += "  };"
      html += "  x.send();"
      html += "}, 500);"
      html += "setTimeout(function(){clearInterval(poll);}, 35000);"
      html += "</script>"
      webserver.content_send(html)
      webserver.content_stop()
      return
    end

    if webserver.has_arg("stop")
      self.cmd_rf_record("stop", nil)
      html += "<p style='color:var(--c_txtwrn);'>Recording stopped.</p>"
    end

    var value = webserver.arg("value")
    var bits = webserver.arg("bits")
    var protocol = webserver.arg("protocol")
    var pulse = webserver.arg("pulse_length")

    if value != "" && value != nil
      html += "<p style='color:var(--c_txtscc);'>Signal captured!</p>"
      html += "<form method='get' action='/rf/record'>"
      html += f"<input type='hidden' name='value' value='{value}'>"
      html += f"<input type='hidden' name='bits' value='{bits}'>"
      html += f"<input type='hidden' name='protocol' value='{protocol}'>"
      html += f"<input type='hidden' name='pulse_length' value='{pulse}'>"
      html += f"<p><label><b>Name</b></label><br><input id='name' name='name' placeholder='e.g. Living Room Light' required></p>"
      html += f"<p><label><b>Group</b></label><br><input id='group' name='group' placeholder='e.g. Lighting'></p>"
      html += f"<p><label><b>Repeat</b></label><br><input id='repeat' name='repeat' type='number' value='10'></p>"
      html += f"<p><label><b>Note</b></label><br><input id='note' name='note' placeholder='Optional note'></p>"
      html += "<p><button class='bgrn' type='submit'>Save Remote</button></p>"
      html += "</form>"
    else
      html += "<p>Press the button below and then press your remote.</p>"
      html += "<form action='/rf/record' method='get'><button name='start' value='1'>Start Recording</button></form>"
    end

    html += "<p></p><form action='/rf' method='get'><button>Back to Remotes</button></form>"
    webserver.content_send(html)
    webserver.content_stop()
  end

  def handle_rf_edit_page()
    import webserver
    webserver.content_start("Edit Remote")
    webserver.content_send_style()
    var html = ""

    var id_str = webserver.arg("id")
    if id_str == nil  id_str = "0"  end
    var id = int(id_str)
    var remote = self.find_remote(id)

    if remote == nil
      html += "<p>Remote not found</p>"
      html += "<form action='/rf' method='get'><button>Back</button></form>"
      webserver.content_send(html)
      webserver.content_stop()
      return
    end

    if webserver.has_arg("save")
      var updates = {}
      updates["name"] = webserver.arg("name")
      updates["group"] = webserver.arg("group")
      updates["pulse_length"] = int(webserver.arg("pulse_length"))
      updates["repeat"] = int(webserver.arg("repeat"))
      updates["note"] = webserver.arg("note")
      self.update_remote(id, updates)
      html += "<p style='color:var(--c_txtscc);'>Saved!</p>"
      html += "<script>setTimeout(function(){window.location.href='/rf';},1000);</script>"
      webserver.content_send(html)
      webserver.content_stop()
      return
    end

    html += "<div style='text-align:center;color:var(--c_ttl);'><h3>Edit Remote</h3></div>"
    html += "<form method='get' action='/rf/edit'>"
    html += f"<input type='hidden' name='id' value='{id}'>"
    html += f"<p><label><b>Name</b></label><br><input id='name' name='name' value='{webserver.html_escape(remote['name'])}'></p>"
    html += f"<p><label><b>Group</b></label><br><input id='group' name='group' value='{webserver.html_escape(remote['group'])}'></p>"
    html += f"<p><label><b>Protocol</b> (read-only)</label><br><input value='{remote['protocol']}' disabled></p>"
    html += f"<p><label><b>Value</b> (read-only)</label><br><input value='{remote['value']}' disabled></p>"
    html += f"<p><label><b>Bits</b> (read-only)</label><br><input value='{remote['bits']}' disabled></p>"
    html += f"<p><label><b>Pulse Length</b> (μs)</label><br><input id='pulse_length' name='pulse_length' type='number' value='{remote['pulse_length']}'></p>"
    html += f"<p><label><b>Repeat</b></label><br><input id='repeat' name='repeat' type='number' value='{remote['repeat']}'></p>"
    html += f"<p><label><b>Note</b></label><br><input id='note' name='note' value='{webserver.html_escape(remote['note'])}'></p>"
    html += "<p><button class='bgrn' name='save' value='1' type='submit'>Save</button></p>"
    html += "</form>"
    html += "<form action='/rf' method='get'><button>Cancel</button></form>"

    webserver.content_send(html)
    webserver.content_stop()
  end

  def handle_door_page()
    import webserver
    webserver.content_start("Door Sensors")
    webserver.content_send_style()
    var html = ""

    html += "<div style='text-align:center;color:var(--c_ttl);'><h3>Door Sensors</h3></div>"

    if webserver.has_arg("delete")
      var id = int(webserver.arg("delete"))
      self.delete_door(id)
      html += "<p style='color:var(--c_txtscc);'>Door deleted</p>"
    end

    html += "<p></p><form action='/door/edit' method='get'><button>Add Door Sensor</button></form><p></p>"

    html += "<table style='width:100%'><tr><th>ID</th><th>Name</th><th>Location</th><th>State</th><th>Actions</th></tr>"

    for door : self.doors
      var state_color = "var(--c_txtscc)"
      if door["state"] == "OPEN"
        state_color = "var(--c_txtwrn)"
      end
      html += f"<tr><td>{door['id']}</td>"
      html += f"<td>{webserver.html_escape(door['name'])}</td>"
      html += f"<td>{webserver.html_escape(door['location'])}</td>"
      html += f"<td style='color:{state_color};font-weight:bold;'>{door['state']}</td>"
      html += "<td>"
      html += f"<button onclick='window.location.href=\"/door/edit?id={door['id']}\"'>Edit</button>"
      html += f"<button class='bred' onclick='if(confirm(\"Delete?\"))la(\"&delete={door['id']}\");'>Delete</button>"
      html += "</td></tr>"
    end

    if size(self.doors) == 0
      html += "<tr><td colspan='5'>No door sensors</td></tr>"
    end

    html += "</table><p></p>"
    html += "<form action='/rf' method='get'><button>Back to Remotes</button></form>"

    if webserver.has_arg("delete")
      html += "<script>setTimeout(function(){window.location.href='/door';},1500);</script>"
    end

    webserver.content_send(html)
    webserver.content_stop()
  end

  def handle_door_edit_page()
    import webserver
    webserver.content_start("Door Sensor")
    webserver.content_send_style()
    var html = ""

    var id_str = webserver.arg("id")
    if id_str == nil  id_str = "0"  end
    var id = int(id_str)
    var door = self.find_door(id)

    if webserver.has_arg("learn")
      self.learn_mode = true
      self.learn_timeout = tasmota.millis() + 30000
      self.learn_result = nil
      cc1101_flush_rx()
      tasmota.remove_timer(self._TIMER_RECORD)
      tasmota.set_timer(30000, def()
        if self.learn_mode
          self.learn_mode = false
          self.learn_result = nil
        end
      end, self._TIMER_RECORD)
      html += "<p style='color:var(--c_txtscc);'>Learning mode: trigger the door sensor now...</p>"
      html += "<script>"
      html += "var poll = setInterval(function(){"
      html += "  var x = new XMLHttpRequest();"
      html += "  x.open('GET', '/api/rf/event', true);"
      html += "  x.onreadystatechange = function(){"
      html += "    if(x.readyState==4 && x.status==200 && x.responseText!=''){"
      html += "      var d = JSON.parse(x.responseText);"
      html += "      if(d.value){"
      html += "        clearInterval(poll);"
      html += "        window.location.href = '/door/edit?id=" + str(id) + "&code='+d.value+'&bits='+d.bits;"
      html += "      }"
      html += "    }"
      html += "  };"
      html += "  x.send();"
      html += "}, 500);"
      html += "setTimeout(function(){clearInterval(poll);}, 35000);"
      html += "</script>"
      webserver.content_send(html)
      webserver.content_stop()
      return
    end

    if webserver.has_arg("save")
      var name = webserver.arg("name")
      var location = webserver.arg("location")
      var code = int(webserver.arg("code"))
      var bits = int(webserver.arg("bits"))
      var note = webserver.arg("note")

      if code == nil  code = 0  end
      if bits == nil  bits = 0  end

      if id > 0 && door != nil
        self.update_door(id, {"name": name, "location": location, "code": code, "bits": bits, "note": note})
        html += "<p style='color:var(--c_txtscc);'>Saved!</p>"
      elif name != "" && code > 0
        self.add_door(name, location, code, bits, 1, note)
        html += "<p style='color:var(--c_txtscc);'>Door sensor added!</p>"
      end

      html += "<script>setTimeout(function(){window.location.href='/door';},1000);</script>"
      webserver.content_send(html)
      webserver.content_stop()
      return
    end

    if door == nil
      html += "<div style='text-align:center;color:var(--c_ttl);'><h3>Add Door Sensor</h3></div>"
      var learn_code = webserver.arg("code")
      if learn_code == nil  learn_code = "0"  end
      var learn_bits = webserver.arg("bits")
      if learn_bits == nil  learn_bits = "24"  end
      html += "<form method='get' action='/door/edit'>"
      html += "<p><button name='learn' value='1'>Learn Mode (Listen for 30s)</button></p>"
      html += "<hr>"
      html += "<p><label><b>Name</b></label><br><input id='name' name='name' placeholder='e.g. Front Door' required></p>"
      html += "<p><label><b>Location</b></label><br><input id='location' name='location' placeholder='e.g. Main Entrance'></p>"
      html += f"<p><label><b>Code</b></label><br><input id='code' name='code' type='number' value='{learn_code}' required></p>"
      html += f"<p><label><b>Bits</b></label><br><input id='bits' name='bits' type='number' value='{learn_bits}'></p>"
      html += "<p><label><b>Note</b></label><br><input id='note' name='note' placeholder='Optional'></p>"
      html += "<p><button class='bgrn' name='save' value='1' type='submit'>Save</button></p>"
      html += "</form>"
    else
      html += "<div style='text-align:center;color:var(--c_ttl);'><h3>Edit Door Sensor</h3></div>"
      html += "<form method='get' action='/door/edit'>"
      html += f"<input type='hidden' name='id' value='{id}'>"
      html += f"<p><label><b>Name</b></label><br><input id='name' name='name' value='{webserver.html_escape(door['name'])}'></p>"
      html += f"<p><label><b>Location</b></label><br><input id='location' name='location' value='{webserver.html_escape(door['location'])}'></p>"
      html += f"<p><label><b>Code</b></label><br><input id='code' name='code' type='number' value='{door['code']}'></p>"
      html += f"<p><label><b>Bits</b></label><br><input id='bits' name='bits' type='number' value='{door['bits']}'></p>"
      html += f"<p><label><b>State</b> (read-only)</label><br><input value='{door['state']}' disabled></p>"
      html += f"<p><label><b>Note</b></label><br><input id='note' name='note' value='{webserver.html_escape(door['note'])}'></p>"
      html += "<p><button class='bgrn' name='save' value='1' type='submit'>Save</button></p>"
      html += "</form>"
    end

    html += "<form action='/door' method='get'><button>Cancel</button></form>"
    webserver.content_send(html)
    webserver.content_stop()
  end

  def handle_link_page()
    import webserver
    webserver.content_start("Linkage Rules")
    webserver.content_send_style()
    var html = ""

    html += "<div style='text-align:center;color:var(--c_ttl);'><h3>Linkage Rules</h3></div>"

    if webserver.has_arg("delete")
      var id = int(webserver.arg("delete"))
      self.delete_link(id)
      html += "<p style='color:var(--c_txtscc);'>Rule deleted</p>"
    end

    if webserver.has_arg("toggle")
      var id = int(webserver.arg("toggle"))
      for link : self.links
        if link["id"] == id
          link["enabled"] = !link["enabled"]
          self.save_links()
          break
        end
      end
    end

    if webserver.has_arg("save")
      var door_id = int(webserver.arg("door_id"))
      var trigger = webserver.arg("trigger_state")
      var action_type = webserver.arg("action_type")
      if door_id == nil  door_id = 0  end
      if action_type == "rf_send"
        var remote_id = int(webserver.arg("remote_id"))
        if remote_id == nil  remote_id = 0  end
        self.add_link(door_id, trigger, "rf_send", {"remote_id": remote_id})
      elif action_type == "mqtt_publish"
        var topic = webserver.arg("mqtt_topic")
        var payload = webserver.arg("mqtt_payload")
        self.add_link(door_id, trigger, "mqtt_publish", {"topic": topic, "payload": payload})
      end
      html += "<p style='color:var(--c_txtscc);'>Rule added!</p>"
    end

    html += "<table style='width:100%'><tr><th>ID</th><th>Door</th><th>Trigger</th><th>Action</th><th>Status</th><th>Actions</th></tr>"

    for link : self.links
      var door_name = "?"
      var d = self.find_door(link["door_id"])
      if d != nil  door_name = d["name"]  end

      var action_desc = link["action_type"]
      if link["action_type"] == "rf_send"
        var r = self.find_remote(link["action_payload"]["remote_id"])
        if r != nil  action_desc = "RF: " + r["name"]  end
      elif link["action_type"] == "mqtt_publish"
        action_desc = "MQTT: " + link["action_payload"].find("topic", "")
      end

      var toggle_btn = "Enable"
      if link["enabled"]
        toggle_btn = "Disable"
      end

      var status_text = "OFF"
      if link["enabled"]
        status_text = "ON"
      end

      html += f"<tr><td>{link['id']}</td>"
      html += f"<td>{webserver.html_escape(door_name)}</td>"
      html += f"<td>{link['trigger_state']}</td>"
      html += f"<td>{webserver.html_escape(action_desc)}</td>"
      html += f"<td>{status_text}</td>"
      html += "<td>"
      html += f"<button onclick='la(\"&toggle={link['id']}\");'>{toggle_btn}</button>"
      html += f"<button class='bred' onclick='if(confirm(\"Delete?\"))la(\"&delete={link['id']}\");'>Delete</button>"
      html += "</td></tr>"
    end

    if size(self.links) == 0
      html += "<tr><td colspan='6'>No rules</td></tr>"
    end

    html += "</table>"

    if size(self.doors) > 0 && size(self.remotes) > 0
      html += "<hr><h4>Add New Rule</h4>"
      html += "<form method='get' action='/link'>"
      html += "<p><label><b>Door Sensor</b></label><br><select id='door_id' name='door_id'>"
      for door : self.doors
        html += f"<option value='{door['id']}'>{webserver.html_escape(door['name'])}</option>"
      end
      html += "</select></p>"
      html += "<p><label><b>Trigger</b></label><br><select id='trigger_state' name='trigger_state'>"
      html += "<option value='OPEN'>Opens</option>"
      html += "<option value='CLOSE'>Closes</option>"
      html += "</select></p>"
      html += "<p><label><b>Action Type</b></label><br><select id='action_type' name='action_type' onchange='document.getElementById(\"rf_send_opts\").style.display=this.value==\"rf_send\"?\"block\":\"none\";document.getElementById(\"mqtt_opts\").style.display=this.value==\"mqtt_publish\"?\"block\":\"none\";'>"
      html += "<option value='rf_send'>Send RF Signal</option>"
      html += "<option value='mqtt_publish'>Publish MQTT</option>"
      html += "</select></p>"
      html += "<div id='rf_send_opts'><p><label><b>Remote</b></label><br><select id='remote_id' name='remote_id'>"
      for remote : self.remotes
        html += f"<option value='{remote['id']}'>{webserver.html_escape(remote['name'])}</option>"
      end
      html += "</select></p></div>"
      html += "<div id='mqtt_opts' style='display:none;'>"
      html += "<p><label><b>MQTT Topic</b></label><br><input id='mqtt_topic' name='mqtt_topic' placeholder='tele/device/trigger'></p>"
      html += "<p><label><b>MQTT Payload</b></label><br><input id='mqtt_payload' name='mqtt_payload' placeholder='ON'></p>"
      html += "</div>"
      html += "<p><button class='bgrn' name='save' value='1' type='submit'>Add Rule</button></p>"
      html += "</form>"
    else
      html += "<p style='color:var(--c_txtwrn);'>Add at least one door sensor and one remote first.</p>"
    end

    html += "<p></p><form action='/rf' method='get'><button>Back to Remotes</button></form>"

    if webserver.has_arg("delete") || webserver.has_arg("save")
      html += "<script>setTimeout(function(){window.location.href='/link';},1500);</script>"
    end

    webserver.content_send(html)
    webserver.content_stop()
  end

  def handle_api_event()
    import webserver
    import json

    # API 返回用 content_response (WSReturnSimpleString)，正确设置响应头并结束响应。
    # 之前用 content_send 会导致 HTTP 响应异常结束 (ResponseEnded)，前端轮询无法读取。

    if self.learn_result != nil
      var resp = json.dump(self.learn_result)
      self.learn_result = nil
      webserver.content_response(resp)
      return
    end

    try
      var rx = json.load(cc1101_receive())
      var value = rx.find("Value", 0)
      var bits = rx.find("Bits", 0)
      var protocol = rx.find("Protocol", 0)
      var delay_val = rx.find("Pulse", 0)
      if value > 0
        var resp = json.dump({
          "value": value,
          "bits": bits,
          "protocol": protocol,
          "pulse_length": delay_val
        })
        webserver.content_response(resp)
        return
      end
    except .. as e, m
      log(f"CC1: rf event error: {e} {m}", 3)
    end
    webserver.content_response("")
  end

  def mqtt_data(topic, idx, data, databytes)
    return false
  end
end

var gateway = Cc1101Gateway()
tasmota.add_driver(gateway)

return gateway