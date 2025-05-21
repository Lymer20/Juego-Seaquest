extends Node2D
@onready var colision_del_mapa: CollisionPolygon2D = $"StaticBody2D/Colision del Mapa"
@onready var polygon_2d: Polygon2D = $"StaticBody2D/Colision del Mapa/Polygon2D"
var enemigo_path=preload("res://hurt_test.tscn")
var jugador_path=preload("res://entities/player/jugador.tscn")
var jugador = jugador_path.instantiate()

#oleadas
var oleadas = [
	preload("res://entities/enemies/waves/oleada_1.tscn"),
	preload("res://entities/enemies/waves/oleada_2.tscn"),
	preload("res://entities/enemies/waves/oleada_3.tscn")
]

#funcion que elije aleatoriamente cual oleada usar
func spawn_random_wave():
	var wave_scene = oleadas.pick_random()
	var wave_instance = wave_scene.instantiate()
	#wave_scene.position = Vector2(randf_range(100, 500), randf_range(100, 300))
	add_child(wave_instance)
	
#aqui se llama a la funcion random cada 3 segundos	
func _on_timer_timeout() -> void:
	spawn_random_wave()

func _ready():
	polygon_2d.polygon = colision_del_mapa.polygon
	

	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("revivir"):
		for node in get_children():
			if node.is_in_group("jugador") or node.is_in_group("enemigo"):
				node.queue_free()
		revivir()
		
func revivir():
	var enemigo = enemigo_path.instantiate()
	add_child(enemigo)
	add_child(jugador)
	jugador.global_position = Vector2(550, 400)
	enemigo.global_position = Vector2(1150, 400)
	jugador.add_to_group("jugador")
	enemigo.add_to_group("enemigo")
	

func _on_oxigeno_area_entered(area: Area2D) -> void:

	if jugador.salvados > 0:
		print("Total de personas salvadas: " + str(jugador.salvados))
	else:
		print("Busca mas personas por salvar!")
	print("¡Estas recibiendo oxígeno!")

func _on_oxigeno_area_exited(area: Area2D) -> void:
	print("¡Dejaste de recibir oxígeno!")
	jugador.salvados = jugador.salvados + 1
