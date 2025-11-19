class_name Top
extends Node2D

@export var initial_room: PackedScene
var save_state_path = "user://save_state.cfg"
var save_state = ConfigFile.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var room = initial_room.instantiate()
	add_child(room)
	
	# Testing
	save_state.load(save_state_path)
	print("loaded test_item: ", save_state.get_value("items", "test_item"))
	save_state.set_value("items", "test_item", true)
	save_state.save(save_state_path)
	print(OS.get_data_dir())


func change_room(room_name: String):
	var room = ResourceLoader.load("res://room_" + room_name + ".tscn")
	var current_room = get_child(0)
	remove_child(current_room)
	
	var next_room = room.instantiate()
	add_child(next_room)

func save():
	save_state.save("user://save_state.cfg")
