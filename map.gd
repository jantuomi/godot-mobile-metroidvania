class_name Map
extends CanvasLayer

@onready var top: Top = get_tree().root.get_node("Top")
var active_map_room: MapRoom

@export var inactive_color: Color
@export var active_color: Color

func _ready():
	hide_map()

func set_active_name(map_room_name: String):
	if active_map_room:
		active_map_room.color = inactive_color

	if has_node(map_room_name):
		active_map_room = get_node(map_room_name)
	else:
		active_map_room = null

	if active_map_room:
		active_map_room.color = active_color

func connect_close_map(callable: Callable):
	$UnpauseButton.connect("pressed", callable)

func show_map():
	visible = true
	$UnpauseButton.mouse_filter = Control.MOUSE_FILTER_STOP
	
func hide_map():
	visible = false
	$UnpauseButton.mouse_filter = Control.MOUSE_FILTER_IGNORE
