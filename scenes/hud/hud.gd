# hud.gd
extends CanvasLayer

signal pause_requested

@onready var health_label = $TopBar/HealthContainer/HealthValue
@onready var coins_label = $TopBar/CoinContainer/CoinValue
#@onready var floor_label = $TopBar/FloorContainer/FloorValue
@onready var pause_button = $TopBar/PauseButton
@onready var mobile_controls = $MobileControls

var health = 3
var coins = 0
#var current_floor = 1

func _ready():
	update_display()
	setup_controls()

func setup_controls():
	# Pause button
	pause_button.pressed.connect(_on_pause_button_pressed)
	
	# Mobile controls
	mobile_controls.visible = OS.has_feature("mobile")
	if mobile_controls.visible:
		var left_button = $MobileControls/LeftButton
		var right_button = $MobileControls/RightButton
		var jump_button = $MobileControls/JumpButton
		
		# Make buttons slightly translucent
		var translucent_color = Color(1, 1, 1, 0.6)  # White with 60% opacity
		left_button.modulate = translucent_color
		right_button.modulate = translucent_color
		jump_button.modulate = translucent_color

		
		# Button pressed
		left_button.pressed.connect(func(): Input.action_press("ui_left"))
		right_button.pressed.connect(func(): Input.action_press("ui_right"))
		jump_button.pressed.connect(func(): Input.action_press("ui_up"))
		
		# Button released
		left_button.released.connect(func(): Input.action_release("ui_left"))
		right_button.released.connect(func(): Input.action_release("ui_right"))
		jump_button.released.connect(func(): Input.action_release("ui_up"))

func _on_pause_button_pressed():
	#var level = get_parent()
	#if level.has_method("toggle_pause"):
		#level.toggle_pause()
	emit_signal("pause_requested")

func update_display():
	health_label.text = str(health)
	coins_label.text = str(coins)
	#floor_label.text = "Floor: " + str(current_floor)

func update_health(new_health):
	health = new_health
	update_display()

func update_coins(new_coins):
	coins = new_coins
	update_display()

#func update_floor(new_floor):
	#current_floor = new_floor
	#update_display()

func hide_hud():
	hide()
