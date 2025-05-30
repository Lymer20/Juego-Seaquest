extends Node2D

var direccion = 1  

var humanos = [
	preload("res://entities/people/humano.tscn")
]

var posiciones_spawn = [
	Vector2(-32.0, 230),
	Vector2(-32.0, 342),
	Vector2(-32.0, 454)
]

var max_humanos = 5
var humanos_pantalla = 0

func _ready():
	spawn_oleada()

## Recomendación: Cambiar este metodo de hacer oleadas con
## oleadas ya predeterminadas. Aprender y hacerlo primero con la de los enemigos
## Update 30/05/2025: Ya está listo, y quedó bien bonito:D
func spawn_oleada():
	if humanos_pantalla >= max_humanos:
		return
	
	var probabilidad = randi() % 100
	var cantidad_humanos: int 
	
	if probabilidad < 50:
		cantidad_humanos = 1
	elif probabilidad < 70:
		cantidad_humanos = 2
	elif probabilidad < 90:
		cantidad_humanos = 3
	else:
		cantidad_humanos = 4
		
	cantidad_humanos = min(cantidad_humanos, max_humanos - humanos_pantalla)
	
	var pos_y = randf_range(215, 434)
	var humano_direction = randi_range(0, 1)
	
	for i in range(cantidad_humanos):
		var humano_escena = humanos.pick_random()
		var humano_instance = humano_escena.instantiate()
		
		if humano_direction == 0:
			humano_instance.scale.x = -humano_instance.scale.x
			humano_instance.direccion = -1
			humano_instance.position = Vector2(get_viewport_rect().size.x + 50, pos_y + (i * 100))  
		else:
			humano_instance.direccion = 1
			humano_instance.position = Vector2(-50, pos_y + (i * 100))  
			
		#humano_instance.scale.x = -1 if humano_direction == 0 else 1
		
		add_child(humano_instance)
		humanos_pantalla += 1

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	humanos_pantalla = max(0, humanos_pantalla - 1)
	queue_free()
