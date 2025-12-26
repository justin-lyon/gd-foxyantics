extends Camera2D

@export var shake_amount: float = 5.0
@export var shake_time: float = 0.3

func _ready() -> void:
	set_process(false)


func _enter_tree() -> void:
	SignalHub.player_hit.connect(_on_player_hit)


func _process(_delta: float) -> void:
	offset = Vector2(
		randf_range(-shake_amount, shake_amount), 
		randf_range(-shake_amount, shake_amount)
	)


func reset_camera() -> void:
	set_process(false)
	offset = Vector2.ZERO


func _on_player_hit(_lives: int, is_shake: bool) -> void:
	if is_shake: 
		set_process(true)
		await get_tree().create_timer(shake_time).timeout
		reset_camera()
