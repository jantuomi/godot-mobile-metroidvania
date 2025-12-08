class_name PauseMenuStatus
extends PauseMenuPage

@onready var top: Top = get_tree().root.get_node("Top")
@onready var inventory: Inventory = top.inventory

const grey: Color = Color("4d4d4d")

func _on_tree_entered() -> void:
	if not is_node_ready(): return

	if not inventory.hanging:
		$AbilityHang.modulate = grey
	if not inventory.zoop:
		$AbilityZoop.modulate = grey
