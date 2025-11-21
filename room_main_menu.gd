class_name RoomMainMenu
extends Node2D

func _ready() -> void:
	$TestRoomButton.grab_focus.call_deferred()
	$TestRoomButton.pressed.connect(_test_room_button_pressed)

func _test_room_button_pressed():
	var transition_manager: TransitionManager = get_tree().root.get_node("Top/TransitionManager")
	transition_manager.room_transition(null, "res://room_test1.tscn", null)
