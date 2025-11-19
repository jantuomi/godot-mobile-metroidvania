class_name Top
extends Node2D

@export var initial_room: PackedScene
var save_state_path = "user://save_state.cfg"
var save_state = ConfigFile.new()

var _transition_room: Node
var _transition_door_name: Variant # String or null

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
	
func is_transitioning() -> bool:
	return _transition_room != null

func transition_to_room(room_path: String, door_name: Variant):
	# Do not transition if there is already a transition in process
	if _transition_room != null:
		#print_debug("Tried to transition to ", room_name, " but a transition was already in process")
		return

	# Start animation
	# The animation calls _change_room at a specific time
	$TransitionCanvas/AnimationPlayer.play("room_trans_start")

	var room = ResourceLoader.load(room_path)
	_transition_room = room.instantiate()
	_transition_door_name = door_name

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
	#next_room.connect("ready", _on_room_changed)
	next_room.connect("tree_entered", _on_room_changed)
	next_room.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(next_room)
	
func _on_room_changed():
	print_debug("_on_room_changed")
	var room = get_node("active_room")
	var player: Player = room.find_child("Player")
	if _transition_door_name:
		var door: Door = room.find_child(_transition_door_name)
		player.position = door.position
		player.set_forced_input(door.exit_towards)

	$TransitionCanvas/AnimationPlayer.play("room_trans_end")
	
func _transition_end():
	print_debug("_transition_end")
	_transition_room = null
	_transition_door_name = null
	
	var room = get_node("active_room")
	var player: Player = room.find_child("Player")
	if player:
		player.set_forced_input(null)

func save():
	save_state.save("user://save_state.cfg")
