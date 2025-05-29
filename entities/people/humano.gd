extends CharacterBody2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var vuelta_automatica: Timer = $Vuelta_Automatica
@onready var raycast_huida: RayCast2D = $Vuelta_Huida
@onready var humanos_container = $humans_bar/HBoxContainer
const MAX_RESCUED = 6

var velocidad_inicial = 75
var velocidad = velocidad_inicial + (velocidad_inicial * Global_Player.waves)/15
var direccion = 1 

func _ready() -> void:
	humanos_container.visible = false 

func update_rescued():
	for i in range(MAX_RESCUED):
		var humanos = humanos_container.get_child(i)
		humanos.visible = i < Global_Player.salvados


func _process(delta):
	humanos_container.visible = Global_Player.salvados > 0
	update_rescued()
	position.x += velocidad * direccion * delta
	vuelta_huida()

func _on_sale_de_vista_screen_exited() -> void:
	queue_free()

func _on_enemy_detect_area_entered(area: Area2D) -> void:
	if area.name == "enemy_hitBox" || area.name == "enemy_gun_hitBox":
		velocidad = velocidad * 2
	
	if area.name == "player_hurtBox":
		var personas_salvadas: int = Global_Player.salvados 
		if Global_Player.salvados < MAX_RESCUED:
			Global_Player.salvados += 1
			update_rescued()
			queue_free()
			
	if area.name == "Muerte_por_area":
		queue_free()

func _on_enemy_detect_area_exited(area: Area2D) -> void:
	if area.name == "enemy_hitBox" || area.name == "enemy_gun_hitBox":
		velocidad = velocidad / 2

func _on_vuelta_automatica_timeout() -> void:
	var oportunidad_vuelta = (randi() % 5)
	if oportunidad_vuelta == 4:
		scale.x = -scale.x
		direccion = direccion * -1

func vuelta_huida():
	if raycast_huida.is_colliding():
		scale.x = -scale.x
		direccion = direccion * -1

	move_and_slide()
	
