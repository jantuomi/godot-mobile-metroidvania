class_name Top
extends Node2D

const ROOM_MAIN_MENU: String = "res://rooms/main_menu.tscn"
const ROOM_NEW_GAME: String = "res://rooms/cine_intro.tscn"
const DOOR_NEW_GAME: Variant = null #"DoorEntry"

var active_room_name: String
var pause_menu: PauseMenu
var inventory: Inventory

@onready var cine_bars_player: AnimationPlayer = $CinematicBars/AnimationPlayer;

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
	
	$MusicPlayer.play()

func _process(_delta: float):
	if Input.is_action_just_pressed("menu"):
		toggle_pause()

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

func toggle_pause():
	if pause_menu.is_inside_tree():
		remove_child.call_deferred(pause_menu)
	else:
		add_child.call_deferred(pause_menu)

func play_cine_bars():
	cine_bars_player.play("cine_bars")
	await cine_bars_player.animation_finished

func clear_cine_bars():
	cine_bars_player.play_backwards("cine_bars")
	await cine_bars_player.animation_finished

# Save state logic

@onready var save_state: ConfigFile = ConfigFile.new()
const SAVE_PATH = "user://save_state.cfg"
const SAVE_SECTION = "save"
const SAVE_ACTIVE_ROOM_PATH = "ACTIVE_ROOM_PATH"
const SAVE_LAST_DOOR_NAME   = "LAST_DOOR_NAME"
const SAVE_GOT_ZOOP         = "GOT_ZOOP"
const SAVE_GOT_HANG         = "GOT_HANG"
const SAVE_RELICS           = "RELICS"
const SAVE_CINE_INTRO_DONE  = "CINE_INTRO_DONE"

func game_set(k: String, v: Variant):
	save_state.set_value(SAVE_SECTION, k, v)

func game_save():
	save_state.set_value(SAVE_SECTION, SAVE_GOT_HANG, inventory.hanging)
	save_state.set_value(SAVE_SECTION, SAVE_GOT_ZOOP, inventory.zoop)

	var relics_str: PackedStringArray = []
	for relic in inventory.relics:
		relics_str.push_back(str(relic))
	var relics_csv = ",".join(relics_str)
	save_state.set_value(SAVE_SECTION, SAVE_RELICS, relics_csv)
	
	save_state.set_value(SAVE_SECTION, SAVE_CINE_INTRO_DONE, inventory.cine_intro_done)

	save_state.save(SAVE_PATH)

func game_load():
	save_state.load(SAVE_PATH)
	var save_active_room_path = save_state.get_value(SAVE_SECTION, SAVE_ACTIVE_ROOM_PATH, ROOM_NEW_GAME)
	var save_last_door_name = save_state.get_value(SAVE_SECTION, SAVE_LAST_DOOR_NAME, DOOR_NEW_GAME)

	inventory = Inventory.new()
	inventory.hanging = save_state.get_value(SAVE_SECTION, SAVE_GOT_HANG, false)
	inventory.zoop = save_state.get_value(SAVE_SECTION, SAVE_GOT_ZOOP, false)

	inventory.relics = []
	# COMMENTED OUT FOR DEV so that reloads/deaths reset relics
	#var relics_csv: String = save_state.get_value(SAVE_SECTION, SAVE_RELICS, "")
	#for relic in relics_csv.split(",", false):
	#	var relic_int = int(relic)
	#	inventory.relics.push_back(relic_int)
	
	inventory.cine_intro_done = save_state.get_value(SAVE_SECTION, SAVE_CINE_INTRO_DONE, false)

	$TransitionPlayer.room_transition(null, save_active_room_path, save_last_door_name)
