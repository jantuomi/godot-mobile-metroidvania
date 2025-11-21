class_name Top
extends Node2D

@export var initial_room: PackedScene

var active_room_name: String
var save_state_path = "user://save_state.cfg"
var save_state = ConfigFile.new()

func _ready() -> void:
	$Map.hide_map()

	var room = initial_room.instantiate()
	active_room_name = room.name
	room.name = "ActiveRoom"
	room.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(room)
	
	# Testing
	save_state.load(save_state_path)
	print("loaded test_item: ", save_state.get_value("items", "test_item"))
	save_state.set_value("items", "test_item", true)
	save_state.save(save_state_path)
	print(OS.get_data_dir())

func _process(_delta: float):
	if Input.is_action_just_pressed("menu"):
		if $Map.visible:
			close_pause_menu()
		elif active_room_name != "MainMenu":
			open_pause_menu()

func save():
	save_state.save("user://save_state.cfg")

func replace_active_room(new_room: Node, on_changed: Callable):
	var current_room = get_node("ActiveRoom")
	remove_child(current_room)
	current_room.queue_free()
	
	var next_is_main_menu = new_room.name == "MainMenu"
	var touchscreen_ui_exists = has_node("TouchScreenUI")
	if next_is_main_menu and touchscreen_ui_exists:
		remove_child(get_node("TouchScreenUI"))
	elif not next_is_main_menu and not touchscreen_ui_exists:
		add_child(preload("res://touch_screen_ui.tscn").instantiate())
	
	active_room_name = new_room.name
	new_room.name = "ActiveRoom"
	new_room.connect("tree_entered", on_changed)
	new_room.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(new_room)

func get_map() -> Map:
	return $Map
	
func get_transition_manager() -> TransitionManager:
	return $TransitionManager

func open_pause_menu():
	get_tree().paused = true
	$Map.show_map()

func close_pause_menu():
	get_tree().paused = false
	$Map.hide_map()
