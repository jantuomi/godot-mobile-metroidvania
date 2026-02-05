class_name RoomShip1
extends Room

@onready var top: Top = get_tree().root.get_node("Top")
@onready var player: Player = $Player

func _ready() -> void:
	if not top.inventory.cine_intro_done:
		var dia = DialogueCineIntroShip1.new()
		add_child(dia)
