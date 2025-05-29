extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var power_up_duration: Timer = $/root/Mundo/Jugador/PowerUp_Duration
var invincibility: bool = false
var shooter_cooldown = 0.0

@export var dentro_del_area = false
@onready var barra_oxigeno: ProgressBar = $"../Oxigeno/barra de oxigeno/ProgressBar"

# Movimiento
const velocidad_max: float = Global_Player.velocidad_max
const aceleracion: float = Global_Player.aceleracion
const friccion: float = Global_Player.friccion

# Personas a salvar
var salvados: int = 0

# Disparo
@onready var arma: Node2D = $Arma
var bala_path=preload("res://entities/player/bala.tscn")
var direccion_disparo = 1

# Cooldown del disparo
var shoot: bool = true
@onready var cooldown: Timer = $Arma/cooldown

var heart_list: Array [TextureRect]
var max_hearts = 6

@onready var reinicio: Timer = $reinicio


func _ready() -> void:	
	reinicio.process_mode = Timer.PROCESS_MODE_ALWAYS
	
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


func _physics_process(delta: float) -> void:
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
	var bala=bala_path.instantiate()
	bala.pos=$Arma.global_position
	bala.speed *= direccion_disparo
	get_parent().add_child(bala)

func _on_cooldown_timeout() -> void:
	if !shoot:
		shoot = true

# Muertes 
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "enemy_hitBox" or area.name == "enemy_gun_hitBox":
		if invincibility == false:
			if Global_Player.health > 0:
				take_damage()
			else:
				Global_Player.jugador_muerto = true
				Global_Player.gameover()
				queue_free()
		else:
			pass
	
	if area.name == "shooter_areaBox":
		shooter_cooldown = 0.3
		power_up_duration.wait_time = 10
		power_up_duration.start()
		
	if area.name == "invincibility_areaBox":
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
	if shooter_cooldown == 0.3:
		shooter_cooldown = 0
		print("No mas shooter")
	
	if invincibility == true:
		invincibility = false
		
# Animacion

func animations_update(movimiento_x):
	if movimiento_x:
		sprite_2d.flip_h = movimiento_x < 0
	
	if invincibility == true:
		sprite_2d.modulate = Color(50, 50, 50)
	else:
		sprite_2d.modulate = Color(1, 1,  1)


func _on_reinicio_timeout() -> void:

	get_tree().paused = false
	respawn()
	
	var puntaje_actual = Global_Scoreboard.score
	var vidas_actuales = Global_Player.health
	
	Global_Player.salvados = 0
	
	get_tree().reload_current_scene()
	Global_Scoreboard.score = puntaje_actual
	Global_Player.health = vidas_actuales
