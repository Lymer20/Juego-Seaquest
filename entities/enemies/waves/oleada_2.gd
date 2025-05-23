extends Node2D

var velocidad = 150
var direccion = 1  

var enemigos = [
	preload("res://entities/enemies/shark/hurt_test.tscn"),
	preload("res://entities/enemies/submarine/submarino_test.tscn")
]

var posiciones_spawn = [
	Vector2(-32.0, 230),
	Vector2(-32.0, 342),
	Vector2(-32.0, 454)
]

func _ready():
	spawn_enemigos()
	print(posiciones_spawn.size())

func spawn_enemigos():
	var enemigo_seleccionado = enemigos.pick_random()
	for i in range(3):
		var enemigo_instance = enemigo_seleccionado.instantiate()
		enemigo_instance.position = posiciones_spawn[i]
		add_child(enemigo_instance)

func _process(delta):
	position.x += velocidad * direccion * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
