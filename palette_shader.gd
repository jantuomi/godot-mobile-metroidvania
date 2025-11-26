class_name PaletteShader
extends CanvasLayer

# Set by TransitionPlayer animation
var brightness: float = 0.3

func _process(_delta: float) -> void:
	$ColorRect.material.set_shader_parameter("brightness", brightness)
