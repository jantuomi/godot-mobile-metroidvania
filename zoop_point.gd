class_name ZoopPoint
extends Node2D

@export_enum("left", "right") var orientation: String

func _ready():
	if orientation == "left":
		$Sprite2D.rotation_degrees = 270
	elif orientation == "right":
		$Sprite2D.rotation_degrees = 90
	else:
		assert(false, "invalid orientation")

func _camera_target() -> Vector2:
	var off: Vector2
	if orientation == "left": off = Vector2(-20, 0)
	elif orientation == "right": off = Vector2(20, 0)
	else: assert(false, "invalid orientation")

	return global_position + off
