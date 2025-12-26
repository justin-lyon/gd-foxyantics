extends Node2D


func _ready() -> void:
	get_tree().paused = false


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("test"):
		pass
