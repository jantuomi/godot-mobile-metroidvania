class_name Top
extends Node2D

@export var initial_room: PackedScene
var save_state_path = "user://save_state.cfg"
var save_state = ConfigFile.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var room = initial_room.instantiate()
	room.name = "active_room"
	add_child(room)
	
	# Testing
	save_state.load(save_state_path)
	print("loaded test_item: ", save_state.get_value("items", "test_item"))
	save_state.set_value("items", "test_item", true)
	save_state.save(save_state_path)
	print(OS.get_data_dir())

var _transition_room: Node

func transition_to_room(room_name: String):
	# Start animation
	# The animation calls _change_room at a specific time
	$TransitionCanvas/AnimationPlayer.play("room_transition")

	var room = ResourceLoader.load("res://room_" + room_name + ".tscn")
	_transition_room = room.instantiate()

func _change_room():
	var current_room = get_node("active_room")
	remove_child(current_room)
	
	var next_room: Node = _transition_room
	next_room.name = "active_room"
	add_child(next_room)
	
	_transition_room = null

func save():
	save_state.save("user://save_state.cfg")
