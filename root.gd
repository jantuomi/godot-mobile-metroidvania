class_name Root
extends Node2D

@export var initial_level: PackedScene
var save_state_path = "user://save_state.cfg"
var save_state = ConfigFile.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var level = initial_level.instantiate()
	add_child(level)
	
	# Testing
	save_state.load(save_state_path)
	print("loaded test_item: ", save_state.get_value("items", "test_item"))
	save_state.set_value("items", "test_item", true)
	save_state.save(save_state_path)
	print(OS.get_data_dir())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func change_level(level_name: String):
	var level = ResourceLoader.load("res://level_" + level_name + ".tscn")
	var current_level = get_child(0)
	remove_child(current_level)
	
	var next_level = level.instantiate()
	add_child(next_level)

func save():
	save_state.save("user://save_state.cfg")
