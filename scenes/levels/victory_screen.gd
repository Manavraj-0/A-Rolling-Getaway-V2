extends Control

# Define the signals
signal exit_pressed
signal next_level_pressed

func show_victory():
	show()

func _on_exit_button_pressed():
	emit_signal("exit_pressed")

func _on_next_level_pressed():
	emit_signal("next_level_pressed")
