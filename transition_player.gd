class_name TransitionPlayer
extends AnimationPlayer

signal transition_finished
signal room_changed

var _transition_room: Node
var _transition_door_name: Variant # String or null
var _override_player_fn: Variant # Callable or null

func room_transition(from_door: Door,
					 to_room_path: String,
					 door_name: Variant,
					 override_player_fn: Variant = null):
	print_debug("Transitioning to room path: %s" % to_room_path)

	var top: Top = get_tree().root.get_node("Top")

	# Do not transition if there is already a transition in process
	if _transition_room != null: return

	if from_door:
		var player: Player = top.get_node("ActiveRoom").find_child("Player")
		player.request_state_forced(from_door.enter_towards)

	# Start animation
	# The animation calls _change_room at a specific time
	play("room_trans_start")

	var room = ResourceLoader.load(to_room_path)
	_transition_room = room.instantiate()
	_transition_door_name = door_name
	_override_player_fn = override_player_fn
	
	if to_room_path != Top.ROOM_MAIN_MENU:
		top.game_set(Top.SAVE_ACTIVE_ROOM_PATH, to_room_path)
		top.game_set(Top.SAVE_LAST_DOOR_NAME, door_name)

	await transition_finished

func _transition_start():
	var top: Top = get_tree().root.get_node("Top")

	# If the room hasn't loaded yet, loop until it is
	while _transition_room == null:
		await get_tree().create_timer(0.1).timeout

	top.pause_menu.get_map().set_room_name(_transition_room.name)
	top.replace_active_room(_transition_room, _on_room_changed)

func _on_room_changed():
	var top: Top = get_tree().root.get_node("Top")
	var room = top.get_node("ActiveRoom")
	var player: Player = room.find_child("Player")
	
	if _transition_door_name and player:
		var door: Door = room.find_child(_transition_door_name)
		player.position = door.position
		player.request_state_forced(door.exit_towards)
		top.game_save()

	play("room_trans_end")
	room_changed.emit()
	
func _transition_end():
	var top: Top = get_tree().root.get_node("Top")
	_transition_room = null
	_transition_door_name = null
	
	var room = top.get_node("ActiveRoom")
	var player: Player = room.find_child("Player")
	if _override_player_fn:
		_override_player_fn.call(player)
	elif player:
		player.request_state_normal()
	
	_override_player_fn = null

	transition_finished.emit()
