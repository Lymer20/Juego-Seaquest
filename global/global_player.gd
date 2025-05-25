extends Node

const velocidad_max: float = 300
const aceleracion: float = 900
const friccion: float = 1200
var salvados: int = 0
var jugador_muerto: bool
var waves: int = 0

var heart_list: Array [TextureRect]
var health = 3

func _ready() -> void:
	var hearts_parent = $Health_bar/HBoxContainer
	for child in hearts_parent.get_children():
		heart_list.append(child)
		print(heart_list)
		
func take_damage():
	if health > 0:
		health -= 1
		update_heart_display()
		
		if health <= 0:
			gameover()
		else:
			print("Perdiste una vida, vida restante:" + str(health))
			
func update_heart_display():
	for i in range(heart_list.size()):
		heart_list[i].visible = i < health

func gameover():
	if Global_Player.jugador_muerto == true:
		get_node("/root/Mundo/GameOver_Canvas/GameOver").game_over()
