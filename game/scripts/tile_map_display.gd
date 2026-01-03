# scripts/grid_display.gd
extends TileMap

# 引用地图数据
var map_data = null

func _ready():
	print("🟢 GridDisplay脚本加载")
	
	# 获取父节点（Map）的数据
	map_data = get_parent()
	
	# 设置格子大小
	cell_size = Vector2(64, 64)
	
	# 更新地图显示
	update_map()

func update_map():
	"""根据地数据更新显示"""
	if not map_data:
		print("❌ 没有地图数据")
		return
	
	print("开始绘制地图...")
	
	# 清除之前的显示
	clear()
	
	# 遍历所有格子
	for x in range(5):
		for y in range(8):
			# 获取地形和状态
			var terrain_type = map_data.get_terrain(x, y)
			var cell_state = map_data.get_state(x, y)
			
			# 计算tile_id
			var tile_id = calculate_tile_id(terrain_type, cell_state)
			
			# 设置格子
			set_cell(x, y, tile_id)
			
			# 调试输出前几个格子
			if x < 2 and y < 2:
				print("  格子(", x, ",", y, "): ", 
					  "地形=", terrain_type,
					  " 状态=", cell_state,
					  " tile_id=", tile_id)

func calculate_tile_id(terrain, state):
	"""
	根据地形和状态计算tile_id
	
	规则:
	- 地形0(地面) + 状态0(可部署)   -> tile_id 0 (地面格.png)
	- 地形0(地面) + 状态1(不可部署) -> tile_id 1 (地面格不可部署.png)
	- 地形1(高台) + 状态0(可部署)   -> tile_id 2 (高台格.png)
	- 地形1(高台) + 状态1(不可部署) -> tile_id 3 (高台格不可部署.png)
	"""
	if terrain == 0:  # 地面
		return 0 if state == 0 else 1
	else:  # 高台
		return 2 if state == 0 else 3

# 鼠标悬停效果（可选）
func highlight_cell(x, y, highlight=true):
	"""高亮显示一个格子"""
	if highlight:
		# 暂时用设置modulate的方式
		# 实际可以用另一个layer或者修改颜色
		set_cell(x, y, 0)  # 暂时用id 0
	else:
		# 恢复原来的tile
		update_map()
