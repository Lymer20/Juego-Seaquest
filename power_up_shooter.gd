extends CharacterBody2D
@onready var sprite_2d: Sprite2D = $Sprite2D
var velocidad = 75
var direccion = 1  

func _process(delta):
	position.x += velocidad * direccion * delta

func _on_sale_de_vista_screen_exited() -> void:
	queue_free()

func _on_shooter_area_box_area_entered(area: Area2D) -> void:
	if area.name == "player_hurtBox":
		queue_free()
