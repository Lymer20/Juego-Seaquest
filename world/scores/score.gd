extends Label
@export var current_score: int = 0

func _process(delta):
	current_score = Global_Scoreboard.score
	self.text = str(current_score)
