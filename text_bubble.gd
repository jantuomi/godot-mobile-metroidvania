class_name TextBubble
extends Node2D

@export var text: String
@export var options: Array[String]

signal answered(text: String)

func _ready() -> void:
	find_child("Label").text = text
	var hbox: HBoxContainer = find_child("HBoxContainer")
	
	var first = true
	for option in options:
		var btn = Button.new()
		btn.text = option
		hbox.add_child(btn)
		
		btn.connect("pressed", func (): answered.emit(option))
		
		if first:
			btn.grab_focus.call_deferred()
			first = false
