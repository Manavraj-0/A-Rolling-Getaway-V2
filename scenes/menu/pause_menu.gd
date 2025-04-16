extends Control

func _ready():
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	hide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_on_resume_button_pressed()

#func _on_resume_pressed():
	#get_tree().paused = false
	#hide()


func _on_menu_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")


func _on_resume_button_pressed() -> void:
	var level = get_tree().current_scene
	if level and level.has_method("toggle_pause"):
		level.toggle_pause()


func _on_restart_button_pressed() -> void:
	# Unpause before restarting
	get_tree().paused = false
	# Reload the current scene
	get_tree().reload_current_scene()
