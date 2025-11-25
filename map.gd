class_name Map
extends CanvasLayer

var active_map_room: MapRoom

func _ready():
	hide_map()

func set_active_name(map_room_name: String):
	if active_map_room: active_map_room.unhighlight()

	active_map_room = get_node_or_null("Rooms/" + map_room_name)

	if active_map_room:
		active_map_room.highlight()
		var pos = active_map_room.position
		var size = get_viewport().get_visible_rect().size
		var delta = Vector2(size.x / 2, size.y / 2)
		$Rooms.position = -pos + delta - active_map_room.size / 2
		#$Rooms.position = -pos + Vector2(10, 10)

func show_map():
	visible = true
	get_tree().call_group("ui_movement", "set_visible", false)
	
func hide_map():
	visible = false
	get_tree().call_group("ui_movement", "set_visible", true)
