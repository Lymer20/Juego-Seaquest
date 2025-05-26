extends Node

@onready var power_up_duration: Timer = $/root/Mundo/Jugador/PowerUp_Duration
const velocidad_max: float = 300
const aceleracion: float = 900
const friccion: float = 1200
var salvados: int = 0
var jugador_muerto: bool
var waves: int = 0
var shooter_cooldown: float = 0
var invincibility: bool = false

func gameover():
	if Global_Player.jugador_muerto == true:
		get_node("/root/Mundo/GameOver_Canvas/GameOver").game_over()

func shooter_powerup():
	shooter_cooldown = 0.3
	power_up_duration.wait_time = 10
	power_up_duration.start()

func invincibility_powerup():
	invincibility = true
	power_up_duration.wait_time = 10
	power_up_duration.start()
