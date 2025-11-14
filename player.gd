extends CharacterBody2D

@export var speed: float
@export var jump_strength: float

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var prev_dir: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

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
	velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_strength
	
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
	# Move the character
	move_and_slide()
