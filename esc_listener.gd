extends Node

@onready var transition_manager: TransitionManager = get_tree().root.get_node("Top/TransitionManager")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		transition_manager.room_transition(null, "res://room_main_menu.tscn", null)
