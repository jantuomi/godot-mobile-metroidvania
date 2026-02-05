class_name CineIntro
extends Cinematic

func _ready():
	await top.get_transition_player().transition_finished
	
	var ap: AnimationPlayer = top.get_active_room().get_node("AnimationPlayer")
	
	ap.play("cine_intro")
	top.play_cine_bars()
	
	await ap.animation_finished
	
	top.get_transition_player().room_transition(
		null, "res://rooms/ship1.tscn", null,
		func (_player): pass)

	await ship1()

	queue_free()

func ship1():
	await top.get_transition_player().room_changed
	var room = top.get_active_room()

	var player: Player = room.get_node("Player")
	var captain: Node2D = room.get_node("Captain")
	var crew1: Node2D = room.get_node("Crew1")
	var crew2: Node2D = room.get_node("Crew2")

	player.remove_from_group("camera_target")

	await top.get_transition_player().transition_finished

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
