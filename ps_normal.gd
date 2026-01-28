class_name PlayerStateNormal
extends PlayerState

var jump_was_released: bool = true
# coyote = 0 indicates on floor
# coyote > 0 indicates seconds since on floor
var coyote: float = 10000
var prev_dir: float = 0.0

func _to_string() -> String:
	return "PlayerStateNormal"

func _handle(_delta: float):
	if p.velocity.x > 0:
		p.anim_sp.flip_h = false
	elif p.velocity.x < 0:
		p.anim_sp.flip_h = true
	
	if not p.is_on_floor():
		p.anim_sp.set_animation("jump")
	elif abs(p.velocity.x) > 0.0:
		p.anim_sp.set_animation("walk")
		p.request_play_walk_sfx()
	else:
		p.anim_sp.set_animation("idle")

func _handle_physics(delta: float):
	var grav_coef = 1.0
	if p.velocity.y < 0 and Input.is_action_pressed("jump"):
		grav_coef = 1.0 + (p.jump_held_coef * p.velocity.y / p.jump_strength)
	
	p.velocity.y += grav_coef * p.gravity * delta
	if p.velocity.y > p.jump_strength:
		p.velocity.y = p.jump_strength

	if p.is_on_floor():
		coyote = 0
	else:
		coyote += delta

	var can_jump = coyote < (p.coyote_max_ms * 0.001) and jump_was_released
	if Input.is_action_pressed("jump") and can_jump:
		p.velocity.y = -p.jump_strength
		# Force coyote time to expire to forbid double jumps
		coyote = p.coyote_max_ms
		jump_was_released = false
		p.request_play_jump_sfx()

	if not Input.is_action_pressed("jump"):
		jump_was_released = true
		
	if Input.is_action_just_pressed("action"):
		p.handle_action_input()
	
	var direction: float
	if Input.is_action_pressed("move_left") and Input.is_action_pressed("move_right"):
		# This is a fix to the stalled movement issue
		# where the player stops if both x inputs are pressed at the same time.
		# To fix it, we store the previous direction the player was moving in, and change
		# the direction when both buttons are held. This is what the player wants nearly always.
		direction = -prev_dir
	else:
		direction = Input.get_axis("move_left", "move_right")
		prev_dir = direction
	
	p.velocity.x = direction * p.speed

	p.move_and_slide()
