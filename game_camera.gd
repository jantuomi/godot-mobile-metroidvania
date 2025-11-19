extends Camera2D

## Amount to smoothly offset the camera if the parent is a Player.
@export var offset_amt: Vector2

func _ready() -> void:
	if not position_smoothing_enabled:
		await get_tree().create_timer(0.1).timeout
		position_smoothing_enabled = true

func _process(_delta: float) -> void:
	var parent = get_parent()
	if parent is Player:
		var player: Player = parent
		position.x = player.get_facing() * offset_amt.x

		if not player.is_on_floor():
			position.y = offset_amt.y
		else:
			position.y = 0
