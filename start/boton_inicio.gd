extends Button
@onready var sfx_selection: AudioStreamPlayer = $"../sfx_selection"

func _pressed():
	get_tree().change_scene_to_file("res://world/mundo.tscn")

func _on_mouse_entered() -> void:
	sfx_selection.play()
