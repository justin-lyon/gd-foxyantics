extends PathFollow2D

@export var speed = 150.0

func _physics_process(delta: float) -> void:
	progress += speed * delta
