@tool
class_name Door
extends Area2D

@onready var top: Top = get_tree().root.get_node("Top")

@export var target_room: String:
	set(v):
		target_room = v
		update_configuration_warnings()

@export var target_door: String:
	set(v):
		target_door = v
		update_configuration_warnings()

@export_enum("LEFT", "RIGHT", "JUMP_LEFT", "JUMP_RIGHT", "DROP") var exit_towards: String
@export_enum("LEFT", "RIGHT", "JUMP", "DROP") var enter_towards: String

func _ready():
	update_configuration_warnings()

func _on_body_entered(_player: Player) -> void:
	top.room_transition(self, to_room_path(target_room), target_door)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	var room_path: String
	if target_room:
		room_path = to_room_path(target_room)
	if not target_room:
		warnings.append("target_room is not defined")
	elif not ResourceLoader.exists(room_path):
		warnings.append("target_room \"%s\" does not exist" % room_path)

	if not target_door:
		warnings.append("target_door is not defined")
	elif target_room:
		var packed: PackedScene = ResourceLoader.load(room_path)
		var state = packed.get_state()
		var found = false
		for idx in range(state.get_node_count()):
			if state.get_node_name(idx) == target_door:
				found = true
				break
		if not found:
			warnings.append("target_door \"%s\" does not exist in the target room" % target_door)

	return warnings

func to_room_path(room_name: String):
	return "res://room_" + room_name + ".tscn"
