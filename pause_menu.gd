class_name PauseMenu
extends CanvasLayer

var active_map_room: MapRoom
var active_page_index: int = 0
@export var pages: Array[Node]

func _ready():
	deactivate()
	$System/QuitButton.grab_focus.call_deferred()
	$System/QuitButton.connect("pressed", _on_quit_button_pressed)

func _process(_delta: float):
	if visible and Input.is_action_just_pressed("jump"):
		active_page_index = (active_page_index + 1) % pages.size()
		refresh_page()

func set_room_name(map_room_name: String):
	if active_map_room: active_map_room.unhighlight()

	active_map_room = $Map.get_node_or_null(map_room_name)

	if active_map_room:
		active_map_room.highlight()
		var pos = active_map_room.position
		var size = get_viewport().get_visible_rect().size
		var delta = Vector2(size.x / 2, size.y / 2)
		$Map.position = -pos + delta - active_map_room.size / 2

func activate():
	active_page_index = 0
	visible = true
	get_tree().paused = true
	get_tree().call_group("ui_movement", "set_visible", false)
	refresh_page()
	
func deactivate():
	visible = false
	get_tree().paused = false
	get_tree().call_group("ui_movement", "set_visible", true)

func refresh_page():
	for i in range(pages.size()):
		pages[i].visible = (active_page_index == i)

func _on_quit_button_pressed() -> void:
	if not visible: return
	var top: Top = get_tree().root.get_node("Top")
	top.get_transition_player().room_transition(null, "res://room_main_menu.tscn", null)
	deactivate()
