#@ solidify:Cc1101Gateway

class Cc1101Gateway
  var remotes, doors, links, events
  var sequences, virtual_devices
  var next_remote_id, next_door_id, next_link_id
  var recording, record_timeout
  var learn_mode, learn_timeout, learn_result
  var pending_remote
  var last_event_ts
  var device_name
  var seq_running_seq, seq_running_index, seq_delay_until, seq_stop_requested

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
    self.pending_remote = nil
    self.last_event_ts = 0
    self.device_name = ""
    self.seq_running_seq = nil
    self.seq_running_index = 0
    self.seq_delay_until = 0
    self.seq_stop_requested = false

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
    import string

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
    var lines = string.split(str(content), "\n")
    for line : lines
      line = string.replace(line, "\r", "")
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

  def add_remote(name, group, protocol, value, bits, pulse_length, repeat, raw, note, icon)
    if icon == nil || icon == "" icon = "remote" end
    var remote = {
      "id": self.next_remote_id,
      "name": name,
      "group": group,
      "icon": icon,
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

  def add_multi_button_remote(name, group, icon, note, buttons)
    if icon == nil || icon == "" icon = "remote" end
    if buttons == nil buttons = [] end
    var value = 0
    var bits = 24
    var protocol = 1
    if size(buttons) > 0
      value = buttons[0].find("value", 0)
      bits = buttons[0].find("bits", 24)
      protocol = buttons[0].find("protocol", 1)
    end
    var remote = {
      "id": self.next_remote_id,
      "name": name,
      "group": group,
      "icon": icon,
      "protocol": protocol,
      "value": value,
      "bits": bits,
      "pulse_length": 0,
      "repeat": 10,
      "raw": nil,
      "note": note,
      "buttons": buttons,
      "last_sent_at": 0
    }
    self.remotes.push(remote)
    self.next_remote_id += 1
    self.save_remotes()
    self.add_event("record", {"remote_id": remote["id"], "detail": f"buttons={size(buttons)}"})
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

  def all_devices()
    var out = []
    for r : self.remotes
      var btns = r.find("buttons", [])
      if btns == nil btns = [] end
      out.push({
        "kind": "remote",
        "id": r["id"],
        "name": r["name"],
        "group": r.find("group", ""),
        "icon": r.find("icon", "remote"),
        "note": r.find("note", ""),
        "buttons": btns,
        "button_count": size(btns),
        "protocol": r.find("protocol", 1),
        "bits": r.find("bits", 0),
        "value": r.find("value", 0),
        "type_label": "遥控"
      })
    end
    for d : self.doors
      out.push({
        "kind": "door",
        "id": d["id"],
        "name": d["name"],
        "location": d.find("location", ""),
        "code": d.find("code", 0),
        "state": d.find("state", "CLOSE"),
        "note": d.find("note", ""),
        "type_label": "门磁",
        "icon": "door",
        "buttons": []
      })
    end
    return out
  end

  def find_device(kind, id)
    if kind == "door"
      return self.find_door(id)
    end
    return self.find_remote(id)
  end

  def delete_device(kind, id)
    if kind == "door"
      return self.delete_door(id)
    end
    return self.delete_remote(id)
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
    tasmota.add_cmd("RfSequence", def(cmd, idx, payload, payload_json)
      self.cmd_rf_sequence(payload, payload_json)
    end)
    tasmota.add_cmd("RfVDevice", def(cmd, idx, payload, payload_json)
      self.cmd_rf_vdevice(payload, payload_json)
    end)
  end

  def register_webui()
    # 老 WebUI 路由已迁移至 cc1101_webapp.be 的 APP UI，此方法保留为空避免外部调用报错
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

  def cmd_rf_sequence(payload, payload_json)
    import json
    if payload_json == nil
      tasmota.resp_cmnd_str('{"Sequence":"error","reason":"invalid_json"}')
      return
    end
    var cmd = payload_json.find("cmd")
    if cmd == "list"
      tasmota.resp_cmnd_str(json.dump({"Sequences": self.sequences}))
      return
    end
    var name = payload_json.find("name")
    if cmd == "save" && name != nil
      self._upsert_sequence(name, payload_json.find("steps", []))
      tasmota.resp_cmnd_str('{"Sequence":"saved"}')
      return
    end
    if cmd == "delete" && name != nil
      self._delete_sequence(name)
      tasmota.resp_cmnd_str('{"Sequence":"deleted"}')
      return
    end
    if cmd == "run" && name != nil
      self.seq_run_by_name(name)
      tasmota.resp_cmnd_str('{"Sequence":"running"}')
      return
    end
    if cmd == "stop"
      self.seq_stop()
      tasmota.resp_cmnd_str('{"Sequence":"stopped"}')
      return
    end
    tasmota.resp_cmnd_str('{"Sequence":"error","reason":"bad_request"}')
  end

  def _upsert_sequence(name, steps)
    var found = false
    for seq : self.sequences
      if seq["name"] == name
        seq["steps"] = steps
        found = true
        break
      end
    end
    if !found
      self.sequences.push({"name": name, "steps": steps})
    end
    self.save_sequences()
  end

  def _delete_sequence(name)
    var i = 0
    while i < size(self.sequences)
      if self.sequences[i]["name"] == name
        self.sequences.remove(i)
        break
      end
      i += 1
    end
    self.save_sequences()
  end

  def seq_run_by_name(name)
    for seq : self.sequences
      if seq["name"] == name
        # 抢占式单实例：立即终止当前序列，从新序列第 1 步开始
        self.seq_stop_requested = true
        self.seq_running_seq = nil
        self.seq_stop_requested = false
        self.seq_running_seq = seq
        self.seq_running_index = 0
        self.seq_delay_until = 0
        self.add_event("seq_start", {"seq": name})
        return true
      end
    end
    return false
  end

  def seq_stop()
    self.seq_stop_requested = true
    self.seq_running_seq = nil
    self.seq_running_index = 0
    self.seq_delay_until = 0
    self.add_event("seq_stop", {})
  end

  def seq_tick()
    if self.seq_running_seq == nil || self.seq_stop_requested
      self.seq_running_seq = nil
      return
    end
    var seq = self.seq_running_seq
    var steps = seq["steps"]
    if self.seq_running_index >= size(steps)
      self.add_event("seq_done", {"seq": seq["name"]})
      self.seq_running_seq = nil
      self.seq_running_index = 0
      return
    end
    var step = steps[self.seq_running_index]
    if self.seq_delay_until == 0
      if step["type"] == "send"
        if step.find("remote_id") != nil
          if step.find("button_id") != nil
            self.send_remote_button(step["remote_id"], step["button_id"])
          else
            self._send_remote_by_id(step["remote_id"])
          end
        end
        self.seq_running_index += 1
      elif step["type"] == "delay"
        self.seq_delay_until = tasmota.millis() + step["ms"]
      end
    else
      if tasmota.millis() >= self.seq_delay_until
        self.seq_delay_until = 0
        self.seq_running_index += 1
      end
    end
  end

  def every_50ms()
    try
      self.seq_tick()
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
    for vd : self.virtual_devices
      self.publish_ha_vdevice(vd)
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

  def cmd_rf_vdevice(payload, payload_json)
    import json
    if payload_json == nil
      tasmota.resp_cmnd_str('{"VDevice":"error","reason":"invalid_json"}')
      return
    end
    var cmd = payload_json.find("cmd")
    if cmd == "list"
      tasmota.resp_cmnd_str(json.dump({"Devices": self.virtual_devices}))
      return
    end
    var name = payload_json.find("name")
    if cmd == "save" && name != nil
      var vd = {
        "name": name,
        "on_sequence": payload_json.find("on_sequence", ""),
        "off_sequence": payload_json.find("off_sequence", ""),
        "state": payload_json.find("state", "OFF")
      }
      self._upsert_vdevice(vd)
      self.publish_ha_vdevice(vd)
      tasmota.resp_cmnd_str('{"VDevice":"saved"}')
      return
    end
    if cmd == "delete" && name != nil
      self._delete_vdevice(name)
      tasmota.resp_cmnd_str('{"VDevice":"deleted"}')
      return
    end
    tasmota.resp_cmnd_str('{"VDevice":"error","reason":"bad_request"}')
  end

  def _upsert_vdevice(vd)
    var found = false
    for i : 0 .. size(self.virtual_devices) - 1
      if self.virtual_devices[i]["name"] == vd["name"]
        self.virtual_devices[i] = vd
        found = true
        break
      end
    end
    if !found
      self.virtual_devices.push(vd)
    end
    self.save_virtual_devices()
  end

  def _delete_vdevice(name)
    var i = 0
    while i < size(self.virtual_devices)
      if self.virtual_devices[i]["name"] == name
        self.virtual_devices.remove(i)
        break
      end
      i += 1
    end
    self.save_virtual_devices()
  end

  def publish_ha_vdevice(vd)
    import mqtt
    import json
    var dev = self._get_device_name()
    var cfg = {
      "name": vd["name"],
      "command_topic": f"cmnd/{dev}/rf_vdevice/{vd['name']}",
      "state_topic": f"tele/{dev}/rf_vdevice/{vd['name']}",
      "payload_on": "ON",
      "payload_off": "OFF",
      "unique_id": f"{dev}_vd_{vd['name']}",
      "device": {"identifiers": [dev], "name": "CC1101 Gateway",
                 "model": "Tasmota CC1101", "manufacturer": "Tasmota"}
    }
    mqtt.publish(f"homeassistant/switch/{dev}_vd_{vd['name']}/config", json.dump(cfg), true)
  end

  def publish_vdevice_state(vd)
    import mqtt
    var dev = self._get_device_name()
    mqtt.publish(f"tele/{dev}/rf_vdevice/{vd['name']}", vd["state"])
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

  # web_add_main_button 由 cc1101_webapp.be 提供 APP UI 入口按钮，此处不再重复
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
    # 原生 UI 不再暴露 433 入口；APP UI 通过 webapp 的 web_add_main_button 进入
    self.register_webui()
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
    import json
    import string
    var dev = self._get_device_name()
    var prefix = "cmnd/" + dev + "/rf_vdevice/"
    if topic.find(prefix) == 0
      var name = topic[size(prefix) .. ]
      for vd : self.virtual_devices
        if vd["name"] == name
          var payload = string.toupper(str(data))
          if string.find(payload, "ON") >= 0
            vd["state"] = "ON"
            self.save_virtual_devices()
            self.seq_run_by_name(vd["on_sequence"])
            self.publish_vdevice_state(vd)
            return true
          elif string.find(payload, "OFF") >= 0
            vd["state"] = "OFF"
            self.save_virtual_devices()
            self.seq_run_by_name(vd["off_sequence"])
            self.publish_vdevice_state(vd)
            return true
          end
        end
      end
    end
    return false
  end
end

var gateway = Cc1101Gateway()
tasmota.add_driver(gateway)

return gateway
