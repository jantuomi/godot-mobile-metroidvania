class_name PauseMenuMap
extends PauseMenuPage

var active_map_room: MapRoom

func _on_tree_entered() -> void:
	if active_map_room:
		active_map_room.highlight()
		var pos = active_map_room.position
		var size = get_viewport().get_visible_rect().size
		var delta = Vector2(size.x / 2, size.y / 2)
		position = -pos + delta - active_map_room.size / 2

func set_room_name(n: String):
	if active_map_room: active_map_room.unhighlight()
	active_map_room = get_node_or_null(n)
