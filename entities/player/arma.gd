extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jugador: CharacterBody2D = $".."
var disparando = false

func _ready():
	animated_sprite_2d.animation_finished.connect(_on_animation_finished)

func _process(delta):
	animated_sprite_2d.flip_h = jugador.animated_sprite_2d.flip_h
	if Input.is_action_pressed("disparo") and not disparando:
		disparando = true
		animated_sprite_2d.play("default")

func _on_animation_finished():
	disparando = false
	animated_sprite_2d.play("not")
