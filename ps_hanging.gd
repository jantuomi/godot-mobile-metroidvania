class_name PlayerStateHanging
extends PlayerState

var target: HookHanging
var t: float
var L: float
var theta0: float
var last_theta: float
var w: float
var tongue: Line2D

var travel_from: Vector2
var travel_to: Vector2

var T_mlem: float = 0.2
var T_travel: float = 0.1

enum S { MLEMING, TRAVELING, HANGING }
var state: S = S.MLEMING

func _init(pl: Player, h_target: HookHanging, h_dist: float) -> void:
	super(pl)

	t = 0
	L = h_dist
	target = h_target
	w = sqrt(p.gravity / L) * 0.8

	state = S.MLEMING

func _to_string() -> String:
	return "PlayerStateHanging %s, θ₀ = %f" % [S.keys()[state], theta0]

static func can_hang_from(pl: Player, c_target: HookHanging) -> bool:
	var d = c_target.global_position - pl.global_position
	var angle = atan2(d.y, d.x)
	var revs = floor(angle / (2 * PI))
	angle -= revs * 2 * PI
	return angle > deg_to_rad(135) or angle < deg_to_rad(45)

func _handle(_delta: float):
	if Input.is_action_just_pressed("move_left"):
		p.anim_sp.flip_h = true
	if Input.is_action_just_pressed("move_right"):
		p.anim_sp.flip_h = false

func _handle_physics(delta: float):
	match state:
		S.MLEMING:	 _mlem(delta)
		S.TRAVELING: _travel(delta)
		S.HANGING:   _hang(delta)
		_: print_debug("_handle_physics: unknown state %s" % str(state))
		
func _mlem(delta: float):
	t += delta
	var d = target.global_position - p.global_position
	
	# Add tongue line
	if not tongue:
		tongue = Line2D.new()
		tongue.width = 2
		tongue.add_point(-d)
		tongue.add_point(-d)
		target.add_child(tongue)
	
	# Update one end to be at player
	tongue.points[0] = -d
	tongue.points[1] = (t / T_mlem - 1) * d

	if t >= T_mlem:
		tongue.points[1] = Vector2.ZERO
		state = S.TRAVELING
		travel_from = p.global_position
		travel_to = target.global_position - d.normalized() * L
		t = 0

func _travel(delta: float):
	t += delta
	p.global_position = travel_from + (t / T_travel) * (travel_to - travel_from)
	
	var d = target.global_position - p.global_position
	tongue.points[0] = -d

	# If we're traveling in the right direction, then travel
	if t >= T_travel:
		p.global_position = travel_to
		state = S.HANGING
		theta0 = atan2(-d.y, -d.x) - PI / 2
		if theta0 > PI: theta0 -= 2 * PI
		if theta0 < -PI: theta0 += 2 * PI
		last_theta = theta0
		t = 0

func _hang(delta: float):
	var d = target.global_position - p.global_position
	tongue.points[0] = -d
	
	t += delta

	if Input.is_action_just_pressed("jump"):
		p.velocity.y = -p.jump_strength
		tongue.queue_free()
		p.set_movement_normal()

	var theta = theta0 * cos(t * w)
	
	if sign(theta) != sign(last_theta) and abs(theta0) > PI / 2:
		theta0 = sign(theta0) * PI / 2
	
	p.global_position.x = target.global_position.x + L * cos(theta + PI / 2)
	p.global_position.y = target.global_position.y + L * sin(theta + PI / 2)
	
	last_theta = theta
