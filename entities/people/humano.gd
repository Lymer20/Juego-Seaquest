extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var vuelta_automatica: Timer = $Vuelta_Automatica
@onready var raycast_huida: RayCast2D = $Vuelta_Huida
@onready var jugador = get_node("/root/Mundo/Jugador")

var velocidad_inicial = 75
var velocidad = velocidad_inicial + (velocidad_inicial * Global_Player.waves)/15
var direccion = 1 
var max_rescued = 6

func _ready() -> void:
	animated_sprite_2d.play("default")
	if jugador:
		max_rescued = jugador.MAX_RESCUED

func _process(delta):
	var velocidad_final: float
	if Global_Player.waves >= 25:
		velocidad_final = 200
	else:
		velocidad_final = velocidad
	position.x += velocidad_final * direccion * delta
	vuelta_huida()

func _on_sale_de_vista_screen_exited() -> void:
	queue_free()

func _on_enemy_detect_area_entered(area: Area2D) -> void:
	if area.name == "enemy_hitBox" || area.name == "enemy_gun_hitBox":
		animated_sprite_2d.play("flee")
		velocidad = velocidad * 2
	
	if area.name == "player_hurtBox":
		var personas_salvadas: int = Global_Player.salvados 
		if Global_Player.salvados < max_rescued:
			Global_Player.salvados += 1
			jugador.update_rescued()
			queue_free()
			
	if area.name == "Muerte_por_area":
		queue_free()

func _on_enemy_detect_area_exited(area: Area2D) -> void:
	if area.name == "enemy_hitBox" || area.name == "enemy_gun_hitBox":
		animated_sprite_2d.play("default")
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
	
