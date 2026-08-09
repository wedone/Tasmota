import os
from playwright.sync_api import sync_playwright

BASE = "http://10.0.0.165"
SHOT = "d:/VC/Tasmota/webui_shots"
os.makedirs(SHOT, exist_ok=True)

with sync_playwright() as p:
    browser = p.chromium.launch(headless=True, channel="msedge")
    page = browser.new_page(viewport={"width": 390, "height": 844})
    logs = []
    page.on("console", lambda m: logs.append(f"{m.type}: {m.text}"))
    page.on("pageerror", lambda e: logs.append(f"PAGEERROR: {e}"))

    results = []

    # 1. 首页
    page.goto(BASE + "/", timeout=15000)
    page.wait_for_load_state("networkidle")
    page.wait_for_timeout(500)
    page.screenshot(path=f"{SHOT}/10_home.png", full_page=True)
    hd = page.locator(".app-hd h1").inner_text()
    results.append(f"首页标题: {hd}")
    results.append(f"首页遥控数量: {page.locator('.hkbtn').count()}")
    results.append(f"首页虚拟设备数量: {page.locator('.hkbtn').count()}")

    # 2. 点击遥控进入子界面（如果有遥控）
    if page.locator("a[href*='/app/rf/view']").count() > 0:
        page.locator("a[href*='/app/rf/view']").first.click()
        page.wait_for_load_state("networkidle")
        page.wait_for_timeout(500)
        page.screenshot(path=f"{SHOT}/11_rf_view.png", full_page=True)
        results.append("遥控子界面: 打开成功")
        # 3. 点击发送按钮
        send_links = page.locator("a[href*='/app/api/send']")
        results.append(f"发送按钮数量: {send_links.count()}")
        if send_links.count() > 0:
            send_links.first.click()
            page.wait_for_timeout(1500)
            results.append("点击发送: 完成(触发RF)")
            page.goto(BASE + "/app/event", timeout=15000)
            page.wait_for_load_state("networkidle")
            page.wait_for_timeout(400)
            body = page.inner_text("body")
            results.append(f"事件页含send事件: {'send' in body or '发送' in body}")
            page.screenshot(path=f"{SHOT}/12_event_after_send.png", full_page=True)
    else:
        results.append("无遥控(跳过子界面测试)")

    # 4. 场景页运行序列
    page.goto(BASE + "/app/seq", timeout=15000)
    page.wait_for_load_state("networkidle")
    page.wait_for_timeout(400)
    page.screenshot(path=f"{SHOT}/13_seq.png", full_page=True)
    run_links = page.locator("a[href*='/app/api/seqrun?name=']")
    results.append(f"场景运行按钮: {run_links.count()}")
    if run_links.count() > 0:
        run_links.first.click()
        page.wait_for_timeout(1500)
        results.append("点击运行场景: 完成")

    # 5. 场景编辑器交互: 添加步骤 + 保存
    page.goto(BASE + "/app/seq/edit?name=new", timeout=15000)
    page.wait_for_load_state("networkidle")
    page.wait_for_timeout(400)
    page.screenshot(path=f"{SHOT}/14_seq_edit.png", full_page=True)
    # 点击第一个遥控添加 send 步骤
    remote_cells = page.locator("#remotes .hkbtn")
    results.append(f"编辑器遥控可选项: {remote_cells.count()}")
    if remote_cells.count() > 0:
        remote_cells.first.click()
        page.wait_for_timeout(300)
        steps_html = page.locator("#steps").inner_text()
        results.append(f"添加send步骤后步骤区: {steps_html.strip()[:40]}")
        # 添加延时
        page.locator("button:has-text('延时')").click()
        page.wait_for_timeout(300)
        page.screenshot(path=f"{SHOT}/15_seq_edit_steps.png", full_page=True)

    # 6. 虚拟设备页
    page.goto(BASE + "/app/vdev", timeout=15000)
    page.wait_for_load_state("networkidle")
    page.wait_for_timeout(400)
    page.screenshot(path=f"{SHOT}/16_vdev.png", full_page=True)

    for r in results:
        print(r)
    print("--- console ---")
    for l in logs[:15]:
        print(l)
    browser.close()
