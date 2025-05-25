extends CharacterBody2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var oportunidad_disparo: Timer = $oportunidad_disparo
var bala_path=preload("res://entities/enemies/submarine/bala_enemiga.tscn")
var direccion_bala: int = 1
var valor_enemigo_submarino = 20

func _ready():
	sprite_2d.modulate = Color(1, 0, 0)
	if global_position.x > get_viewport_rect().size.x / 2:
		direccion_bala = -1
	else:
		direccion_bala = 1
	oportunidad_disparo.wait_time = 3 - (Global_Player.waves)/10
	oportunidad_disparo.start()
	
func _on_enemy_s_hit_box_area_entered(area: Area2D) -> void:
	if area.name == "gun_hitBox":
		var score_ganado: int 
		if Global_Player.waves >= 7:
			score_ganado = 90
		else: 
			score_ganado = (valor_enemigo_submarino + (Global_Player.waves * 10))
		Global_Scoreboard.score += score_ganado
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
