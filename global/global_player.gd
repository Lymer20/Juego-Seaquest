extends Node

const velocidad_max: float = 300
const aceleracion: float = 900
const friccion: float = 1200
var salvados: int = 0
var jugador_muerto: bool
var waves: int = 0

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
	print("Función gameover() llamada")  # Debug
	var game_over_node = get_node("/root/Mundo/GameOver_Canvas/GameOver")
	if game_over_node:
		print("Nodo GameOver encontrado, ejecutando game_over()")
		game_over_node.game_over()
	else:
		print("Error: No se encontró el nodo GameOver")
		
