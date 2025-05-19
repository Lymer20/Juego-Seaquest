extends CharacterBody2D

var pos:Vector2
var speed: float = 400
@onready var desaparece: Timer = $desaparece

func _ready():
	global_position=pos
	desaparece.wait_time = 4
	desaparece.start()

func _physics_process(delta: float) -> void:
	velocity=Vector2(speed, 0)
	move_and_slide()
	
func _on_timer_timeout() -> void:
	queue_free() # Replace with function body.
