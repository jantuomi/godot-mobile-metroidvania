class_name PlayerStateZooping
extends PlayerState

var target: ZoopPoint
var t: float
var tongue: Line2D

var travel_from: Vector2
var travel_to: Vector2

var T_mlem: float = 0.2
var T_travel: float = 0.2

enum S { MLEMING, TRAVELING }
var state: S = S.MLEMING

func _init(pl: Player, h_target: ZoopPoint) -> void:
	super(pl)

	t = 0
	target = h_target
	
	var dx = target.global_position.x - pl.global_position.x
	pl.anim_sp.flip_h = dx < 0

	state = S.MLEMING

func _to_string() -> String:
	return "PlayerStateZooping %s" % S.keys()[state]

static func can_zoop_to(pl: Player, z_target: ZoopPoint) -> bool:
	var dy = z_target.global_position.y - pl.global_position.y
	var dx = z_target.global_position.x - pl.global_position.x
	return abs(dy) < 20 and abs(dx) < 100

func _handle(_delta: float):
	pass

func _handle_physics(delta: float):
	match state:
		S.MLEMING:	 _mlem(delta)
		S.TRAVELING: _travel(delta)
		_: assert(false, "unknown state %s" % str(state))
		
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
		travel_to = target.global_position
		t = 0

func _travel(delta: float):
	t += delta
	p.global_position = travel_from + (t / T_travel) * (travel_to - travel_from)
	
	var d = target.global_position - p.global_position
	tongue.points[0] = -d

	# If we're traveling in the right direction, then travel
	if t >= T_travel:
		p.global_position = travel_to
		tongue.queue_free()
		
		p.velocity = Vector2(0, -100)
		p.request_state_normal()
