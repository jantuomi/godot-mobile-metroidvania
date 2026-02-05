class_name DialogueCineIntroShip1
extends Dialogue

@onready var top: Top = get_tree().root.get_node("Top")
@onready var player: Player = parent.get_node("Player")
@onready var captain: Node2D = parent.get_node("Captain")
@onready var crew1: Node2D = parent.get_node("Crew1")
@onready var crew2: Node2D = parent.get_node("Crew2")

func _ready():
	player.remove_from_group("camera_target")

	await say(captain, "Crew!")
	
	player.velocity.x = -1 # flip
	crew1.flip_h = true
	crew2.flip_h = true
	
	await get_tree().create_timer(1.0).timeout

	await say(captain, "The Frogcorp Scientific Excursion commences today!")
	await say(captain, "TODO")
	
	await top.clear_cine_bars()
	
	player.request_state_normal()
	player.add_to_group("camera_target")
