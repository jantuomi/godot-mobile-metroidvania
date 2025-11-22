extends TouchScreenButton

@export var texture: Texture2D
@export var inactive_color: Color
@export var active_color: Color

func _ready() -> void:
	connect("pressed", _on_pressed)
	connect("released", _on_released)
	$TextureRect.texture = texture
	$TextureRect.modulate = inactive_color

func _on_pressed() -> void:
	$TextureRect.modulate = active_color

func _on_released() -> void:
	$TextureRect.modulate = inactive_color
