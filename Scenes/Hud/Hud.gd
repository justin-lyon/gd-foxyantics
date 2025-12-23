extends Control

@onready var score_label: Label = $MarginContainer/ScoreLabel
var _score: int = 0;

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("quit"):
		GameManager.load_main()


func _ready() -> void:
	_score = GameManager.cached_score
	_on_scored(0)


func _enter_tree() -> void:
	SignalHub.scored.connect(_on_scored)


func _exit_tree() -> void:
	GameManager.try_add_new_score(_score)


func _on_scored(points: int) -> void:
	_score += points
	score_label.text = "%05d" % _score
