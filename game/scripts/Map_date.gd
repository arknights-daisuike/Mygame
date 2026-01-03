extends Node2D

# ====================
# 地图核心数据（你的设计）
# ====================

# 地形类型：0=地面，1=高台
var terrain = [
	[1,1,1,1,1,0,0,0],
	[0,0,0,0,0,0,0,0],
	[0,1,1,1,1,0,1,0],
	[0,0,0,0,0,0,0,0],
	[0,0,0,1,1,1,1,1]
]

# 部署状态：0=可部署，1=不可部署
var state = [
	[0,0,0,0,0,1,1,1],
	[0,0,0,0,0,0,0,0],
	[1,0,0,0,0,1,0,1],
	[0,0,0,0,0,0,0,0],
	[1,1,1,0,0,0,0,0]
]

# ====================
# 配置参数
# ====================
var CELL_SIZE = 64  # 每个格子64x64像素
var GRID_OFFSET = Vector2(32, 32)  # 地图左上角偏移

# 当前选中的格子
var selected_cell = null

# ====================
# 初始化
# ====================
func _ready():
	print("🟢 地图数据脚本加载成功！")
	print_map_summary()
	
	# 获取TileMap节点并通知它更新
	var tilemap = $GridDisplay
	if tilemap and tilemap.has_method("update_map"):
		tilemap.update_map()

# ====================
# 数据获取方法
# ====================
func get_terrain(x, y):
	"""获取指定位置的terrain值"""
	if x >= 0 and x < 5 and y >= 0 and y < 8:
		return terrain[x][y]
	return -1  # 无效位置

func get_state(x, y):
	"""获取指定位置的state值"""
	if x >= 0 and x < 5 and y >= 0 and y < 8:
		return state[x][y]
	return -1  # 无效位置

func is_deployable(x, y):
	"""检查格子是否可部署"""
	if x >= 0 and x < 5 and y >= 0 and y < 8:
		return state[x][y] == 0
	return false

func is_ground(x, y):
	"""检查是否是地面"""
	if x >= 0 and x < 5 and y >= 0 and y < 8:
		return terrain[x][y] == 0
	return false

func is_platform(x, y):
	"""检查是否是高台"""
	if x >= 0 and x < 5 and y >= 8:
		return terrain[x][y] == 1
	return false

# ====================
# 坐标转换
# ====================
func screen_to_grid(screen_pos):
	"""
	将屏幕坐标转换为网格坐标
	
	公式：
	grid_x = (screen_x - offset_x) / cell_size
	grid_y = (screen_y - offset_y) / cell_size
	"""
	
	# 先减去偏移
	var local_pos = screen_pos - GRID_OFFSET
	
	# 除以格子大小
	var grid_x = int(local_pos.x / CELL_SIZE)
	var grid_y = int(local_pos.y / CELL_SIZE)
	
	# 调试输出
	print("坐标转换调试:")
	print("  点击位置:", screen_pos)
	print("  减去偏移后:", local_pos)
	print("  计算出的网格坐标: (", grid_x, ",", grid_y, ")")
	
	# 检查边界
	if grid_x >= 0 and grid_x < 5 and grid_y >= 0 and grid_y < 8:
		print("  ✅ 在网格内")
		return Vector2(grid_x, grid_y)
	else:
		print("  ❌ 超出网格范围")
		return null
# ====================
# 调试方法
# ====================
func print_map_summary():
	"""打印地图摘要"""
	print("=== 地图信息 ===")
	print("尺寸: 5×8 格")
	print("格子大小: ", CELL_SIZE, "像素")
	print("总格子数: ", 5*8)
	
	# 统计信息
	var ground_count = 0
	var platform_count = 0
	var deployable_count = 0
	var blocked_count = 0
	
	for x in range(5):
		for y in range(8):
			if terrain[x][y] == 0:
				ground_count += 1
			else:
				platform_count += 1
				
			if state[x][y] == 0:
				deployable_count += 1
			else:
				blocked_count += 1
	
	print("地面格子: ", ground_count)
	print("高台格子: ", platform_count)
	print("可部署格子: ", deployable_count)
	print("不可部署格子: ", blocked_count)
	
	# 特殊点
	print("特殊点:")
	print("  保护点 (2,0): ", "不可部署" if state[2][0] == 1 else "可部署")
	print("  生成点 (2,7): ", "不可部署" if state[2][7] == 1 else "可部署")

func print_cell_info(x, y):
	"""打印指定格子的详细信息"""
	if x >= 0 and x < 5 and y >= 0 and y < 8:
		var terrain_str = "高台" if terrain[x][y] == 1 else "地面"
		var state_str = "可部署" if state[x][y] == 0 else "不可部署"
		var special = ""
		
		if x == 2 and y == 0:
			special = " (我方保护点)"
		elif x == 2 and y == 7:
			special = " (敌方生成点)"
		
		print("格子 (", x, ",", y, "): ", terrain_str, " - ", state_str, special)
	else:
		print("无效坐标: (", x, ",", y, ")")

# ====================
# 选中操作
# ====================
func select_cell(x, y):
	"""选中一个格子"""
	if x >= 0 and x < 5 and y >= 0 and y < 8:
		selected_cell = Vector2(x, y)
		print("✅ 选中格子 (", x, ",", y, ")")
		print_cell_info(x, y)
		return true
	return false

func clear_selection():
	"""清除选中"""
	selected_cell = null
	print("清除选中")
