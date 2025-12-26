extends CharacterBody2D

class_name Player

@export var fell_off_y: float = 150.0
@export var lives: int = 3
@export var camera_min: Vector2 = Vector2(-10000, 10000)
@export var camera_max: Vector2 = Vector2(10000, -10000)

@onready var sprite: Sprite2D = $Sprite2D
@onready var debug_label: Label = $DebugLabel
@onready var shooter: Shooter = $Shooter
@onready var sound: AudioStreamPlayer2D = $Sound
@onready var hurt_timer: Timer = $HurtTimer
@onready var player_cam: Camera2D = $PlayerCam

const JUMP = preload("uid://eviw0poqok6k")
const DAMAGE = preload("uid://cjhhfqyhj3c2l")

const RUN_SPEED: int = 120
const JUMP_POWER: int = -270
const MAX_FALL: int = 350
const HURT_JUMP_VELOCITY = Vector2(0.0, -130.0)

#var _gravity: float = ProjectSettings.get("physics/2d/default_gravity")
var _gravity: float = 690.0
var _is_hurt: bool = false
var _is_invincible: bool = false

func _ready() -> void:
	call_deferred("late_init")
	set_camera_limits()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		var dir = Vector2.LEFT if sprite.flip_h else Vector2.RIGHT
		shooter.shoot(dir)


func _enter_tree() -> void:
	add_to_group(Constants.PLAYER_GROUP)


func _physics_process(delta: float) -> void:
	velocity.y += _gravity * delta
	
	if !_is_hurt:
		jump()
		move_horizontal()
	
	# clamp the max fall speed
	velocity.y = clampf(velocity.y, JUMP_POWER, MAX_FALL)
	
	move_and_slide()
	
	update_debug_label()
	fallen_off()


func _on_hitbox_area_entered(_area: Area2D) -> void:
	call_deferred("apply_hit")


func _on_hurt_timer_timeout() -> void:
	_is_hurt = false


func late_init() -> void:
	SignalHub.emit_player_hit(lives)


func reduce_lives(reduction: int) -> bool:
	lives -= reduction
	SignalHub.emit_player_hit(lives, true)
	
	if lives <= 0:
		print("DEAD")
		set_physics_process(false)
		return false
	return true


func jump() -> void:
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_POWER
		play_effect(JUMP)


func move_horizontal() -> void:
	velocity.x = Input.get_axis("left", "right") * RUN_SPEED
	if not is_equal_approx(velocity.x, 0.0):
		sprite.flip_h = velocity.x < 0


func update_debug_label() -> void:
	var ds: String = ""
	ds += "Floor:%s LV:%d\n" % [is_on_floor(), lives]
	ds += "V:%.1f,%.1f\n" % [velocity.x, velocity.y]
	ds += "P:%.1f,%.1f" % [global_position.x, global_position.y]
	debug_label.text = ds


func fallen_off() -> void:
	if global_position.y < fell_off_y:
		return
	reduce_lives(1)


func apply_hurt_jump() -> void:
	_is_hurt = true
	velocity = HURT_JUMP_VELOCITY
	hurt_timer.start()
	play_effect(DAMAGE)


func apply_hit() -> void:
	if _is_invincible: 
		return
	
	var is_alive = reduce_lives(1)
	if !is_alive:
		return
	
	go_invincible()
	apply_hurt_jump()


func go_invincible() -> void:
	if _is_invincible:
		return
	
	_is_invincible = true
	
	var flasher: Tween = create_tween()
	for i in range(3):
		flasher.tween_property(sprite, "modulate", Color("#ffffff", 0.0), 0.5)
		flasher.tween_property(sprite, "modulate", Color("#ffffff", 1.0), 0.5)

	flasher.tween_property(self, "_is_invincible", false, 0)
	

func play_effect(effect: AudioStream) -> void:
	sound.stop()
	sound.stream = effect
	sound.play()


func set_camera_limits() -> void:
	player_cam.limit_bottom = camera_min.y
	player_cam.limit_left = camera_min.x
	player_cam.limit_top = camera_max.y
	player_cam.limit_right = camera_max.x
