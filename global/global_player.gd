extends Node

const velocidad_max: float = 300
const aceleracion: float = 900
const friccion: float = 1600
var salvados: int = 0
var jugador_muerto: bool
var waves: int = 0
var health: int = 3
var check_life = 0

func pausa():
	get_node("/root/Mundo/Canvas/Pausa").pausa()

func gameover():
	get_node("/root/Mundo/Canvas/GameOver").game_over()
	print("Game Over")
