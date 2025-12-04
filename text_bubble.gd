class_name TextBubble
extends Node2D

@export var text: String

func _ready() -> void:
	$Label.text = text

func size() -> Vector2:
	return $ColorRect.size
