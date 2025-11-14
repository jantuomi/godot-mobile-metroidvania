extends TouchScreenButton

@export var texture: Texture2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TextureRect.texture = texture
	if not DisplayServer.is_touchscreen_available():
		visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
