import sys
from playwright.sync_api import sync_playwright

BASE = "http://10.0.0.165"
SHOT = "d:/VC/Tasmota/webui_shots"

import os
os.makedirs(SHOT, exist_ok=True)

with sync_playwright() as p:
    browser = p.chromium.launch(headless=True, channel="msedge")
    page = browser.new_page(viewport={"width": 390, "height": 844})
    logs = []
    page.on("console", lambda m: logs.append(f"{m.type}: {m.text}"))
    page.on("pageerror", lambda e: logs.append(f"PAGEERROR: {e}"))

    results = []

    def check(tag, cond):
        results.append(f"{tag}: {'PASS' if cond else 'FAIL'}")

    page.goto(BASE + "/", timeout=15000)
    page.wait_for_load_state("networkidle")
    page.wait_for_timeout(800)
    page.screenshot(path=f"{SHOT}/01_home.png", full_page=True)

    title = page.title()
    check("title是App标题(非Tasmota原生)", "Tasmota" not in title and title != "")
    check("有app-hd", page.locator(".app-hd").count() > 0)
    check("有app-tab底部栏", page.locator(".app-tab").count() > 0)
    check("无原生菜单(m类表格)", page.locator("table.m, .p, #main").count() == 0)

    body_bg = page.evaluate("getComputedStyle(document.body).backgroundColor")
    body_font = page.evaluate("getComputedStyle(document.body).fontFamily")
    results.append(f"body背景色: {body_bg}")
    results.append(f"body字体: {body_font}")

    # 是否有原生JS脚本残留(全局变量)
    has_native_js = page.evaluate("typeof jd !== 'undefined' || typeof qs !== 'undefined'")
    results.append(f"原生JS残留(jd/qs): {has_native_js}")

    # 检查原生CSS是否覆盖了我们的样式
    hd_color = page.evaluate("() => { const el = document.querySelector('.app-hd h1'); return el ? getComputedStyle(el).fontSize : 'none' }")
    results.append(f"app-hd h1字号: {hd_color}")

    # 各 Tab 截图
    for name, path in [("seq", "02_seq"), ("door", "03_door"), ("event", "04_event"), ("manage", "05_manage"), ("vdev", "06_vdev")]:
        page.goto(BASE + f"/app/{name}", timeout=15000)
        page.wait_for_load_state("networkidle")
        page.wait_for_timeout(600)
        page.screenshot(path=f"{SHOT}/{path}.png", full_page=True)

    # 场景编辑器
    page.goto(BASE + "/app/seq/edit?name=new", timeout=15000)
    page.wait_for_load_state("networkidle")
    page.wait_for_timeout(600)
    page.screenshot(path=f"{SHOT}/07_seq_edit.png", full_page=True)
    check("编辑器有遥控网格", page.locator("#remotes").count() > 0)

    # 遥控子界面(需要遥控存在)
    page.goto(BASE + "/app/rf", timeout=15000)
    page.wait_for_load_state("networkidle")
    page.wait_for_timeout(600)

    for r in results:
        print(r)
    print("--- console日志 ---")
    for l in logs[:30]:
        print(l)
    print(f"--- 截图已保存到 {SHOT} ---")
    browser.close()
