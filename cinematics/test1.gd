class_name CinematicTest1
extends Cinematic

func _ready():
	var player: Player = get_room_node("Player")
	var npc: Node2D = get_room_node("CinematicTestNPC")
	player.request_state_forced("DROP")

	await say(player, "hello")
	await say(npc, "well hi")
	var answer = await ask(npc, "buy or sell?", ["buy", "sell"])
	await say(npc, "it's %s time" % answer)
	
	player.request_state_normal()
	print("dialogue done, answer %s" % answer)
