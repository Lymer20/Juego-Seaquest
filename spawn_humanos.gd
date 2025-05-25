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

func _ready():
	spawn_oleada()

func spawn_oleada():
	var cantidad_humanos = randi_range(1, 4) 
	var pos_y = randf_range(230, 454)
	var humano_direction = randi_range(0, 1)
	
	for i in range(cantidad_humanos):
		var humano_escena = humanos.pick_random()
		var humano_instance = humano_escena.instantiate()
		
		if humano_direction == 0:
			humano_instance.scale.x = -humano_instance.scale.x
			humano_instance.direccion = -1
			humano_instance.position = Vector2(get_viewport_rect().size.x + 50, pos_y + (i * 40))  
		else:
			humano_instance.direccion = 1
			humano_instance.position = Vector2(-50, pos_y + (i * 40))  
			
		#humano_instance.scale.x = -1 if humano_direction == 0 else 1
		
		add_child(humano_instance)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
