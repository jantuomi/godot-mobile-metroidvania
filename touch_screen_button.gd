extends TouchScreenButton

@export var texture: Texture2D
@export var desktop_visible: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TextureRect.texture = texture
	if not DisplayServer.is_touchscreen_available():
		visible = desktop_visible
