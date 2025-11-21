class_name Player
extends CharacterBody2D

@onready var top: Top = get_tree().root.get_node("Top")

@export var speed: float
@export var jump_strength: float
@export var coyote_max: int
@export var jump_held_coef: float

## float (-1.0 .. 1.0) or null
var forced_input_x: Variant

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var prev_dir: float = 0.0
var jump_was_released: bool = true

# coyote = 0 indicates on floor
# coyote > 0 indicates frames since on floor
var coyote: int = 0

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
	var grav_coef = 1.0
	if velocity.y < 0 and Input.is_action_pressed("jump"):
		grav_coef = 1.0 + (jump_held_coef * velocity.y / jump_strength)
	
	#print_debug("1.0 + (", velocity.y, " / (", jump_held_coef, " * ", jump_strength, ")) = ", grav_coef)
	velocity.y += grav_coef * gravity * delta
	if velocity.y > jump_strength:
		velocity.y = jump_strength

	if is_on_floor():
		coyote = 0
	else:
		coyote += 1

	var can_jump = coyote < coyote_max and jump_was_released and forced_input_x == null
	if Input.is_action_pressed("jump") and can_jump:
		velocity.y = -jump_strength
		# Force coyote time to expire to forbid double jumps
		coyote = coyote_max
		jump_was_released = false

	if not Input.is_action_pressed("jump"):
		jump_was_released = true
	
	var direction: float
	if forced_input_x != null:
		direction = forced_input_x
	elif Input.is_action_pressed("move_left") and Input.is_action_pressed("move_right"):
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

func set_forced_input(dir: Variant):
	var jump_coef = 1.3
	if dir == null:
		forced_input_x = null
	elif dir == "LEFT":
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
