# Lvl_2.gd
extends Node2D

@onready var camera = $Camera2D  # Your Camera2D node
@onready var victory_area = $Ground/VictoryArea  # Area2D for detection
@onready var victory_screen = $Camera2D/VictoryScreen
@onready var hud: CanvasLayer = $Camera2D/HUD
@onready var pause_menu: Control = $Camera2D/PauseMenu

var camera_speed = 50  # Camera movement speed
var game_won = false
var movement_started = false
var start_timer = 0.1
var can_move = false
var current_level = 2  # Current level number
var coins_collected_this_level = 0

func _ready():
	hud.pause_requested.connect(toggle_pause)
	
	hud.add_to_group("hud")
	hud.update_health(3)
	hud.update_coins(0)
	
	for coin in get_tree().get_nodes_in_group("coins"):
		coin.collected.connect(_on_coin_collected)
	
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.health_changed.connect(_on_player_health_changed)
	
	if victory_area:
		victory_area.body_entered.connect(_on_victory_area_body_entered)
	
	if victory_screen:
		victory_screen.connect("exit_pressed", _on_exit)
		victory_screen.connect("next_level_pressed", _on_next_level)
	
	victory_screen.hide()

func _on_coin_collected():
	coins_collected_this_level += 1
	hud.update_coins(coins_collected_this_level)
	
func _on_player_health_changed(new_health):
	hud.update_health(new_health)

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		toggle_pause()

func toggle_pause():
	get_tree().paused = !get_tree().paused
	pause_menu.visible = get_tree().paused
	hud.visible = !get_tree().paused

func _process(delta):
	if game_won:
		return  # Stop all movement if game is won
		
	if not movement_started:
		if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
			movement_started = true
			get_tree().create_timer(start_timer).timeout.connect(_on_start_timer_timeout)
			
			var player = get_tree().get_first_node_in_group("player")
			if player:
				player.notify_level_started()
	
	# Move camera downward if timer has finished and game isn't won
	if can_move and !game_won:
		move_camera(delta)

func move_camera(delta):
	# Move camera downward at constant speed
	camera.position.y += camera_speed * delta

func _on_start_timer_timeout():
	can_move = true

func _on_victory_area_body_entered(body):
	if "player" in body.get_groups():
		win_game()

func win_game():
	game_won = true
	can_move = false
	
	# Save coins only when level is completed
	GameProgress.add_coins(coins_collected_this_level)
	
	# Mark level as completed and unlock next level
	GameProgress.complete_level(current_level)
	
	victory_screen.show_victory()
	hud.hide()

func _on_exit():
	get_tree().change_scene_to_file("res://scenes/menu/levels.tscn")

func _on_next_level():
	# Only allow proceeding to next level if it's unlocked
	var next_level = current_level + 1
	if GameProgress.is_level_unlocked(next_level):
		get_tree().change_scene_to_file("res://scenes/levels/lvl_" + str(next_level) + ".tscn")
	else:
		_on_exit()  # Return to level selection if next level isn't unlocked
