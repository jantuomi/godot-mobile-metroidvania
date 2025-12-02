class_name HookHanging
extends Sprite2D

@export var hang_distance: float

func _camera_target() -> Vector2:
	return global_position + Vector2(0, 20)
