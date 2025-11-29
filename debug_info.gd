class_name DebugInfo
extends CanvasLayer

func _ready() -> void:
	while true:
		await get_tree().create_timer(0.05).timeout
		_update.call_deferred()

func _update():
	var text = ""
	
	text += "FPS: %d\n" % Engine.get_frames_per_second()
	
	var nodes = get_tree().get_nodes_in_group("debug_info")
	for node in nodes:
		text += node._debug_info()

	$Label.text = text
