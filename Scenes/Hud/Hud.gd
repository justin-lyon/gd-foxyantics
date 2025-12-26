extends Control

const GAME_OVER = preload("uid://bto4slrhp4bqp")
const YOU_WIN = preload("uid://k6hnq2x72tgi")

@onready var score_label: Label = $MarginContainer/ScoreLabel
@onready var hb_hearts: HBoxContainer = $MarginContainer/HBHearts
@onready var color_rect: ColorRect = $ColorRect
@onready var vb_game_over: VBoxContainer = $ColorRect/VBGameOver
@onready var vb_complete: VBoxContainer = $ColorRect/VBComplete
@onready var complete_timer: Timer = $CompleteTimer
@onready var sound: AudioStreamPlayer2D = $Sound

var _score: int = 0;
var _hearts: Array
var _can_continue: bool = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("quit"):
		GameManager.load_main()

	if event.is_action_pressed("next"):
		GameManager.load_next_level()
	
	if _can_continue and event.is_action_pressed("shoot"):
		if vb_game_over.visible:
			GameManager.load_main()
		else:
			GameManager.load_next_level()


func _ready() -> void:
	_hearts = hb_hearts.get_children()
	_score = GameManager.cached_score
	_on_scored(0)


func _enter_tree() -> void:
	SignalHub.scored.connect(_on_scored)
	SignalHub.player_hit.connect(_on_player_hit)
	SignalHub.level_complete.connect(_on_level_complete)


func _exit_tree() -> void:
	GameManager.try_add_new_score(_score)


func _on_scored(points: int) -> void:
	_score += points
	score_label.text = "%05d" % _score


func _on_player_hit(lives: int, shake: bool) -> void:
	for index in range(_hearts.size()):
		_hearts[index].visible = lives > index
	
	if lives <= 0:
		_on_level_complete(false)


func _on_level_complete(is_complete: bool) -> void:
	color_rect.show()
	
	if (is_complete):
		vb_complete.show()
		sound.stream = YOU_WIN
	else: 
		vb_game_over.show()
		sound.stream = GAME_OVER
	
	sound.play()
	get_tree().paused = true
	complete_timer.start()


func _on_complete_timer_timeout() -> void:
	_can_continue = true
