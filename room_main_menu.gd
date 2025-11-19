class_name RoomMainMenu
extends Node2D

@onready var root: Root = get_tree().root.get_child(0)

func _ready() -> void:
	$TestRoomButton.grab_focus.call_deferred()
	$TestRoomButton.pressed.connect(_test_room_button_pressed)

func _process(_delta: float) -> void:
	pass

func _test_room_button_pressed():
	root.change_room("test")
