extends CharacterBody2D
@onready var sprite_2d: Sprite2D = $Sprite2D
var bala_path=preload("res://entities/enemies/submarine/bala_enemiga.tscn")
var direccion_bala: int = 1

func _ready():
	sprite_2d.modulate = Color(1, 0, 0)
	if global_position.x > get_viewport_rect().size.x / 2:
		direccion_bala = -1
	else:
		direccion_bala = 1

func _on_enemy_s_hit_box_area_entered(area: Area2D) -> void:
	if area.name == "gun_hitBox":
		print("Ohsi, lo mataste!")
		queue_free()

func _on_oportunidad_disparo_timeout() -> void:
	var oportunidad_disparo = (randi() % 2)
	if oportunidad_disparo == 1:
		disparar()

func disparar():
	var bala=bala_path.instantiate()

	bala.pos=$Arma.global_position
		
	bala.speed = bala.speed * direccion_bala
	get_parent().add_child(bala)
