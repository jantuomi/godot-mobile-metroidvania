@tool
class_name Door
extends Area2D

@onready var transition_manager: TransitionManager = get_tree().root.get_node("Top/TransitionManager")

var _target_room: Variant
var _target_door: Variant

@export_enum("LEFT", "RIGHT", "JUMP_LEFT", "JUMP_RIGHT", "DROP") var exit_towards: String
@export_enum("LEFT", "RIGHT", "JUMP", "DROP") var enter_towards: String

func _set(property, val):
	if property == "target_room":
		_target_room = val
		if not ResourceLoader.exists(_target_room):
			_target_door = null
		update_configuration_warnings()
		notify_property_list_changed()
	elif property == "target_door":
		_target_door = val
		update_configuration_warnings()
		notify_property_list_changed()
	
func _get(property):
	if property == "target_room":
		return _target_room
	elif property == "target_door":
		return _target_door

func _on_body_entered(_player: Player) -> void:
	if not Engine.is_editor_hint():
		transition_manager.room_transition(self, _target_room, _target_door)
	
func _get_property_list() -> Array[Dictionary]:
	var rooms: PackedStringArray = []
	for res_name in ResourceLoader.list_directory("."):
		if res_name.begins_with("room_") and res_name.ends_with(".tscn"):
			rooms.append("res://" + res_name)
	
	var props: Array[Dictionary] = [{
		"name": "target_room",
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": ",".join(rooms)
	}]
	if _target_room and _target_room != "":
		var options: PackedStringArray = []
		if not ResourceLoader.exists(_target_room): return props
		var packed: PackedScene = ResourceLoader.load(_target_room)
		var state = packed.get_state()
		for idx in range(state.get_node_count()):
			var node_name = state.get_node_name(idx)
			if node_name.begins_with("Door"):
				options.append(node_name)
			
		#print(options)
		props.append({
			"name": "target_door",
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": ",".join(options)
		})

	return props

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []

	if not _target_room:
		warnings.append("target_room is not defined")
	
	if not _target_door:
		warnings.append("target_door is not defined")

	return warnings
