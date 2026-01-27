class_name MapRoom
extends ColorRect

@export var inactive_color: Color
@export var active_color: Color

@onready var pi: TextureRect = $PlayerIcon;

func _ready():
	unhighlight()
	
	pi.position = get_rect().size / 2 - pi.get_rect().size / 2 - Vector2(0, 1.1)

func highlight():
	color = active_color
	$PlayerIcon.visible = true

func unhighlight():
	color = inactive_color
	$PlayerIcon.visible = false
