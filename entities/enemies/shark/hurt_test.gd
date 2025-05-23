extends CharacterBody2D
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready():
	sprite_2d.modulate = Color(1, 0, 0)

func _on_enemy_hit_box_area_entered(area: Area2D) -> void:
	if area.name == "gun_hitBox":
		Global_Scoreboard.score += 20
		print("Ohsi, lo mataste!")
		queue_free()
