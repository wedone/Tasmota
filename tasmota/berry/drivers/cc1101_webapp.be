#@ solidify:Cc1101WebApp

# 433 Gateway App 风格 WebUI（HomeKit 风格）
# 依赖 cc1101_gateway.be 的全局 gateway 实例
class Cc1101WebApp
  def init()
  end

  def ic(name)
    var path = ""
    if name == "gear"
      path = "M19.14 12.94c.04-.3.06-.61.06-.94 0-.32-.02-.64-.07-.94l2.03-1.58c.18-.14.23-.41.12-.61l-1.92-3.32c-.12-.22-.37-.29-.59-.22l-2.39.96c-.5-.38-1.03-.7-1.62-.94l-.36-2.54c-.04-.24-.24-.41-.48-.41h-3.84c-.24 0-.43.17-.47.41l-.36 2.54c-.59.24-1.13.57-1.62.94l-2.39-.96c-.22-.08-.47 0-.59.22L2.74 8.87c-.12.21-.08.47.12.61l2.03 1.58c-.05.31-.09.63-.09.94s.02.64.07.94l-2.03 1.58c-.18.14-.23.41-.12.61l1.92 3.32c.12.22.37.29.59.22l2.39-.96c.5.38 1.03.7 1.62.94l.36 2.54c.05.24.24.41.48.41h3.84c.24 0 .44-.17.47-.41l.36-2.54c.59-.24 1.13-.56 1.62-.94l2.39.96c.22.08.47 0 .59-.22l1.92-3.32c.12-.22.07-.47-.12-.61l-2.01-1.58zM12 15.6c-1.98 0-3.6-1.62-3.6-3.6s1.62-3.6 3.6-3.6 3.6 1.62 3.6 3.6-1.62 3.6-3.6 3.6z"
    elif name == "back"
      path = "M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z"
    elif name == "chev"
      path = "M10 6L8.59 7.41 13.17 12l-4.58 4.59L10 18l6-6z"
    elif name == "remote"
      path = "M12 1c-3 0-5.73 1.16-7.78 3.05l1.42 1.42A8.97 8.97 0 0 1 12 3c2.49 0 4.73.99 6.36 2.47l1.42-1.42A8.97 8.97 0 0 0 12 1zm4.24 8.1a5 5 0 0 0-8.48 0L9.2 10.5a2.97 2.97 0 0 1 5.6 0l1.44-1.4zM12 10a2 2 0 1 0 0 4 2 2 0 0 0 0-4zm-7 2a7 7 0 0 0 2.05 4.95l1.42-1.42A5 5 0 0 1 7 12c0-1.28.48-2.5 1.35-3.4L6.93 7.18A7 7 0 0 0 5 12zm14 0a7 7 0 0 0-2.05-4.95l-1.42 1.42A5 5 0 0 1 19 12a5 5 0 0 1-1.35 3.4l1.42 1.42A7 7 0 0 0 21 12z"
    elif name == "play"
      path = "M8 5v14l11-7z"
    elif name == "door"
      path = "M6 2h8a2 2 0 0 1 2 2v2h2a2 2 0 0 1 2 2v14l-6-2-6 2V4a2 2 0 0 1 2-2zm8 4V4H6v16l4-1.33V6h4zm-4 4a1.5 1.5 0 1 0 0 3 1.5 1.5 0 0 0 0-3z"
    elif name == "event"
      path = "M13 3a9 9 0 0 0-9 9H1l3.89 3.89.07.14L9 12H6a7 7 0 1 1 2.05 4.95l-1.42 1.42A9 9 0 1 0 13 3zm-1 5v5l4.28 2.54.72-1.21-3.5-2.08V8H12z"
    elif name == "antenna"
      path = "M12 5a9 9 0 0 0-6.36 2.64l1.42 1.42A7 7 0 0 1 12 7c1.94 0 3.7.79 4.95 2.05l1.42-1.42A9 9 0 0 0 12 5zm0 4a5 5 0 0 0-3.54 1.46l1.42 1.42A3 3 0 0 1 12 11c.83 0 1.58.33 2.12.88l1.42-1.42A5 5 0 0 0 12 9zm-4.8 8.2L12 22l4.8-4.8a6.78 6.78 0 0 0-9.6 0zM12 11a1 1 0 1 1 0 2 1 1 0 0 1 0-2z"
    elif name == "plus"
      path = "M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"
    elif name == "power"
      path = "M13 3h-2v10h2V3zm4.83 2.17l-1.42 1.42A6.92 6.92 0 0 1 19 12c0 3.87-3.13 7-7 7A6.995 6.995 0 0 1 7.58 6.58L6.17 5.17A8.932 8.932 0 0 0 3 12a9 9 0 0 0 18 0c0-2.62-1.12-4.97-2.17-6.83z"
    elif name == "light"
      path = "M12 2C8.13 2 5 5.13 5 9c0 2.38 1.19 4.47 3 5.74V17c0 .55.45 1 1 1h6c.55 0 1-.45 1-1v-2.26c1.81-1.27 3-3.36 3-5.74 0-3.87-3.13-7-7-7zM9 21c0 .55.45 1 1 1h4c.55 0 1-.45 1-1v-1H9v1z"
    elif name == "lock"
      path = "M18 8h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zm-6 9c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zM9 8V6c0-1.66 1.34-3 3-3s3 1.34 3 3v2H9z"
    elif name == "star"
      path = "M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"
    end
    return "<svg viewBox='0 0 24 24' xmlns='http://www.w3.org/2000/svg'><path d='" + path + "' fill='currentColor'/></svg>"
  end

  def icon_html(val)
    import webserver
    var keys = ["gear","back","chev","remote","play","door","event","antenna","plus","power","light","lock","star"]
    var i = 0
    while i < size(keys)
      if keys[i] == val
        return self.ic(val)
      end
      i += 1
    end
    return webserver.html_escape(val)
  end

  def icon_picker_html(selected)
    var opts = [["remote","遥控"],["antenna","信号"],["power","电源"],["light","灯光"],["door","门窗"],["play","播放"],["event","事件"],["gear","设置"],["lock","锁定"],["star","收藏"]]
    var html = "<div class='iconpick'>"
    for o : opts
      var key = o[0]
      var cls = ""
      var checked = ""
      if key == selected
        cls = " on"
        checked = " checked"
      end
      html += "<label class='ipick" + cls + "'><input type='radio' name='icon' value='" + key + "'" + checked + "><span class='ic'>" + self.ic(key) + "</span><span class='nm'>" + o[1] + "</span></label>"
    end
    html += "</div>"
    return html
  end

  def icon_key(val)
    var keys = ["gear","back","chev","remote","play","door","event","antenna","plus","power","light","lock","star"]
    var i = 0
    while i < size(keys)
      if keys[i] == val
        return val
      end
      i += 1
    end
    return "remote"
  end

  def icon_picker_js()
    return "document.querySelectorAll('.ipick').forEach(function(l){l.addEventListener('click',function(){document.querySelectorAll('.ipick').forEach(function(x){x.classList.remove('on')});l.classList.add('on')})});"
  end

  def app_page(title, active_tab, content_html)
    var html = "<!DOCTYPE html><html><head><meta charset='utf-8'>"
    html += "<meta name='viewport' content='width=device-width,initial-scale=1,viewport-fit=cover'>"
    html += "<title>" + title + "</title>"
    html += "<style>"
    html += "html,body{background:var(--bg);font-family:-apple-system,BlinkMacSystemFont,'SF Pro Text','PingFang SC',system-ui,sans-serif;margin:0;padding:0;color:var(--label);-webkit-font-smoothing:antialiased;}"
    html += "a{outline:none;} *{-webkit-tap-highlight-color:transparent;box-sizing:border-box;}"
    html += ":root{--bg:#f2f2f7;--card:#fff;--fill:#e5e5ea;--sep:rgba(60,60,67,.29);--label:#000;--secondary:#8e8e93;--blue:#007aff;--green:#34c759;--red:#ff3b30;}"
    html += "@media (prefers-color-scheme:dark){:root{--bg:#000;--card:#1c1c1e;--fill:#2c2c2e;--sep:rgba(255,255,255,.2);--label:#fff;--secondary:#98989f;--blue:#0a84ff;--green:#30d158;--red:#ff453a;}}"
    html += ".app-hd{padding:18px 20px 6px;display:flex;align-items:center;justify-content:space-between;}"
    html += ".app-hd h1{font-size:28px;margin:0;font-weight:700;letter-spacing:-.02em;}"
    html += ".app-hd a{text-decoration:none;color:var(--blue);padding:6px;display:flex;} .app-hd a svg{width:24px;height:24px;}"
    html += ".app-body{padding:6px 20px calc(86px + env(safe-area-inset-bottom,0px));}"
    html += ".sect{font-size:13px;color:var(--secondary);font-weight:600;margin:20px 0 8px;letter-spacing:.02em;}"
    html += ".grid3{display:grid;grid-template-columns:repeat(3,1fr);gap:14px;}"
    html += ".grid4{display:grid;grid-template-columns:repeat(4,1fr);gap:12px;}"
    html += ".hkbtn{background:var(--card);border-radius:20px;text-align:center;padding:22px 6px;text-decoration:none;color:var(--label);display:block;transition:transform .12s ease,opacity .12s ease;} .hkbtn:active{transform:scale(.96);opacity:.85;}"
    html += ".hkbtn .ic{font-size:34px;line-height:1;color:var(--blue);} .hkbtn .ic svg{width:34px;height:34px;} .hkbtn .nm{font-size:12px;margin-top:8px;font-weight:500;color:var(--secondary);}"
    html += ".sqcell{text-align:center;text-decoration:none;color:var(--label);display:block;} .sqcell:active{opacity:.6;}"
    html += ".sqbtn{width:64px;height:64px;margin:0 auto;background:var(--fill);border-radius:18px;display:flex;align-items:center;justify-content:center;color:var(--blue);font-size:30px;line-height:1;} .sqbtn svg{width:32px;height:32px;}"
    html += ".sqlbl{font-size:12px;color:var(--secondary);margin-top:6px;}"
    html += ".card{background:var(--card);border-radius:14px;padding:10px 14px;margin-bottom:14px;}"
    html += ".cell{display:flex;align-items:center;gap:12px;} .cell:active{background:var(--fill);}"
    html += ".cell .ic{width:38px;height:38px;border-radius:11px;background:var(--fill);display:flex;align-items:center;justify-content:center;color:var(--blue);flex:none;font-size:18px;} .cell .ic svg{width:22px;height:22px;}"
    html += ".cell .tx{flex:1;} .cell .t1{font-size:16px;} .cell .t2{font-size:13px;color:var(--secondary);margin-top:2px;}"
    html += ".btn{display:block;text-align:center;padding:14px;border-radius:12px;font-size:16px;font-weight:500;text-decoration:none;margin-bottom:10px;} .btn:active{opacity:.7;}"
    html += ".btn.blue{background:var(--blue);color:#fff;} .btn.gray{background:var(--fill);color:var(--blue);}"
    html += ".list{background:var(--card);border-radius:14px;overflow:hidden;margin-bottom:14px;}"
    html += ".row{display:flex;align-items:center;gap:14px;padding:13px 16px;text-decoration:none;color:var(--label);} .row:active{background:var(--fill);} .row + .row{border-top:1px solid var(--sep);}"
    html += ".row .rix{width:32px;height:32px;border-radius:8px;display:flex;align-items:center;justify-content:center;color:#fff;flex:none;} .row .rix svg{width:19px;height:19px;}"
    html += ".row .rt{flex:1;font-size:16px;} .row .chv{color:var(--secondary);font-size:15px;display:flex;} .row .chv svg{width:20px;height:20px;}"
    html += ".app-tab{position:fixed;bottom:0;left:0;right:0;background:var(--card);border-top:1px solid var(--sep);display:flex;z-index:9;padding-bottom:env(safe-area-inset-bottom,0px);}"
    html += ".app-tab a{flex:1;text-align:center;padding:5px 0 8px;font-size:10px;color:var(--secondary);text-decoration:none;display:flex;flex-direction:column;align-items:center;gap:2px;} .app-tab a:active{opacity:.6;}"
    html += ".app-tab a svg{width:24px;height:24px;} .app-tab a.on{color:var(--blue);font-weight:600;}"
    html += ".iconpick{display:grid;grid-template-columns:repeat(4,1fr);gap:10px;}"
    html += ".ipick{display:flex;flex-direction:column;align-items:center;gap:5px;padding:12px 4px;border-radius:12px;background:var(--fill);color:var(--blue);cursor:pointer;border:2px solid transparent;} .ipick input{display:none;} .ipick.on{background:var(--card);border-color:var(--blue);}"
    html += ".ipick .ic{width:30px;height:30px;display:flex;align-items:center;justify-content:center;font-size:24px;} .ipick .ic svg{width:28px;height:28px;} .ipick .nm{font-size:11px;color:var(--secondary);}"
    html += "</style>"
    html += "</head><body>"
    html += "<div class='app-hd'><h1>" + title + "</h1><a href='/app/manage'>" + self.ic("gear") + "</a></div>"
    html += "<div class='app-body'>" + content_html + "</div>"
    var tabs = [["/app/rf","遥控","remote"],["/app/seq","场景","play"],["/app/door","门磁","door"],["/app/event","事件","event"],["/app/manage","管理","gear"]]
    html += "<div class='app-tab'>"
    for t : tabs
      html += "<a href='" + t[0] + "'" + (t[1] == active_tab ? " class='on'" : "") + ">" + self.ic(t[2]) + "<span>" + t[1] + "</span></a>"
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
        var bg = st == "OPEN" ? "var(--red)" : "var(--green)"
        var txt = st == "OPEN" ? "开启" : "已关"
        html += f"<div class='hkbtn' style='flex:1;background:{bg};color:#fff;'><div class='ic' style='color:#fff;'>{self.ic('door')}</div><div class='nm' style='color:#fff;'>{webserver.html_escape(door['name'])} · {txt}</div></div>"
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
        html += f"<div class='ic'>{self.icon_html(remote.find('icon','remote'))}</div>"
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
        var vst = vd.find("state","OFF") == "ON"
        var vtxt = vst ? "ON" : "OFF"
        var vbg = vst ? "var(--green)" : "var(--card)"
        var vfg = vst ? "#fff" : "var(--label)"
        html += f"<a class='hkbtn' style='background:{vbg};color:{vfg};' href='/app/api/vdtog?name={vd['name']}'><div class='ic' style='color:{vfg};'>{self.ic('antenna')}</div><div class='nm' style='color:{vfg};'>{webserver.html_escape(vd['name'])}<br>{vtxt}</div></a>"
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
      html += f"<div class='sqbtn'>{self.icon_html(remote.find('icon','remote'))}</div><div class='sqlbl'>{webserver.html_escape(remote['name'])}</div></a>"
    else
      for b : btns
        html += f"<a class='sqcell' href='/app/api/send?rid={remote['id']}&bid={b['id']}'>"
        html += f"<div class='sqbtn'>{self.icon_html(b.find('icon','remote'))}</div><div class='sqlbl'>{webserver.html_escape(b['name'])}</div></a>"
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
        html += f"<div class='ic'>{self.ic('play')}</div><div class='tx'><div class='t1'>{webserver.html_escape(seq['name'])}</div><div class='t2'>{n} 步</div></div>"
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
      if seqname == nil || seqname == "" seqname = "新场景" end
      g._upsert_sequence(seqname, steps)
      if name != "new" && name != seqname
        g._delete_sequence(name)
      end
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
    var edit_name = ""
    if name != "new"
      edit_name = name
    end
    var html = ""
    html += "<a href='/app/seq' style='text-decoration:none;color:#007aff;font-size:13px;'>‹ 场景</a>"
    html += "<div class='sect'>" + webserver.html_escape(name == "new" ? "新建场景" : name) + "</div>"
    html += "<div class='sect'>场景名称</div>"
    html += "<div class='card'><input id='seqname' value='" + webserver.html_escape(edit_name) + "' placeholder='输入场景名称' style='width:100%;border:none;font-size:16px;background:transparent;'></div>"
    html += "<div class='sect'>动作序列</div>"
    html += "<div class='card'><div id='steps'></div></div>"
    html += "<div class='card' style='display:flex;gap:8px;align-items:center;'><input id='delayms' type='number' value='1000' style='flex:1;border:none;font-size:14px;background:transparent;'><button class='btn gray' onclick='addDelay()' style='margin:0;padding:8px 12px;font-size:13px;'>＋ 延时</button></div>"
    html += "<div class='sect'>添加发送遥控</div>"
    html += "<div class='grid3' id='remotes'></div>"
    if size(g.remotes) == 0
      html += "<div class='card' style='color:#8e8e93;font-size:12px;'>暂无遥控，请先录制遥控</div>"
    end
    html += "<button class='btn blue' onclick='saveSeq()'>保存</button>"
    var remotes = []
    for r : g.remotes
      remotes.push({"id": r["id"], "name": r["name"], "icon": self.icon_html(r.find("icon", "remote"))})
    end
    html += "<script>var STEPS=" + (seq != nil ? json.dump(seq["steps"]) : "[]") + ";"
    html += "var REMOTES=" + json.dump(remotes) + ";"
    html += "function rname(id){var r=REMOTES.find(function(x){return x.id==id});return r?r.name:('遥控#'+id)}"
    html += "function render(){var h='';STEPS.forEach(function(s,i){if(s.type=='send'){h+='<div style=\"padding:6px 0;border-bottom:1px solid #f2f2f7;display:flex;align-items:center;\"><span style=\"flex:1;\">📡 '+rname(s.remote_id)+(s.button_id!==undefined?' ·按钮'+s.button_id:'')+'</span><span onclick=\"STEPS.splice('+i+',1);render()\" style=\"color:var(--red);padding:4px;\">✕</span></div>'}else{h+='<div style=\"padding:6px 0;border-bottom:1px solid #f2f2f7;display:flex;align-items:center;\"><span style=\"flex:1;\">⏱ <input type=\"number\" value=\"'+s.ms+'\" onchange=\"STEPS['+i+'].ms=parseInt(this.value)||1000\" style=\"width:110px;border:1px solid #e5e5ea;border-radius:8px;padding:4px 6px;font-size:13px;background:transparent;\"> ms</span><span onclick=\"STEPS.splice('+i+',1);render()\" style=\"color:var(--red);padding:4px;\">✕</span></div>'}});document.getElementById('steps').innerHTML=h}"
    html += "function addSend(rid){STEPS.push({type:'send',remote_id:rid});render()}"
    html += "function addDelay(){var ms=parseInt(document.getElementById('delayms').value)||1000;STEPS.push({type:'delay',ms:ms});render()}"
    html += "function saveSeq(){location.href='/app/seq/edit?save=1&seqname='+encodeURIComponent(document.getElementById('seqname').value||'新场景')+'&steps='+encodeURIComponent(JSON.stringify(STEPS));}"
    html += "render();"
    html += "var rh='';REMOTES.forEach(function(r){rh+='<a class=\"hkbtn\" style=\"padding:10px 4px;\" onclick=\"addSend('+r.id+')\"><div class=\"ic\">'+(r.icon||'🕹')+'</div><div class=\"nm\">'+r.name+'</div></a>'});document.getElementById('remotes').innerHTML=rh;"
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
        var color = st == "OPEN" ? "var(--red)" : "var(--green)"
        var txt = st == "OPEN" ? "开启" : "已关"
        html += "<div class='card cell'>"
        html += f"<div class='ic'>{self.ic('door')}</div><div class='tx'><div class='t1'>{webserver.html_escape(door['name'])}</div><div class='t2'>最后变更 {door.find('last_event_at','-')}</div></div>"
        html += f"<span style='font-size:15px;font-weight:600;color:{color};'>{txt}</span></div>"
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
    html += "<div class='list'>"
    html += "<a class='row' href='/app/rf/manage'><span class='rix' style='background:#007aff;'>" + self.ic("remote") + "</span><span class='rt'>遥控管理（录制/编辑）</span><span class='chv'>" + self.ic("chev") + "</span></a>"
    html += "<a class='row' href='/app/door/manage'><span class='rix' style='background:#34c759;'>" + self.ic("door") + "</span><span class='rt'>门磁管理</span><span class='chv'>" + self.ic("chev") + "</span></a>"
    html += "<a class='row' href='/app/link'><span class='rix' style='background:#ff9500;'>" + self.ic("antenna") + "</span><span class='rt'>联动规则</span><span class='chv'>" + self.ic("chev") + "</span></a>"
    html += "<a class='row' href='/app/vdev'><span class='rix' style='background:#af52de;'>" + self.ic("antenna") + "</span><span class='rt'>虚拟设备</span><span class='chv'>" + self.ic("chev") + "</span></a>"
    html += "<a class='row' href='/app/rf/record'><span class='rix' style='background:#ff2d55;'>" + self.ic("plus") + "</span><span class='rt'>录制遥控</span><span class='chv'>" + self.ic("chev") + "</span></a>"
    html += "</div>"
    html += "<div class='sect'>系统</div>"
    html += "<div class='list'>"
    html += "<a class='row' href='/mm'><span class='rix' style='background:#8e8e93;'>" + self.ic("gear") + "</span><span class='rt'>Tasmota 主菜单</span><span class='chv'>" + self.ic("chev") + "</span></a>"
    html += "</div>"
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
        html += f"<div class='ic'>{self.ic('antenna')}</div><div class='tx'><div class='t1'>{webserver.html_escape(vd['name'])}</div>"
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
      var icon = webserver.arg("icon")
      if value == nil value = 0 end
      if bits == nil bits = 0 end
      if protocol == nil protocol = 0 end
      if repeat == nil repeat = 10 end
      if note == nil note = "" end
      if group == nil group = "" end
      if icon == nil || icon == "" icon = "remote" end
      if name != "" && value > 0
        g.add_remote(name, group, protocol, value, bits, pulse, repeat, nil, note, icon)
        html += "<div class='card' style='text-align:center;color:var(--green);font-weight:600;'>遥控已保存</div>"
        html += "<script>setTimeout(function(){window.location.href='/app/rf/manage';},1000);</script>"
        self.app_send_page("录制遥控", "管理", html)
        return
      end
    end

    # 状态3：停止录制
    if webserver.has_arg("stop")
      g.learn_mode = false
      g.learn_result = nil
      html += "<div class='card' style='text-align:center;color:var(--red);font-weight:600;'>录制已停止</div>"
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
      html += "<div class='sect'>按钮图标</div>"
      html += "<div class='card'>" + self.icon_picker_html("remote") + "</div>"
      html += "<script>" + self.icon_picker_js() + "</script>"
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
      var icon = webserver.arg("icon")
      if name == nil name = "" end
      if group == nil group = "" end
      if note == nil note = "" end
      if protocol == nil protocol = 1 end
      if value == nil value = 0 end
      if bits == nil bits = 24 end
      if pulse == nil pulse = 0 end
      if repeat == nil repeat = 10 end
      if icon == nil || icon == "" icon = "remote" end
      g.update_remote(id, {"name": name, "group": group, "icon": icon, "protocol": protocol, "value": value, "bits": bits, "pulse_length": pulse, "repeat": repeat, "note": note})
      html += "<div class='card' style='text-align:center;color:var(--green);font-weight:600;'>已保存</div>"
      html += "<script>setTimeout(function(){window.location.href='/app/rf/manage';},1000);</script>"
      self.app_send_page("编辑遥控", "管理", html)
      return
    end

    var remote = g.find_remote(id)
    if remote == nil
      html += "<div class='card' style='text-align:center;color:var(--red);'>遥控不存在</div>"
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
    html += "<div class='sect'>按钮图标</div>"
    html += "<div class='card'>" + self.icon_picker_html(self.icon_key(remote.find("icon","remote"))) + "</div>"
    html += "<script>" + self.icon_picker_js() + "</script>"
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
        html += f"<div class='ic'>{self.icon_html(remote.find('icon','remote'))}</div>"
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
        var color = st == "OPEN" ? "var(--red)" : "var(--green)"
        html += "<div class='card cell'>"
        html += f"<div class='ic'>{self.ic('door')}</div>"
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
      html += "<div class='card' style='text-align:center;color:var(--green);font-weight:600;'>已保存</div>"
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
        var en_short = link["enabled"] ? "ON" : "OFF"
        var st_color = link["enabled"] ? "#2e9e5b" : "#8e8e93"
        html += "<div class='card cell'>"
        html += f"<div class='ic'>🔗</div>"
        html += f"<div class='tx'><div class='t1'>{webserver.html_escape(door_name)} {link['trigger_state']}</div>"
        html += f"<div class='t2'>{webserver.html_escape(action_desc)}</div></div>"
        html += f"<span style='font-size:11px;font-weight:600;color:{st_color};'>{en_short}</span>"
        html += "<a class='btn gray' style='padding:8px 12px;font-size:11px;margin:0;' href='/app/link?toggle=" + str(link["id"]) + "'>" + en_label + "</a></div>"
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
      html += "<div class='card' style='color:var(--red);font-size:12px;'>需先添加至少一个门磁和一个遥控</div>"
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
      html += "<div class='card' style='text-align:center;color:var(--green);font-weight:600;'>已保存</div>"
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

  def handle_app_api_vdtog()
    import webserver
    import json
    var g = gateway
    var name = webserver.arg("name")
    for vd : g.virtual_devices
      if vd["name"] == name
        if vd.find("state","OFF") == "ON"
          vd["state"] = "OFF"
          g.save_virtual_devices()
          g.seq_run_by_name(vd["off_sequence"])
        else
          vd["state"] = "ON"
          g.save_virtual_devices()
          g.seq_run_by_name(vd["on_sequence"])
        end
        g.publish_vdevice_state(vd)
        break
      end
    end
    webserver.redirect("/app/rf")
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
    webserver.on("/app/api/vdtog", / -> self.handle_app_api_vdtog())
    webserver.on("/app/api/rf/event", / -> self.handle_app_api_rf_event())
    webserver.on("/app/api/rf/delete", / -> self.handle_app_api_rf_delete())
    webserver.on("/app/api/door/delete", / -> self.handle_app_api_door_delete())
  end
end

var webapp = Cc1101WebApp()
tasmota.add_driver(webapp)

return webapp
