extends CharacterBody2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var vuelta_automatica: Timer = $Vuelta_Automatica
@onready var raycast_huida: RayCast2D = $Vuelta_Huida

var velocidad = 75
var direccion = 1  

func _process(delta):
	position.x += velocidad * direccion * delta
	vuelta_huida()

func _on_sale_de_vista_screen_exited() -> void:
	queue_free()

func _on_enemy_detect_area_entered(area: Area2D) -> void:
	if area.name == "enemy_hitBox" || area.name == "enemy_gun_hitBox":
		velocidad = velocidad * 2
	
	if area.name == "player_hurtBox":
		var personas_salvadas: int = Global_Player.salvados
		if personas_salvadas >= 6:
			print("De humanos.gd: Ya no podei")
		else:
			queue_free()

func _on_enemy_detect_area_exited(area: Area2D) -> void:
	if area.name == "enemy_hitBox" || area.name == "enemy_gun_hitBox":
		velocidad = velocidad / 2

func _on_vuelta_automatica_timeout() -> void:
	var oportunidad_vuelta = (randi() % 5)
	if oportunidad_vuelta == 4:
		scale.x = -scale.x
		direccion = direccion * -1
		print("Hubo vuelta")

func vuelta_huida():
	if raycast_huida.is_colliding():
		print("Hay colision")
		scale.x = -scale.x
		direccion = direccion * -1
	move_and_slide()
	
