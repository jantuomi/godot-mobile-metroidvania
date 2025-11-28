class_name DebugInfo
extends CanvasLayer

func _ready() -> void:
	while true:
		await get_tree().create_timer(0.05).timeout
		_update.call_deferred()

func _update():
	var text = ""
	
	text += "FPS: %d\n" % Engine.get_frames_per_second()
	
	var room: Node = get_tree().root.get_node_or_null("Top/ActiveRoom")
	var player: Player
	if room: player = room.find_child("Player")

	if room:
		text += "Room: %s\n" % room.scene_file_path
	if player:
		text += "%s\n" % player.state.to_string()

	$Label.text = text
