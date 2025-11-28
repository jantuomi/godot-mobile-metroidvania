class_name DebugInfo
extends CanvasLayer

var player_state: PlayerState

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var text = ""
	if player_state: text += "%s\n" % player_state.to_string()
	$Label.text = text
