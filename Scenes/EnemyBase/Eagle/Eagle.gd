extends EnemyBase
class_name Eagle

@export var fly_speed = Vector2(35, 15)

@onready var turn_timer: Timer = $TurnTimer
@onready var player_detector: RayCast2D = $PlayerDetector
@onready var shooter: Shooter = $Shooter

var _fly_direction = Vector2.ZERO


func _physics_process(_delta: float) -> void:
	velocity = _fly_direction
	move_and_slide()
	shoot()


func _on_turn_timer_timeout() -> void:
	fly_to_player()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	animated_sprite_2d.play('fly')
	start_timer()
	fly_to_player()


func fly_to_player() -> void:
	flip_me()
	var x_dir: float = 1.0 if animated_sprite_2d.flip_h else -1
	_fly_direction = Vector2(x_dir, 1) * fly_speed
	#if _player_ref.global_position.x > position.x:
		#_fly_direction = fly_speed
	#else:
		#_fly_direction = Vector2(-fly_speed.x, fly_speed.y)


func shoot() -> void:
	if player_detector.is_colliding():
		var dir = Vector2.DOWN
		shooter.shoot(dir)


func start_timer() -> void:
	turn_timer.start()
