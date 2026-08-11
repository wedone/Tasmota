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
      path = "M15 9H9c-.55 0-1 .45-1 1v12c0 .55.45 1 1 1h6c.55 0 1-.45 1-1V10c0-.55-.45-1-1-1zm-3 6c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zM7.05 6.05l1.41 1.41C9.37 6.56 10.62 6 12 6s2.63.56 3.54 1.46l1.41-1.41C15.68 4.78 13.93 4 12 4s-3.68.78-5.05 2.05zM12 0C8.96 0 6.21 1.23 4.22 3.22l1.41 1.41A10.966 10.966 0 0 1 12 2c3.04 0 5.78 1.23 7.78 3.22l1.41-1.41A13.954 13.954 0 0 0 12 0z"
    elif name == "play"
      path = "M8 5v14l11-7z"
    elif name == "door"
      path = "M8 3c-1.11 0-2 .89-2 2v16h12V5c0-1.11-.89-2-2-2H8zm0 2h8v14H8V5zm1 3v2h2V8H9z"
    elif name == "event"
      path = "M19 3h-1V1h-2v2H8V1H6v2H5c-1.11 0-1.99.9-1.99 2L3 19c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm0 16H5V8h14v11zM7 10h5v5H7z"
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
    elif name == "up"
      path = "M13 20h-2V8l-5.5 5.5-1.42-1.42L12 4.16l7.92 7.92-1.42 1.42L13 8v12z"
    elif name == "down"
      path = "M11 4h2v12l5.5-5.5 1.42 1.42L12 19.84l-7.92-7.92L5.5 10.5 11 16V4z"
    elif name == "stop"
      path = "M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zM8 8h8v8H8z"
    elif name == "trash"
      path = "M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"
    elif name == "edit"
      path = "M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34a.9959.9959 0 0 0-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"
    end
    return "<svg viewBox='0 0 24 24' xmlns='http://www.w3.org/2000/svg'><path d='" + path + "' fill='currentColor'/></svg>"
  end

  def icon_html(val)
    import webserver
    var keys = ["gear","back","chev","remote","play","door","event","antenna","plus","power","light","lock","star","up","down","stop","trash","edit"]
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
    var opts = [["remote","遥控"],["up","向上"],["down","向下"],["stop","停止"],["antenna","信号"],["power","电源"],["light","灯光"],["door","门窗"],["play","播放"],["event","事件"],["lock","锁定"],["star","收藏"]]
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
    var keys = ["gear","back","chev","remote","play","door","event","antenna","plus","power","light","lock","star","up","down","stop","trash","edit"]
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

  def icon_select_html(name, selected)
    var opts = [["remote","遥控"],["up","向上"],["down","向下"],["stop","停止"],["power","电源"],["light","灯光"],["door","门窗"],["play","播放"],["lock","锁定"],["star","收藏"],["event","事件"],["antenna","信号"]]
    var html = "<select name='" + name + "' style='width:100%;border:none;font-size:14px;background:transparent;'>"
    for o : opts
      var sel = o[0] == selected ? " selected" : ""
      html += "<option value='" + o[0] + "'" + sel + ">" + o[1] + "</option>"
    end
    html += "</select>"
    return html
  end

  def app_css()
    var css = ""
    css += "html,body{background:var(--bg);font-family:-apple-system,BlinkMacSystemFont,'SF Pro Text','PingFang SC',system-ui,sans-serif;margin:0;padding:0;color:var(--label);-webkit-font-smoothing:antialiased;}"
    css += "a{outline:none;} *{-webkit-tap-highlight-color:transparent;box-sizing:border-box;}"
    css += ":root{--bg:#f2f2f7;--card:#fff;--fill:#e5e5ea;--sep:rgba(60,60,67,.29);--label:#000;--secondary:#8e8e93;--blue:#007aff;--green:#34c759;--red:#ff3b30;}"
    css += "@media (prefers-color-scheme:dark){:root{--bg:#000;--card:#1c1c1e;--fill:#2c2c2e;--sep:rgba(255,255,255,.2);--label:#fff;--secondary:#98989f;--blue:#0a84ff;--green:#30d158;--red:#ff453a;}}"
    css += ".app-hd{padding:18px 20px 6px;display:flex;align-items:center;justify-content:space-between;}"
    css += ".app-hd h1{font-size:28px;margin:0;font-weight:700;letter-spacing:-.02em;}"
    css += ".app-hd a{text-decoration:none;color:var(--blue);padding:6px;display:flex;} .app-hd a svg{width:24px;height:24px;}"
    css += ".app-body{padding:6px 20px calc(86px + env(safe-area-inset-bottom,0px));}"
    css += ".sect{font-size:13px;color:var(--secondary);font-weight:600;margin:20px 0 8px;letter-spacing:.02em;}"
    css += ".grid3{display:grid;grid-template-columns:repeat(3,1fr);gap:14px;}"
    css += ".grid4{display:grid;grid-template-columns:repeat(4,1fr);gap:12px;}"
    css += ".hkbtn{background:var(--card);border-radius:20px;text-align:center;padding:22px 6px;text-decoration:none;color:var(--label);display:block;transition:transform .12s ease,opacity .12s ease;} .hkbtn:active{transform:scale(.96);opacity:.85;}"
    css += ".hkbtn .ic{font-size:34px;line-height:1;color:var(--blue);} .hkbtn .ic svg{width:34px;height:34px;} .hkbtn .nm{font-size:12px;margin-top:8px;font-weight:500;color:var(--secondary);}"
    css += ".devwrap{background:var(--card);border-radius:20px;overflow:hidden;} .devwrap.wide{grid-column:1 / -1;} .devwrap>.hkbtn{background:transparent;padding:20px 8px 12px;cursor:pointer;position:relative;} .devwrap>.hkbtn .chv{position:absolute;right:8px;top:10px;color:var(--secondary);display:flex;transition:transform .15s ease;} .devwrap>.hkbtn .chv svg{width:16px;height:16px;} .devwrap.open>.hkbtn .chv{transform:rotate(90deg);}"
    css += ".btnrow{display:none;grid-template-columns:repeat(4,1fr);gap:8px;padding:4px 10px 14px;border-top:1px solid var(--sep);} .devwrap.open .btnrow{display:grid;} .btnrow .sqcell .sqbtn{width:100%;height:auto;aspect-ratio:1;min-height:44px;border-radius:14px;} .btnrow .sqcell .sqlbl{font-size:11px;margin-top:4px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;}"
    css += ".badge{display:inline-block;font-size:10px;line-height:1;padding:4px 6px;border-radius:6px;background:var(--fill);color:var(--secondary);margin-left:8px;vertical-align:2px;}"
    css += ".typepick{flex:1;display:flex;flex-direction:column;align-items:center;gap:6px;padding:14px 6px;border-radius:12px;background:var(--fill);color:var(--blue);cursor:pointer;border:2px solid transparent;text-align:center;} .typepick input{display:none;} .typepick.on{background:var(--card);border-color:var(--blue);} .typepick .ic{width:28px;height:28px;display:flex;align-items:center;justify-content:center;} .typepick .ic svg{width:28px;height:28px;} .typepick span{font-size:12px;color:var(--label);}"
    css += "select,input{color:var(--label);} select{appearance:none;-webkit-appearance:none;}"
    css += ".sqcell{text-align:center;text-decoration:none;color:var(--label);display:block;} .sqcell:active{opacity:.6;}"
    css += ".sqbtn{width:64px;height:64px;margin:0 auto;background:var(--fill);border-radius:18px;display:flex;align-items:center;justify-content:center;color:var(--blue);font-size:30px;line-height:1;} .sqbtn svg{width:32px;height:32px;}"
    css += ".sqlbl{font-size:12px;color:var(--secondary);margin-top:6px;}"
    css += ".card{background:var(--card);border-radius:14px;padding:10px 14px;margin-bottom:14px;}"
    css += ".cell{display:flex;align-items:center;gap:12px;} .cell:active{background:var(--fill);}"
    css += ".cell .ic{width:38px;height:38px;border-radius:11px;background:var(--fill);display:flex;align-items:center;justify-content:center;color:var(--blue);flex:none;font-size:18px;} .cell .ic svg{width:22px;height:22px;}"
    css += ".cell .tx{flex:1;} .cell .t1{font-size:16px;} .cell .t2{font-size:13px;color:var(--secondary);margin-top:2px;}"
    css += ".btn{display:block;text-align:center;padding:14px;border-radius:12px;font-size:16px;font-weight:500;text-decoration:none;margin-bottom:10px;} .btn:active{opacity:.7;}"
    css += ".btn.blue{background:var(--blue);color:#fff;} .btn.gray{background:var(--fill);color:var(--blue);}"
    css += ".list{background:var(--card);border-radius:14px;overflow:hidden;margin-bottom:14px;}"
    css += ".row{display:flex;align-items:center;gap:14px;padding:13px 16px;text-decoration:none;color:var(--label);} .row:active{background:var(--fill);} .row + .row{border-top:1px solid var(--sep);}"
    css += ".row .rix{width:32px;height:32px;border-radius:8px;display:flex;align-items:center;justify-content:center;color:#fff;flex:none;} .row .rix svg{width:19px;height:19px;}"
    css += ".row .rt{flex:1;font-size:16px;} .row .chv{color:var(--secondary);font-size:15px;display:flex;} .row .chv svg{width:20px;height:20px;}"
    css += ".app-tab{position:fixed;bottom:0;left:0;right:0;background:var(--card);border-top:1px solid var(--sep);display:flex;z-index:9;padding-bottom:env(safe-area-inset-bottom,0px);}"
    css += ".app-tab a{flex:1;text-align:center;padding:5px 0 8px;font-size:10px;color:var(--secondary);text-decoration:none;display:flex;flex-direction:column;align-items:center;gap:2px;} .app-tab a:active{opacity:.6;}"
    css += ".app-tab a svg{width:24px;height:24px;} .app-tab a.on{color:var(--blue);font-weight:600;}"
    css += ".iconpick{display:grid;grid-template-columns:repeat(4,1fr);gap:10px;}"
    css += ".ipick{display:flex;flex-direction:column;align-items:center;gap:5px;padding:12px 4px;border-radius:12px;background:var(--fill);color:var(--blue);cursor:pointer;border:2px solid transparent;} .ipick input{display:none;} .ipick.on{background:var(--card);border-color:var(--blue);}"
    css += ".ipick .ic{width:30px;height:30px;display:flex;align-items:center;justify-content:center;font-size:24px;} .ipick .ic svg{width:28px;height:28px;} .ipick .nm{font-size:11px;color:var(--secondary);}"
    css += ".formgrid{display:grid;grid-template-columns:repeat(2,1fr);gap:12px;align-items:end;} .formgrid .full{grid-column:1 / -1;} .formgrid .sect{margin:0 0 8px;} .formgrid .card{margin:0;}"
    css += "input[type=number]::-webkit-inner-spin-button,input[type=number]::-webkit-outer-spin-button{-webkit-appearance:none;margin:0;} input[type=number]{-moz-appearance:textfield;appearance:textfield;}"
    css += ".hintcard{background:var(--fill);border-radius:12px;padding:10px 14px;margin-bottom:14px;font-size:12px;color:var(--secondary);line-height:1.6;}"
    css += ".btncard{margin:0;} .btncard .btnhead{display:flex;gap:8px;align-items:center;} .btncard .btnhead input[type=text]{flex:1;border:none;font-size:14px;background:transparent;}"
    css += ".rfgrid{display:grid;grid-template-columns:repeat(2,1fr);gap:8px 12px;margin-top:10px;} .rfgrid .rfld label{display:block;font-size:11px;color:var(--secondary);margin-bottom:4px;} .rfgrid .rfld input{width:100%;border:none;font-size:14px;background:var(--fill);border-radius:8px;padding:8px 10px;}"
    css += ".rfmask{position:fixed;inset:0;background:rgba(0,0,0,.45);z-index:20;display:none;align-items:center;justify-content:center;padding:20px;} .rfmask.open{display:flex;} .rfbox{background:var(--card);border-radius:14px;width:100%;max-width:340px;padding:16px;box-shadow:0 8px 30px rgba(0,0,0,.25);} .rfbox h3{margin:0 0 4px;font-size:17px;} .rfbox .rfgrid{margin-top:12px;} .rfbox .btns{display:flex;gap:10px;margin-top:14px;} .rfbox .btns .btn{margin:0;flex:1;font-size:14px;padding:11px;}"
    return css
  end

  def app_send_page(title, active_tab, content_html)
    import webserver
    webserver.content_open(200, "text/html")
    webserver.content_send("<!DOCTYPE html><html><head><meta charset='utf-8'>")
    webserver.content_send("<meta name='viewport' content='width=device-width,initial-scale=1,viewport-fit=cover'>")
    webserver.content_send("<title>" + title + "</title>")
    webserver.content_send("<link rel='stylesheet' href='/app/app.css'>")
    webserver.content_send("</head><body>")
    webserver.content_send("<div class='app-hd'><h1>" + title + "</h1><a href='/app/manage'>" + self.ic("gear") + "</a></div>")
    webserver.content_send("<div class='app-body'>")
    var chunk = 1024
    var i = 0
    while i < size(content_html)
      var ep = i + chunk
      if ep > size(content_html)
        ep = size(content_html)
      end
      webserver.content_send(bytes().fromstring(content_html[i .. ep - 1]))
      webserver.content_flush()
      i = ep
    end
    webserver.content_send("</div>")
    var tabs = [["/app/rf","设备","remote"],["/app/seq","场景","play"],["/app/event","事件","event"],["/app/manage","管理","gear"]]
    webserver.content_send("<div class='app-tab'>")
    for t : tabs
      webserver.content_send("<a href='" + t[0] + "'" + (t[1] == active_tab ? " class='on'" : "") + ">" + self.ic(t[2]) + "<span>" + t[1] + "</span></a>")
    end
    webserver.content_send("</div></body></html>")
    webserver.content_close()
  end

  def handle_app_page_root()
    import webserver
    webserver.redirect("/app/rf")
  end

  def handle_app_css_page()
    import webserver
    webserver.content_open(200, "text/css")
    webserver.content_send(self.app_css())
    webserver.content_close()
  end

  def handle_app_rf_page()
    import webserver
    var g = gateway
    var html = ""
    var devices = g.all_devices()
    html += "<div class='sect'>设备</div>"
    if size(devices) > 0
      html += "<div class='grid3'>"
      for d : devices
        if d["kind"] == "door"
          var st = d["state"]
          var bg = st == "OPEN" ? "var(--red)" : "var(--green)"
          var txt = st == "OPEN" ? "开启" : "已关"
          html += f"<a class='hkbtn' style='background:{bg};color:#fff;' href='/app/rf/edit?kind=door&id={d['id']}'>"
          html += f"<div class='ic' style='color:#fff;'>{self.ic('door')}</div>"
          html += f"<div class='nm' style='color:#fff;'>{webserver.html_escape(d['name'])}<br>{txt}</div></a>"
        elif d["button_count"] > 0
          html += f"<div class='devwrap wide' id='dev-{d['id']}'>"
          html += f"<div class='hkbtn' onclick='toggleDev({d['id']})'>"
          html += f"<div class='ic'>{self.icon_html(d['icon'])}</div>"
          html += f"<div class='nm'>{webserver.html_escape(d['name'])}</div>"
          html += "<span class='chv'>" + self.ic("chev") + "</span></div>"
          html += f"<div class='btnrow' id='btnrow-{d['id']}'>"
          for b : d["buttons"]
            var recorded = b.find("recorded", false) || b.find("value", 0) > 0
            if recorded
              html += f"<a class='sqcell' href='/app/api/send?rid={d['id']}&bid={b['id']}' onclick='sendBtn(this.href);return false;'>"
              html += f"<div class='sqbtn'>{self.icon_html(b.find('icon', d['icon']))}</div>"
              html += f"<div class='sqlbl'>{webserver.html_escape(b['name'])}</div></a>"
            else
              html += f"<a class='sqcell' href='/app/rf/edit?kind=remote&id={d['id']}&learn=1&bid={b['id']}'>"
              html += f"<div class='sqbtn' style='color:var(--red);'>{self.icon_html(b.find('icon', d['icon']))}</div>"
              html += f"<div class='sqlbl'>{webserver.html_escape(b['name'])}<br>未录制</div></a>"
            end
          end
          html += "</div></div>"
        else
          html += f"<a class='hkbtn' href='/app/rf/view?id={d['id']}'>"
          html += f"<div class='ic'>{self.icon_html(d['icon'])}</div>"
          html += f"<div class='nm'>{webserver.html_escape(d['name'])}</div></a>"
        end
      end
      html += "</div>"
    else
      html += "<div class='card' style='color:#8e8e93;font-size:12px;'>暂无设备，请到管理中新建</div>"
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
    html += "<script>function toggleDev(id){var w=document.getElementById('dev-'+id);if(w){w.classList.toggle('open')}}function sendBtn(url){fetch(url).catch(function(e){});}</script>"
    self.app_send_page("射频网关", "设备", html)
  end

  def handle_app_rf_view_page()
    import webserver
    var g = gateway
    var id = int(webserver.arg("id"))
    var remote = g.find_remote(id)
    if remote == nil
      self.app_send_page("设备", "设备", "<div class='card'>遥控不存在</div>")
      return
    end
    var html = ""
    html += "<a href='/app/rf' style='text-decoration:none;color:#007aff;font-size:13px;'>‹ 设备</a>"
    html += "<div class='sect'>" + webserver.html_escape(remote["name"]) + "</div>"
    html += "<div class='card'><div class='grid4'>"
    var btns = remote["buttons"]
    if btns == nil || size(btns) == 0
      html += f"<a class='sqcell' href='/app/api/send?rid={remote['id']}' onclick='sendBtn(this.href);return false;'>"
      html += f"<div class='sqbtn'>{self.icon_html(remote.find('icon','remote'))}</div><div class='sqlbl'>{webserver.html_escape(remote['name'])}</div></a>"
    else
      for b : btns
        var recorded = b.find("recorded", false) || b.find("value", 0) > 0
        if recorded
          html += f"<a class='sqcell' href='/app/api/send?rid={remote['id']}&bid={b['id']}' onclick='sendBtn(this.href);return false;'>"
          html += f"<div class='sqbtn'>{self.icon_html(b.find('icon', remote.find('icon','remote')))}</div><div class='sqlbl'>{webserver.html_escape(b['name'])}</div></a>"
        else
          html += f"<a class='sqcell' href='/app/rf/edit?kind=remote&id={remote['id']}&learn=1&bid={b['id']}'>"
          html += f"<div class='sqbtn' style='color:var(--red);'>{self.icon_html(b.find('icon', remote.find('icon','remote')))}</div><div class='sqlbl'>{webserver.html_escape(b['name'])}<br>未录制</div></a>"
        end
      end
    end
    html += "</div></div>"
    html += "<a class='btn gray' href='/app/rf/edit?kind=remote&id=" + str(remote["id"]) + "'>编辑设备</a>"
    html += "<script>function sendBtn(url){fetch(url).catch(function(e){});}</script>"
    self.app_send_page(webserver.html_escape(remote["name"]), "设备", html)
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
    html += "<div class='sect'>添加发送设备</div>"
    html += "<div class='grid3' id='remotes'></div>"
    if size(g.remotes) == 0
      html += "<div class='card' style='color:#8e8e93;font-size:12px;'>暂无设备，请先添加设备</div>"
    end
    html += "<button class='btn blue' onclick='saveSeq()'>保存</button>"
    var remotes = []
    for r : g.remotes
      var btns = r.find("buttons", [])
      if btns == nil btns = [] end
      remotes.push({"id": r["id"], "name": r["name"], "icon": self.icon_html(r.find("icon", "remote")), "buttons": btns})
    end
    html += "<script>var STEPS=" + (seq != nil ? json.dump(seq["steps"]) : "[]") + ";"
    html += "var REMOTES=" + json.dump(remotes) + ";"
    html += "function rname(id){var r=REMOTES.find(function(x){return x.id==id});return r?r.name:('设备#'+id)}"
    html += "function bname(rid,bid){var r=REMOTES.find(function(x){return x.id==rid});if(!r)return '按钮'+bid;var b=(r.buttons||[]).find(function(x){return x.id==bid});return b?b.name:('按钮'+bid)}"
    html += "function render(){var h='';STEPS.forEach(function(s,i){if(s.type=='send'){h+='<div style=\"padding:6px 0;border-bottom:1px solid #f2f2f7;display:flex;align-items:center;\"><span style=\"flex:1;\">📡 '+rname(s.remote_id)+(s.button_id!==undefined?' ·'+bname(s.remote_id,s.button_id):'')+'</span><span onclick=\"STEPS.splice('+i+',1);render()\" style=\"color:var(--red);padding:4px;\">✕</span></div>'}else{h+='<div style=\"padding:6px 0;border-bottom:1px solid #f2f2f7;display:flex;align-items:center;\"><span style=\"flex:1;\">⏱ <input type=\"number\" value=\"'+s.ms+'\" onchange=\"STEPS['+i+'].ms=parseInt(this.value)||1000\" style=\"width:110px;border:1px solid #e5e5ea;border-radius:8px;padding:4px 6px;font-size:13px;background:transparent;\"> ms</span><span onclick=\"STEPS.splice('+i+',1);render()\" style=\"color:var(--red);padding:4px;\">✕</span></div>'}});document.getElementById('steps').innerHTML=h}"
    html += "function addSend(rid,bid){STEPS.push({type:'send',remote_id:rid,button_id:bid});render()}"
    html += "function addDelay(){var ms=parseInt(document.getElementById('delayms').value)||1000;STEPS.push({type:'delay',ms:ms});render()}"
    html += "function saveSeq(){location.href='/app/seq/edit?save=1&seqname='+encodeURIComponent(document.getElementById('seqname').value||'新场景')+'&steps='+encodeURIComponent(JSON.stringify(STEPS));}"
    html += "render();"
    html += "var rh='';REMOTES.forEach(function(r){if(r.buttons&&r.buttons.length){r.buttons.forEach(function(b){rh+='<a class=\"hkbtn\" style=\"padding:10px 4px;\" onclick=\"addSend('+r.id+','+b.id+')\"><div class=\"ic\">'+(r.icon||'🕹')+'</div><div class=\"nm\">'+r.name+' · '+b.name+'</div></a>'})}else{rh+='<a class=\"hkbtn\" style=\"padding:10px 4px;\" onclick=\"addSend('+r.id+')\"><div class=\"ic\">'+(r.icon||'🕹')+'</div><div class=\"nm\">'+r.name+'</div></a>'}});document.getElementById('remotes').innerHTML=rh;"
    html += "</script>"
    self.app_send_page("编辑场景", "场景", html)
  end

  def handle_app_door_page()
    import webserver
    webserver.redirect("/app/rf")
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
    html += "<a class='row' href='/app/rf/manage'><span class='rix' style='background:#007aff;'>" + self.ic("remote") + "</span><span class='rt'>设备管理（新建/录制/编辑）</span><span class='chv'>" + self.ic("chev") + "</span></a>"
    html += "<a class='row' href='/app/link'><span class='rix' style='background:#ff9500;'>" + self.ic("antenna") + "</span><span class='rt'>联动规则</span><span class='chv'>" + self.ic("chev") + "</span></a>"
    html += "<a class='row' href='/app/vdev'><span class='rix' style='background:#af52de;'>" + self.ic("antenna") + "</span><span class='rt'>虚拟设备</span><span class='chv'>" + self.ic("chev") + "</span></a>"
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

  def find_remote_button(remote, bid)
    for b : remote.find("buttons", [])
      if b["id"] == bid
        return b
      end
    end
    return nil
  end

  def render_learn_page(kind, total, idx, name, group, note, icon, location, prompt, target, stop_target)
    import webserver
    import json
    import string
    var g = gateway
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
    var stop_url = "/app/rf/record?stop=1"
    if stop_target != nil
      stop_url = stop_target
    end
    var html = ""
    html += "<div class='card' style='text-align:center;'>"
    html += "<div style='font-size:40px;'>" + (kind == "door" ? "🚪" : "🎙") + "</div>"
    html += "<div style='font-size:14px;font-weight:600;margin-top:8px;'>" + webserver.html_escape(prompt) + "</div>"
    html += "<div style='font-size:11px;color:#8e8e93;margin-top:4px;'>30秒内触发设备</div>"
    html += "</div>"
    html += "<a class='btn gray' href='" + stop_url + "'>停止</a>"
    html += "<script>"
    html += "var NAME=" + json.dump(name) + ";"
    html += "var GROUP=" + json.dump(group) + ";"
    html += "var NOTE=" + json.dump(note) + ";"
    html += "var LOC=" + json.dump(location) + ";"
    html += "var ICON=" + json.dump(icon) + ";"
    html += "var KIND='" + kind + "';"
    html += "var TOTAL=" + str(total) + ";"
    html += "var IDX=" + str(idx) + ";"
    html += "var TARGET='" + target + "';"
    html += "var STOP=" + json.dump(stop_url) + ";"
    html += "var poll=setInterval(function(){"
    html += "var x=new XMLHttpRequest();"
    html += "x.open('GET','/app/api/rf/event',true);"
    html += "x.onreadystatechange=function(){"
    html += "if(x.readyState==4&&x.status==200&&x.responseText!=''){"
    html += "var d=JSON.parse(x.responseText);"
    html += "if(d.value){clearInterval(poll);"
    html += "var base=(TARGET.indexOf('?')>=0?TARGET+'&value='+d.value:TARGET+'?value='+d.value)+'&bits='+d.bits+'&protocol='+d.protocol+'&pulse_length='+d.pulse_length;"
    html += "if(TARGET.indexOf('/app/rf/edit')>=0)base+='&learned=1';"
    html += "if(KIND=='door'){window.location.href=base+'&type=door&name='+encodeURIComponent(NAME)+'&location='+encodeURIComponent(LOC)+'&note='+encodeURIComponent(NOTE);}"
    html += "else{window.location.href=base+'&type=remote&total='+TOTAL+'&idx='+IDX+'&name='+encodeURIComponent(NAME)+'&group='+encodeURIComponent(GROUP)+'&note='+encodeURIComponent(NOTE)+'&icon='+ICON;}"
    html += "}}};x.send();},500);"
    html += "setTimeout(function(){clearInterval(poll);window.location.href=STOP;},35000);"
    html += "</script>"
    self.app_send_page(kind == "door" ? "添加设备" : (string.find(target, "/app/rf/edit") == 0 ? "录制按钮" : "录制设备"), "管理", html)
  end

  def handle_app_rf_record()
    import webserver
    try
      self.handle_app_rf_record_inner()
    except .. as e, m
      self.app_send_page("错误", "管理", "<div class='card' style='color:var(--red);'>ERROR: " + webserver.html_escape(str(e)) + " " + webserver.html_escape(str(m)) + "</div>")
    end
  end

  def handle_app_api_rf_stop()
    import webserver
    var g = gateway
    g.learn_mode = false
    g.learn_result = nil
    g.pending_remote = nil
    var kind = webserver.arg("kind")
    var id = int(webserver.arg("id"))
    if kind == "door"
      webserver.redirect("/app/rf/edit?kind=door&id=" + str(id))
    else
      webserver.redirect("/app/rf/edit?kind=remote&id=" + str(id))
    end
  end

  # ============ 添加设备：先创建 N 个按钮的遥控，再逐个录制 ============
  def handle_app_rf_record_inner()
    import webserver
    var g = gateway
    var html = ""
    html += "<a href='/app/rf/manage' style='text-decoration:none;color:#007aff;font-size:13px;'>‹ 设备管理</a>"
    var kind = webserver.arg("type")
    if kind == nil || kind == "" kind = "remote" end

    # 停止录制
    if webserver.has_arg("stop")
      g.learn_mode = false
      g.learn_result = nil
      g.pending_remote = nil
      html += "<div class='card' style='text-align:center;color:var(--red);font-weight:600;'>录制已停止</div>"
      html += "<a class='btn blue' href='/app/rf/record'>重新录制</a>"
      self.app_send_page("添加设备", "管理", html)
      return
    end

    # 门磁保存（学习捕获后）
    if kind == "door" && webserver.has_arg("save")
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
      if name != "" && code > 0
        g.add_door(name, location, code, bits, 1, note)
        html += "<div class='card' style='text-align:center;color:var(--green);font-weight:600;'>设备已保存</div>"
        html += "<script>setTimeout(function(){window.location.href='/app/rf/manage';},1000);</script>"
        self.app_send_page("添加设备", "管理", html)
      else
        html += "<div class='card' style='text-align:center;color:var(--red);'>名称和编码不能为空</div>"
        html += "<a class='btn blue' href='/app/rf/record'>重新添加</a>"
        self.app_send_page("添加设备", "管理", html)
      end
      return
    end

    # 创建带 N 个空按钮的遥控骨架
    if webserver.has_arg("create") && kind == "remote"
      var total = int(webserver.arg("total"))
      var name = webserver.arg("name")
      var group = webserver.arg("group")
      var note = webserver.arg("note")
      var icon = webserver.arg("icon")
      if total == nil || total < 1 total = 1 end
      if name == nil || name == "" name = "新遥控" end
      if group == nil group = "" end
      if note == nil note = "" end
      if icon == nil || icon == "" icon = "remote" end
      var remote = g.add_remote_with_buttons(name, group, icon, note, total)
      webserver.redirect("/app/rf/edit?kind=remote&id=" + str(remote["id"]) + "&created=1")
      return
    end

    # 遥控按钮保存（逐个录制）
    if kind == "remote" && webserver.has_arg("savebtn")
      var idx = int(webserver.arg("idx"))
      var total = int(webserver.arg("total"))
      if idx == nil idx = 1 end
      if total == nil total = 1 end
      var name = webserver.arg("name")
      var group = webserver.arg("group")
      var note = webserver.arg("note")
      var icon = webserver.arg("icon")
      var btn_name = webserver.arg("btn_name")
      var bicon = webserver.arg("bicon")
      var repeat = int(webserver.arg("repeat"))
      var value = int(webserver.arg("value"))
      var bits = int(webserver.arg("bits"))
      var protocol = int(webserver.arg("protocol"))
      var pulse = int(webserver.arg("pulse_length"))
      if name == nil name = "新遥控" end
      if group == nil group = "" end
      if note == nil note = "" end
      if icon == nil || icon == "" icon = "remote" end
      if btn_name == nil || btn_name == "" btn_name = "按钮" + str(idx) end
      if bicon == nil || bicon == "" bicon = icon end
      if repeat == nil repeat = 10 end
      if value == nil value = 0 end
      if bits == nil bits = 24 end
      if protocol == nil protocol = 1 end
      if pulse == nil pulse = 0 end
      if g.pending_remote == nil
        g.pending_remote = {"name": name, "group": group, "icon": icon, "note": note, "buttons": []}
      end
      g.pending_remote["buttons"].push({"id": idx, "name": btn_name, "icon": bicon, "value": value, "bits": bits, "protocol": protocol, "pulse_length": pulse, "repeat": repeat})
      if idx < total
        self.render_learn_page("remote", total, idx + 1, name, group, note, icon, "", f"按钮 {idx} 已保存，正在监听第 {idx + 1} 个按钮（共 {total} 个）", "/app/rf/record", nil)
      else
        g.add_multi_button_remote(name, group, icon, note, g.pending_remote["buttons"])
        g.pending_remote = nil
        html += "<div class='card' style='text-align:center;color:var(--green);font-weight:600;'>设备已保存</div>"
        html += "<script>setTimeout(function(){window.location.href='/app/rf/manage';},1000);</script>"
        self.app_send_page("添加设备", "管理", html)
      end
      return
    end

    # 门磁学习开始
    if kind == "door" && webserver.has_arg("learn")
      var name = webserver.arg("name")
      var location = webserver.arg("location")
      var note = webserver.arg("note")
      if name == nil name = "新门磁" end
      if location == nil location = "" end
      if note == nil note = "" end
      self.render_learn_page("door", 1, 1, name, "", note, "door", location, "配对中...", "/app/rf/record", nil)
      return
    end

    # 遥控学习开始
    if kind == "remote" && webserver.has_arg("start")
      var total = int(webserver.arg("total"))
      var idx = int(webserver.arg("idx"))
      var name = webserver.arg("name")
      var group = webserver.arg("group")
      var note = webserver.arg("note")
      var icon = webserver.arg("icon")
      if total == nil total = 1 end
      if idx == nil idx = 1 end
      if name == nil name = "新遥控" end
      if group == nil group = "" end
      if note == nil note = "" end
      if icon == nil || icon == "" icon = "remote" end
      if idx == 1
        g.pending_remote = {"name": name, "group": group, "icon": icon, "note": note, "buttons": []}
      end
      self.render_learn_page("remote", total, idx, name, group, note, icon, "", f"正在监听第 {idx} 个按钮（共 {total} 个）", "/app/rf/record", nil)
      return
    end

    # 已捕获信号，显示保存表单
    var value = webserver.arg("value")
    if value != nil && value != ""
      var bits = webserver.arg("bits")
      var protocol = webserver.arg("protocol")
      var pulse = webserver.arg("pulse_length")
      html += "<div class='sect'>已捕获信号</div>"
      html += "<div class='card' style='font-size:12px;color:#666;line-height:1.8;'>"
      html += f"<div>编码: <b>{value}</b></div>"
      html += f"<div>位数: {bits}</div>"
      html += f"<div>协议: P{protocol}</div>"
      html += f"<div>脉宽: {pulse}</div>"
      html += "</div>"
      if kind == "door"
        var name = webserver.arg("name")
        var location = webserver.arg("location")
        var note = webserver.arg("note")
        if name == nil name = "" end
        if location == nil location = "" end
        if note == nil note = "" end
        html += "<form method='get' action='/app/rf/record'>"
        html += "<input type='hidden' name='type' value='door'>"
        html += "<input type='hidden' name='save' value='1'>"
        html += f"<input type='hidden' name='code' value='{value}'>"
        html += f"<input type='hidden' name='bits' value='{bits}'>"
        html += "<div class='sect'>名称</div>"
        html += f"<div class='card'><input name='name' value='{webserver.html_escape(name)}' placeholder='如：前门' style='width:100%;border:none;font-size:14px;background:transparent;' required></div>"
        html += "<div class='sect'>位置</div>"
        html += f"<div class='card'><input name='location' value='{webserver.html_escape(location)}' placeholder='如：正门' style='width:100%;border:none;font-size:14px;background:transparent;'></div>"
        html += "<div class='sect'>备注</div>"
        html += f"<div class='card'><input name='note' value='{webserver.html_escape(note)}' placeholder='可选' style='width:100%;border:none;font-size:14px;background:transparent;'></div>"
        html += "<button class='btn blue' type='submit'>保存门磁</button>"
        html += "</form>"
        self.app_send_page("添加设备", "管理", html)
        return
      end

      var idx = int(webserver.arg("idx"))
      var total = int(webserver.arg("total"))
      var name = webserver.arg("name")
      var group = webserver.arg("group")
      var note = webserver.arg("note")
      var icon = webserver.arg("icon")
      if idx == nil idx = 1 end
      if total == nil total = 1 end
      if name == nil name = "新遥控" end
      if group == nil group = "" end
      if note == nil note = "" end
      if icon == nil || icon == "" icon = "remote" end
      html += "<form method='get' action='/app/rf/record'>"
      html += "<input type='hidden' name='type' value='remote'>"
      html += "<input type='hidden' name='savebtn' value='1'>"
      html += f"<input type='hidden' name='idx' value='{idx}'>"
      html += f"<input type='hidden' name='total' value='{total}'>"
      html += f"<input type='hidden' name='value' value='{value}'>"
      html += f"<input type='hidden' name='bits' value='{bits}'>"
      html += f"<input type='hidden' name='protocol' value='{protocol}'>"
      html += f"<input type='hidden' name='pulse_length' value='{pulse}'>"
      if idx == 1
        html += "<div class='sect'>设备名称</div>"
        html += f"<div class='card'><input name='name' value='{webserver.html_escape(name)}' placeholder='如：卷帘门' style='width:100%;border:none;font-size:14px;background:transparent;' required></div>"
        html += "<div class='sect'>分组</div>"
        html += f"<div class='card'><input name='group' value='{webserver.html_escape(group)}' placeholder='如：门窗' style='width:100%;border:none;font-size:14px;background:transparent;'></div>"
        html += "<div class='sect'>备注</div>"
        html += f"<div class='card'><input name='note' value='{webserver.html_escape(note)}' placeholder='可选' style='width:100%;border:none;font-size:14px;background:transparent;'></div>"
        html += "<div class='sect'>设备图标</div>"
        html += "<div class='card'>" + self.icon_picker_html(self.icon_key(icon)) + "</div>"
        html += "<script>" + self.icon_picker_js() + "</script>"
      else
        html += f"<input type='hidden' name='name' value='{webserver.html_escape(name)}'>"
        html += f"<input type='hidden' name='group' value='{webserver.html_escape(group)}'>"
        html += f"<input type='hidden' name='note' value='{webserver.html_escape(note)}'>"
        html += f"<input type='hidden' name='icon' value='{webserver.html_escape(icon)}'>"
        html += "<div class='card' style='font-size:12px;color:#666;'>设备: " + webserver.html_escape(name) + " · 按钮 " + str(idx) + "/" + str(total) + "</div>"
      end
      html += "<div class='sect'>按钮名称</div>"
      html += "<div class='card'><input id='btnname' name='btn_name' value='按钮" + str(idx) + "' placeholder='如：上' style='width:100%;border:none;font-size:14px;background:transparent;' required></div>"
      if total == 4
        html += "<div class='card' style='display:flex;gap:8px;align-items:center;font-size:12px;color:var(--secondary);'>常用: "
        for preset : ["上","停","下","锁"]
          html += "<span style='padding:4px 8px;background:var(--fill);border-radius:8px;cursor:pointer;' onclick=\"document.getElementById('btnname').value='" + preset + "'\">" + preset + "</span>"
        end
        html += "</div>"
      end
      html += "<div class='sect'>按钮图标</div>"
      html += "<div class='card'>" + self.icon_select_html("bicon", icon) + "</div>"
      html += "<div class='sect'>重复次数</div>"
      html += "<div class='card'><input name='repeat' type='number' value='10' style='width:100%;border:none;font-size:14px;background:transparent;'></div>"
      html += "<button class='btn blue' type='submit'>" + (idx < total ? "保存并录制下一按钮" : "保存设备") + "</button>"
      html += "</form>"
      self.app_send_page("录制设备", "管理", html)
      return
    end

    # 默认页：设备类型 + 基础信息 + 按钮数量，创建后进入按钮录制页
    html += "<div class='sect'>设备类型</div>"
    html += "<div class='card' style='display:flex;gap:10px;'>"
    html += "<label class='typepick on'><input type='radio' name='type' value='remote' checked onclick='pickType()'><span class='ic'>" + self.ic("remote") + "</span><span>遥控</span></label>"
    html += "<label class='typepick'><input type='radio' name='type' value='door' onclick='pickType()'><span class='ic'>" + self.ic("door") + "</span><span>门磁</span></label>"
    html += "</div>"
    html += "<div class='formgrid'>"
    html += "<div><div class='sect'>名称</div><div class='card'><input id='devname' placeholder='如：卷帘门' style='width:100%;border:none;font-size:14px;background:transparent;' required></div></div>"
    html += "<div id='grprow'><div class='sect'>分组</div><div class='card'><input id='devgroup' placeholder='如：门窗' style='width:100%;border:none;font-size:14px;background:transparent;'></div></div>"
    html += "<div id='locrow' style='display:none;'><div class='sect'>位置</div><div class='card'><input id='devloc' placeholder='如：客厅' style='width:100%;border:none;font-size:14px;background:transparent;'></div></div>"
    html += "<div id='btnrow'><div class='sect'>按钮数量</div><div class='card'><input id='btotal' type='number' value='4' min='1' max='12' style='width:100%;border:none;font-size:14px;background:transparent;'></div></div>"
    html += "<div class='full'><div class='sect'>备注</div><div class='card'><input id='devnote' placeholder='可选' style='width:100%;border:none;font-size:14px;background:transparent;'></div></div>"
    html += "</div>"
    html += "<div id='iconrow'><div class='sect'>设备图标</div>"
    html += "<div class='card'>" + self.icon_picker_html("remote") + "</div></div>"
    html += "<script>"
    html += self.icon_picker_js()
    html += "function pickType(){var labels=document.querySelectorAll('.typepick');for(var i=0;i<labels.length;i++){labels[i].classList.remove('on')}var t=document.querySelector('input[name=type]:checked').value;document.querySelector('input[name=type]:checked').closest('.typepick').classList.add('on');document.getElementById('grprow').style.display=t==='remote'?'block':'none';document.getElementById('locrow').style.display=t==='door'?'block':'none';document.getElementById('btnrow').style.display=t==='remote'?'block':'none';document.getElementById('iconrow').style.display=t==='remote'?'block':'none';var b=document.getElementById('startbtn');if(b)b.textContent=t==='remote'?'创建设备':'开始配对';}"
    html += "function startRecord(){var t=document.querySelector('input[name=type]:checked').value;var name=encodeURIComponent(document.getElementById('devname').value||(t==='door'?'新门磁':'新遥控'));var note=encodeURIComponent(document.getElementById('devnote').value);if(t==='remote'){var total=parseInt(document.getElementById('btotal').value||'4',10);if(!total||total<1)total=1;var group=encodeURIComponent(document.getElementById('devgroup').value);var icon=document.querySelector('input[name=icon]:checked').value;window.location.href='/app/rf/record?create=1&type=remote&total='+total+'&name='+name+'&group='+group+'&note='+note+'&icon='+icon;}else{var loc=encodeURIComponent(document.getElementById('devloc').value);window.location.href='/app/rf/record?learn=1&type=door&name='+name+'&location='+loc+'&note='+note;}}"
    html += "pickType();"
    html += "</script>"
    html += "<button class='btn blue' id='startbtn' type='button' onclick='startRecord()'>创建设备</button>"
    self.app_send_page("添加设备", "管理", html)
  end

  # ============ 设备编辑（遥控/门磁统一，替代 /rf/edit + /door/edit）============
  def handle_app_rf_edit()
    import webserver
    var g = gateway
    var kind = webserver.arg("kind")
    var id = int(webserver.arg("id"))
    if kind == nil || kind == ""
      if g.find_remote(id) != nil
        kind = "remote"
      else
        kind = "door"
      end
    end
    self.handle_app_device_edit(kind, id)
  end

  def handle_app_device_edit(kind, id)
    import webserver
    var g = gateway
    var html = ""
    html += "<a href='/app/rf/manage' style='text-decoration:none;color:#007aff;font-size:13px;'>‹ 设备管理</a>"

    if kind == "door"
      var door = g.find_door(id)
      # 门磁重新配对学习
      if webserver.has_arg("learn")
        var lname = door != nil ? door["name"] : webserver.arg("name")
        var lloc = door != nil ? door["location"] : webserver.arg("location")
        var lnote = door != nil ? door["note"] : webserver.arg("note")
        if lname == nil lname = "新门磁" end
        if lloc == nil lloc = "" end
        if lnote == nil lnote = "" end
        self.render_learn_page("door", 1, 1, lname, "", lnote, "door", lloc, "配对中...", "/app/rf/edit?kind=door&id=" + str(id), "/app/api/rf/stop?kind=door&id=" + str(id))
        return
      end
      # 门磁保存
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
          html += "<div class='card' style='text-align:center;color:var(--green);font-weight:600;'>已保存</div>"
          html += "<script>setTimeout(function(){window.location.href='/app/rf/manage';},1000);</script>"
          self.app_send_page("编辑设备", "管理", html)
        elif name != "" && code > 0
          g.add_door(name, location, code, bits, 1, note)
          html += "<div class='card' style='text-align:center;color:var(--green);font-weight:600;'>已保存</div>"
          html += "<script>setTimeout(function(){window.location.href='/app/rf/manage';},1000);</script>"
          self.app_send_page("编辑设备", "管理", html)
        else
          html += "<div class='card' style='text-align:center;color:var(--red);'>名称和编码不能为空</div>"
          self.app_send_page("编辑设备", "管理", html)
        end
        return
      end
      var learn_code = webserver.arg("code")
      if learn_code == nil learn_code = "0" end
      var learn_bits = webserver.arg("bits")
      if learn_bits == nil learn_bits = "24" end
      var learned = webserver.has_arg("learned")
      var title = (door == nil && id == 0) ? "添加门磁" : "编辑门磁"
      if (door == nil && learn_code != "0") || learned
        title = "已捕获信号"
      end
      html += f"<div class='sect'>{title}</div>"
      if (door == nil && learn_code != "0") || learned
        html += "<div class='card' style='font-size:12px;color:#666;'>"
        html += f"<div>编码: <b>{learn_code}</b></div>"
        html += f"<div>位数: {learn_bits}</div>"
        html += "</div>"
      end
      html += "<form method='get' action='/app/rf/edit'>"
      html += "<input type='hidden' name='kind' value='door'>"
      if id > 0
        html += f"<input type='hidden' name='id' value='{id}'>"
      end
      html += "<input type='hidden' name='save' value='1'>"
      if door == nil
        html += f"<input type='hidden' name='code' value='{learn_code}'>"
        html += f"<input type='hidden' name='bits' value='{learn_bits}'>"
      else
        var code_val = learned ? learn_code : door["code"]
        var bits_val = learned ? learn_bits : door["bits"]
        html += f"<input type='hidden' name='code' value='{code_val}'>"
        html += f"<input type='hidden' name='bits' value='{bits_val}'>"
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
      html += f"<a class='btn gray' href='/app/rf/edit?kind=door&learn=1&id={id}'>🎙 配对学习</a>"
      if id > 0
        html += f"<a class='btn gray' href='/app/api/rf/delete?kind=door&id={id}'>删除门磁</a>"
      end
      self.app_send_page("编辑设备", "管理", html)
      return
    end

    # 遥控按钮逐个录制
    var remote = g.find_remote(id)
    if remote != nil
      if webserver.has_arg("learn")
        var bid = int(webserver.arg("bid"))
        var btn = self.find_remote_button(remote, bid)
        if btn == nil
          html += "<div class='card' style='text-align:center;color:var(--red);'>按钮不存在</div>"
          self.app_send_page("编辑设备", "管理", html)
          return
        end
        self.render_learn_page("remote", size(remote["buttons"]), bid, remote["name"], remote.find("group",""), remote.find("note",""), remote.find("icon","remote"), "", "正在录制按钮「" + webserver.html_escape(btn["name"]) + "」", "/app/rf/edit?kind=remote&id=" + str(id), "/app/api/rf/stop?kind=remote&id=" + str(id))
        return
      end
      if webserver.has_arg("learned")
        var bid = int(webserver.arg("idx"))
        var value = int(webserver.arg("value"))
        var bits = int(webserver.arg("bits"))
        var protocol = int(webserver.arg("protocol"))
        var pulse = int(webserver.arg("pulse_length"))
        if bid != nil && value != nil && value > 0
          g.update_remote_button(id, bid, {"value": value, "bits": bits, "protocol": protocol, "pulse_length": pulse, "recorded": true})
          webserver.redirect("/app/rf/edit?kind=remote&id=" + str(id) + "&saved=1")
          return
        end
      end
    end

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
      remote = g.find_remote(id)
      if remote != nil
        var i = 0
        for b : remote.find("buttons", [])
          if b == nil break end
          var bn = webserver.arg("btn_name" + str(i))
          var bi = webserver.arg("btn_icon" + str(i))
          if bn != nil && bn != "" b["name"] = bn end
          if bi != nil && bi != "" b["icon"] = bi end
          var bv = webserver.arg("btn_value" + str(i))
          var bb = webserver.arg("btn_bits" + str(i))
          var bp = webserver.arg("btn_protocol" + str(i))
          var bl = webserver.arg("btn_pulse" + str(i))
          var br = webserver.arg("btn_repeat" + str(i))
          if bv != nil && bv != ""
            b["value"] = int(bv)
            b["bits"] = int(bb == nil || bb == "" ? "24" : bb)
            b["protocol"] = int(bp == nil || bp == "" ? "1" : bp)
            b["pulse_length"] = int(bl == nil || bl == "" ? "0" : bl)
            b["repeat"] = int(br == nil || br == "" ? "10" : br)
            if b["value"] > 0
              b["recorded"] = true
            end
          end
          i += 1
        end
        g.update_remote(id, {"name": name, "group": group, "icon": icon, "protocol": protocol, "value": value, "bits": bits, "pulse_length": pulse, "repeat": repeat, "note": note})
      end
      html += "<div class='card' style='text-align:center;color:var(--green);font-weight:600;'>已保存</div>"
      html += "<script>setTimeout(function(){window.location.href='/app/rf/manage';},1000);</script>"
      self.app_send_page("编辑设备", "管理", html)
      return
    end

    remote = g.find_remote(id)
    if remote == nil
      html += "<div class='card' style='text-align:center;color:var(--red);'>设备不存在</div>"
      self.app_send_page("编辑设备", "管理", html)
      return
    end
    if webserver.has_arg("created")
      html += "<div class='card' style='text-align:center;color:var(--green);font-weight:600;'>设备已创建，点击下方按钮开始录制</div>"
    elif webserver.has_arg("saved")
      html += "<div class='card' style='text-align:center;color:var(--green);font-weight:600;'>按钮已保存</div>"
    end
    html += f"<div class='sect'>{webserver.html_escape(remote['name'])}</div>"
    var btns = remote.find("buttons", [])
    if btns != nil && size(btns) > 0
      var done = 0
      for b : btns
        if b.find("recorded", false) || b.find("value", 0) > 0
          done += 1
        end
      end
      html += "<div class='sect'>按钮</div>"
      html += f"<div class='hintcard'>已录制 {done}/{size(btns)} · 点击按钮录制或重录，长按按钮编辑射频数据</div>"
      html += "<div class='grid3'>"
      var i = 0
      for b : btns
        var recorded = b.find("recorded", false) || b.find("value", 0) > 0
        var bg = recorded ? "var(--green)" : "var(--fill)"
        var fg = recorded ? "#fff" : "var(--blue)"
        html += f"<a class='sqcell' data-idx='{i}' href='/app/rf/edit?kind=remote&id={id}&learn=1&bid={b['id']}' onclick='return tileTap(this);'>"
        html += f"<div class='sqbtn' style='background:{bg};color:{fg};'>{self.icon_html(b.find('icon', remote.find('icon','remote')))}</div>"
        html += f"<div class='sqlbl'>{webserver.html_escape(b['name'])}</div></a>"
        i += 1
      end
      html += "</div>"
      html += "<script>"
      html += "var pressTimer=null,pressedBid=0,longFired=false;"
      html += "function tileTap(el){if(longFired){longFired=false;return false;}return true;}"
      html += "function pressStart(el){var idx=parseInt(el.getAttribute('data-idx'),10);pressedBid=idx;longFired=false;clearTimeout(pressTimer);pressTimer=setTimeout(function(){longFired=true;openRf(idx);},600);}"
      html += "function pressEnd(){clearTimeout(pressTimer);}"
      html += "document.querySelectorAll('.sqcell[data-idx]').forEach(function(el){el.addEventListener('contextmenu',function(e){e.preventDefault()});el.addEventListener('touchstart',function(e){pressStart(el)},{passive:true});el.addEventListener('touchend',function(e){pressEnd()});el.addEventListener('touchmove',function(e){clearTimeout(pressTimer)});el.addEventListener('mousedown',function(e){pressStart(el)});el.addEventListener('mouseup',function(e){pressEnd()});el.addEventListener('mouseleave',function(e){pressEnd()});});"
      html += "</script>"
    end
    html += "<form method='get' action='/app/rf/edit'>"
    html += "<input type='hidden' name='kind' value='remote'>"
    html += f"<input type='hidden' name='id' value='{id}'>"
    html += f"<input type='hidden' name='save' value='1'>"
    html += "<div class='formgrid'>"
    html += "<div><div class='sect'>名称</div><div class='card'><input name='name' value='" + webserver.html_escape(remote["name"]) + "' style='width:100%;border:none;font-size:14px;background:transparent;'></div></div>"
    html += "<div><div class='sect'>分组</div><div class='card'><input name='group' value='" + webserver.html_escape(remote["group"]) + "' style='width:100%;border:none;font-size:14px;background:transparent;'></div></div>"
    html += "<div><div class='sect'>编码值</div><div class='card'><input name='value' type='number' value='" + str(remote["value"]) + "' style='width:100%;border:none;font-size:14px;background:transparent;'></div></div>"
    html += "<div><div class='sect'>位数</div><div class='card'><input name='bits' type='number' value='" + str(remote["bits"]) + "' style='width:100%;border:none;font-size:14px;background:transparent;'></div></div>"
    html += "<div><div class='sect'>协议号</div><div class='card'><input name='protocol' type='number' value='" + str(remote["protocol"]) + "' style='width:100%;border:none;font-size:14px;background:transparent;'></div></div>"
    html += "<div><div class='sect'>脉宽</div><div class='card'><input name='pulse_length' type='number' value='" + str(remote["pulse_length"]) + "' style='width:100%;border:none;font-size:14px;background:transparent;'></div></div>"
    html += "<div><div class='sect'>重复次数</div><div class='card'><input name='repeat' type='number' value='" + str(remote["repeat"]) + "' style='width:100%;border:none;font-size:14px;background:transparent;'></div></div>"
    html += "<div class='full'><div class='sect'>备注</div><div class='card'><input name='note' value='" + webserver.html_escape(remote["note"]) + "' style='width:100%;border:none;font-size:14px;background:transparent;'></div></div>"
    html += "</div>"
    html += "<div class='sect'>设备图标</div>"
    html += "<div class='card'>" + self.icon_picker_html(self.icon_key(remote.find("icon","remote"))) + "</div>"
    html += "<script>" + self.icon_picker_js() + "</script>"
    if btns != nil && size(btns) > 0
      var i = 0
      for b : btns
        var bv = b.find("value", 0)
        var bb = b.find("bits", 24)
        var bp = b.find("protocol", 1)
        var bl = b.find("pulse_length", 0)
        var br = b.find("repeat", 10)
        html += f"<input type='hidden' name='btn_name{i}' value='{webserver.html_escape(b['name'])}'>"
        html += f"<input type='hidden' name='btn_icon{i}' value='{webserver.html_escape(b.find('icon','remote'))}'>"
        html += f"<input type='hidden' id='btn_value{i}' name='btn_value{i}' value='{bv}'>"
        html += f"<input type='hidden' id='btn_bits{i}' name='btn_bits{i}' value='{bb}'>"
        html += f"<input type='hidden' id='btn_protocol{i}' name='btn_protocol{i}' value='{bp}'>"
        html += f"<input type='hidden' id='btn_pulse{i}' name='btn_pulse{i}' value='{bl}'>"
        html += f"<input type='hidden' id='btn_repeat{i}' name='btn_repeat{i}' value='{br}'>"
        i += 1
      end
      html += "<div class='rfmask' id='rfmask' onclick='if(event.target===this)closeRf()'>"
      html += "<div class='rfbox'>"
      html += "<h3 id='rftitle'>射频数据</h3>"
      html += "<div style='font-size:12px;color:var(--secondary);'>修改后随设备表单一起保存</div>"
      html += "<div style='margin-top:12px;'><label style='display:block;font-size:11px;color:var(--secondary);margin-bottom:4px;'>按钮名称</label><input id='rf_name' type='text' style='width:100%;border:none;font-size:14px;background:var(--fill);border-radius:8px;padding:8px 10px;'></div>"
      html += "<div class='rfgrid'>"
      html += "<div class='rfld'><label>编码值</label><input id='rf_value' type='number'></div>"
      html += "<div class='rfld'><label>位数</label><input id='rf_bits' type='number'></div>"
      html += "<div class='rfld'><label>协议号</label><input id='rf_protocol' type='number'></div>"
      html += "<div class='rfld'><label>脉宽</label><input id='rf_pulse' type='number'></div>"
      html += "<div class='rfld'><label>重复次数</label><input id='rf_repeat' type='number'></div>"
      html += "</div>"
      html += "<div class='btns'><button class='btn gray' type='button' onclick='closeRf()'>取消</button><button class='btn blue' type='button' onclick='saveRf()'>保存</button></div>"
      html += "</div></div>"
      html += "<script>"
      import json
      var bdata = []
      var k = 0
      for b : btns
        bdata.push({"i": k, "name": b.find("name", "按钮" + str(b.find("id", k + 1))), "value": b.find("value", 0), "bits": b.find("bits", 24), "protocol": b.find("protocol", 1), "pulse": b.find("pulse_length", 0), "repeat": b.find("repeat", 10)})
        k += 1
      end
      html += "var BTNS=" + json.dump(bdata) + ";"
      html += "var RFIDX=-1;"
      html += "function openRf(i){RFIDX=i;var d=BTNS[RFIDX];if(!d)return;document.getElementById('rftitle').textContent=d.name+' · 射频数据';document.getElementById('rf_name').value=d.name;document.getElementById('rf_value').value=d.value;document.getElementById('rf_bits').value=d.bits;document.getElementById('rf_protocol').value=d.protocol;document.getElementById('rf_pulse').value=d.pulse;document.getElementById('rf_repeat').value=d.repeat;document.getElementById('rfmask').classList.add('open');}"
      html += "function closeRf(){document.getElementById('rfmask').classList.remove('open');}"
      html += "function saveRf(){if(RFIDX<0)return;var set=function(id){return document.getElementById(id).value};document.getElementById('btn_name'+RFIDX).value=set('rf_name');document.getElementById('btn_value'+RFIDX).value=set('rf_value');document.getElementById('btn_bits'+RFIDX).value=set('rf_bits');document.getElementById('btn_protocol'+RFIDX).value=set('rf_protocol');document.getElementById('btn_pulse'+RFIDX).value=set('rf_pulse');document.getElementById('btn_repeat'+RFIDX).value=set('rf_repeat');closeRf();}"
      html += "</script>"
    end
    html += "<button class='btn blue' type='submit'>保存</button>"
    html += "</form>"
    html += f"<a class='btn gray' href='/app/rf/view?id={id}'>测试发送</a>"
    html += f"<a class='btn gray' href='/app/api/rf/delete?kind=remote&id={id}'>删除遥控</a>"
    self.app_send_page("编辑设备", "管理", html)
  end

  # ============ 遥控管理列表（替代 /rf）============
  def handle_app_rf_manage()
    import webserver
    import string
    var g = gateway
    var html = ""
    html += "<a href='/app/rf' style='text-decoration:none;color:#007aff;font-size:13px;'>‹ 返回首页</a>"
    html += "<div class='sect'>设备管理</div>"
    html += "<a class='btn blue' href='/app/rf/record'>＋ 添加设备</a>"
    var search = ""
    if webserver.has_arg("search")
      search = webserver.arg("search")
    end
    var filter = webserver.arg("kind")
    if filter == nil filter = "" end
    html += "<form method='get' action='/app/rf/manage' style='margin:8px 0;'>"
    if filter != ""
      html += f"<input type='hidden' name='kind' value='{webserver.html_escape(filter)}'>"
    end
    html += f"<div class='card' style='display:flex;gap:8px;'><input name='search' placeholder='搜索名称/分组/位置' value='{webserver.html_escape(search)}' style='flex:1;border:none;font-size:14px;background:transparent;'><button type='submit'>🔍</button></div></form>"
    var count = 0
    for d : g.all_devices()
      if filter != "" && d["kind"] != filter
        continue
      end
      var matched = true
      if search != ""
        var lower = string.tolower(str(search))
        var hay = str(d["name"]) + " " + str(d.find("group", "")) + " " + str(d.find("location", ""))
        if string.find(string.tolower(hay), lower) < 0
          matched = false
        end
      end
      if matched
        count += 1
        html += "<div class='card cell'>"
        html += f"<div class='ic'>{self.icon_html(d['icon'])}</div>"
        html += f"<div class='tx'><div class='t1'>{webserver.html_escape(d['name'])}<span class='badge'>{d['type_label']}</span></div>"
        if d["kind"] == "remote"
          if d["button_count"] > 0
            var done = 0
            for b : d["buttons"]
              if b.find("recorded", false) || b.find("value", 0) > 0
                done += 1
              end
            end
            html += f"<div class='t2'>{done}/{d['button_count']} 已录制 · {webserver.html_escape(d['group'])}</div>"
          else
            html += f"<div class='t2'>P{d['protocol']} · {d['bits']}bit · {webserver.html_escape(d['group'])}</div>"
          end
        else
          var st = d["state"] == "OPEN" ? "开启" : "已关"
          html += f"<div class='t2'>{webserver.html_escape(d['location'])} · {d['code']} · {st}</div>"
        end
        html += "</div>"
        if d["kind"] == "remote"
          html += f"<a class='btn blue' style='padding:8px 12px;font-size:11px;margin:0;' href='/app/rf/view?id={d['id']}'>发送</a>"
        end
        html += f"<a class='btn gray' style='padding:8px 12px;font-size:11px;margin:0;' href='/app/rf/edit?kind={d['kind']}&id={d['id']}'>✎</a></div>"
      end
    end
    if count == 0
      html += "<div class='card' style='text-align:center;color:#8e8e93;font-size:12px;'>暂无设备</div>"
    end
    self.app_send_page("设备管理", "管理", html)
  end

  # ============ 删除遥控 API ============
  def handle_app_api_rf_delete()
    import webserver
    var g = gateway
    var kind = webserver.arg("kind")
    if kind == nil kind = "remote" end
    var id = int(webserver.arg("id"))
    g.delete_device(kind, id)
    webserver.redirect("/app/rf/manage")
  end

  # ============ 门磁管理列表（替代 /door）============
  def handle_app_door_manage()
    import webserver
    webserver.redirect("/app/rf/manage?kind=door")
  end

  # ============ 门磁配对+编辑（替代 /door/edit）============
  def handle_app_door_edit()
    import webserver
    var id = int(webserver.arg("id"))
    if id == nil id = 0 end
    self.handle_app_device_edit("door", id)
  end

  # ============ 删除门磁 API ============
  def handle_app_api_door_delete()
    import webserver
    var g = gateway
    var id = int(webserver.arg("id"))
    g.delete_door(id)
    webserver.redirect("/app/rf/manage")
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
    webserver.content_send("<p><button onclick='window.location.href=\"/app/rf\";'>RF Gateway</button></p>")
  end

  def web_add_handler()
    import webserver
    webserver.on("/app", / -> self.handle_app_page_root())
    webserver.on("/app/app.css", / -> self.handle_app_css_page())
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
    webserver.on("/app/api/rf/stop", / -> self.handle_app_api_rf_stop())
    webserver.on("/app/api/rf/delete", / -> self.handle_app_api_rf_delete())
    webserver.on("/app/api/door/delete", / -> self.handle_app_api_door_delete())
  end
end

var webapp = Cc1101WebApp()
tasmota.add_driver(webapp)

return webapp
