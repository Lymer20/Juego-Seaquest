extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var dentro_del_area = false
@onready var barra_oxigeno: ProgressBar = $"../Oxigeno/barra de oxigeno/ProgressBar"

# Movimiento
const velocidad_max: float = Global_Player.velocidad_max
const aceleracion: float = Global_Player.aceleracion
const friccion: float = Global_Player.friccion

# Personas a salvar
var salvados: int 

# Disparo
@onready var arma: Node2D = $Arma
var bala_path=preload("res://entities/player/bala.tscn")
var direccion_disparo = 1

# Cooldown del disparo
var shoot: bool = true
@onready var cooldown: Timer = $Arma/cooldown

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
	if Input.is_action_just_pressed("disparo") and shoot:
		disparar()
		shoot = false
		cooldown.start()
		
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

# Muertes y Personas Salvadas
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "enemy_hitBox" or area.name == "enemy_gun_hitBox":
		Global_Player.jugador_muerto = true
		Global_Player.gameover()
		queue_free()
		
	# Persona salvada
	if area.name == "human_areaBox" :
		if Global_Player.salvados >= 6:
			print("Ya estas al maximo.")
		else:
			Global_Player.salvados += 1
			salvados == Global_Player.salvados
			print("Personas salvadas:" + str(salvados) + ("!"))

func death_oxygen():
	if barra_oxigeno.value == 0.0:
		Global_Player.jugador_muerto = true
		Global_Player.gameover()
		queue_free()

# Animacion

func animations_update(movimiento_x):
	if movimiento_x:
		sprite_2d.flip_h = movimiento_x < 0
