class_name Top
extends Node2D

@export var initial_room: PackedScene
var save_state_path = "user://save_state.cfg"
var save_state = ConfigFile.new()

## Should objects like the Player react to input, and enemies move
var objects_active = true

var _transition_room: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var room = initial_room.instantiate()
	room.name = "active_room"
	room.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(room)
	
	# Testing
	save_state.load(save_state_path)
	print("loaded test_item: ", save_state.get_value("items", "test_item"))
	save_state.set_value("items", "test_item", true)
	save_state.save(save_state_path)
	print(OS.get_data_dir())

func transition_to_room(room_name: String):
	# Do not transition if there is already a transition in process
	if _transition_room != null:
		print_debug("Tried to transition to ", room_name, " but a transition was already in process")
		return

	# Start animation
	# The animation calls _change_room at a specific time
	$TransitionCanvas/AnimationPlayer.play("room_trans_start")
	objects_active = false

	var room = ResourceLoader.load("res://room_" + room_name + ".tscn")
	_transition_room = room.instantiate()

func _transition_start():
	print_debug("_transition_start")
	var current_room = get_node("active_room")
	remove_child(current_room)
	current_room.queue_free()
	
	# If the room hasn't loaded yet, loop until it is
	while _transition_room == null:
		await get_tree().create_timer(0.1).timeout

	var next_room: Node = _transition_room
	next_room.name = "active_room"
	next_room.connect("ready", _on_room_changed)
	add_child(next_room)
	
func _on_room_changed():
	print_debug("_on_room_changed")
	$TransitionCanvas/AnimationPlayer.play("room_trans_end")
	
func _transition_end():
	print_debug("_transition_end")
	objects_active = true
	_transition_room = null

func save():
	save_state.save("user://save_state.cfg")
