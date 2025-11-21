class_name RoomMainMenu
extends Node2D

func _ready() -> void:
	$PlayButton.grab_focus.call_deferred()
	$PlayButton.pressed.connect(_play_button_pressed)

func _play_button_pressed():
	var top: Top = get_tree().root.get_node("Top")
	top.game_load()
