extends Node

var score: int = 0
var highscore: int = 0
var reset_score: bool = false

func _ready():
	if reset_score == true:
		score = 0
		reset_score = false
	
