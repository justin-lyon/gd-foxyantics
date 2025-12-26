extends Node

signal create_bullet(new_position: Vector2, new_direction: Vector2, speed: float, ob_type: Constants.ObjectType)

func emit_create_bullet(new_position: Vector2, new_direction: Vector2, speed: float, ob_type: Constants.ObjectType) -> void:
	create_bullet.emit(new_position, new_direction, speed, ob_type)


signal create_object(new_position: Vector2, ob_type: Constants.ObjectType)

func emit_create_object(new_position: Vector2, ob_type: Constants.ObjectType) -> void:
	create_object.emit(new_position, ob_type)


signal scored(points: int)

func emit_scored(points: int) -> void:
	scored.emit(points)


signal boss_killed

func emit_boss_killed() -> void:
	boss_killed.emit()


signal player_hit(lives: int, shake: bool)

func emit_player_hit(lives: int = 3, shake: bool = false) -> void:
	player_hit.emit(lives, shake)


signal level_complete(complete: bool)

func emit_level_complete(complete: bool) -> void:
	level_complete.emit(complete)
