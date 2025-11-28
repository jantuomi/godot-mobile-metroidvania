class_name Player
extends CharacterBody2D

@export var speed: float
@export var jump_strength: float
@export var coyote_max_ms: float
@export var jump_held_coef: float
@export var hook_distance_max: float

var state: PlayerState = PlayerStateInit.new()
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func get_facing() -> int:
	if $AnimatedSprite2D.flip_h:
		return -1
	else:
		return 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	state._handle(self, delta)

func _physics_process(delta: float):
	state._handle_physics(self, delta)

#region movement type setters
func set_movement_normal():
	state = PlayerStateNormal.new()
	
func set_movement_forced(dir: String):
	if state is PlayerStateForced: return
	
	var psf: PlayerStateForced = PlayerStateForced.new()
	psf.initialize(self, dir)
	state = psf

func set_movement_curve(curve: Curve2D, c_speed: float, c_reverse: bool):
	if state is PlayerStateCurve: return

	var psc: PlayerStateCurve = PlayerStateCurve.new()
	psc.initialize(self, curve, c_speed, c_reverse)
	state = psc

func set_movement_hanging(target: Node2D, hang_dist: float):
	if state is PlayerStateHanging: return

	var psh: PlayerStateHanging = PlayerStateHanging.new()
	psh.initialize(self, target, hang_dist)
	state = psh
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
