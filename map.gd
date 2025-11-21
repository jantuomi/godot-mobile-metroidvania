class_name Map
extends CanvasLayer

var active_map_room: MapRoom

@export var inactive_color: Color
@export var active_color: Color

func set_active_name(map_room_name: String):
	if active_map_room:
		active_map_room.color = inactive_color

	if has_node(map_room_name):
		active_map_room = get_node(map_room_name)
	else:
		active_map_room = null

	if active_map_room:
		active_map_room.color = active_color
