extends Node2D
@onready var sprite_2d: Sprite2D = $Sprite2D

var velocidad = 150
var direccion = 1  

func _process(delta):
	position.x += velocidad * direccion * delta

	# Si la figura se sale de la pantalla, vuelve a aparecer
	if position.x > get_viewport_rect().size.x + 50:
		position.x = -50
	elif position.x < -50:
		position.x = get_viewport_rect().size.x + 50


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
