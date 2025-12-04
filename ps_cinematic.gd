class_name PlayerStateCinematic
extends PlayerState

func _to_string() -> String:
	return "PlayerStateCinematic"

func _handle(_delta: float):
	if p.velocity.x > 0:
		p.anim_sp.flip_h = false
	elif p.velocity.x < 0:
		p.anim_sp.flip_h = true

	p.anim_sp.set_animation("idle")

func _handle_physics(_delta: float):
	pass
