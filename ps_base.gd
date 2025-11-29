@abstract class_name PlayerState
extends RefCounted

var p: Player

func _init(pl: Player): p = pl
@abstract func _handle(delta: float)
@abstract func _handle_physics(delta: float)
