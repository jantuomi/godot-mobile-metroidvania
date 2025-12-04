class_name GameCamera
extends Camera2D

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
		if target.has_method("_camera_target"):
			pos += target._camera_target()
		else:
			pos += target.global_position
		n += 1

	global_position = pos / n
