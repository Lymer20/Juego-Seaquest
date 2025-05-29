extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@onready var power_up_duration: Timer = $/root/Mundo/Jugador/PowerUp_Duration
var rapidfire: bool = false
var invincibility: bool = false
var shooter_cooldown = 0.0
@onready var sfx_powerup: AudioStreamPlayer2D = $sfx_powerup
@onready var sfx_normalwave: AudioStreamPlayer = $"../sfx_normalwave"
@onready var sfx_hardwave: AudioStreamPlayer = $"../sfx_hardwave"
@onready var sfx_funnydeath: AudioStreamPlayer2D = $sfx_funnydeath
@onready var player_hurtBox: CollisionShape2D = $player_hurtBox/CollisionShape2D

@export var dentro_del_area = false
@onready var barra_oxigeno: ProgressBar = $"../Oxigeno/barra de oxigeno/ProgressBar"
@onready var arma: Node2D = $Arma
@onready var cooldown: Timer = $Arma/cooldown
@onready var reinicio: Timer = $reinicio
@onready var humanos_container = $humans_bar/HBoxContainer

# Movimiento
const velocidad_max: float = Global_Player.velocidad_max
const aceleracion: float = Global_Player.aceleracion
const friccion: float = Global_Player.friccion
@onready var sfx_playerbullet: AudioStreamPlayer2D = $sfx_playerbullet
@onready var sfx_rapidfire: AudioStreamPlayer2D = $sfx_rapidfire

# Personas a salvar
var salvados: int = 0

# Disparo
var bala_path=preload("res://entities/player/bala.tscn")
var direccion_disparo = 1

# Cooldown del disparo
var shoot: bool = true

#vidas
var heart_list: Array [TextureRect]
var max_hearts = 6

const MAX_RESCUED = 6

func _ready() -> void:	
	reinicio.process_mode = Timer.PROCESS_MODE_ALWAYS
	humanos_container.visible = false 
	
	var hearts_parent = $health_bar/HBoxContainer
	var children = hearts_parent.get_children()
	heart_list.clear()
	
	for i in range(children.size()):
		heart_list.append(children[i])
	
	update_heart_display()

func update_heart_display():
	for i in range(heart_list.size()):
		heart_list[i].visible = i < Global_Player.health

#vidas extras
func extra_life():
	var puntos_necesarios = Global_Scoreboard.score - Global_Player.check_life
	if puntos_necesarios >= 1000 and Global_Player.health < max_hearts:
		Global_Player.health += 1 
		Global_Scoreboard.score -= 1000
		Global_Player.check_life += 1000  
		update_heart_display()
		print("¡Has ganado una vida extra!")
		
func take_damage():
	if Global_Player.health > 0:
		Global_Player.health -= 1
		update_heart_display()
		
		if Global_Player.health <= 0:
			Global_Player.jugador_muerto = true
			Global_Player.gameover()
		else:
			print("Perdiste una vida, vida restante:" + str(Global_Player.health))
			get_tree().paused = true
			reinicio.start()
#humanos
func update_rescued():
	for i in range(MAX_RESCUED):
		var humanos = humanos_container.get_child(i)
		humanos.visible = i < Global_Player.salvados

