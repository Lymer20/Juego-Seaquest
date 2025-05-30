extends Area2D

@export var dentro_del_area = false
@export var velocidad_disminucion = 30
var cantidad_oxigeno: float = 1250
var valor_humano: int = 50
var jugador_path=preload("res://entities/player/jugador.tscn")
var jugador = jugador_path.instantiate()
@onready var tiempo_reinicio: Timer = $Tiempo_Reinicio
@onready var sfx_allsaved: AudioStreamPlayer2D = $"../sfx_allsaved"
@onready var sfx_lowoxygen: AudioStreamPlayer2D = $"../sfx_lowoxygen"
var low_oxygen_bool: bool = false

func _ready():
	tiempo_reinicio.process_mode = Timer.PROCESS_MODE_ALWAYS

func low_oxygen():
	if low_oxygen_bool == true && !sfx_lowoxygen.is_playing():
		sfx_lowoxygen.play()

func _process(delta: float) -> void:
	var progress_bar = get_node("barra de oxigeno/ProgressBar")
	progress_bar.value = cantidad_oxigeno
	
	var estilo_barra = progress_bar.get("theme_override_styles/fill")
	if cantidad_oxigeno <= 350: 
		low_oxygen_bool = true
		estilo_barra.bg_color = Color(1, 0, 0)
	else:
		low_oxygen_bool = false
		estilo_barra.bg_color = Color(0, 1, 0)
	
	if not dentro_del_area:
		cantidad_oxigeno = max(cantidad_oxigeno - velocidad_disminucion * delta, 0)
	else:
		cantidad_oxigeno = min(cantidad_oxigeno + (velocidad_disminucion * 5 * delta), 1250)
		
		if cantidad_oxigeno >= 1250:
			cantidad_oxigeno = 1250
			
	if cantidad_oxigeno <= 0:
		var jugador_node = get_node("/root/Mundo/Jugador")
		jugador_node.animated_sprite_2d.play("death")
		jugador_node.sfx_funnydeath.play()
		if jugador_node:
			if Global_Player.health > 1:
				jugador_node.take_damage()
				cantidad_oxigeno = 1250
			else:
				Global_Player.jugador_muerto = true
				Global_Player.gameover()
	low_oxygen()

func _on_body_entered(body: Node) -> void:
	if body.name == "Jugador":
		
		# Punto medio, donde no logró salvar a todos
		if Global_Player.salvados > 0 && Global_Player.salvados < 6:
			Global_Player.salvados -= 1
			#cantidad_oxigeno = 1250
			dentro_del_area = true
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
				
				var jugador_node = get_node("/root/Mundo/Jugador") 
				if jugador_node:
					jugador_node.extra_life()

			# Aumenta el wave y reinicia el oxigeno y los salvados
			Global_Player.waves += 1
			Global_Player.salvados = 0
			cantidad_oxigeno = 1250
			
			get_tree().paused = true
			tiempo_reinicio.start()
			
			# Sube a la superficie sin salvar a nadie
		else:
			var jugador_node = get_node("/root/Mundo/Jugador")
			if jugador_node:
				jugador_node.take_damage()
			
			if Global_Player.health <= 0:
				Global_Player.jugador_muerto = true
				Global_Player.gameover()
			
func _on_body_exited(body: Node) -> void:
	if body.name == "Jugador":
		#if cantidad_oxigeno < 1250:
			dentro_del_area = false
		
func _on_tiempo_reinicio_timeout() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
