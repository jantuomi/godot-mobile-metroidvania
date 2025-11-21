class_name MapRoom
extends ColorRect

@export var inactive_color: Color
@export var active_color: Color

func _ready():
	unhighlight()

func highlight():
	color = active_color
	$PlayerIcon.visible = true

func unhighlight():
	color = inactive_color
	$PlayerIcon.visible = false
