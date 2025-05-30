extends Control
@onready var animated_sprite_2d: AnimatedSprite2D = $Mundo_Fondo/AnimatedSprite2D
@onready var animated_sprite_2d_2: AnimatedSprite2D = $Mundo_Fondo/AnimatedSprite2D2

func _ready():
	animated_sprite_2d.play("default")
	animated_sprite_2d_2.play("default")
