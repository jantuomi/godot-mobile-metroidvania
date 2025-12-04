class_name Dialogue
extends Node

signal next

@onready var parent: Node2D = get_parent()
@onready var cam: GameCamera = parent.get_node("GameCamera")

func say(who: Object, text: String):
	var tb: TextBubble = preload("res://text_bubble.tscn").instantiate()
	tb.text = text
	if who is Node2D:
		tb.global_position = who.global_position + Vector2(0, -20)
	else:
		tb.global_position = cam.global_position

	tb.add_to_group("text_bubbles")
	parent.add_child(tb)
	await next

func _process(_delta: float):
	if Input.is_action_just_pressed("action") or Input.is_action_just_pressed("jump"):
		get_tree().call_group("text_bubbles", "queue_free")
		next.emit()
