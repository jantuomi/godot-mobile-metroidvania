class_name Player
extends CharacterBody2D

@export var speed: float
@export var jump_strength: float
@export var coyote_max_ms: float
@export var jump_held_coef: float

@export var camera_offset_look: float
@export var camera_offset_jump: float

var state: PlayerState = PlayerStateInit.new(self)
@onready var anim_sp: AnimatedSprite2D = $AnimatedSprite2D
@onready var tree: SceneTree = get_tree()
@onready var top: Top = tree.root.get_node("Top") as Top
@onready var inventory: Inventory = top.inventory

@onready var walk_audio: AudioStreamPlayer2D = $WalkAudio
@onready var jump_audio: AudioStreamPlayer2D = $JumpAudio
@onready var die_audio: AudioStreamPlayer2D = $DieAudio
@onready var fanfare_audio: AudioStreamPlayer2D = $FanfareAudio

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _debug_info():
	return "%s\ngot zoop: %s\ngot hanging: %s\nrelics: %s" % [state.to_string(), str(inventory.zoop), str(inventory.hanging), str(inventory.relics)]

func _camera_target() -> Vector2:
	var oy: float = 0
	if not is_on_floor():
		oy = camera_offset_jump
	return global_position + Vector2(get_facing() * camera_offset_look, oy)

func _process(delta: float) -> void:
	state._handle(delta)

	var look_at_nodes: Array[Node2D] = []
	look_at_nodes.append_array(tree.get_nodes_in_group("hook_hanging"))
	look_at_nodes.append_array(tree.get_nodes_in_group("zoop_points"))
	for look_at_node in look_at_nodes:
		var is_camera_target: bool = look_at_node.is_in_group("camera_target")
		var player_not_much_higher = (look_at_node.global_position.y - global_position.y) < 30
		var is_close: bool = ((look_at_node.global_position - global_position).length() < 100) and player_not_much_higher

		if not is_camera_target and is_close:
			look_at_node.add_to_group("camera_target")
		elif is_camera_target and not is_close:
			look_at_node.remove_from_group("camera_target")

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

func request_state_hanging(target: Node2D):
	if state is PlayerStateHanging: return
	if not PlayerStateHanging.can_hang_from(self, target): return

	state = PlayerStateHanging.new(self, target)

func request_state_zooping(target: ZoopPoint) -> bool:
	if state is PlayerStateZooping: return false
	if not PlayerStateZooping.can_zoop_to(self, target): return false

	state = PlayerStateZooping.new(self, target)
	return true

func request_state_dead():
	if state is PlayerStateDead: return false
	
	state = PlayerStateDead.new(self)

func get_facing() -> int:
	if anim_sp.flip_h:
		return -1
	else:
		return 1

func handle_action_input():
	if inventory.zoop and _try_action_zoop(): return
	if inventory.hanging and _try_action_hang(): return

func _try_action_hang() -> bool:
	var hooks = get_tree().get_nodes_in_group("hook_hanging")
	for hook_any in hooks:
		var hook: HookHanging = hook_any as HookHanging
		if request_state_hanging(hook): return true
	return false

func _try_action_zoop():
	var zoops = get_tree().get_nodes_in_group("zoop_points")
	for zoop_any in zoops:
		var zoop: ZoopPoint = zoop_any as ZoopPoint
		if request_state_zooping(zoop): return true
	return false

const walk_sfx_interval_ms = 300
var last_walk_sfx_time = -INF
func request_play_walk_sfx():
	var now = Time.get_ticks_msec()
	if now - last_walk_sfx_time > walk_sfx_interval_ms:
		walk_audio.pitch_scale = 1 + 1 * randf()
		walk_audio.volume_db = -3 + 0.5 * randf()
		walk_audio.play()
		last_walk_sfx_time = now

func request_play_jump_sfx():
	jump_audio.pitch_scale = 0.95 + 0.1 * randf()
	jump_audio.volume_db = -0.5 + 0.5 * randf()
	jump_audio.play()

func request_play_die_sfx():
	die_audio.play()

func request_play_fanfare_sfx():
	fanfare_audio.play()
