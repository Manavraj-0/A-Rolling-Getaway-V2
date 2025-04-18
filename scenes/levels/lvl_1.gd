# Lvl_1.gd
extends Node2D

@onready var ground = $Tilemaps
@onready var victory_area = $Tilemaps/Ground/VictoryArea
@onready var victory_screen = $VictoryScreen
@onready var hud: CanvasLayer = $HUD
@onready var pause_menu: Control = $PauseMenu

var ground_speed = 0.0
var target_ground_speed = 50.0
var ramp_up_duration = 4.0
var ramp_up_timer = 0.0

var game_won = false
var movement_started = false
var coins_collected_this_level = 0
var can_ramp_up = false
var current_level = 1

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
		return

	if !movement_started:
		if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
			movement_started = true
			get_tree().create_timer(0.3).timeout.connect(_on_delay_timer_timeout)

	var player = get_tree().get_first_node_in_group("player")

	if can_ramp_up and !game_won:
		ramp_up_timer += delta
		var t = clamp(ramp_up_timer / ramp_up_duration, 0.0, 1.0)
		ground_speed = lerp(0.0, target_ground_speed, t)
		if player:
			player.notify_level_started()
		ground.move_ground(ground_speed)

func _on_delay_timer_timeout():
	can_ramp_up = true

func _on_victory_area_body_entered(body):
	if "player" in body.get_groups():
		win_game()

func win_game():
	game_won = true
	can_ramp_up = false

	if ground.has_method("stop_movement"):
		ground.stop_movement()

	GameProgress.add_coins(coins_collected_this_level)
	GameProgress.complete_level(current_level)

	victory_screen.show_victory()
	hud.hide()

func _on_exit():
	get_tree().change_scene_to_file("res://scenes/menu/levels.tscn")

func _on_next_level():
	var next_level = current_level + 1
	if GameProgress.is_level_unlocked(next_level):
		get_tree().change_scene_to_file("res://scenes/levels/lvl_" + str(next_level) + ".tscn")
	else:
		_on_exit()
