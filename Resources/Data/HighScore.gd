extends Resource

class_name HighScore

@export var score: int = 0
@export var date_scored: String = FoxyUtils.formatted_dt()

func _init(new_score: int = 0, new_date: String = FoxyUtils.formatted_dt()) -> void:
	score = new_score
	date_scored = new_date
