class_name PlayerStateCurve
extends PlayerState

var t: float = 0
var target: Curve2D
var speed: float
var dir: int

func _init(pl: Player, c_target: Curve2D, c_speed: float, c_reverse: bool):
	super(pl)
	
	target = c_target
	speed = c_speed
	if c_reverse:
		dir = -1
		t = 1
	else:
		dir = 1
		t = 0

func _to_string() -> String:
	return "PlayerStateCurve"

func _handle(_delta: float):
	pass

func _handle_physics(delta: float):
	t += dir * speed * delta
	var finished: bool
	if dir == 1:
		finished = t >= 1.0
	else:
		finished = t <= 0.0

	var new_position = target.sample_baked(t * target.get_baked_length(), true)
	p.velocity = (new_position - p.position) / delta

	if finished:
		p.set_movement_normal()
		return

	p.position = new_position
