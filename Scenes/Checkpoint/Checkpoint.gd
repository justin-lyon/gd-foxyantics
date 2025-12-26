extends Area2D

var _is_boss_killed: bool = false

func _ready() -> void:
	SignalHub.boss_killed.connect(_on_boss_killed)


func _on_boss_killed() -> void:
	_is_boss_killed = true
	print("boss killed")


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "open":
		set_deferred("monitoring", true)


func _on_area_entered(_area: Area2D) -> void:
	SignalHub.emit_level_complete(true)
