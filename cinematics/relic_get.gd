class_name CineRelicGet
extends Cinematic

var r: Node2D

func _init(relic: Node2D):
	r = relic

func _ready():
	var player: Player = get_room_node("Player")
	var mp: AudioStreamPlayer = top.get_node("MusicPlayer")
	mp.stream_paused = true
	player.request_play_fanfare_sfx()

	get_tree().paused = true

	await top.play_cine_bars()
	await say(r, "You found a mysterious relic!")
	await top.clear_cine_bars()
	
	r.queue_free()
	get_tree().paused = false
	
	mp.stream_paused = false

	queue_free()