func _physics_process(delta: float) -> void:
	humanos_container.visible = Global_Player.salvados > 0
	update_rescued()
	# MOVIMIENTO
	# Estas variables detectan movimiento en X y en Y
	var movimiento_x := Input.get_axis("izquierda", "derecha")
	var movimiento_y := Input.get_axis("arriba", "abajo")
	# Por alguna razón, para ir arriba, se necesita que el "salto" sea negativo... Godot, ¿¿¿q fue???
	
	# Movimiento en X
	if movimiento_x:
		# Movimiento como tal
		velocity.x = move_toward(velocity.x, movimiento_x * velocidad_max, aceleracion * delta)
		
		# Dirección de la bala
		if movimiento_x < 0:
			direccion_disparo = -1
		else:
			direccion_disparo = 1	
	else:
		velocity.x = move_toward(velocity.x, 0, friccion * delta)

	# Movimiento en Y
	if movimiento_y:
		velocity.y = move_toward(velocity.y, movimiento_y * velocidad_max, aceleracion * delta)
	else:
		velocity.y = move_toward(velocity.y, 0, friccion * delta)

	# DISPARO DEL ARMA
	if Input.is_action_pressed("disparo") and shoot:
		if rapidfire:
			sfx_rapidfire.play()
		disparar()
		shoot = false
		cooldown.wait_time = 0.4 - (shooter_cooldown)
		cooldown.start()
		
	if Input.is_action_just_pressed("pausa"):
		Global_Player.pausa()
		
	move_and_slide()
	animations_update(movimiento_x)
	
	if barra_oxigeno.value == 0.0:
		death_oxygen()

func disparar():
	if !rapidfire:
		sfx_playerbullet.play()
	var bala=bala_path.instantiate()
	bala.pos=$Arma.global_position
	bala.speed *= direccion_disparo
	get_parent().add_child(bala)

func _on_cooldown_timeout() -> void:
	if !shoot:
		shoot = true

# Muertes y power ups
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "enemy_hitBox" or area.name == "enemy_gun_hitBox":
		if invincibility == false:
			animated_sprite_2d.play("death")
			animated_sprite_2d.scale.y = animated_sprite_2d.scale.y*2
			animated_sprite_2d.scale.x = animated_sprite_2d.scale.x*2
			sfx_funnydeath.play()
			player_hurtBox.set_deferred("disabled", true)
			if Global_Player.health > 0:
				take_damage()
			else:
				Global_Player.jugador_muerto = true
				Global_Player.gameover()
				queue_free()
		else:
			pass
	
	if area.name == "shooter_areaBox":
		sfx_powerup.play()
		if sfx_normalwave || sfx_hardwave:
			sfx_normalwave.volume_db = -60
			sfx_hardwave.volume_db = -60
		rapidfire = true
		shooter_cooldown = 0.3
		power_up_duration.wait_time = 10
		power_up_duration.start()
		
	if area.name == "invincibility_areaBox":
		sfx_powerup.play()
		if sfx_normalwave || sfx_hardwave:
			sfx_normalwave.volume_db = -60
			sfx_hardwave.volume_db = -60
		invincibility = true
		power_up_duration.wait_time = 10
		power_up_duration.start()

func death_oxygen():
	if barra_oxigeno.value == 0.0:
		Global_Player.jugador_muerto = true
		Global_Player.gameover()
		queue_free()

func respawn():
	global_position = Vector2(624, 359)
	
# Power Up
func _on_power_up_duration_timeout() -> void:
	sfx_powerup.stop()
	if sfx_normalwave || sfx_hardwave:
		sfx_normalwave.volume_db = -10
		sfx_hardwave.volume_db = -10
		
	if shooter_cooldown == 0.3:
		rapidfire = false
		shooter_cooldown = 0
	
	if invincibility == true:
		invincibility = false
		
# Animacion

func animations_update(movimiento_x):
	if movimiento_x:
		animated_sprite_2d.play("moving")
		animated_sprite_2d.flip_h = movimiento_x < 0
	else:
		animated_sprite_2d.play("idle")
	
	if invincibility == true:
		animated_sprite_2d.modulate = Color(50, 50, 50)
	else:
		animated_sprite_2d.modulate = Color(1, 1,  1)


func _on_reinicio_timeout() -> void:

	get_tree().paused = false
	respawn()
	
	var puntaje_actual = Global_Scoreboard.score
	var vidas_actuales = Global_Player.health
	
	Global_Player.salvados = 0
	
	get_tree().reload_current_scene()
	Global_Scoreboard.score = puntaje_actual
	Global_Player.health = vidas_actuales
