class_name RoomMainMenu
extends Node2D

func _ready() -> void:
	$PlayButton.grab_focus.call_deferred()
	$PlayButton.connect("pressed", _on_play_button_pressed)

func _on_play_button_pressed() -> void:
	var top: Top = get_tree().root.get_node("Top")
	top.game_load()
