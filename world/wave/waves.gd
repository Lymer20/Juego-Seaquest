extends Label
var wave_actual: int = 0

func _process(_delta):
	wave_actual = Global_Player.waves + 1
	self.text = "Wave actual: " + str(wave_actual)
	
