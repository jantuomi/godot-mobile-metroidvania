extends Camera2D

## Amount to smoothly offset the camera if the parent is a Player.
@export var offset_amt: Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var parent = get_parent()
	if parent is Player:
		var player: Player = parent
		position.x = player.get_facing() * offset_amt.x

		if not player.is_on_floor():
			position.y = offset_amt.y
		else:
			position.y = 0
