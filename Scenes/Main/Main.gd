extends Control

@onready var scores_container: GridContainer = $MarginContainer/GridContainer

const HIGH_SCORE_DISPLAY = preload("uid://c8jvlp4ibcxk7")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		GameManager.load_next_level()


func _ready() -> void:
	get_scores()

func get_scores() -> void:
	for score: HighScore in GameManager.high_scores.get_scores_list():
		var hsd = HIGH_SCORE_DISPLAY.instantiate()
		hsd.setup(score)
		scores_container.add_child(hsd)
