extends Label
@export var highscore: int = 0
	
func _process(_delta):
	if Global_Scoreboard.score >= Global_Scoreboard.highscore:
		Global_Scoreboard.highscore = Global_Scoreboard.score 
	highscore = Global_Scoreboard.highscore
	self.text = str(highscore)
