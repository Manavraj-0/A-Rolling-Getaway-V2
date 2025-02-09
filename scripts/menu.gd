extends Node2D

@onready var toggle_sound: TextureButton = $MainContainer/ToggleSound

@onready var MUSIC_OFF = preload("res://assets/gui_pack_White/white_musicOff.png")
@onready var MUSIC_ON = preload("res://assets/gui_pack_White/white_musicOn.png")

@onready var settings_button: TextureButton = $MainContainer/SettingsButton
@onready var settings_popup: Control = $SettingsPopup

func _ready():
	settings_button.pressed.connect(_on_settings_button_pressed)
	
	settings_popup.settings_closed.connect(_on_settings_closed)
	settings_popup.reset_confirmed.connect(_on_reset_confirmed)
	
	toggle_sound.modulate.a = 1.0
	
	if Sound.is_playing:
		toggle_sound.texture_normal = MUSIC_ON
	else:
		toggle_sound.texture_normal = MUSIC_OFF

func _on_settings_button_pressed():
	settings_popup.show_settings()
	get_tree().paused = true

func _on_settings_closed():
	get_tree().paused = false

func _on_reset_confirmed():
	pass

func _on_toggle_sound_pressed():

	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	
	tween.tween_property(toggle_sound, "modulate:a", 0.0, 0.15)
	
	tween.tween_callback(func():
		Sound.toggle_music()
		if Sound.is_playing:
			toggle_sound.texture_normal = MUSIC_ON
		else:
			toggle_sound.texture_normal = MUSIC_OFF
	)
	
	tween.tween_property(toggle_sound, "modulate:a", 1.0, 0.15)

func _on_level_mode_btn_pressed():
	get_tree().change_scene_to_file("res://scenes/menu/levels.tscn")

func _on_endless_btn_pressed():
	get_tree().change_scene_to_file("res://scenes/menu/endless.tscn")

func _on_customization_btn_pressed():
	get_tree().change_scene_to_file("res://scenes/menu/ball_skin.tscn")

func _on_high_score_btn_pressed():
	get_tree().change_scene_to_file("res://scenes/menu/high_score.tscn")
