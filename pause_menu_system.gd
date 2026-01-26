class_name PauseMenuSystem
extends PauseMenuPage

func _ready():
	$QuitButton.connect("pressed", _on_quit_button_pressed)

func _on_tree_entered() -> void:
	if is_node_ready():
		$QuitButton.grab_focus.call_deferred()
		

func _on_quit_button_pressed() -> void:
	var menu: PauseMenu = get_parent()
	var top: Top = menu.get_parent()
	
	top.get_transition_player().room_transition(null, "res://rooms/main_menu.tscn", null)
	top.toggle_pause()
