extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D

# Movimiento
const velocidad_max: float = 300
const aceleracion: float = 900
const friccion: float = 1200

var salvados: int = 1


# Disparo
@onready var arma: Node2D = $Arma
var bala_path=preload("res://entities/player/bala.tscn")

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

func disparar():
	var bala=bala_path.instantiate()
	bala.pos=$Arma.global_position
	get_parent().add_child(bala)

func _on_cooldown_timeout() -> void:
	if !shoot:
		shoot = true
		print("Puedes disparar!")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "enemy_hitBox" or area.name == "enemy_gun_hitBox":
		print("Ohno, moriste!")
		queue_free() # Replace with function body.
