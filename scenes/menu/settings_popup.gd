# settings_popup.gd
extends Control

signal settings_closed
signal reset_confirmed

@onready var reset_confirm_dialog = $Panel/ResetConfirmDialog
@onready var main_menu_ui: Control = $"../MainContainer"


func _ready():
	hide()
	# Make sure popup can process while game is paused
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	
	reset_confirm_dialog.dialog_text = "Are you sure you want to Reset?\nThis will:\n- Reset all levels\n- Reset coins\n- Reset to level 1\n\nThis cannot be undone!\n"
	reset_confirm_dialog.ok_button_text = "Reset"

func show_settings():
	show()
	main_menu_ui.hide()

func _on_close_button_pressed():
	hide()
	main_menu_ui.show()
	emit_signal("settings_closed")

func _on_reset_progress_pressed():
	reset_confirm_dialog.show()

func _on_reset_confirmed():
	GameProgress.reset_progress()
	#hide()
	#main_menu_ui.show()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")

func _on_reset_canceled():
	reset_confirm_dialog.hide()
