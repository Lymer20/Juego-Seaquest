extends Node2D
@onready var colision_del_mapa: CollisionPolygon2D = $"StaticBody2D/Colision del Mapa"
@onready var polygon_2d: Polygon2D = $"StaticBody2D/Colision del Mapa/Polygon2D"
var jugador_path=preload("res://entities/player/jugador.tscn")
var jugador = jugador_path.instantiate()

func _ready():
	polygon_2d.polygon = colision_del_mapa.polygon
		
func _on_oxigeno_area_entered(area: Area2D) -> void:

	if jugador.salvados > 0:
		print("Total de personas salvadas: " + str(jugador.salvados) + ". Se aumentará el tamaño cuando salgas para testear")
	else:
		print("Busca mas personas por salvar!")
	print("¡Estas recibiendo oxígeno!")

func _on_oxigeno_area_exited(area: Area2D) -> void:
	print("¡Dejaste de recibir oxígeno!")
	jugador.salvados = jugador.salvados + 1
