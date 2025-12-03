class_name Player
extends CharacterBody2D

@export var speed: float
@export var jump_strength: float
@export var coyote_max_ms: float
@export var jump_held_coef: float
@export var hook_distance_max: float

@export var camera_offset_look: float
@export var camera_offset_jump: float

var state: PlayerState = PlayerStateInit.new(self)
@onready var anim_sp: AnimatedSprite2D = $AnimatedSprite2D
@onready var tree: SceneTree = get_tree()

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _debug_info():
	return "%s\n" % state.to_string()

func _camera_target() -> Vector2:
	var oy: float = 0
	if not is_on_floor():
		oy = camera_offset_jump
	return global_position + Vector2(get_facing() * camera_offset_look, oy)

func _process(delta: float) -> void:
	state._handle(delta)

	for hook_any in tree.get_nodes_in_group("hook_hanging"):
		assert(hook_any is HookHanging, "hook is not HookHanging")
		var hook: HookHanging = hook_any
		var is_camera_target: bool = hook.is_in_group("camera_target")
		var player_not_much_higher = (hook.global_position.y - global_position.y) < 30
		var is_close: bool = ((hook.global_position - global_position).length() < 100) and player_not_much_higher

		if not is_camera_target and is_close:
			hook.add_to_group("camera_target")
		elif is_camera_target and not is_close:
			hook.remove_from_group("camera_target")

func _physics_process(delta: float):
	state._handle_physics(delta)

func request_state_init():
	state = PlayerStateInit.new(self)

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
		assert(hook_any is HookHanging, "hook is not HookHanging")
		var hook: HookHanging = hook_any
		var dist = (hook.global_position - global_position).length()
		if dist < hook_distance_max:
			request_state_hanging(hook, hook.hang_distance)
