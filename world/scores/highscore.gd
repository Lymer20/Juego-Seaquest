extends Label
@export var highscore: int = 0

func _ready():
	highscore = SaveLoad.highscore
	
func _process(delta):
	if Global_Scoreboard.score >= highscore:
		highscore = Global_Scoreboard.score 
	self.text = str(highscore)
