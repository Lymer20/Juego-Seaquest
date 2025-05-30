extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var oportunidad_disparo: Timer = $oportunidad_disparo
@onready var sfx_enemybullet: AudioStreamPlayer2D = $sfx_enemybullet
@onready var sfx_funnydeath: AudioStreamPlayer2D = $sfx_funnydeath
@onready var enemy_hitBox: CollisionShape2D = $enemy_hitBox/CollisionShape2D

var bala_path=preload("res://entities/enemies/submarine/enemy_bullet.tscn")
var direccion_bala: int = 1
var valor_enemigo_submarino = 20

func _ready():
	animated_sprite_2d.modulate = Color(1, 0.25, 0.25)
	animated_sprite_2d.play("default")
	if global_position.x > get_viewport_rect().size.x / 2:
		direccion_bala = -1
	else:
		direccion_bala = 1
		animated_sprite_2d.flip_h = global_position.x < get_viewport_rect().size.x / 2
	oportunidad_disparo.wait_time = max(0.5, 3 - (Global_Player.waves)/10)
	oportunidad_disparo.start()
	
func _on_enemy_s_hit_box_area_entered(area: Area2D) -> void:
	if area.name == "Muerte_por_area":
		queue_free()
		
	if area.name == "gun_hitBox":
		sfx_funnydeath.play()
		enemy_hitBox.set_deferred("disabled", true)
		var score_ganado: int 
		if Global_Player.waves >= 7:
			score_ganado = 90
		else: 
			score_ganado = (valor_enemigo_submarino + (Global_Player.waves * 10))
		Global_Scoreboard.score += score_ganado
		animated_sprite_2d.play("death")
		animated_sprite_2d.scale.y = animated_sprite_2d.scale.y*2
		animated_sprite_2d.scale.x = animated_sprite_2d.scale.x*3
		await animated_sprite_2d.animation_finished
		queue_free()
		
	

func _on_oportunidad_disparo_timeout() -> void:
	if animated_sprite_2d.animation != "death":
		var oportunidad_disparo = (randi() % 2)
		if oportunidad_disparo == 1:
			sfx_enemybullet.play()
			disparar()

func disparar():
	var bala=bala_path.instantiate()
	bala.pos=$Arma.global_position
	bala.speed = bala.speed * direccion_bala
	get_parent().add_child(bala)
