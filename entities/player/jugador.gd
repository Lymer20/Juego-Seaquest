extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var dentro_del_area = false
var jugador_muerto: bool
@onready var barra_oxigeno: ProgressBar = $"../Oxigeno/barra de oxigeno/ProgressBar"

# Movimiento
const velocidad_max: float = 300
const aceleracion: float = 900
const friccion: float = 1200

var salvados: int = 1


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
	
	# Movimiento en X
	if movimiento_x:
		velocity.x = move_toward(velocity.x, movimiento_x * velocidad_max, aceleracion * delta)
		#direccion del sprite
		sprite_2d.scale.x = abs(sprite_2d.scale.x) * (1 if movimiento_x < 0 else -1)
		#direccion del disparo
		direccion_disparo = 1 if movimiento_x > 0 else -1
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

func death_oxygen():
	if barra_oxigeno.value == 0.0:
		jugador_muerto = true
		gameover()
		print("Ohno, moriste!")
		queue_free()

func gameover():
	if jugador_muerto == true:
		get_node("../GameOver_Canvas/GameOver").game_over()
		print("Se cumplio la condición")
