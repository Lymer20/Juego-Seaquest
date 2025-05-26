extends Node2D

var direccion = 1  

var power_ups = [
	preload("res://power_up_shooter.tscn"),
	preload("res://power_up_invincibility.tscn")
]

func _ready():
	spawn_oleada()

## Recomendación: Cambiar este metodo de hacer oleadas con
## oleadas ya predeterminadas. Aprender y hacerlo primero con la de los enemigos
func spawn_oleada():
	var pos_x
	var pos_y = randf_range(200, 544)
	var wave_direction = (randi() % 2)
	
	var powerup_escogido = power_ups.pick_random()
	var powerup = powerup_escogido.instantiate()
	if wave_direction == 0:
		powerup.scale.x = -powerup.scale.x
		powerup.direccion = -1
		powerup.position = Vector2(get_viewport_rect().size.x + 32, pos_y)
	else:
		powerup.direccion = 1
		powerup.position = Vector2(-32, pos_y)

	add_child(powerup)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
