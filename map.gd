class_name Map
extends CanvasLayer

@onready var top: Top = get_tree().root.get_node("Top")
var active_map_room: MapRoom

func _ready():
	hide_map()

func set_active_name(map_room_name: String):
	if active_map_room: active_map_room.unhighlight()

	active_map_room = get_node_or_null(map_room_name)

	if active_map_room: active_map_room.highlight()

func show_map():
	visible = true
	$UnpauseButton.mouse_filter = Control.MOUSE_FILTER_STOP
	
func hide_map():
	visible = false
	$UnpauseButton.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_unpause_button_pressed() -> void:
	Input.action_press("menu")
