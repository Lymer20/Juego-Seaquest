extends Node2D
@onready var colision_del_mapa: CollisionPolygon2D = $"StaticBody2D/Colision del Mapa"
@onready var polygon_2d: Polygon2D = $"StaticBody2D/Colision del Mapa/Polygon2D"
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
	polygon_2d.polygon = colision_del_mapa.polygon

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("revivir"):
		for node in get_children():
			if node.is_in_group("jugador") or node.is_in_group("enemigo"):
				node.queue_free()

func _on_oxigeno_area_entered(area: Area2D) -> void:

	if jugador.salvados > 0:
		print("Total de personas salvadas: " + str(jugador.salvados) + ". Se aumentará el tamaño cuando salgas para testear")
	else:
		print("Busca mas personas por salvar!")
	print("¡Estas recibiendo oxígeno!")

func _on_oxigeno_area_exited(area: Area2D) -> void:
	print("¡Dejaste de recibir oxígeno!")
	jugador.salvados = jugador.salvados + 1
