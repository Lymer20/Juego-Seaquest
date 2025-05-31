extends CharacterBody2D

var pos:Vector2
var speed: float = 200

func _ready():
	global_position=pos

func _physics_process(_delta: float) -> void:
	velocity=Vector2(speed, 0)
	move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
