extends Button
@onready var sfx_selection: AudioStreamPlayer = $"../sfx_selection"

func _pressed():
	Global_Transicion.transition()
	await Global_Transicion.on_transition_finished
	get_tree().change_scene_to_file("res://world/mundo.tscn")

func _on_mouse_entered() -> void:
	sfx_selection.play()

func _on_salir_pressed() -> void:
	Global_Transicion.transition()
	await Global_Transicion.on_transition_finished
	get_tree().quit()
