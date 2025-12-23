extends Area2D

var _is_boss_killed: bool = false

func _ready() -> void:
	SignalHub.boss_killed.connect(_on_boss_killed)


func _on_boss_killed() -> void:
	print("boss killed")
	_is_boss_killed = true
