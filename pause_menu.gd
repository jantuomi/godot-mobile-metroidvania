class_name PauseMenu
extends CanvasLayer

var active_page_index: int
var pages: Array[PauseMenuPage] = []

func _ready():
	pages = []
	var children = get_children()
	for child in children:
		if child is PauseMenuPage:
			pages.push_back(child)
			remove_child.call_deferred(child)

func _on_tree_entered() -> void:
	get_tree().paused = true
	get_tree().call_group("ui_movement", "set_visible", false)

	if pages.size() > 0:
		set_page(0)

func _exit_tree():
	get_tree().paused = false
	get_tree().call_group("ui_movement", "set_visible", true)

func _process(_delta: float):
	if visible and Input.is_action_just_pressed("action"):
		set_page((active_page_index + 1) % pages.size())

func get_map() -> PauseMenuMap:
	for page in pages:
		if page is PauseMenuMap: return page

	return null

func set_page(i: int):
	var prev_page = pages[active_page_index]
	remove_child.call_deferred(prev_page)
	
	active_page_index = i
	add_child.call_deferred(pages[i])
