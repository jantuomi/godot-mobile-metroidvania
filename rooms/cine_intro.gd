class_name RoomCineIntro
extends Room

@onready var top: Top = get_tree().root.get_node("Top")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var cine = CineIntro.new()
	top.add_child(cine)
