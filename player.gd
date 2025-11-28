class_name Player
extends CharacterBody2D

@export var speed: float
@export var jump_strength: float
@export var coyote_max_ms: float
@export var jump_held_coef: float
@export var hook_distance_max: float

## float (-1.0 .. 1.0) or null
var forced_input_x: Variant

var curve_t: float = 0
var curve_target: Curve2D
var curve_speed: float
var curve_dir: int

var hanging_target: HookHanging
var hanging_t: float
var hanging_L: float
var hanging_theta0: float
var hanging_line2D: Line2D

enum MovementType {
	NORMAL,
	FORCED,
	CURVE,
	HANGING,
}
var movement_type = MovementType.NORMAL
var movement_handler: Callable = _movement_normal
var movement_handlers = {
	MovementType.NORMAL: _movement_normal,
	MovementType.FORCED: _movement_forced,
	MovementType.CURVE: _movement_curve,
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
	movement_handler.call(delta)

#region movement type setters
func set_movement_normal():
	movement_type = MovementType.NORMAL
	movement_handler = _movement_normal
	
func set_movement_forced(dir: String):
	if movement_type == MovementType.FORCED: return

	movement_type = MovementType.FORCED
	movement_handler = _movement_forced

	var jump_coef = 1.3

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

func set_movement_curve(curve: Curve2D, speed: float, reverse: bool):
	if movement_type == MovementType.CURVE: return

	movement_type = MovementType.CURVE
	movement_handler = _movement_curve

	curve_target = curve
	curve_speed = speed
	if reverse:
		curve_dir = -1
		curve_t = 1
	else:
		curve_dir = 1
		curve_t = 0

func set_movement_hanging(target: Node2D, hang_dist: float):
	if movement_type == MovementType.HANGING: return
	
	movement_type = MovementType.HANGING
	movement_handler = _movement_hanging
	
	hanging_t = 0
	hanging_L = hang_dist
	hanging_target = target
	var theta0_sign = sign(global_position.x - target.global_position.x)
	hanging_theta0 = deg_to_rad(theta0_sign * 30)
	
	hanging_line2D = Line2D.new()
	hanging_line2D.width = 2
	hanging_line2D.add_point(Vector2.ZERO)
	hanging_line2D.add_point(Vector2.ZERO) # set in movement handler
	target.add_child(hanging_line2D)
#endregion

#region movement handlers
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
	if Input.is_action_pressed("jump") and can_jump:
		velocity.y = -jump_strength
		# Force coyote time to expire to forbid double jumps
		coyote = coyote_max_ms
		jump_was_released = false

	if not Input.is_action_pressed("jump"):
		jump_was_released = true
		
	if Input.is_action_just_pressed("action"):
		handle_action_input()
	
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

func _movement_curve(delta: float):
	curve_t += curve_dir * curve_speed * delta
	var finished: bool
	if curve_dir == 1:
		finished = curve_t >= 1.0
	else:
		finished = curve_t <= 0.0
	
	var new_position = curve_target.sample_baked(curve_t * curve_target.get_baked_length(), true)
	velocity = (new_position - position) / delta

	if finished:
		set_movement_normal()
		curve_target = null
		return

	position = new_position
	
func _movement_hanging(delta: float):
	hanging_t += delta

	if Input.is_action_just_pressed("jump"):
		velocity.y = -jump_strength
		# Force coyote time to expire to forbid double jumps
		coyote = coyote_max_ms
		jump_was_released = false
		hanging_line2D.queue_free()
		set_movement_normal()

	var omega = sqrt(gravity / hanging_L)
	var theta = hanging_theta0 * cos(hanging_t * omega)
	global_position.x = hanging_target.global_position.x + hanging_L * sin(theta)
	global_position.y = hanging_target.global_position.y + hanging_L * cos(theta)
	
	hanging_line2D.points[1] = global_position - hanging_target.global_position
#endregion

func handle_action_input():
	var hooks = get_tree().get_nodes_in_group("hook_hanging")
	for hook_any in hooks:
		if not hook_any is HookHanging:
			print_debug("hook is not HookHanging!", hook_any)
			continue

		var hook: HookHanging = hook_any
		var dist = (hook.global_position - global_position).length()
		print_debug("found hook: ", hook, ", dist: ", dist)
		if dist < hook_distance_max:
			set_movement_hanging(hook, hook.hang_distance)
