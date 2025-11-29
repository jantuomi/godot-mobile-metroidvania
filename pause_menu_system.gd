class_name PauseMenuSystem
extends PauseMenuPage

func _on_tree_entered() -> void:
	$QuitButton.grab_focus.call_deferred()
	$QuitButton.connect("pressed", _on_quit_button_pressed)

func _on_quit_button_pressed() -> void:
	var menu: PauseMenu = get_parent()
	var top: Top = menu.get_parent()
	
	top.get_transition_player().room_transition(null, "res://room_main_menu.tscn", null)
	top.handle_pause()
