extends Area2D

@export var target_room: String

func _on_body_entered(_body: Node2D) -> void:
	var top: Top = get_tree().root.get_node("Top")
	top.transition_to_room(target_room)
