extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var velocidad = 75
var direccion = 1  

func _ready():
	animated_sprite_2d.play("default")

func _process(delta):
	position.x += velocidad * direccion * delta

func _on_sale_de_vista_screen_exited() -> void:
	queue_free()

func _on_shooter_area_box_area_entered(area: Area2D) -> void:
	if area.name == "player_hurtBox":
		queue_free()
