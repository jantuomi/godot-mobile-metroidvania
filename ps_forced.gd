class_name PlayerStateForced
extends PlayerState

var input_x: float
var jump_coef = 1.3

func initialize(p: Player, dir: String):
	if dir == "LEFT":
		input_x = -1.0
	elif dir == "JUMP_LEFT":
		p.velocity.y = -jump_coef * p.jump_strength
		input_x = -1.0
	elif dir == "RIGHT":
		input_x = 1.0
	elif dir == "JUMP_RIGHT":
		p.velocity.y = -jump_coef * p.jump_strength
		input_x = 1.0
	elif dir == "JUMP":
		p.velocity.y = -p.jump_strength
		input_x = 0.0
		p.gravity = 0.0
	elif dir == "DROP":
		input_x = 0.0

func _handle(p: Player, _delta: float):
	var as2d = p.get_node("AnimatedSprite2D")
	if p.velocity.x > 0:
		as2d.flip_h = false
	elif p.velocity.x < 0:
		as2d.flip_h = true
	
	if not p.is_on_floor():
		as2d.set_animation("jump")
	elif abs(p.velocity.x) > 0.0:
		as2d.set_animation("walk")
	else:
		as2d.set_animation("idle")

func _handle_physics(p: Player, delta: float):
	p.velocity.y += p.gravity * delta
	if p.velocity.y > p.jump_strength:
		p.velocity.y = p.jump_strength

	p.velocity.x = input_x * p.speed

	p.move_and_slide()
