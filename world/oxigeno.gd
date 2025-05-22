extends Area2D

var dentro_del_area = false
@export var velocidad_disminucion = 0.3

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if dentro_del_area:
		return
		
	var progress_bar = get_node("../CanvasLayer/ProgressBar")
	if progress_bar:
		progress_bar.value = max(progress_bar.value - velocidad_disminucion * delta, 0)


func _on_body_entered(body: Node) -> void:
	if body.name == "Jugador":
		dentro_del_area = true
		#print("Jugador ENTRÓ al área: dentro_del_area =", dentro_del_area)


func _on_body_exited(body: Node) -> void:
	if body.name == "Jugador":
		dentro_del_area = false
		#print("Jugador SALIÓ del área: dentro_del_area =", dentro_del_area)
 
