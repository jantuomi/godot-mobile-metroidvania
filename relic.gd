extends Sprite2D

@onready var top: Top = get_tree().root.get_node("Top")
@onready var ordinal = int(name.replace("Relic", ""))

var t: float = 0
const w: float = 5
const A: float = 1

var oscing = true
var already_got = false

func _ready():
	for existing in top.inventory.relics:
		if existing == ordinal:
			turn_transparent()
			already_got = true
			break

func turn_transparent():
	modulate.a = 0.3

func _physics_process(delta: float) -> void:
	if oscing: t += delta
	offset.y = A * sin(w * t)

func _on_area_2d_body_entered(player: Player) -> void:
	top.inventory.add_relic(ordinal)
	top.game_save()

	if already_got:
		queue_free()
	else:
		var dia = DialogueRelicGet.new(self)
		dia.process_mode = Node.PROCESS_MODE_ALWAYS
		get_parent().add_child(dia)
