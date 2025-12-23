extends Area2D
class_name Bullet

var _direction = Vector2(50, -50)

func _process(delta: float) -> void:
	position += _direction * delta


func setup(new_position: Vector2, new_direction: Vector2, speed: float) -> void:
	_direction = new_direction.normalized() * speed
	global_position = new_position


func _on_area_entered(_area: Area2D) -> void:
	queue_free()
