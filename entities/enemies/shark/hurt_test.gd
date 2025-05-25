extends CharacterBody2D
@onready var sprite_2d: Sprite2D = $Sprite2D
var valor_enemigo_tiburon = 20

func _ready():
	sprite_2d.modulate = Color(1, 0, 0)

func _on_enemy_hit_box_area_entered(area: Area2D) -> void:
	if area.name == "gun_hitBox":
		var score_ganado: int 
		if Global_Player.waves >= 7:
			score_ganado = 90
		else: 
			score_ganado = (valor_enemigo_tiburon + (Global_Player.waves * 10))
		Global_Scoreboard.score += score_ganado
		queue_free()
