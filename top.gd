class_name Top
extends Node2D

const ROOM_MAIN_MENU: String = "res://room_main_menu.tscn"
const ROOM_NEW_GAME: String = "res://room_test1.tscn"

var active_room_name: String
var pause_menu: PauseMenu

func _ready() -> void:
	if not OS.is_debug_build():
		$DebugInfo.queue_free()

	print("data_dir: \"%s\"" % OS.get_user_data_dir())

	pause_menu = $PauseMenu
	remove_child.call_deferred(pause_menu)

	get_tree().call_group("ui_movement", "set_visible", false)
	get_tree().call_group("ui_menu", "set_visible", false)
	get_tree().call_group("ui_action", "set_visible", false)

	var room = preload(ROOM_MAIN_MENU).instantiate()
	active_room_name = room.name
	room.name = "ActiveRoom"
	room.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(room)

func _process(_delta: float):
	if Input.is_action_just_pressed("menu"):
		handle_pause()

func replace_active_room(new_room: Node, on_changed: Callable):
	var current_room = get_node("ActiveRoom")
	remove_child(current_room)
	current_room.queue_free()

	var show_touchscreen_ui = (new_room.name != "MainMenu")
	get_tree().call_group("ui_movement", "set_visible", show_touchscreen_ui)
	get_tree().call_group("ui_menu", "set_visible", show_touchscreen_ui)
	get_tree().call_group("ui_action", "set_visible", show_touchscreen_ui)
	
	active_room_name = new_room.name
	new_room.name = "ActiveRoom"
	new_room.connect("tree_entered", on_changed)
	new_room.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(new_room)

func get_transition_player() -> TransitionPlayer:
	return $TransitionPlayer

func handle_pause():
	if pause_menu.is_inside_tree():
		remove_child.call_deferred(pause_menu)
	else:
		add_child.call_deferred(pause_menu)

# Save state logic

@onready var save_state: ConfigFile = ConfigFile.new()
const SAVE_PATH = "user://save_state.cfg"
const SAVE_SECTION = "save"
const SAVE_ACTIVE_ROOM_PATH = "ACTIVE_ROOM_PATH"
const SAVE_LAST_DOOR_NAME   = "LAST_DOOR_NAME"

func game_set(k: String, v: Variant):
	save_state.set_value(SAVE_SECTION, k, v)

func game_save():
	save_state.save(SAVE_PATH)

func game_load():
	save_state.load(SAVE_PATH)
	var save_active_room_path = save_state.get_value(SAVE_SECTION, SAVE_ACTIVE_ROOM_PATH, ROOM_NEW_GAME)
	var save_last_door_name = save_state.get_value(SAVE_SECTION, SAVE_LAST_DOOR_NAME, "DoorLeft")
	$TransitionPlayer.room_transition(null, save_active_room_path, save_last_door_name)
