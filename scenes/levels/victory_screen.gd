extends Control

signal exit_pressed
signal next_level_pressed

@onready var next_level_button = $"VBoxContainer/HBoxContainer/Next Level"  # Add this line

func show_victory(current_level := 1):  # Optional argument
	show()

	if current_level >= 3:
		next_level_button.hide()
	else:
		next_level_button.show()

func _on_exit_button_pressed():
	emit_signal("exit_pressed")

func _on_next_level_pressed():
	emit_signal("next_level_pressed")
