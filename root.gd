extends Node2D

@export var initial_level: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var level = initial_level.instantiate()
	add_child(level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func change_level(level: PackedScene):
	var current_level = get_child(0)
	remove_child(current_level)
	
	var next_level = level.instantiate()
	add_child(next_level)
	
