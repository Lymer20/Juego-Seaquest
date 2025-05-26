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

#vida
var heart_list: Array = []
var health = 3

func _ready() -> void:
	var hearts_parent = $/root/Mundo/Jugador/heatlh_bar/HBoxContainer
	for child in hearts_parent.get_children():
		heart_list.append(child)
		print(heart_list)
		
func take_damage():
	if health > 0:
		health -= 1
		update_heart_display()
		
		if health <= 0:
			Global_Player.gameover()
		else:
			print("Perdiste una vida, vida restante:" + str(health))
			
func update_heart_display():
	for i in range(heart_list.size()):
		heart_list[i].visible = i < health
		
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
