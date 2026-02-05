class_name Cinematic
extends Node

signal next(arg: Variant)

@onready var top: Top = get_tree().root.get_node("Top")

enum Type { SAY, ASK }
var type: Type

func say(who: Object, text: String):
	var tb: TextBubble = preload("res://text_bubble.tscn").instantiate()
	tb.text = text
	if who is Node2D:
		tb.global_position = who.global_position + Vector2(0, -20)
	else:
		var room = top.get_active_room()
		tb.global_position = room.get_node("GameCamera").global_position

	tb.add_to_group("text_bubbles")
	top.add_child(tb)
	type = Type.SAY
	await next

func ask(who: Object, text: String, options: Array[String]) -> String:
	var tb: TextBubble = preload("res://text_bubble.tscn").instantiate()
	tb.text = text
	tb.options = options
	tb.connect("answered", _on_answered)
	if who is Node2D:
		tb.global_position = who.global_position + Vector2(0, -20)
	else:
		var room = top.get_active_room()
		tb.global_position = room.get_node("GameCamera").global_position

	tb.add_to_group("text_bubbles")
	top.add_child(tb)
	type = Type.ASK
	return await next

func _process(_delta: float):
	if type == Type.SAY and (Input.is_action_just_pressed("action") or Input.is_action_just_pressed("jump")):
		get_tree().call_group("text_bubbles", "queue_free")
		next.emit()

func _on_answered(answer: String):
	get_tree().call_group("text_bubbles", "queue_free")
	next.emit(answer)
