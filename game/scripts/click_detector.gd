extends Area2D

# 引用地图数据
var map_data = null

func _ready():
	print("🟢 ClickDetector脚本加载")
	
	# 获取地图数据
	map_data = get_parent()
	
	# 在代码中正确创建碰撞形状
	setup_collision_shape()

func setup_collision_shape():
	"""正确设置碰撞形状"""
	# 删除已有的碰撞形状节点（如果有）
	for child in get_children():
		if child is CollisionShape2D:
			child.queue_free()
	
	# 创建新的碰撞形状
	var collision_shape = CollisionShape2D.new()
	
	# 创建形状资源并赋值
	var rectangle = RectangleShape2D.new()
	rectangle.extents = Vector2(160, 256)  # 5×8格子的一半大小
	
	# 正确设置形状
	collision_shape.shape = rectangle
	
	# 添加到节点
	add_child(collision_shape)
	
	print("碰撞区域已创建，大小:", rectangle.extents * 2)
	
	# 设置位置居中
	collision_shape.position = rectangle.extents
	
	# 连接信号（重要！）
	connect("input_event", self, "_on_input_event")

func _on_input_event(viewport, event, shape_idx):
	"""处理鼠标点击事件"""
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_LEFT:  # 左键点击
			var click_pos = get_global_mouse_position()
			print("点击位置:", click_pos)
			
			var grid_pos = map_data.screen_to_grid(click_pos)
			
			if grid_pos:
				print("✅ 点击格子 (", grid_pos.x, ",", grid_pos.y, ")")
				
				# 获取格子信息
				var terrain = map_data.get_terrain(grid_pos.x, grid_pos.y)
				var state = map_data.get_state(grid_pos.x, grid_pos.y)
				
				var terrain_str = "高台" if terrain == 1 else "地面"
				var state_str = "可部署" if state == 0 else "不可部署"
				
				print("地形:", terrain_str)
				print("状态:", state_str)
				
				# 特殊点识别
				if grid_pos.x == 2 and grid_pos.y == 0:
					print("⚠️ 这是我方保护点！")
				elif grid_pos.x == 2 and grid_pos.y == 7:
					print("⚠️ 这是敌方生成点！")
				
				# 选中格子
				map_data.select_cell(grid_pos.x, grid_pos.y)
			else:
				print("❌ 点击了地图外区域")
