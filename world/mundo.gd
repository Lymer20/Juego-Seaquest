extends Node2D
@onready var colision_del_mapa: CollisionPolygon2D = $"StaticBody2D/Colision del Mapa"
@onready var animated_sprite_2d: AnimatedSprite2D = $"StaticBody2D/Colision del Mapa/AnimatedSprite2D"
@onready var wave_spawner_timer: Timer = $Wave_Spawner
@onready var humans_spawner_timer: Timer = $Humans_Spawner
@onready var powerup_spawner_timer: Timer = $PowerUp_Spawner
@onready var sfx_hardwave: AudioStreamPlayer = $sfx_hardwave
@onready var sfx_normalwave: AudioStreamPlayer = $sfx_normalwave

var powerup_path = preload("res://world/power_ups/spawn_powerup.tscn")
var humanos = preload("res://entities/people/spawn_humanos.tscn")

#oleadas
var oleadas = preload("res://entities/enemies/waves/oleadas.tscn")

func _ready():
	if Global_Player.waves >= 6:
		sfx_hardwave.play()
	else:
		sfx_normalwave.play()
		
	wave_spawner_timer.wait_time = 5 - (Global_Player.waves * 1.5)/10
	wave_spawner_timer.start()
	humans_spawner_timer.wait_time = 4 - (Global_Player.waves)/10
	humans_spawner_timer.start()
	powerup_spawner_timer.wait_time = 30 - (Global_Player.waves * 1.20)
	powerup_spawner_timer.start()
	animated_sprite_2d.play("default")

#funcion que elije aleatoriamente cual oleada usar
func spawn_random_wave():
	var wave_instance = oleadas.instantiate()
	var wave_y: float = (randi() % 225)
	var wave_direction = (randi() % 2)
	if wave_direction == 0:
		wave_instance.direccion = wave_instance.direccion * -1 
		wave_instance.position = Vector2(1280, wave_y)
	else:
		wave_instance.direccion = wave_instance.direccion
		wave_instance.position = Vector2(0, wave_y)
	
	add_child(wave_instance)

func spawn_humanos():
	var humano_instance = humanos.instantiate()
	add_child(humano_instance)
	
func spawn_power_up():
	var powerup_instance = powerup_path.instantiate()
	add_child(powerup_instance)
	
#aqui se llama a la funcion random cada 5 segundos	
func _on_humans_spawner_timeout() -> void:
	spawn_humanos()
	
func _on_wave_spawner_timeout() -> void:
	spawn_random_wave()
	var oportunidad_doble_spawn = (randi() % 10)
	if oportunidad_doble_spawn == 5:
		spawn_random_wave()

func _on_power_up_spawner_timeout() -> void:
	spawn_power_up()
