extends Node2D
@onready var colision_del_mapa: CollisionPolygon2D = $"StaticBody2D/Colision del Mapa"
@onready var polygon_2d: Polygon2D = $"StaticBody2D/Colision del Mapa/Polygon2D"

func _ready():
	polygon_2d.polygon = colision_del_mapa.polygon
