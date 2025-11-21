extends TouchScreenButton

@export var texture: Texture2D
@export var inactive_color: Color
@export var active_color: Color

func _ready() -> void:
	$TextureRect.texture = texture
	$TextureRect/CanvasModulate.color = inactive_color

func _on_pressed() -> void:
	$TextureRect/CanvasModulate.color = active_color

func _on_released() -> void:
	$TextureRect/CanvasModulate.color = inactive_color
