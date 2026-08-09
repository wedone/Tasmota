#@ solidify:Cc1101WebApp

# 433 Gateway App 风格 WebUI（HomeKit 风格）
# 依赖 cc1101_gateway.be 的全局 gateway 实例
class Cc1101WebApp
  def init()
  end

  def app_page(title, active_tab, content_html)
    var html = "<!DOCTYPE html><html><head><meta charset='utf-8'>"
    html += "<meta name='viewport' content='width=device-width,initial-scale=1,maximum-scale=1,user-scalable=no'>"
    html += "<title>" + title + "</title>"
    html += "<style>"
    html += "html,body{background:#f7f7f9;font-family:-apple-system,sans-serif;margin:0;padding:0;color:#000;}"
    html += "a{outline:none;} *{-webkit-tap-highlight-color:transparent;box-sizing:border-box;}"
    html += ".app-hd{background:#f7f7f9;padding:14px 16px 6px;display:flex;align-items:center;justify-content:space-between;}"
    html += ".app-hd h1{font-size:19px;margin:0;font-weight:700;}"
    html += ".app-hd a{font-size:17px;text-decoration:none;color:#007aff;}"
    html += ".app-body{padding:6px 14px 74px;}"
    html += ".sect{font-size:12px;color:#8e8e93;font-weight:700;margin:12px 0 6px;}"
    html += ".grid3{display:grid;grid-template-columns:repeat(3,1fr);gap:10px;}"
    html += ".grid4{display:grid;grid-template-columns:repeat(4,1fr);gap:8px;}"
    html += ".hkbtn{background:#fff;border-radius:16px;text-align:center;padding:14px 4px;box-shadow:0 1px 4px rgba(0,0,0,.07);cursor:pointer;text-decoration:none;color:#000;}"
    html += ".hkbtn .ic{font-size:23px;line-height:1;} .hkbtn .nm{font-size:10px;margin-top:5px;font-weight:500;}"
    html += ".sqcell{text-align:center;text-decoration:none;color:#000;display:block;}"
    html += ".sqbtn{width:48px;height:48px;margin:0 auto;background:#fff;border-radius:14px;box-shadow:0 1px 4px rgba(0,0,0,.08);display:flex;align-items:center;justify-content:center;font-size:21px;}"
    html += ".sqlbl{font-size:9px;color:#666;margin-top:4px;}"
    html += ".card{background:#fff;border-radius:14px;padding:10px 12px;box-shadow:0 1px 3px rgba(0,0,0,.07);margin-bottom:8px;}"
    html += ".cell{display:flex;align-items:center;gap:9px;}"
    html += ".cell .ic{width:30px;height:30px;border-radius:9px;background:#f0f2f5;display:flex;align-items:center;justify-content:center;font-size:14px;flex:none;}"
    html += ".cell .tx{flex:1;} .cell .t1{font-size:13px;font-weight:600;} .cell .t2{font-size:10px;color:#8e8e93;margin-top:1px;}"
    html += ".btn{display:block;text-align:center;padding:11px;border-radius:12px;font-size:13px;font-weight:600;text-decoration:none;margin-bottom:8px;}"
    html += ".btn.blue{background:#007aff;color:#fff;} .btn.gray{background:#e9e9ee;color:#333;}"
    html += ".app-tab{position:fixed;bottom:0;left:0;right:0;background:rgba(249,249,251,.97);border-top:1px solid #e5e5ea;display:flex;z-index:9;}"
    html += ".app-tab a{flex:1;text-align:center;padding:9px 0;font-size:9.5px;color:#8e8e93;text-decoration:none;}"
    html += ".app-tab a.on{color:#007aff;font-weight:700;}"
    html += "</style>"
    html += "</head><body>"
    html += "<div class='app-hd'><h1>" + title + "</h1><a href='/app/manage'>⚙</a></div>"
    html += "<div class='app-body'>" + content_html + "</div>"
    var tabs = [["/app/rf","遥控"],["/app/seq","场景"],["/app/door","门磁"],["/app/event","事件"],["/app/manage","管理"]]
    html += "<div class='app-tab'>"
    for t : tabs
      html += "<a href='" + t[0] + "'" + (t[1] == active_tab ? " class='on'" : "") + ">" + t[1] + "</a>"
    end
    html += "</div>"
    html += "</body></html>"
    return html
  end

  def app_send_page(title, active_tab, content_html)
    import webserver
    webserver.content_open(200, "text/html")
    webserver.content_send(self.app_page(title, active_tab, content_html))
    webserver.content_close()
  end

  def handle_app_page_root()
    import webserver
    webserver.redirect("/app/rf")
  end

  def handle_app_rf_page()
    import webserver
    var g = gateway
    var html = ""
    html += "<div class='sect'>门磁</div>"
    if size(g.doors) > 0
      html += "<div style='display:flex;gap:10px;'>"
      for door : g.doors
        var st = door["state"]
        var bg = st == "OPEN" ? "#fdecec" : "#eaf6ee"
        var txt = st == "OPEN" ? "开启!" : "已关"
        html += f"<div class='hkbtn' style='flex:1;background:{bg};'><div class='ic'>🚪</div><div class='nm'>{webserver.html_escape(door['name'])} {txt}</div></div>"
      end
      html += "</div>"
    else
      html += "<div class='card' style='color:#8e8e93;font-size:12px;'>暂无门磁，请在管理中添加</div>"
    end
    html += "<div class='sect'>遥控</div>"
    if size(g.remotes) > 0
      html += "<div class='grid3'>"
      for remote : g.remotes
        html += f"<a class='hkbtn' href='/app/rf/view?id={remote['id']}'>"
        html += f"<div class='ic'>{webserver.html_escape(remote.find('icon','🕹'))}</div>"
        html += f"<div class='nm'>{webserver.html_escape(remote['name'])}</div></a>"
      end
      html += "</div>"
    else
      html += "<div class='card' style='color:#8e8e93;font-size:12px;'>暂无遥控，请到管理中录制</div>"
    end
    html += "<div class='sect'>虚拟设备</div>"
    if size(g.virtual_devices) > 0
      html += "<div class='grid3'>"
      for vd : g.virtual_devices
        html += f"<a class='hkbtn' href='/app/api/vdon?name={vd['name']}'><div class='ic'>📡</div><div class='nm'>{webserver.html_escape(vd['name'])}</div></a>"
      end
      html += "</div>"
    end
    self.app_send_page("433 Gateway", "遥控", html)
  end

  def handle_app_rf_view_page()
    import webserver
    var g = gateway
    var id = int(webserver.arg("id"))
    var remote = g.find_remote(id)
    if remote == nil
      self.app_send_page("遥控", "遥控", "<div class='card'>遥控不存在</div>")
      return
    end
    var html = ""
    html += "<a href='/app/rf' style='text-decoration:none;color:#007aff;font-size:13px;'>‹ 遥控</a>"
    html += "<div class='sect'>" + webserver.html_escape(remote["name"]) + "</div>"
    html += "<div class='card'><div class='grid4'>"
    var btns = remote["buttons"]
    if btns == nil || size(btns) == 0
      html += f"<a class='sqcell' href='/app/api/send?rid={remote['id']}'>"
      html += f"<div class='sqbtn'>{webserver.html_escape(remote.find('icon','🕹'))}</div><div class='sqlbl'>{webserver.html_escape(remote['name'])}</div></a>"
    else
      for b : btns
        html += f"<a class='sqcell' href='/app/api/send?rid={remote['id']}&bid={b['id']}'>"
        html += f"<div class='sqbtn'>{webserver.html_escape(b['icon'])}</div><div class='sqlbl'>{webserver.html_escape(b['name'])}</div></a>"
      end
    end
    html += "</div></div>"
    html += "<a class='btn gray' href='/app/rf/edit?id=" + str(remote["id"]) + "'>＋ 管理按钮</a>"
    self.app_send_page(webserver.html_escape(remote["name"]), "遥控", html)
  end

  def handle_app_seq_page()
    import webserver
    var g = gateway
    var html = ""
    html += "<div class='sect'>场景（序列动作）</div>"
    if size(g.sequences) > 0
      for seq : g.sequences
        var n = size(seq["steps"])
        html += "<div class='card cell'>"
        html += f"<div class='ic'>🎬</div><div class='tx'><div class='t1'>{webserver.html_escape(seq['name'])}</div><div class='t2'>{n} 步</div></div>"
        html += f"<a class='btn blue' style='padding:8px 13px;font-size:11px;margin:0;' href='/app/api/seqrun?name={seq['name']}'>▶</a>"
        html += f"<a class='btn gray' style='padding:8px 13px;font-size:11px;margin:0;' href='/app/seq/edit?name={seq['name']}'>✎</a>"
        html += "</div>"
      end
    else
      html += "<div class='card' style='color:#8e8e93;font-size:12px;'>暂无场景</div>"
    end
    html += "<a class='btn blue' href='/app/seq/edit?name=new'>＋ 新建场景</a>"
    html += "<a class='btn gray' href='/app/api/seqrun?stop=1'>■ 停止当前序列</a>"
    self.app_send_page("场景", "场景", html)
  end

  def handle_app_seq_edit_page()
    import webserver
    import json
    var g = gateway
    var name = webserver.arg("name")
    if webserver.has_arg("save")
      var steps = json.load(webserver.arg("steps"))
      var seqname = webserver.arg("seqname")
      g._upsert_sequence(seqname, steps)
      webserver.redirect("/app/seq")
      return
    end
    var seq = nil
    if name != "new"
      for s : g.sequences
        if s["name"] == name
          seq = s
          break
        end
      end
    end
    var html = ""
    html += "<a href='/app/seq' style='text-decoration:none;color:#007aff;font-size:13px;'>‹ 场景</a>"
    html += "<div class='sect'>" + webserver.html_escape(name == "new" ? "新建场景" : name) + "</div>"
    html += "<div class='card'><div id='steps'></div>"
    html += "<button class='btn gray' onclick='addDelay()' style='width:100%;'>＋ 延时 1000ms</button>"
    html += "</div>"
    html += "<div class='sect'>添加发送遥控</div>"
    html += "<div class='grid3' id='remotes'></div>"
    if size(g.remotes) == 0
      html += "<div class='card' style='color:#8e8e93;font-size:12px;'>暂无遥控，请先录制遥控</div>"
    end
    html += "<a class='btn blue' id='savebtn'>保存</a>"
    var remotes = []
    for r : g.remotes
      remotes.push({"id": r["id"], "name": r["name"], "icon": r.find("icon", "🕹")})
    end
    html += "<script>var STEPS=" + (seq != nil ? json.dump(seq["steps"]) : "[]") + ";"
    html += "var REMOTES=" + json.dump(remotes) + ";"
    html += "function rname(id){var r=REMOTES.find(function(x){return x.id==id});return r?r.name:('遥控#'+id)}"
    html += "function render(){var h='';STEPS.forEach(function(s,i){if(s.type=='send'){h+='<div style=\"padding:6px 0;border-bottom:1px solid #f2f2f7;display:flex;align-items:center;\"><span style=\"flex:1;\">📡 '+rname(s.remote_id)+(s.button_id!==undefined?' ·按钮'+s.button_id:'')+'</span><span onclick=\"STEPS.splice('+i+',1);render()\" style=\"color:#d33;padding:4px;\">✕</span></div>'}else{h+='<div style=\"padding:6px 0;border-bottom:1px solid #f2f2f7;display:flex;align-items:center;\"><span style=\"flex:1;\">⏱ 延时 '+s.ms+'ms</span><span onclick=\"STEPS.splice('+i+',1);render()\" style=\"color:#d33;padding:4px;\">✕</span></div>'}});document.getElementById('steps').innerHTML=h}"
    html += "function addSend(rid){STEPS.push({type:'send',remote_id:rid});render()}"
    html += "function addDelay(){STEPS.push({type:'delay',ms:1000});render()}"
    html += "render();"
    html += "var rh='';REMOTES.forEach(function(r){rh+='<a class=\"hkbtn\" style=\"padding:10px 4px;\" onclick=\"addSend('+r.id+')\"><div class=\"ic\">'+(r.icon||'🕹')+'</div><div class=\"nm\">'+r.name+'</div></a>'});document.getElementById('remotes').innerHTML=rh;"
    html += "document.getElementById('savebtn').href='/app/seq/edit?save=1&seqname='+encodeURIComponent('" + webserver.html_escape(name) + "')+'&steps='+encodeURIComponent(JSON.stringify(STEPS));"
    html += "</script>"
    self.app_send_page("编辑场景", "场景", html)
  end

  def handle_app_door_page()
    import webserver
    var g = gateway
    var html = ""
    html += "<div class='sect'>门磁</div>"
    if size(g.doors) > 0
      for door : g.doors
        var st = door["state"]
        var color = st == "OPEN" ? "#d33" : "#2e9e5b"
        var txt = st == "OPEN" ? "开启!" : "已关"
        html += "<div class='card cell'>"
        html += f"<div class='ic'>🚪</div><div class='tx'><div class='t1'>{webserver.html_escape(door['name'])}</div><div class='t2'>最后变更 {door.find('last_event_at','-')}</div></div>"
        html += f"<span style='font-size:13px;font-weight:700;color:{color};'>{txt}</span></div>"
      end
    else
      html += "<div class='card' style='color:#8e8e93;font-size:12px;'>暂无门磁</div>"
    end
    html += "<a class='btn blue' href='/app/door/edit'>＋ 添加门磁</a>"
    self.app_send_page("门磁", "门磁", html)
  end

  def handle_app_event_page()
    import webserver
    var g = gateway
    var html = ""
    html += "<div class='sect'>事件</div><div class='card'>"
    var n = size(g.events)
    if n == 0
      html += "<div style='color:#8e8e93;font-size:12px;'>暂无事件</div>"
    else
      var start = n > 30 ? n - 30 : 0
      for i : start .. n - 1
        var evt = g.events[i]
        html += f"<div style='padding:5px 0;border-bottom:1px solid #f2f2f7;font-size:12px;'>"
        html += f"<span style='color:#8e8e93;font-size:11px;'>{evt.find('ts','-')}</span> "
        html += f"<span>{webserver.html_escape(evt['type'])} · {webserver.html_escape(str(evt.find('detail','')))}</span></div>"
      end
    end
    html += "</div>"
    self.app_send_page("事件", "事件", html)
  end

  def handle_app_manage_page()
    import webserver
    var html = ""
    html += "<div class='sect'>433 管理</div>"
    html += "<a class='btn gray' href='/app/rf/manage'>🕹 遥控管理（录制/编辑）</a>"
    html += "<a class='btn gray' href='/app/door/manage'>🚪 门磁管理</a>"
    html += "<a class='btn gray' href='/app/link'>🔗 联动规则</a>"
    html += "<a class='btn gray' href='/app/vdev'>📡 虚拟设备</a>"
    html += "<a class='btn gray' href='/app/rf/record'>🎙 录制遥控</a>"
    html += "<div class='sect'>系统</div>"
    html += "<a class='btn gray' href='/cs'>🔐 Tasmota 系统设置</a>"
    self.app_send_page("管理", "管理", html)
  end

  def handle_app_vdev_page()
    import webserver
    var g = gateway
    var html = ""
    html += "<div class='sect'>虚拟设备</div>"
    if size(g.virtual_devices) > 0
      for vd : g.virtual_devices
        html += "<div class='card cell'>"
        html += f"<div class='ic'>📡</div><div class='tx'><div class='t1'>{webserver.html_escape(vd['name'])}</div>"
        html += f"<div class='t2'>开:{webserver.html_escape(vd['on_sequence'])} · 关:{webserver.html_escape(vd['off_sequence'])} · {vd['state']}</div></div>"
        html += f"<a class='btn gray' style='padding:8px 12px;font-size:11px;margin:0;' href='/app/vdev/edit?name={webserver.html_escape(vd['name'])}'>✎</a></div>"
      end
    else
      html += "<div class='card' style='color:#8e8e93;font-size:12px;'>暂无虚拟设备</div>"
    end
    html += "<a class='btn blue' href='/app/vdev/edit'>＋ 新建虚拟设备</a>"
    html += "<div class='card' style='color:#666;font-size:11px;'>虚拟设备在 HA 中显示为开关，控制命令触发本地序列。</div>"
    self.app_send_page("虚拟设备", "管理", html)
  end

  def handle_app_api_send()
    import webserver
    import json
    var g = gateway
    var rid = int(webserver.arg("rid"))
    var bid = webserver.arg("bid")
    if bid != nil && bid != ""
      g.send_remote_button(rid, int(bid))
    else
      g._send_remote_by_id(rid)
    end
    webserver.content_response(json.dump({"ok": true}))
  end

  def handle_app_api_seqrun()
    import webserver
    import json
    var g = gateway
    if webserver.has_arg("stop")
      g.seq_stop()
    else
      var name = webserver.arg("name")
      if name != nil
        g.seq_run_by_name(name)
      end
    end
    webserver.redirect("/app/seq")
  end

  def handle_app_api_vdon()
    import webserver
    import json
    var g = gateway
    var name = webserver.arg("name")
    for vd : g.virtual_devices
      if vd["name"] == name
        vd["state"] = "ON"
        g.save_virtual_devices()
        g.seq_run_by_name(vd["on_sequence"])
        break
      end
    end
    webserver.redirect("/app/rf")
  end

  # ============ 录制/配对 AJAX 端点（迁移自 /api/rf/event）============
  def handle_app_api_rf_event()
    gateway.handle_api_event()
  end

  # ============ 遥控录制（替代 /rf/record）============
  def handle_app_rf_record()
    import webserver
    var g = gateway
    var html = ""
    html += "<a href='/app/rf/manage' style='text-decoration:none;color:#007aff;font-size:13px;'>‹ 遥控管理</a>"

    # 状态4：保存
    if webserver.has_arg("name")
      var name = webserver.arg("name")
      var group = webserver.arg("group")
      var protocol = int(webserver.arg("protocol"))
      var value = int(webserver.arg("value"))
      var bits = int(webserver.arg("bits"))
      var pulse = int(webserver.arg("pulse_length"))
      var repeat = int(webserver.arg("repeat"))
      var note = webserver.arg("note")
      if value == nil value = 0 end
      if bits == nil bits = 0 end
      if protocol == nil protocol = 0 end
      if repeat == nil repeat = 10 end
      if note == nil note = "" end
      if group == nil group = "" end
      if name != "" && value > 0
        g.add_remote(name, group, protocol, value, bits, pulse, repeat, nil, note)
        html += "<div class='card' style='text-align:center;color:#2e9e5b;font-weight:600;'>遥控已保存</div>"
        html += "<script>setTimeout(function(){window.location.href='/app/rf/manage';},1000);</script>"
        self.app_send_page("录制遥控", "管理", html)
        return
      end
    end

    # 状态3：停止录制
    if webserver.has_arg("stop")
      g.learn_mode = false
      g.learn_result = nil
      html += "<div class='card' style='text-align:center;color:#d33;font-weight:600;'>录制已停止</div>"
      html += "<a class='btn blue' href='/app/rf/record'>重新录制</a>"
      self.app_send_page("录制遥控", "管理", html)
      return
    end

    # 状态2：录制中（启动监听 + AJAX 轮询）
    if webserver.has_arg("start")
      g.learn_mode = true
      g.learn_timeout = tasmota.millis() + 30000
      g.learn_result = nil
      cc1101_flush_rx()
      tasmota.remove_timer(g._TIMER_RECORD)
      tasmota.set_timer(30000, def()
        if g.learn_mode
          g.learn_mode = false
          g.learn_result = nil
        end
      end, g._TIMER_RECORD)
      html += "<div class='card' style='text-align:center;'>"
      html += "<div style='font-size:40px;'>🎙</div>"
      html += "<div style='font-size:14px;font-weight:600;margin-top:8px;'>监听中...</div>"
      html += "<div style='font-size:11px;color:#8e8e93;margin-top:4px;'>30秒内按下遥控器按钮</div>"
      html += "</div>"
      html += "<a class='btn gray' href='/app/rf/record?stop=1'>停止录制</a>"
      html += "<script>"
      html += "var poll=setInterval(function(){"
      html += "var x=new XMLHttpRequest();"
      html += "x.open('GET','/app/api/rf/event',true);"
      html += "x.onreadystatechange=function(){"
      html += "if(x.readyState==4&&x.status==200&&x.responseText!=''){"
      html += "var d=JSON.parse(x.responseText);"
      html += "if(d.value){clearInterval(poll);"
      html += "window.location.href='/app/rf/record?value='+d.value+'&bits='+d.bits+'&protocol='+d.protocol+'&pulse_length='+d.pulse_length;"
      html += "}}};x.send();},500);"
      html += "setTimeout(function(){clearInterval(poll);window.location.href='/app/rf/record?stop=1';},35000);"
      html += "</script>"
      self.app_send_page("录制遥控", "管理", html)
      return
    end

    # 状态1：已捕获信号，显示保存表单
    var value = webserver.arg("value")
    var bits = webserver.arg("bits")
    var protocol = webserver.arg("protocol")
    var pulse = webserver.arg("pulse_length")
    if value != nil && value != ""
      html += "<div class='sect'>已捕获信号</div>"
      html += "<div class='card' style='font-size:12px;color:#666;line-height:1.8;'>"
      html += f"<div>编码: <b>{value}</b></div>"
      html += f"<div>位数: {bits}</div>"
      html += f"<div>协议: P{protocol}</div>"
      html += f"<div>脉宽: {pulse}</div>"
      html += "</div>"
      html += "<form method='get' action='/app/rf/record'>"
      html += f"<input type='hidden' name='value' value='{value}'>"
      html += f"<input type='hidden' name='bits' value='{bits}'>"
      html += f"<input type='hidden' name='protocol' value='{protocol}'>"
      html += f"<input type='hidden' name='pulse_length' value='{pulse}'>"
      html += "<div class='sect'>名称</div>"
      html += "<div class='card'><input id='name' name='name' placeholder='如：客厅灯' style='width:100%;border:none;font-size:14px;background:transparent;' required></div>"
      html += "<div class='sect'>分组</div>"
      html += "<div class='card'><input id='group' name='group' placeholder='如：照明' style='width:100%;border:none;font-size:14px;background:transparent;'></div>"
      html += "<div class='sect'>重复次数</div>"
      html += "<div class='card'><input id='repeat' name='repeat' type='number' value='10' style='width:100%;border:none;font-size:14px;background:transparent;'></div>"
      html += "<div class='sect'>备注</div>"
      html += "<div class='card'><input id='note' name='note' placeholder='可选' style='width:100%;border:none;font-size:14px;background:transparent;'></div>"
      html += "<button class='btn blue' type='submit'>保存遥控</button>"
      html += "</form>"
      self.app_send_page("录制遥控", "管理", html)
      return
    end

    # 状态0：未开始
    html += "<div class='card' style='text-align:center;'>"
    html += "<div style='font-size:40px;'>🎙</div>"
    html += "<div style='font-size:14px;font-weight:600;margin-top:8px;'>录制遥控</div>"
    html += "<div style='font-size:11px;color:#8e8e93;margin-top:4px;'>点击开始后，30秒内按下遥控器</div>"
    html += "</div>"
    html += "<a class='btn blue' href='/app/rf/record?start=1'>开始录制</a>"
    self.app_send_page("录制遥控", "管理", html)
  end

  # ============ 遥控编辑（替代 /rf/edit）============
  def handle_app_rf_edit()
    import webserver
    var g = gateway
    var id = int(webserver.arg("id"))
    var html = ""
    html += "<a href='/app/rf/manage' style='text-decoration:none;color:#007aff;font-size:13px;'>‹ 遥控管理</a>"

    # 保存
    if webserver.has_arg("save")
      var name = webserver.arg("name")
      var group = webserver.arg("group")
      var protocol = int(webserver.arg("protocol"))
      var value = int(webserver.arg("value"))
      var bits = int(webserver.arg("bits"))
      var pulse = int(webserver.arg("pulse_length"))
      var repeat = int(webserver.arg("repeat"))
      var note = webserver.arg("note")
      if name == nil name = "" end
      if group == nil group = "" end
      if note == nil note = "" end
      if protocol == nil protocol = 1 end
      if value == nil value = 0 end
      if bits == nil bits = 24 end
      if pulse == nil pulse = 0 end
      if repeat == nil repeat = 10 end
      g.update_remote(id, {"name": name, "group": group, "protocol": protocol, "value": value, "bits": bits, "pulse_length": pulse, "repeat": repeat, "note": note})
      html += "<div class='card' style='text-align:center;color:#2e9e5b;font-weight:600;'>已保存</div>"
      html += "<script>setTimeout(function(){window.location.href='/app/rf/manage';},1000);</script>"
      self.app_send_page("编辑遥控", "管理", html)
      return
    end

    var remote = g.find_remote(id)
    if remote == nil
      html += "<div class='card' style='text-align:center;color:#d33;'>遥控不存在</div>"
      self.app_send_page("编辑遥控", "管理", html)
      return
    end
    html += f"<div class='sect'>{webserver.html_escape(remote['name'])}</div>"
    html += "<form method='get' action='/app/rf/edit'>"
    html += f"<input type='hidden' name='id' value='{id}'>"
    html += f"<input type='hidden' name='save' value='1'>"
    html += "<div class='sect'>名称</div>"
    html += f"<div class='card'><input name='name' value='{webserver.html_escape(remote['name'])}' style='width:100%;border:none;font-size:14px;background:transparent;'></div>"
    html += "<div class='sect'>分组</div>"
    html += f"<div class='card'><input name='group' value='{webserver.html_escape(remote['group'])}' style='width:100%;border:none;font-size:14px;background:transparent;'></div>"
    html += "<div class='sect'>编码值</div>"
    html += f"<div class='card'><input name='value' type='number' value='{remote['value']}' style='width:100%;border:none;font-size:14px;background:transparent;'></div>"
    html += "<div class='sect'>位数</div>"
    html += f"<div class='card'><input name='bits' type='number' value='{remote['bits']}' style='width:100%;border:none;font-size:14px;background:transparent;'></div>"
    html += "<div class='sect'>协议号</div>"
    html += f"<div class='card'><input name='protocol' type='number' value='{remote['protocol']}' style='width:100%;border:none;font-size:14px;background:transparent;'></div>"
    html += "<div class='sect'>脉宽</div>"
    html += f"<div class='card'><input name='pulse_length' type='number' value='{remote['pulse_length']}' style='width:100%;border:none;font-size:14px;background:transparent;'></div>"
    html += "<div class='sect'>重复次数</div>"
    html += f"<div class='card'><input name='repeat' type='number' value='{remote['repeat']}' style='width:100%;border:none;font-size:14px;background:transparent;'></div>"
    html += "<div class='sect'>备注</div>"
    html += f"<div class='card'><input name='note' value='{webserver.html_escape(remote['note'])}' style='width:100%;border:none;font-size:14px;background:transparent;'></div>"
    html += "<button class='btn blue' type='submit'>保存</button>"
    html += "</form>"
    html += f"<a class='btn gray' href='/app/rf/view?id={id}'>测试发送</a>"
    html += f"<a class='btn gray' href='/app/api/rf/delete?id={id}'>删除遥控</a>"
    self.app_send_page("编辑遥控", "管理", html)
  end

  # ============ 遥控管理列表（替代 /rf）============
  def handle_app_rf_manage()
    import webserver
    import string
    var g = gateway
    var html = ""
    html += "<a href='/app/rf' style='text-decoration:none;color:#007aff;font-size:13px;'>‹ 返回首页</a>"
    html += "<div class='sect'>遥控管理</div>"
    html += "<a class='btn blue' href='/app/rf/record'>＋ 录制新遥控</a>"
    var search = ""
    if webserver.has_arg("search")
      search = webserver.arg("search")
    end
    html += "<form method='get' action='/app/rf/manage' style='margin:8px 0;'>"
    html += f"<div class='card' style='display:flex;gap:8px;'><input name='search' placeholder='搜索名称/分组' value='{webserver.html_escape(search)}' style='flex:1;border:none;font-size:14px;background:transparent;'><button type='submit'>🔍</button></div></form>"
    var count = 0
    for remote : g.remotes
      var matched = true
      if search != ""
        var lower = string.tolower(str(search))
        if string.find(string.tolower(str(remote["name"])), lower) < 0 && string.find(string.tolower(str(remote["group"])), lower) < 0
          matched = false
        end
      end
      if matched
        count += 1
        html += "<div class='card cell'>"
        html += f"<div class='ic'>{webserver.html_escape(remote.find('icon','🕹'))}</div>"
        html += f"<div class='tx'><div class='t1'>{webserver.html_escape(remote['name'])}</div>"
        html += f"<div class='t2'>P{remote['protocol']} · {remote['bits']}bit · {remote['group']}</div></div>"
        html += f"<a class='btn blue' style='padding:8px 12px;font-size:11px;margin:0;' href='/app/rf/view?id={remote['id']}'>发送</a>"
        html += f"<a class='btn gray' style='padding:8px 12px;font-size:11px;margin:0;' href='/app/rf/edit?id={remote['id']}'>✎</a></div>"
      end
    end
    if count == 0
      html += "<div class='card' style='text-align:center;color:#8e8e93;font-size:12px;'>暂无遥控</div>"
    end
    self.app_send_page("遥控管理", "管理", html)
  end

  # ============ 删除遥控 API ============
  def handle_app_api_rf_delete()
    import webserver
    var g = gateway
    var id = int(webserver.arg("id"))
    g.delete_remote(id)
    webserver.redirect("/app/rf/manage")
  end

  # ============ 门磁管理列表（替代 /door）============
  def handle_app_door_manage()
    import webserver
    var g = gateway
    var html = ""
    html += "<a href='/app/door' style='text-decoration:none;color:#007aff;font-size:13px;'>‹ 门磁状态</a>"
    html += "<div class='sect'>门磁管理</div>"
    html += "<a class='btn blue' href='/app/door/edit'>＋ 添加门磁</a>"
    if size(g.doors) == 0
      html += "<div class='card' style='text-align:center;color:#8e8e93;font-size:12px;'>暂无门磁</div>"
    else
      for door : g.doors
        var st = door["state"]
        var color = st == "OPEN" ? "#d33" : "#2e9e5b"
        html += "<div class='card cell'>"
        html += f"<div class='ic'>🚪</div>"
        html += f"<div class='tx'><div class='t1'>{webserver.html_escape(door['name'])}</div>"
        html += f"<div class='t2'>{webserver.html_escape(door['location'])} · {door['code']}</div></div>"
        html += f"<span style='font-size:12px;font-weight:700;color:{color};'>{st}</span>"
        html += f"<a class='btn gray' style='padding:8px 12px;font-size:11px;margin:0;' href='/app/door/edit?id={door['id']}'>✎</a></div>"
      end
    end
    self.app_send_page("门磁管理", "管理", html)
  end

  # ============ 门磁配对+编辑（替代 /door/edit）============
  def handle_app_door_edit()
    import webserver
    var g = gateway
    var html = ""
    var id_str = webserver.arg("id")
    if id_str == nil id_str = "0" end
    var id = int(id_str)
    var door = g.find_door(id)
    if id > 0
      html += "<a href='/app/door/manage' style='text-decoration:none;color:#007aff;font-size:13px;'>‹ 门磁管理</a>"
    else
      html += "<a href='/app/door/manage' style='text-decoration:none;color:#007aff;font-size:13px;'>‹ 门磁管理</a>"
    end

    # 配对学习模式
    if webserver.has_arg("learn")
      g.learn_mode = true
      g.learn_timeout = tasmota.millis() + 30000
      g.learn_result = nil
      cc1101_flush_rx()
      tasmota.remove_timer(g._TIMER_RECORD)
      tasmota.set_timer(30000, def()
        if g.learn_mode
          g.learn_mode = false
          g.learn_result = nil
        end
      end, g._TIMER_RECORD)
      html += "<div class='card' style='text-align:center;'>"
      html += "<div style='font-size:40px;'>🚪</div>"
      html += "<div style='font-size:14px;font-weight:600;margin-top:8px;'>配对中...</div>"
      html += "<div style='font-size:11px;color:#8e8e93;margin-top:4px;'>30秒内触发门磁</div>"
      html += "</div>"
      html += f"<a class='btn gray' href='/app/door/edit?id={id}'>取消</a>"
      html += "<script>"
      html += "var poll=setInterval(function(){"
      html += "var x=new XMLHttpRequest();"
      html += "x.open('GET','/app/api/rf/event',true);"
      html += "x.onreadystatechange=function(){"
      html += "if(x.readyState==4&&x.status==200&&x.responseText!=''){"
      html += "var d=JSON.parse(x.responseText);"
      html += "if(d.value){clearInterval(poll);"
      html += f"window.location.href='/app/door/edit?id={id}&code='+d.value+'&bits='+d.bits;"
      html += "}}};x.send();},500);"
      html += "setTimeout(function(){clearInterval(poll);},35000);"
      html += "</script>"
      self.app_send_page("配对门磁", "管理", html)
      return
    end

    # 保存
    if webserver.has_arg("save")
      var name = webserver.arg("name")
      var location = webserver.arg("location")
      var code = int(webserver.arg("code"))
      var bits = int(webserver.arg("bits"))
      var note = webserver.arg("note")
      if name == nil name = "" end
      if location == nil location = "" end
      if note == nil note = "" end
      if code == nil code = 0 end
      if bits == nil bits = 24 end
      if id > 0 && door != nil
        g.update_door(id, {"name": name, "location": location, "code": code, "bits": bits, "note": note})
      elif name != "" && code > 0
        g.add_door(name, location, code, bits, 1, note)
      end
      html += "<div class='card' style='text-align:center;color:#2e9e5b;font-weight:600;'>已保存</div>"
      html += "<script>setTimeout(function(){window.location.href='/app/door/manage';},1000);</script>"
      self.app_send_page("编辑门磁", "管理", html)
      return
    end

    # 显示编辑表单（新建或编辑）
    var learn_code = webserver.arg("code")
    if learn_code == nil learn_code = "0" end
    var learn_bits = webserver.arg("bits")
    if learn_bits == nil learn_bits = "24" end
    var title = (door == nil && id == 0) ? "添加门磁" : "编辑门磁"
    if door == nil && learn_code != "0"
      title = "已捕获信号"
    end
    html += f"<div class='sect'>{title}</div>"
    if door == nil && learn_code != "0"
      html += "<div class='card' style='font-size:12px;color:#666;'>"
      html += f"<div>编码: <b>{learn_code}</b></div>"
      html += f"<div>位数: {learn_bits}</div>"
      html += "</div>"
    end
    html += "<form method='get' action='/app/door/edit'>"
    if id > 0
      html += f"<input type='hidden' name='id' value='{id}'>"
    end
    html += "<input type='hidden' name='save' value='1'>"
    if door == nil
      html += f"<input type='hidden' name='code' value='{learn_code}'>"
      html += f"<input type='hidden' name='bits' value='{learn_bits}'>"
    else
      html += f"<input type='hidden' name='code' value='{door['code']}'>"
      html += f"<input type='hidden' name='bits' value='{door['bits']}'>"
    end
    var n_val = door != nil ? door["name"] : ""
    var l_val = door != nil ? door["location"] : ""
    var note_val = door != nil ? door["note"] : ""
    html += "<div class='sect'>名称</div>"
    html += f"<div class='card'><input name='name' value='{webserver.html_escape(n_val)}' placeholder='如：前门' style='width:100%;border:none;font-size:14px;background:transparent;' required></div>"
    html += "<div class='sect'>位置</div>"
    html += f"<div class='card'><input name='location' value='{webserver.html_escape(l_val)}' placeholder='如：正门' style='width:100%;border:none;font-size:14px;background:transparent;'></div>"
    html += "<div class='sect'>备注</div>"
    html += f"<div class='card'><input name='note' value='{webserver.html_escape(note_val)}' placeholder='可选' style='width:100%;border:none;font-size:14px;background:transparent;'></div>"
    html += "<button class='btn blue' type='submit'>保存</button>"
    html += "</form>"
    # 配对按钮：进入学习模式
    html += f"<a class='btn gray' href='/app/door/edit?learn=1&id={id}'>🎙 配对学习</a>"
    if id > 0
      html += f"<a class='btn gray' href='/app/api/door/delete?id={id}'>删除门磁</a>"
    end
    self.app_send_page("编辑门磁", "管理", html)
  end

  # ============ 删除门磁 API ============
  def handle_app_api_door_delete()
    import webserver
    var g = gateway
    var id = int(webserver.arg("id"))
    g.delete_door(id)
    webserver.redirect("/app/door/manage")
  end

  # ============ 联动规则（替代 /link）============
  def handle_app_link()
    import webserver
    var g = gateway
    var html = ""
    html += "<a href='/app/manage' style='text-decoration:none;color:#007aff;font-size:13px;'>‹ 管理</a>"
    html += "<div class='sect'>联动规则</div>"

    # 切换启用状态
    if webserver.has_arg("toggle")
      var id = int(webserver.arg("toggle"))
      for link : g.links
        if link["id"] == id
          link["enabled"] = !link["enabled"]
          g.save_links()
          break
        end
      end
    end

    # 保存新规则
    if webserver.has_arg("save")
      var door_id = int(webserver.arg("door_id"))
      var trigger = webserver.arg("trigger_state")
      var action_type = webserver.arg("action_type")
      if door_id == nil door_id = 0 end
      if trigger == nil trigger = "OPEN" end
      if action_type == "rf_send"
        var remote_id = int(webserver.arg("remote_id"))
        if remote_id == nil remote_id = 0 end
        g.add_link(door_id, trigger, "rf_send", {"remote_id": remote_id})
      elif action_type == "mqtt_publish"
        var topic = webserver.arg("mqtt_topic")
        var payload = webserver.arg("mqtt_payload")
        if topic == nil topic = "" end
        if payload == nil payload = "" end
        g.add_link(door_id, trigger, "mqtt_publish", {"topic": topic, "payload": payload})
      end
    end

    # 规则列表
    if size(g.links) == 0
      html += "<div class='card' style='text-align:center;color:#8e8e93;font-size:12px;'>暂无联动规则</div>"
    else
      for link : g.links
        var door_name = "?"
        var d = g.find_door(link["door_id"])
        if d != nil door_name = d["name"] end
        var action_desc = link["action_type"]
        if link["action_type"] == "rf_send"
          var r = g.find_remote(link["action_payload"]["remote_id"])
          if r != nil action_desc = "RF: " + r["name"] end
        elif link["action_type"] == "mqtt_publish"
          action_desc = "MQTT: " + link["action_payload"].find("topic", "")
        end
        var en_label = link["enabled"] ? "禁用" : "启用"
        var st_color = link["enabled"] ? "#2e9e5b" : "#8e8e93"
        html += "<div class='card cell'>"
        html += f"<div class='ic'>🔗</div>"
        html += f"<div class='tx'><div class='t1'>{webserver.html_escape(door_name)} {link['trigger_state']}</div>"
        html += f"<div class='t2'>{webserver.html_escape(action_desc)}</div></div>"
        html += f"<span style='font-size:11px;font-weight:600;color:{st_color};'>{link['enabled'] ? 'ON' : 'OFF'}</span>"
        html += f"<a class='btn gray' style='padding:8px 12px;font-size:11px;margin:0;' href='/app/link?toggle={link['id']}'>{en_label}</a></div>"
      end
    end

    # 添加规则表单
    if size(g.doors) > 0 && size(g.remotes) > 0
      html += "<div class='sect'>添加规则</div>"
      html += "<form method='get' action='/app/link'>"
      html += "<input type='hidden' name='save' value='1'>"
      html += "<div class='sect'>门磁</div>"
      html += "<div class='card'><select name='door_id' style='width:100%;border:none;font-size:14px;background:transparent;'>"
      for door : g.doors
        html += f"<option value='{door['id']}'>{webserver.html_escape(door['name'])}</option>"
      end
      html += "</select></div>"
      html += "<div class='sect'>触发</div>"
      html += "<div class='card'><select name='trigger_state' style='width:100%;border:none;font-size:14px;background:transparent;'>"
      html += "<option value='OPEN'>开门</option><option value='CLOSE'>关门</option></select></div>"
      html += "<div class='sect'>动作类型</div>"
      html += "<div class='card'><select name='action_type' id='action_type' onchange='document.getElementById(\"rf_opts\").style.display=this.value==\"rf_send\"?\"block\":\"none\";document.getElementById(\"mqtt_opts\").style.display=this.value==\"mqtt_publish\"?\"block\":\"none\";' style='width:100%;border:none;font-size:14px;background:transparent;'>"
      html += "<option value='rf_send'>发送遥控</option><option value='mqtt_publish'>发布MQTT</option></select></div>"
      html += "<div id='rf_opts'><div class='sect'>遥控</div>"
      html += "<div class='card'><select name='remote_id' style='width:100%;border:none;font-size:14px;background:transparent;'>"
      for remote : g.remotes
        html += f"<option value='{remote['id']}'>{webserver.html_escape(remote['name'])}</option>"
      end
      html += "</select></div></div>"
      html += "<div id='mqtt_opts' style='display:none;'><div class='sect'>MQTT主题</div>"
      html += "<div class='card'><input name='mqtt_topic' placeholder='tele/device/trigger' style='width:100%;border:none;font-size:14px;background:transparent;'></div>"
      html += "<div class='sect'>MQTT载荷</div>"
      html += "<div class='card'><input name='mqtt_payload' placeholder='ON' style='width:100%;border:none;font-size:14px;background:transparent;'></div></div>"
      html += "<button class='btn blue' type='submit'>添加规则</button>"
      html += "</form>"
    else
      html += "<div class='card' style='color:#d33;font-size:12px;'>需先添加至少一个门磁和一个遥控</div>"
    end
    self.app_send_page("联动规则", "管理", html)
  end

  # ============ 虚拟设备编辑（新增）============
  def handle_app_vdev_edit()
    import webserver
    var g = gateway
    var html = ""
    html += "<a href='/app/vdev' style='text-decoration:none;color:#007aff;font-size:13px;'>‹ 虚拟设备</a>"
    var name = webserver.arg("name")

    # 保存
    if webserver.has_arg("save")
      var new_name = webserver.arg("new_name")
      var on_seq = webserver.arg("on_sequence")
      var off_seq = webserver.arg("off_sequence")
      if new_name == nil new_name = "" end
      if on_seq == nil on_seq = "" end
      if off_seq == nil off_seq = "" end
      var found = false
      for vd : g.virtual_devices
        if vd["name"] == name
          vd["name"] = new_name
          vd["on_sequence"] = on_seq
          vd["off_sequence"] = off_seq
          found = true
          break
        end
      end
      if !found && new_name != ""
        g.virtual_devices.push({"name": new_name, "on_sequence": on_seq, "off_sequence": off_seq, "state": "OFF"})
      end
      g.save_virtual_devices()
      html += "<div class='card' style='text-align:center;color:#2e9e5b;font-weight:600;'>已保存</div>"
      html += "<script>setTimeout(function(){window.location.href='/app/vdev';},1000);</script>"
      self.app_send_page("编辑虚拟设备", "管理", html)
      return
    end

    var vd = nil
    for v : g.virtual_devices
      if v["name"] == name
        vd = v
        break
      end
    end
    var title = (vd == nil && name == nil) ? "新建虚拟设备" : "编辑虚拟设备"
    html += f"<div class='sect'>{title}</div>"
    html += "<form method='get' action='/app/vdev/edit'>"
    html += "<input type='hidden' name='save' value='1'>"
    if vd != nil
      html += f"<input type='hidden' name='name' value='{webserver.html_escape(vd['name'])}'>"
    end
    html += "<div class='sect'>名称</div>"
    var n_val = vd != nil ? vd["name"] : ""
    html += f"<div class='card'><input name='new_name' value='{webserver.html_escape(n_val)}' placeholder='如：车库' style='width:100%;border:none;font-size:14px;background:transparent;' required></div>"
    html += "<div class='sect'>开启序列</div>"
    var on_val = vd != nil ? vd["on_sequence"] : ""
    html += "<div class='card'><select name='on_sequence' style='width:100%;border:none;font-size:14px;background:transparent;'><option value=''>无</option>"
    for seq : g.sequences
      var sel = (on_val == seq["name"]) ? " selected" : ""
      html += f"<option value='{seq['name']}'{sel}>{webserver.html_escape(seq['name'])}</option>"
    end
    html += "</select></div>"
    html += "<div class='sect'>关闭序列</div>"
    var off_val = vd != nil ? vd["off_sequence"] : ""
    html += "<div class='card'><select name='off_sequence' style='width:100%;border:none;font-size:14px;background:transparent;'><option value=''>无</option>"
    for seq : g.sequences
      var sel = (off_val == seq["name"]) ? " selected" : ""
      html += f"<option value='{seq['name']}'{sel}>{webserver.html_escape(seq['name'])}</option>"
    end
    html += "</select></div>"
    html += "<button class='btn blue' type='submit'>保存</button>"
    html += "</form>"
    self.app_send_page("编辑虚拟设备", "管理", html)
  end

  def web_add_main_button()
    import webserver
    # 在 Tasmota 原生主页添加「433 Gateway App」独立按钮，跳转 APP UI
    webserver.content_send("<p><button onclick='window.location.href=\"/app/rf\";'>433 Gateway App</button></p>")
  end

  def web_add_handler()
    import webserver
    webserver.on("/app", / -> self.handle_app_page_root())
    webserver.on("/app/rf", / -> self.handle_app_rf_page())
    webserver.on("/app/rf/view", / -> self.handle_app_rf_view_page())
    webserver.on("/app/rf/manage", / -> self.handle_app_rf_manage())
    webserver.on("/app/rf/record", / -> self.handle_app_rf_record())
    webserver.on("/app/rf/edit", / -> self.handle_app_rf_edit())
    webserver.on("/app/seq", / -> self.handle_app_seq_page())
    webserver.on("/app/seq/edit", / -> self.handle_app_seq_edit_page())
    webserver.on("/app/door", / -> self.handle_app_door_page())
    webserver.on("/app/door/manage", / -> self.handle_app_door_manage())
    webserver.on("/app/door/edit", / -> self.handle_app_door_edit())
    webserver.on("/app/event", / -> self.handle_app_event_page())
    webserver.on("/app/manage", / -> self.handle_app_manage_page())
    webserver.on("/app/vdev", / -> self.handle_app_vdev_page())
    webserver.on("/app/vdev/edit", / -> self.handle_app_vdev_edit())
    webserver.on("/app/link", / -> self.handle_app_link())
    webserver.on("/app/api/send", / -> self.handle_app_api_send())
    webserver.on("/app/api/seqrun", / -> self.handle_app_api_seqrun())
    webserver.on("/app/api/vdon", / -> self.handle_app_api_vdon())
    webserver.on("/app/api/rf/event", / -> self.handle_app_api_rf_event())
    webserver.on("/app/api/rf/delete", / -> self.handle_app_api_rf_delete())
    webserver.on("/app/api/door/delete", / -> self.handle_app_api_door_delete())
  end
end

var webapp = Cc1101WebApp()
tasmota.add_driver(webapp)

return webapp
