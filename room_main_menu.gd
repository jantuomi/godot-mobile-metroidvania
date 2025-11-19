class_name RoomMainMenu
extends Node2D

@onready var top: Top = get_tree().root.get_node("Top")

func _ready() -> void:
	$TestRoomButton.grab_focus.call_deferred()
	$TestRoomButton.pressed.connect(_test_room_button_pressed)

func _process(_delta: float) -> void:
	pass

func _test_room_button_pressed():
	top.change_room("test")
