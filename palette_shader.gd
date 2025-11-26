class_name PaletteShader
extends CanvasLayer

@export_range(-1, 1) var brightness: float = 0.0

func notify_brightness_changed():
	$ColorRect.material.set_shader_parameter("brightness", brightness)
