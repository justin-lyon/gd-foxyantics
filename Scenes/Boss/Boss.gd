extends Node2D

@export var lives: int = 2
@export var points: int = 5

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var hitbox: Area2D = $Visuals/Hitbox
@onready var shooter: Shooter = $Visuals/Shooter
@onready var state_machine: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]
@onready var visuals: Node2D = $Visuals

var _player_ref: Player
var _invincible: bool = false

func _ready() -> void:
	_player_ref = get_tree().get_first_node_in_group(Constants.PLAYER_GROUP)
	if _player_ref == null:
		queue_free()


func _on_trigger_area_entered(_area: Area2D) -> void:
	animation_tree["parameters/conditions/on_trigger"] = true


func _on_hitbox_area_entered(_area: Area2D) -> void:
	take_damage()


func reduce_lives() -> void:
	lives -= 1
	if lives <= 0:
		SignalHub.emit_scored(points)
		SignalHub.emit_boss_killed()
		queue_free()


func tween_hit() -> void:
	var hit_to_start: Tween = create_tween()
	hit_to_start.tween_property(visuals, "position", Vector2.ZERO, 1.8)


func take_damage() -> void:
	if _invincible: 
		return
	
	reduce_lives()
	set_invincible(true)
	state_machine.travel("hit")
	tween_hit()


func set_invincible(is_invincible: bool) -> void:
	_invincible = is_invincible


func activate_collisions() -> void:
	hitbox.set_deferred("monitoring", true)
	hitbox.set_deferred("monitorable", true)


func shoot() -> void:
	shooter.shoot(
		shooter.global_position.direction_to(
			_player_ref.global_position
		)
	)
