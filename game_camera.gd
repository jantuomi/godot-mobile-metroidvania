extends Camera2D

@onready var parent = get_parent()
@onready var is_parent_player = parent is Player

## Amount to smoothly offset the camera if the parent is a Player.
@export var offset_amt: Vector2

var time_since_floor: float = 0.0
var time_since_floor_max: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#if player.is_on_floor():
	#	time_since_floor = 0
	#elif time_since_floor < time_since_floor_max:
	#	time_since_floor += delta
	
	if is_parent_player:
		var player: Player = parent
		position.x = player.get_facing() * offset_amt.x

		if not player.is_on_floor():
			position.y = offset_amt.y
		else:
			position.y = 0

	#offset.y = lerpf(0.0, look_down_on_jump_amt, ease(time_since_floor, 0.2))
	#print_debug("offset y:", offset.y)
