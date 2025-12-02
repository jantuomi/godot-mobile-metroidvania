class_name TriggerButton
extends Node2D

signal triggered

func _on_player_entered(_player: Player) -> void:
	triggered.emit()
