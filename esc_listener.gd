extends Node

@onready var root: Root = get_tree().root.get_child(0)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		root.change_level("main_menu")
