extends TouchScreenButton

@export var texture: Texture2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TextureRect.texture = texture
	if not DisplayServer.is_touchscreen_available():
		visible = false
		#visible = true
