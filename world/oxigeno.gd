extends Area2D

@export var dentro_del_area = false
@export var velocidad_disminucion = 30
var cantidad_oxigeno: float = 1000
var valor_humano: int = 50
var jugador_path=preload("res://entities/player/jugador.tscn")
var jugador = jugador_path.instantiate()

func _process(delta: float) -> void:
	var progress_bar = get_node("barra de oxigeno/ProgressBar")
	progress_bar.value = cantidad_oxigeno
	cantidad_oxigeno = max(cantidad_oxigeno - velocidad_disminucion * delta, 0)

func _on_body_entered(body: Node) -> void:
	if body.name == "Jugador":
		# Punto medio, donde no logró salvar a todos
		if Global_Player.salvados > 0 && Global_Player.salvados < 6:
			Global_Player.salvados -= 1
			cantidad_oxigeno = 1000
			print("Bien, sigue salvando")
			
		# Punto de siguiente oleada, donde logró salvar a todos
		elif Global_Player.salvados >= 6:
			
			var score_ganado: int 
			
			if Global_Player.waves >= 19:
				score_ganado = 1000 + ((cantidad_oxigeno)*2 * Global_Player.waves)
			else:
## ARREGLAR DESPUES !!!!!
				score_ganado = (valor_humano + (Global_Player.waves * valor_humano) + ((cantidad_oxigeno)* 10 * Global_Player.waves))

			# Valor que recibe de los salvados
			for i in range(Global_Player.salvados):
				Global_Scoreboard.score += score_ganado

			# Aumenta el wave y reinicia el oxigeno y los salvados
			Global_Player.waves += 1
			Global_Player.salvados = 0
			cantidad_oxigeno = 1000
			print("Avanzas de ola")
		else:
			print("Haha q tonto")
			Global_Player.jugador_muerto = true
			Global_Player.gameover()


 
