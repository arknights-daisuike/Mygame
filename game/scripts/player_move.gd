extends Sprite  # Godot 3中Sprite节点这样继承

# 移动速度（像素/秒）
var speed = 500

# _process函数：每帧自动调用，delta是上一帧到现在的时间（秒）
func _process(delta):
	# 每帧向右移动：距离 = 速度 × 时间
	position.x += speed * delta
	
	# 如果移出屏幕右边，回到左边（可选）
	if position.x > 1000:  # 1000是假设的屏幕宽度
		position.x = 0
