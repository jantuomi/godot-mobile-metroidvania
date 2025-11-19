extends Node

@onready var top: Top = get_tree().root.get_node("Top")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		top.change_room("main_menu")
