extends Area2D

@export var dentro_del_area = false
@export var velocidad_disminucion = 3
var cantidad_oxigeno: float = 100
var jugador_path=preload("res://entities/player/jugador.tscn")
var jugador = jugador_path.instantiate()

func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var progress_bar = get_node("barra de oxigeno/ProgressBar")
	progress_bar.value = cantidad_oxigeno
	if dentro_del_area:
		cantidad_oxigeno = min(cantidad_oxigeno + (velocidad_disminucion)*10 * delta, 100)
	else:
		cantidad_oxigeno = max(cantidad_oxigeno - velocidad_disminucion * delta, 0)

func _on_body_entered(body: Node) -> void:
	if body.name == "Jugador":
		dentro_del_area = true

func _on_body_exited(body: Node) -> void:
	if body.name == "Jugador":
		dentro_del_area = false
 
