extends VBoxContainer
class_name HighScoreDisplayItem

var _high_score: HighScore = null

@onready var label_score: Label = $LabelScore
@onready var label_date: Label = $LabelDate

func _ready() -> void:
	if _high_score == null: 
		queue_free()
		return

	label_score.text = "%05d" % _high_score.score
	label_date.text = _high_score.date_scored
	run_tween()


func run_tween() -> void:
	var fadein: Tween = create_tween()
	fadein.tween_property(self, "modulate", Color("#ffffff", 1.0), 0.8)


func setup(high_score: HighScore):
	_high_score = high_score
