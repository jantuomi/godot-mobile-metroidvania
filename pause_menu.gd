class_name PauseMenu
extends CanvasLayer

var active_map_room: MapRoom

func _ready():
	deactivate()

func set_room_name(map_room_name: String):
	if active_map_room: active_map_room.unhighlight()

	active_map_room = $Map.get_node_or_null(map_room_name)

	if active_map_room:
		active_map_room.highlight()
		var pos = active_map_room.position
		var size = get_viewport().get_visible_rect().size
		var delta = Vector2(size.x / 2, size.y / 2)
		$Map.position = -pos + delta - active_map_room.size / 2

func activate():
	visible = true
	get_tree().call_group("ui_movement", "set_visible", false)
	
func deactivate():
	visible = false
	get_tree().call_group("ui_movement", "set_visible", true)
