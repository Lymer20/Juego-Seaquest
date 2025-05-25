extends Label
@export var current_score: int = 0

func _process(delta):
	if Global_Scoreboard.reset_score:
		Global_Scoreboard.score = 0
		Global_Scoreboard.reset_score = false
		
	current_score = Global_Scoreboard.score
	self.text = str(current_score)
	
