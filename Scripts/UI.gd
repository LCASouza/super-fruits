extends Control

signal mute_sound()

@onready var fruits = $FruitsLabel:
	set(value):
		fruits.text = ":  " + str(value)

@onready var max_fruits = $MaxLabel:
	set(value):
		max_fruits.text = " / " + str(value)

func _on_restart_pressed():
	get_tree().reload_current_scene()

func _on_exit_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menu.tscn")

func _on_sound_pressed():
	emit_signal("mute_sound")
