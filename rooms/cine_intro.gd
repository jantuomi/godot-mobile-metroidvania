class_name CineIntro
extends Node2D


func _ready() -> void:
	run()

func run():
	var top: Top = get_tree().root.get_node("Top")
	
	$AnimationPlayer.play("cine_intro")
	await get_tree().create_timer(0.5).timeout
	top.play_cine_bars()
	
	await $AnimationPlayer.animation_finished
	
	top.get_transition_player().room_transition(null, "res://rooms/ship1.tscn", null,
												 func (_player): pass)
