#@ solidify:Cc1101WebApp

# 433 Gateway App 风格 WebUI（HomeKit 风格）
# 依赖 cc1101_gateway.be 的全局 gateway 实例
class Cc1101WebApp
  def init()
  end

  def app_page(title, active_tab, content_html)
    import webserver
    var html = ""
    html += "<style>"
    html += "body{background:#f7f7f9;font-family:-apple-system,sans-serif;margin:0;color:#000;}"
    html += ".app-hd{background:#f7f7f9;padding:14px 16px 6px;display:flex;align-items:center;justify-content:space-between;}"
    html += ".app-hd h1{font-size:19px;margin:0;}"
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
    html += ".app-tab{position:fixed;bottom:0;left:0;right:0;background:rgba(249,249,251,.97);border-top:1px solid #e5e5ea;display:flex;}"
    html += ".app-tab a{flex:1;text-align:center;padding:9px 0;font-size:9.5px;color:#8e8e93;text-decoration:none;}"
    html += ".app-tab a.on{color:#007aff;font-weight:700;}"
    html += "</style>"
    html += "<div class='app-hd'><h1>" + title + "</h1><a href='/app/manage'>⚙</a></div>"
    html += "<div class='app-body'>" + content_html + "</div>"
    var tabs = [["/app/rf","遥控"],["/app/seq","场景"],["/app/door","门磁"],["/app/event","事件"],["/app/manage","管理"]]
    html += "<div class='app-tab'>"
    for t : tabs
      html += "<a href='" + t[0] + "'" + (t[1] == active_tab ? " class='on'" : "") + ">" + t[1] + "</a>"
    end
    html += "</div>"
    webserver.content_send(html)
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
    webserver.content_start("433 Gateway")
    webserver.content_send_style()
    self.app_page("433 Gateway", "遥控", html)
    webserver.content_stop()
  end

  def handle_app_rf_view_page()
    import webserver
    var g = gateway
    var id = int(webserver.arg("id"))
    var remote = g.find_remote(id)
    if remote == nil
      webserver.content_start("遥控")
      webserver.content_send_style()
      self.app_page("遥控", "遥控", "<div class='card'>遥控不存在</div>")
      webserver.content_stop()
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
    html += "<a class='btn gray' href='/rf/edit?id=" + str(remote["id"]) + "'>＋ 管理按钮</a>"
    webserver.content_start("遥控")
    webserver.content_send_style()
    self.app_page(webserver.html_escape(remote["name"]), "遥控", html)
    webserver.content_stop()
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
    webserver.content_start("场景")
    webserver.content_send_style()
    self.app_page("场景", "场景", html)
    webserver.content_stop()
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
    webserver.content_start("编辑场景")
    webserver.content_send_style()
    self.app_page("编辑场景", "场景", html)
    webserver.content_stop()
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
    html += "<a class='btn blue' href='/rf/door/add'>＋ 添加门磁</a>"
    webserver.content_start("门磁")
    webserver.content_send_style()
    self.app_page("门磁", "门磁", html)
    webserver.content_stop()
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
    webserver.content_start("事件")
    webserver.content_send_style()
    self.app_page("事件", "事件", html)
    webserver.content_stop()
  end

  def handle_app_manage_page()
    import webserver
    var html = ""
    html += "<div class='sect'>433 管理</div>"
    html += "<a class='btn gray' href='/rf'>🕹 遥控管理（录制/编辑）</a>"
    html += "<a class='btn gray' href='/door'>🚪 门磁管理</a>"
    html += "<a class='btn gray' href='/link'>🔗 联动规则</a>"
    html += "<a class='btn gray' href='/app/vdev'>📡 虚拟设备</a>"
    html += "<a class='btn gray' href='/rf/record'>🎙 录制遥控</a>"
    html += "<div class='sect'>系统</div>"
    html += "<a class='btn gray' href='/cs'>🔐 Tasmota 系统设置</a>"
    webserver.content_start("管理")
    webserver.content_send_style()
    self.app_page("管理", "管理", html)
    webserver.content_stop()
  end

  def handle_app_vdev_page()
    import webserver
    var g = gateway
    var html = ""
    html += "<div class='sect'>虚拟设备</div>"
    if size(g.virtual_devices) > 0
      for vd : g.virtual_devices
        html += "<div class='card'>"
        html += f"<div style='font-size:14px;font-weight:600;'>{webserver.html_escape(vd['name'])}</div>"
        html += f"<div style='font-size:11px;color:#8e8e93;'>开:{webserver.html_escape(vd['on_sequence'])} · 关:{webserver.html_escape(vd['off_sequence'])} · 状态:{vd['state']}</div>"
        html += "</div>"
      end
    else
      html += "<div class='card' style='color:#8e8e93;font-size:12px;'>暂无虚拟设备</div>"
    end
    html += "<div class='card' style='color:#666;font-size:11px;'>虚拟设备在 HA 中显示为开关，控制命令触发本地序列。</div>"
    webserver.content_start("虚拟设备")
    webserver.content_send_style()
    self.app_page("虚拟设备", "管理", html)
    webserver.content_stop()
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

  def web_add_handler()
    import webserver
    webserver.on("/", / -> self.handle_app_page_root())
    webserver.on("/app", / -> self.handle_app_page_root())
    webserver.on("/app/rf", / -> self.handle_app_rf_page())
    webserver.on("/app/rf/view", / -> self.handle_app_rf_view_page())
    webserver.on("/app/seq", / -> self.handle_app_seq_page())
    webserver.on("/app/seq/edit", / -> self.handle_app_seq_edit_page())
    webserver.on("/app/door", / -> self.handle_app_door_page())
    webserver.on("/app/event", / -> self.handle_app_event_page())
    webserver.on("/app/manage", / -> self.handle_app_manage_page())
    webserver.on("/app/vdev", / -> self.handle_app_vdev_page())
    webserver.on("/app/api/send", / -> self.handle_app_api_send())
    webserver.on("/app/api/seqrun", / -> self.handle_app_api_seqrun())
    webserver.on("/app/api/vdon", / -> self.handle_app_api_vdon())
  end
end

var webapp = Cc1101WebApp()
tasmota.add_driver(webapp)

return webapp
