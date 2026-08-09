# CC1101 Gateway 驱动自动加载脚本
# 设备启动时执行，加载 433MHz 网关驱动
import path
if path.exists('/cc1101_gateway.be')
  try
    load('/cc1101_gateway.be')
    log("CC1: Gateway driver loaded", 2)
  except
    log("CC1: Failed to load cc1101_gateway.be", 3)
  end
end
if path.exists('/cc1101_webapp.be')
  try
    load('/cc1101_webapp.be')
    log("CC1: WebApp driver loaded", 2)
  except
    log("CC1: Failed to load cc1101_webapp.be", 3)
  end
end
