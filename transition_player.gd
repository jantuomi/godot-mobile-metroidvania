class_name TransitionPlayer
extends AnimationPlayer

var _transition_room: Node
var _transition_door_name: Variant # String or null

func room_transition(from_door: Door, to_room_path: String, door_name: Variant):
	print_debug("to_room_path: %s" % to_room_path)

	var top: Top = get_tree().root.get_node("Top")
	# Do not transition if there is already a transition in process
	if _transition_room != null:
		#print_debug("Tried to transition to ", room_name, " but a transition was already in process")
		return

	if from_door:
		var player: Player = top.get_node("ActiveRoom").find_child("Player")
		player.set_forced_input(from_door.enter_towards)

	# Start animation
	# The animation calls _change_room at a specific time
	play("room_trans_start")

	var room = ResourceLoader.load(to_room_path)
	_transition_room = room.instantiate()
	_transition_door_name = door_name
	
	if to_room_path != Top.ROOM_MAIN_MENU:
		top.game_set(Top.SAVE_ACTIVE_ROOM_PATH, to_room_path)
		top.game_set(Top.SAVE_LAST_DOOR_NAME, door_name)

func _transition_start():
	var top: Top = get_tree().root.get_node("Top")
	#print_debug("_transition_start")
	
	# If the room hasn't loaded yet, loop until it is
	while _transition_room == null:
		await get_tree().create_timer(0.1).timeout

	top.get_pause_menu().set_room_name(_transition_room.name)
	top.replace_active_room(_transition_room, _on_room_changed)
	
func _on_room_changed():
	var top: Top = get_tree().root.get_node("Top")
	#print_debug("_on_room_changed")
	var room = top.get_node("ActiveRoom")
	var player: Player = room.find_child("Player")
	if _transition_door_name:
		var door: Door = room.find_child(_transition_door_name)
		player.position = door.position
		player.set_movement_forced(door.exit_towards)

	play("room_trans_end")
	top.game_save()
	
func _transition_end():
	var top: Top = get_tree().root.get_node("Top")
	#print_debug("_transition_end")
	_transition_room = null
	_transition_door_name = null
	
	var room = top.get_node("ActiveRoom")
	var player: Player = room.find_child("Player")
	if player:
		player.set_movement_normal()
