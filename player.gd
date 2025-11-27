class_name Player
extends CharacterBody2D

@export var speed: float
@export var jump_strength: float
@export var coyote_max_ms: float
@export var jump_held_coef: float
@export var curve_speed: float

## float (-1.0 .. 1.0) or null
var forced_input_x: Variant
var curve_t: float = 0
var followed_curve: Curve2D
enum {
	MOVEMENT_NORMAL,
	MOVEMENT_FORCED,
	MOVEMENT_CURVE,
}
var movement_type = MOVEMENT_NORMAL
var movement_handlers = {
	MOVEMENT_NORMAL: _movement_normal,
	MOVEMENT_FORCED: _movement_forced,
	MOVEMENT_CURVE: _movement_curve,
}

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var prev_dir: float = 0.0
var jump_was_released: bool = true

# coyote = 0 indicates on floor
# coyote > 0 indicates seconds since on floor
var coyote: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func get_facing() -> int:
	if $AnimatedSprite2D.flip_h:
		return -1
	else:
		return 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	elif velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	
	if not is_on_floor():
		$AnimatedSprite2D.set_animation("jump")
	elif abs(velocity.x) > 0.0:
		$AnimatedSprite2D.set_animation("walk")
	else:
		$AnimatedSprite2D.set_animation("idle")

func _physics_process(delta: float):
	movement_handlers[movement_type].call(delta)

func set_forced_input(dir: Variant):
	var jump_coef = 1.3
	if dir == null:
		movement_type = MOVEMENT_NORMAL
		forced_input_x = null
		return

	movement_type = MOVEMENT_FORCED
	#movement_type = MOVEMENT_CURVE
	if dir == "LEFT":
		forced_input_x = -1.0
	elif dir == "JUMP_LEFT":
		velocity.y = -jump_coef * jump_strength
		forced_input_x = -1.0
	elif dir == "RIGHT":
		forced_input_x = 1.0
	elif dir == "JUMP_RIGHT":
		velocity.y = -jump_coef * jump_strength
		forced_input_x = 1.0
	elif dir == "JUMP":
		velocity.y = -jump_strength
		forced_input_x = 0.0
		gravity = 0.0
	elif dir == "DROP":
		forced_input_x = 0.0

func _movement_normal(delta: float):
	var grav_coef = 1.0
	if velocity.y < 0 and Input.is_action_pressed("jump"):
		grav_coef = 1.0 + (jump_held_coef * velocity.y / jump_strength)
	
	velocity.y += grav_coef * gravity * delta
	if velocity.y > jump_strength:
		velocity.y = jump_strength

	if is_on_floor():
		coyote = 0
	else:
		coyote += delta

	var can_jump = coyote < (coyote_max_ms * 0.001) and jump_was_released
	if Input.is_action_just_pressed("jump"):
		print_debug("coyote:", coyote, ", max:", coyote_max_ms * 0.001)
	if Input.is_action_pressed("jump") and can_jump:
		velocity.y = -jump_strength
		# Force coyote time to expire to forbid double jumps
		coyote = coyote_max_ms
		jump_was_released = false

	if not Input.is_action_pressed("jump"):
		jump_was_released = true
	
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
	
	velocity.x = direction * speed

	move_and_slide()

func _movement_forced(delta: float):
	velocity.y += gravity * delta
	if velocity.y > jump_strength:
		velocity.y = jump_strength

	velocity.x = forced_input_x * speed

	move_and_slide()

func follow_curve(curve: Curve2D):
	movement_type = MOVEMENT_CURVE
	followed_curve = curve
	curve_t = 0

func _movement_curve(delta: float):
	#print_debug("t:", curve_t)
	curve_t += curve_speed * delta
	if curve_t >= 1.0:
		movement_type = MOVEMENT_NORMAL
		followed_curve = null
		return

	position = followed_curve.sample_baked(curve_t * followed_curve.get_baked_length(), true)
