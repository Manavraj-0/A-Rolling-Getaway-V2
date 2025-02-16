extends Control

@onready var margin_container: MarginContainer = $MarginContainer
@onready var coins_label: Label = $MarginContainer/HBoxContainer/LeftPanel/PreviewCard/VBoxContainer/CoinsLabel
@onready var skin_container: GridContainer = $MarginContainer/HBoxContainer/RightPanel/SkinGrid
@onready var skin_button_scene = preload("res://scenes/menu/skin_button.tscn")
# Updated: PreviewBall is now a TextureRect node.
@onready var preview_ball: TextureRect = $MarginContainer/HBoxContainer/LeftPanel/PreviewCard/VBoxContainer/PreviewBall
@onready var back_button: Button = $MarginContainer/HBoxContainer/LeftPanel/BackButton

func _ready():
	setup_layout()
	update_coins_display()
	setup_skin_buttons()
	back_button.pressed.connect(_on_back_button_pressed)

func setup_layout():
	# Use 3 columns unless running on Android (in which case use 2)
	skin_container.custom_minimum_size = Vector2(0, 400)  # Adjust based on your needs
	skin_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	skin_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	skin_container.columns = 3 if DisplayServer.get_name() != "android" else 2
	
	skin_container.add_theme_constant_override("h_separation", 10)
	skin_container.add_theme_constant_override("v_separation", 10)
	
	# Create a new style for the preview panel.
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.12, 0.13, 0.2, 0.3)
	style.border_color = Color(0.3, 0.34, 0.39, 0.5)
	# Note: In Godot 4, StyleBoxFlat’s corner radius properties have been split (e.g., corner_radius_top_left).
	# You can adjust each one as needed (the following is commented out):
	# style.corner_radius_top_left = 12
	# style.corner_radius_top_right = 12
	# style.corner_radius_bottom_left = 12
	# style.corner_radius_bottom_right = 12

	# Update the panel’s style override.
	#$MarginContainer/HBoxContainer/LeftPanel/PreviewPanel.add_style_override("panel", style)

func update_coins_display():
	coins_label.text = "Coins: " + str(GameProgress.get_total_coins())

func setup_skin_buttons():
	for skin_name in GameProgress.player_data["skins"]:
		var skin_data = GameProgress.get_skin_data(skin_name)
		var button = skin_button_scene.instantiate()
		
		skin_container.add_child(button)
		
		button.skin_name = skin_name
		button.price = skin_data["price"]
		button.owned = skin_data["owned"]
		button.texture_path = skin_data["texture_path"]
		button.setup_display()
		
		# Bind the pressed signal with the skin_name argument.
		button.pressed.connect(_on_skin_button_pressed.bind(skin_name))
		
		if skin_name == GameProgress.get_current_skin():
			update_preview(skin_data["texture_path"])

func _on_skin_button_pressed(skin_name: String):
	var skin_data = GameProgress.get_skin_data(skin_name)
	
	if GameProgress.is_skin_owned(skin_name):
		GameProgress.equip_skin(skin_name)
		update_preview(skin_data["texture_path"])
	else:
		if GameProgress.buy_skin(skin_name):
			update_coins_display()
			var button = find_skin_button(skin_name)
			if button:
				button.owned = true
				button.setup_display()

func update_preview(texture_path: String):
	# For a Sprite2D, setting the texture works the same as before.
	preview_ball.texture = load(texture_path)

func find_skin_button(skin_name: String) -> Node:
	for button in skin_container.get_children():
		if button.skin_name == skin_name:
			return button
	return null

func _on_back_button_pressed():
	# In Godot 4, use change_scene_to() with a PackedScene resource.
	#var new_scene = load("res://scenes/menu/menu.tscn")
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")
