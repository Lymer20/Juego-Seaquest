extends Node2D

var velocidad = 150
var direccion = 1  

var enemigos = [
	preload("res://entities/enemies/shark/shark.tscn"),
	preload("res://entities/enemies/submarine/enemy_submarine.tscn")
]

var posiciones_spawn: Array

var posicion_escoger: Array

var posicion_1: Array = [
	Vector2(-32.0, 230),
	Vector2(68.0, 230),
	Vector2(168.0, 230)]

var posicion_2: Array = [	
	Vector2(-32.0, 230),
	Vector2(-32.0, 332),
	Vector2(-32.0, 434)]

var posicion_3: Array = [	
	Vector2(-32.0, 230),
	Vector2(-32.0, 332),
	Vector2(68.0, 230),
	Vector2(68.0, 332)]

var posicion_4: Array = [
	Vector2(-32.0, 230),
	Vector2(-32.0, 332),
	Vector2(-32.0, 434),
	Vector2(68.0, 230),
	Vector2(68.0, 332),
	Vector2(68.0, 434)]

var posicion_5: Array = [
	Vector2(-32.0, 230),
	Vector2(68.0, 230),
	Vector2(168.0, 230),
	Vector2(-32.0, 332),
	Vector2(68.0, 332),
	Vector2(168.0, 332)]

var posicion_6: Array = [
	Vector2(-32.0, 230),
	Vector2(68.0, 332),
	Vector2(168.0, 230),
	Vector2(268.0, 332)]

var posicion_7: Array = [
	Vector2(-32.0, 230),
	Vector2(68.0, 230),
	Vector2(168.0, 230),
	Vector2(268.0, 230),
	Vector2(-32.0, 332),
	Vector2(68.0, 332),
	Vector2(168.0, 332),
	Vector2(268.0, 332)]

var posicion_8: Array = [
	Vector2(-32.0, 230),
	Vector2(68.0, 230),
	Vector2(168.0, 230),
	Vector2(-32.0, 332),
	Vector2(68.0, 332),
	Vector2(168.0, 332),
	Vector2(-32.0, 434),
	Vector2(68.0, 434),
	Vector2(168.0, 434)]

var posicion_9: Array = [
	Vector2(-32.0, 230),
	Vector2(68.0, 332),
	Vector2(168.0, 434),
	Vector2(268.0, 332),
	Vector2(368.0, 230),
	Vector2(468.0, 332),
	Vector2(568.0, 434),
	Vector2(668.0, 332),
	Vector2(778.0, 230)]

var posicion_10: Array = [
	Vector2(-32.0, 230),
	Vector2(68.0, 230),
	Vector2(168.0, 230),
	Vector2(268.0, 230),
	Vector2(-32.0, 332),
	Vector2(68.0, 332),
	Vector2(168.0, 332),
	Vector2(268.0, 332),
	Vector2(-32.0, 434),
	Vector2(68.0, 434),
	Vector2(168.0, 434),
	Vector2(268.0, 434),
	Vector2(-32.0, 536),
	Vector2(68.0, 536),
	Vector2(168.0, 536),
	Vector2(268.0, 536),
]

func _ready():
	if Global_Player.waves < 3:
		posicion_escoger = [
			posicion_1, posicion_2, posicion_3, posicion_4]
	elif Global_Player.waves >= 3 || Global_Player.waves <= 6:
		posicion_escoger = [
			posicion_1, posicion_2, posicion_3, posicion_4,
			posicion_5, posicion_6, posicion_7]
	elif Global_Player.waves > 6:	
		posiciones_spawn = [
			posicion_1, posicion_2, posicion_3, posicion_4,
			posicion_5, posicion_6, posicion_7, posicion_8,
			posicion_9, posicion_10]
	elegir_oleada()
	spawn_enemigos()

func elegir_oleada():
	posiciones_spawn = posicion_escoger.pick_random()

func spawn_enemigos():
	var enemigo_seleccionado = enemigos.pick_random()
	var cantidad_enemigos = posiciones_spawn.size()
	
	for i in range(cantidad_enemigos):
		var enemigo_instance = enemigo_seleccionado.instantiate()
		if direccion == -1:
			enemigo_instance.position = posiciones_spawn[i]
		else:
			enemigo_instance.position = Vector2(posiciones_spawn[i].x * -1, posiciones_spawn[i].y)
		add_child(enemigo_instance)

func _process(delta):
	var movimiento_base: float = (velocidad * direccion * delta)
	var movimiento_def = movimiento_base + (movimiento_base * Global_Player.waves)/10
	position.x += movimiento_def

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
