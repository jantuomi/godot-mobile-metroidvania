class_name DialogueTest1
extends Dialogue

@onready var player: Player = parent.get_node("Player")
@onready var npc: Node2D = parent.get_node("DialogueTestNPC")

func _ready():
	player.request_state_forced("DROP")

	await say(player, "hello")
	await say(npc, "well hi")
	var answer = await ask(npc, "buy or sell?", ["buy", "sell"])
	await say(npc, "it's %s time" % answer)
	
	player.request_state_normal()
	print("dialogue done, answer %s" % answer)
