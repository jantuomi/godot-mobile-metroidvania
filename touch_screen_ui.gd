extends CanvasLayer

@export var desktop_visible: bool

func _ready() -> void:
	if not DisplayServer.is_touchscreen_available():
		visible = desktop_visible
