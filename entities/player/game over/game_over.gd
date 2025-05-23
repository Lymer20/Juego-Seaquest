extends Control

func _ready():
	self.hide()
	
func game_over():
	get_tree().paused = true
	self.show()

func _on_boton_reiniciar_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func _on_boton_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://start/inicio.tscn")

	
