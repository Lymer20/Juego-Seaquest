extends Area2D

@export var dentro_del_area = false
@export var velocidad_disminucion = 30
var cantidad_oxigeno: float = 1000
var valor_humano: int = 50
var jugador_path=preload("res://entities/player/jugador.tscn")
var jugador = jugador_path.instantiate()
@onready var tiempo_reinicio: Timer = $Tiempo_Reinicio
@onready var sfx_allsaved: AudioStreamPlayer2D = $"../sfx_allsaved"


func _ready():
	tiempo_reinicio.process_mode = Timer.PROCESS_MODE_ALWAYS

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
			
		# Punto de siguiente oleada, donde logró salvar a todos
		elif Global_Player.salvados >= 6:
			
			sfx_allsaved.play()
			var score_ganado: int 
			
			if Global_Player.waves >= 19:
				score_ganado = 500 + (valor_humano * Global_Player.waves) + ((cantidad_oxigeno / 100) * Global_Player.waves)
			else:
				score_ganado = (valor_humano * Global_Player.waves) + (cantidad_oxigeno / 50) + (250 * log(Global_Player.waves + 1))
			
			# Valor que recibe de los salvados
			for i in range(Global_Player.salvados):
				Global_Scoreboard.score += score_ganado
				
				var jugador = get_node("/root/Mundo/Jugador")  # Asegura que la ruta es correcta
				if jugador:
					jugador.extra_life()

			# Aumenta el wave y reinicia el oxigeno y los salvados
			Global_Player.waves += 1
			Global_Player.salvados = 0
			cantidad_oxigeno = 1000
			
			get_tree().paused = true
			tiempo_reinicio.start()
			
			# Sube a la superficie sin salvar a nadie
		else:
			Global_Player.jugador_muerto = true
			Global_Player.gameover()
			
func _on_tiempo_reinicio_timeout() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
