class_name Inventory
extends RefCounted

var zoop: bool
var hanging: bool
var relics: Array[int]

func add_relic(relic: int):
	if not relic in relics:
		relics.push_back(relic)

var cine_intro_done: bool
