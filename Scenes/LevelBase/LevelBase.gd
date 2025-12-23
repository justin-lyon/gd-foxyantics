extends Node2D


func _ready() -> void:
	await get_tree().create_timer(2.0).timeout
	SignalHub.emit_boss_killed()


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("test"):
		pass
