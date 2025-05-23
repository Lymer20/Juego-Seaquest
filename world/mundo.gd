extends Node2D
@onready var colision_del_mapa: CollisionPolygon2D = $"StaticBody2D/Colision del Mapa"
@onready var polygon_2d: Polygon2D = $"StaticBody2D/Colision del Mapa/Polygon2D"
var jugador_path=preload("res://entities/player/jugador.tscn")
var jugador = jugador_path.instantiate()
@export var game_over: bool

#oleadas
var oleadas = [
	preload("res://entities/enemies/waves/oleada_2.tscn")
]

func jugador_muerto():
	print(jugador.jugador_muerto)
	if jugador.jugador_muerto == true:
		get_node("GameOver_Canvas/GameOver").game_over()
		print("Se cumplio la condición")

#funcion que elije aleatoriamente cual oleada usar
func spawn_random_wave():
	var wave_scene = oleadas.pick_random()
	var wave_instance = wave_scene.instantiate()
	
	var wave_direction = (randi() % 2)
	if wave_direction == 0:
		wave_instance.direccion = wave_instance.direccion * -1 
		wave_instance.position = Vector2(1280, 0)
	else:
		wave_instance.direccion = wave_instance.direccion
		wave_instance.position = Vector2(0, 0)
	
	add_child(wave_instance)

	
#aqui se llama a la funcion random cada 5 segundos	
func _on_timer_timeout() -> void:
	spawn_random_wave()

func _ready():
	if game_over == true:
		pass

func _physics_process(delta: float) -> void:
	pass
