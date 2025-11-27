extends Sprite2D

@export var path: Path2D
@export var speed: float
@export var reverse: bool

func _on_area_2d_body_entered(player: Player) -> void:
	player.follow_curve(path.curve, speed, reverse)
