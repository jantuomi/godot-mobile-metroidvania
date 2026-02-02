class_name CineIntro
extends Node2D


func _ready() -> void:
	run()

func run():
	$AnimationPlayer.play("cine_intro")
	await $AnimationPlayer.animation_finished
	
	var top: Top = get_tree().root.get_node("Top")
	top.get_transition_player().room_transition(null, "res://rooms/surface1.tscn", "DoorEntry")
