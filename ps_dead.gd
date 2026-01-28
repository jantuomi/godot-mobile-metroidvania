class_name PlayerStateDead
extends PlayerState

const DEAD_TIMEOUT = 1 # sec

func _to_string() -> String:
	return "PlayerStateDead"

func _init(pl: Player):
	super(pl)

	p.anim_sp.set_animation("dead")
	p.request_play_die_sfx()

	wait_respawn.call_deferred()
	
func wait_respawn():
	await p.get_tree().create_timer(DEAD_TIMEOUT).timeout
	p.top.game_load()

func _handle(_delta: float):
	pass

func _handle_physics(delta: float):
	p.velocity.y += p.gravity * delta
	if p.velocity.y > p.jump_strength:
		p.velocity.y = p.jump_strength
	
	p.velocity.x = 0

	p.move_and_slide()
