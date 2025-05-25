extends Node2D
@onready var colision_del_mapa: CollisionPolygon2D = $"StaticBody2D/Colision del Mapa"
@onready var polygon_2d: Polygon2D = $"StaticBody2D/Colision del Mapa/Polygon2D"
@onready var wave_spawner_timer: Timer = $Wave_Spawner

var humanos = preload("res://spawn_humanos.tscn")

#oleadas
var oleadas = [
	preload("res://entities/enemies/waves/oleada_2.tscn")
]

func _ready():
	wave_spawner_timer.wait_time = 5 - (Global_Player.waves * 1.5)/10
	wave_spawner_timer.start()

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

func spawn_humanos():
	var humano_instance = humanos.instantiate()
	add_child(humano_instance)
	
#aqui se llama a la funcion random cada 5 segundos	
func _on_humans_spawner_timeout() -> void:
	spawn_humanos()
	
func _on_timer_timeout() -> void:
	spawn_random_wave()
