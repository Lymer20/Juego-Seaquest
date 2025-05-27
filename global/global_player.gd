extends Node

const velocidad_max: float = 300
const aceleracion: float = 900
const friccion: float = 1200
var salvados: int = 0
var jugador_muerto: bool
var waves: int = 0

func gameover():
	if Global_Player.jugador_muerto:
		get_node("/root/Mundo/GameOver_Canvas/GameOver").game_over()
		print("Game Over")
