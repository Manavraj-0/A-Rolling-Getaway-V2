extends Control

signal move_left_pressed
signal move_left_released
signal move_right_pressed
signal move_right_released
signal jump_pressed
signal jump_released

func _ready():
	visible = OS.has_feature("mobile")

	# Connect signals for pressing and releasing movement buttons
	$LeftButton.pressed.connect(func(): emit_signal("move_left_pressed"))
	$LeftButton.released.connect(func(): emit_signal("move_left_released"))

	$RightButton.pressed.connect(func(): emit_signal("move_right_pressed"))
	$RightButton.released.connect(func(): emit_signal("move_right_released"))

	$JumpButton.pressed.connect(func(): emit_signal("jump_pressed"))
	$JumpButton.released.connect(func(): emit_signal("jump_released"))
