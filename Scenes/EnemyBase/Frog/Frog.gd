extends EnemyBase
class_name Frog

@onready var jump_timer: Timer = $JumpTimer

const JUMP_VELOCITY_L = Vector2(100, -150)
const JUMP_VELOCITY_R = Vector2(-100, -150)

var _seen_player: bool = false
var _can_jump: bool = false

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	velocity.y += delta * _gravity
	
	apply_jump()
	move_and_slide()
	flip_me()
	
	if is_on_floor() and velocity.x != 0:
		velocity.x = 0
		animated_sprite_2d.play("idle")


func apply_jump() -> void:
	if !is_on_floor() or !_can_jump:
		return
	if !_seen_player:
		return
	
	if animated_sprite_2d.flip_h:
		velocity = JUMP_VELOCITY_L
	else:
		velocity = JUMP_VELOCITY_R
	
	_can_jump = false
	start_timer()
	animated_sprite_2d.play("jump")


func start_timer() -> void:
	jump_timer.wait_time = randf_range(2.0, 3.0)
	jump_timer.start()


func _on_jump_timer_timeout() -> void:
	_can_jump = true


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	super._on_visible_on_screen_notifier_2d_screen_entered()
	if !_seen_player:
		_seen_player = true
		start_timer()
