class_name Player
extends CharacterBody2D

@export var speed: float
@export var jump_strength: float
@export var coyote_max_ms: float
@export var jump_held_coef: float
@export var hook_distance_max: float

var state: PlayerState = PlayerStateInit.new(self)
@onready var anim_sp: AnimatedSprite2D = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _debug_info():
	return "%s\n" % state.to_string()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	state._handle(delta)

func _physics_process(delta: float):
	state._handle_physics(delta)

func request_state_normal():
	state = PlayerStateNormal.new(self)
	
func request_state_forced(dir: String):
	if state is PlayerStateForced: return

	state = PlayerStateForced.new(self, dir)

func request_state_curve(curve: Curve2D, c_speed: float, c_reverse: bool):
	if state is PlayerStateCurve: return

	state = PlayerStateCurve.new(self, curve, c_speed, c_reverse)

func request_state_hanging(target: Node2D, hang_dist: float):
	if state is PlayerStateHanging: return
	if not PlayerStateHanging.can_hang_from(self, target): return

	state = PlayerStateHanging.new(self, target, hang_dist)

func get_facing() -> int:
	if anim_sp.flip_h:
		return -1
	else:
		return 1

func handle_action_input():
	var hooks = get_tree().get_nodes_in_group("hook_hanging")
	for hook_any in hooks:
		if not hook_any is HookHanging:
			print_debug("hook is not HookHanging!", hook_any)
			continue

		var hook: HookHanging = hook_any
		var dist = (hook.global_position - global_position).length()
		#print_debug("found hook: ", hook, ", dist: ", dist)
		if dist < hook_distance_max:
			request_state_hanging(hook, hook.hang_distance)
