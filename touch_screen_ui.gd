extends CanvasLayer

func _ready() -> void:
	var screen = %GameCamera.get_screen_center_position()
	var view = get_viewport().get_screen_transform()
	# todo
