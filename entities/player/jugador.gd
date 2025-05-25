extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var dentro_del_area = false
@onready var barra_oxigeno: ProgressBar = $"../Oxigeno/barra de oxigeno/ProgressBar"
var jugador_muerto: bool

# Movimiento
const velocidad_max: float = 300
const aceleracion: float = 900
const friccion: float = 1200

# Personas a salvar
var salvados: int = 0

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
		cooldown.wait_time = 0.75
		cooldown.start()
		print("Cooldown")
		
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
		print("Puedes disparar!")

# Muertes
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "enemy_hitBox" or area.name == "enemy_gun_hitBox": 
		jugador_muerto = true 
		gameover() 
		print("Ohno, moriste!") 
		queue_free()
		
	# Persona salvada
	if area.name == "human_areaBox" and salvados < 6:
		salvados += 1
		print("Personas salvadas:" + str(salvados) + ("!"))
	elif area.name == "human_areaBox" and salvados >= 6:
		print("Ya estas al maximo")
		print("Cantidad de personas salvadas:" + str(salvados) + ("!"))

func death_oxygen():
	if barra_oxigeno.value == 0.0:
		jugador_muerto = true
		gameover()
		print("Ohno, moriste!")
		queue_free()

func gameover():
	if jugador_muerto == true:
		print("Se cumplio la condición")
		get_node("../GameOver_Canvas/GameOver").game_over()
		

# Animacion

func animations_update(movimiento_x):
	if movimiento_x:
		sprite_2d.flip_h = movimiento_x < 0
