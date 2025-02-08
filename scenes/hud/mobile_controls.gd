extends Control

signal move_left_pressed
signal move_right_pressed
signal jump_pressed

func _ready():
	visible = OS.has_feature("mobile")
	
	$LeftButton.button_down.connect(func(): emit_signal("move_left_pressed"))
	$RightButton.button_down.connect(func(): emit_signal("move_right_pressed"))
	$JumpButton.button_down.connect(func(): emit_signal("jump_pressed"))
