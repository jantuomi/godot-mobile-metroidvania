class_name TransitionManager
extends CanvasLayer

@onready var top: Top = get_tree().root.get_node("Top")

var _transition_room: Node
var _transition_door_name: Variant # String or null

func room_transition(from_door: Door, to_room_path: String, door_name: Variant):
	# Do not transition if there is already a transition in process
	if _transition_room != null:
		#print_debug("Tried to transition to ", room_name, " but a transition was already in process")
		return

	if from_door:
		var player: Player = top.get_node("ActiveRoom").find_child("Player")
		player.set_forced_input(from_door.enter_towards)

	# Start animation
	# The animation calls _change_room at a specific time
	$AnimationPlayer.play("room_trans_start")

	var room = ResourceLoader.load(to_room_path)
	_transition_room = room.instantiate()
	_transition_door_name = door_name
	
	top.game_set(Top.SAVE_ACTIVE_ROOM_PATH, to_room_path)
	top.game_set(Top.SAVE_LAST_DOOR_NAME, door_name)

func _transition_start():
	#print_debug("_transition_start")
	
	# If the room hasn't loaded yet, loop until it is
	while _transition_room == null:
		await get_tree().create_timer(0.1).timeout

	top.get_map().set_active_name(_transition_room.name)
	top.replace_active_room(_transition_room, _on_room_changed)
	
func _on_room_changed():
	#print_debug("_on_room_changed")
	var room = top.get_node("ActiveRoom")
	var player: Player = room.find_child("Player")
	if _transition_door_name:
		var door: Door = room.find_child(_transition_door_name)
		player.position = door.position
		player.set_forced_input(door.exit_towards)

	$AnimationPlayer.play("room_trans_end")
	top.game_save()
	
func _transition_end():
	#print_debug("_transition_end")
	_transition_room = null
	_transition_door_name = null
	
	var room = top.get_node("ActiveRoom")
	var player: Player = room.find_child("Player")
	if player:
		player.set_forced_input(null)
