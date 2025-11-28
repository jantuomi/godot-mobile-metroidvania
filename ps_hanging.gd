class_name PlayerStateHanging
extends PlayerState

var target: HookHanging
var t: float
var L: float
var theta0: float
var line2D: Line2D

enum S { MLEMING, TRAVELING, HANGING }
var state: S = S.MLEMING

func _to_string() -> String:
	return "PlayerStateHanging (%s)" % S.keys()[state]

static func can_hang_from(p: Player, target: HookHanging) -> bool:
	var d = target.global_position - p.global_position
	var angle = atan2(d.y, d.x)
	var revs = floor(angle / (2 * PI))
	angle -= revs * 2 * PI
	return angle > deg_to_rad(135) or angle < deg_to_rad(45)

func initialize(p: Player, h_target: HookHanging, h_dist: float):
	t = 0
	L = h_dist
	target = h_target
	
	# Add tongue line
	line2D = Line2D.new()
	line2D.width = 2
	line2D.add_point(Vector2.ZERO)
	line2D.add_point(Vector2.ZERO) # set in movement handler
	target.add_child(line2D)
	
	var hyp = target.global_position - p.global_position
	var sign_x = sign(hyp.x)
	var angle_below_horiz = 15
	var angle_below_horiz_r = deg_to_rad(angle_below_horiz)
	var tweening_target_point = target.global_position \
		- Vector2(sign_x * L * cos(angle_below_horiz_r),
				  -L * sin(angle_below_horiz_r))

	# if player is above the hook, we need to tween to horizontal
	if tweening_target_point.y - p.global_position.y > 0:
		state = S.TRAVELING
		return

	state = S.HANGING

	theta0 = atan2(-hyp.y, hyp.x) - PI/2
	if theta0 < -PI: theta0 += 2*PI
	print_debug("hyp: ", hyp, ", theta0: ", theta0)

func _handle(_p: Player, _delta: float):
	pass

func _handle_physics(p: Player, delta: float):
	match state:
		S.MLEMING:	 _mlem(p, delta)
		S.TRAVELING: _travel(p, delta)
		S.HANGING:   _hang(p, delta)
		_: print_debug("_handle_physics: unknown state %s" % str(state))
		
func _mlem(p: Player, delta: float):
	pass

func _travel(p: Player, delta: float):
	var tween_speed = p.jump_strength
	var hyp = target.global_position - p.global_position
	var sign_x = sign(hyp.x)
	
	var angle_below_horiz = 15
	var angle_below_horiz_r = deg_to_rad(angle_below_horiz)
	var tweening_target_point = target.global_position \
		- Vector2(sign_x * L * cos(angle_below_horiz_r),
				  -L * sin(angle_below_horiz_r))
	
	var tween_hyp = tweening_target_point - p.global_position
	var tween_dir: Vector2 = tween_hyp.normalized()
	var v: Vector2 = tween_dir * tween_speed
	var s: Vector2 = v * delta

	if tween_hyp.length() < s.length():
		state = S.HANGING
		theta0 = deg_to_rad(-sign_x * (90 - angle_below_horiz))
	else:
		p.position += s
	
	line2D.points[1] = p.global_position - target.global_position

func _hang(p: Player, delta: float):
	t += delta

	if Input.is_action_just_pressed("jump"):
		p.velocity.y = -p.jump_strength
		line2D.queue_free()
		p.set_movement_normal()

	var omega = sqrt(p.gravity / L)
	var theta = theta0 * cos(t * omega)
	p.global_position.x = target.global_position.x + L * sin(theta)
	p.global_position.y = target.global_position.y + L * cos(theta)
	
	line2D.points[1] = p.global_position - target.global_position
