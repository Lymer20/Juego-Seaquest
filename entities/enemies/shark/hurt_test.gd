extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $Path2D/PathFollow2D/AnimatedSprite2D
@onready var enemy_hitBox: CollisionShape2D = $Path2D/PathFollow2D/enemy_hitBox/CollisionShape2D
@onready var sfx_funnydeath: AudioStreamPlayer2D = $sfx_funnydeath

var valor_enemigo_tiburon = 20

func _ready():
	animated_sprite_2d.play("default")
	animated_sprite_2d.modulate = Color(1, 0.25, 0.25)
	if global_position.x > get_viewport_rect().size.x / 2:
		animated_sprite_2d.flip_h = global_position.x > get_viewport_rect().size.x / 2


func _on_enemy_hit_box_area_entered(area: Area2D) -> void:
	if area.name == "Muerte_por_area":
		queue_free()
		
	if area.name == "gun_hitBox":
		sfx_funnydeath.play()
		enemy_hitBox.set_deferred("disabled", true)
		var score_ganado: int 
		if Global_Player.waves >= 7:
			score_ganado = 90
		else: 
			score_ganado = (valor_enemigo_tiburon + (Global_Player.waves * 10))
		Global_Scoreboard.score += score_ganado
		animated_sprite_2d.play("death")
		await animated_sprite_2d.animation_finished
		queue_free()
		
