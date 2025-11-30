extends Camera2D

## Amount to smoothly offset the camera if the parent is a Player.
@export var offset_amt: Vector2

@onready var tree: SceneTree = get_tree()

func _ready() -> void:
	if not position_smoothing_enabled:
		await get_tree().create_timer(0.1).timeout
		position_smoothing_enabled = true

func _process(_delta: float) -> void:
	var pos: Vector2 = Vector2.ZERO
	var n = 0

	var targets = tree.get_nodes_in_group("camera_target")
	if targets.size() == 0: return

	for target in targets:
		if target is Player:
			var player: Player = target
			var oy: float = 0
			if not player.is_on_floor():
				oy = offset_amt.y
			pos += Vector2(player.global_position.x + player.get_facing() * offset_amt.x,
						   player.global_position.y + oy)
		elif target is Node2D:
			var node2d: Node2D = target
			pos += node2d.global_position
		else:
			assert(false, "camera_target node is invalid")

		n += 1

	global_position = pos / n
