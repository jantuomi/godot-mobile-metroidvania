class_name RoomMainMenu
extends Node2D

func _ready() -> void:
	$TestRoomButton.grab_focus.call_deferred()
	$TestRoomButton.pressed.connect(_test_room_button_pressed)

func _test_room_button_pressed():
	var top: Top = get_tree().root.get_node("Top")
	top.room_transition(null, "res://room_test1.tscn", null)
