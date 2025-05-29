extends Control
@onready var sfx_selection: AudioStreamPlayer = $sfx_selection

func _ready():
	self.hide()

func pausa():
	get_tree().paused = true
	self.show()

func _on_boton_continuar_pressed() -> void:
	self.hide()
	get_tree().paused = false

func _on_boton_reinicio_pressed() -> void:
	Global_Scoreboard.reset_score = true
	Global_Player.waves = 0
	Global_Player.salvados = 0
	Global_Player.health = 3
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_boton_menu_pressed() -> void:
	Global_Scoreboard.reset_score = true
	Global_Player.waves = 0
	Global_Player.salvados = 0
	Global_Player.health = 3
	get_tree().paused = false
	get_tree().change_scene_to_file("res://start/inicio.tscn")

func _on_mouse_entered() -> void:
	sfx_selection.play()
