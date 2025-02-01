extends RigidBody2D

# Movement variables
var move_speed = 300
var jump_force = -250
var is_grounded = false
var has_moved = false
var is_dying = false

@onready var tilemap = get_node("/root/Lvl1/Tilemaps")  # Adjust path if needed
@onready var death_timer = Timer.new()

func _ready():
	# Set physics properties
	gravity_scale = 1.0
	contact_monitor = true
	max_contacts_reported = 3
	
	# Connect collision signals
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Setup death timer
	add_child(death_timer)
	death_timer.wait_time = 1.0
	death_timer.one_shot = true
	death_timer.timeout.connect(player_death)

func _on_body_entered(body):
	# Check if the collision is with the floor
	if body is TileMap or body.is_in_group("ground"):
		is_grounded = true

func _on_body_exited(body):
	# When leaving contact with floor
	if body is TileMap or body.is_in_group("ground"):
		is_grounded = false

func _physics_process(_delta):
	# Only process movement if not dying
	if not is_dying:
		# Handle horizontal movement
		var horizontal_input = Input.get_axis("ui_left", "ui_right")
		if horizontal_input != 0 or Input.is_action_pressed("ui_up"):
			if not has_moved:
				has_moved = true
				tilemap.start_movement()
			
			apply_central_force(Vector2(horizontal_input * move_speed, 0))
		
		# Handle jumping
		if Input.is_action_just_pressed("ui_up") and is_grounded:
			apply_central_impulse(Vector2(0, jump_force))
			is_grounded = false  # Set to false immediately after jumping

func _process(delta):
	var viewport_rect = get_viewport_rect()
	var margin = 50
	var alivescreen = viewport_rect.grow(margin)
	var player_global_pos = global_position
	
	# Check if player is outside the viewport bounds
	if not is_dying and not alivescreen.has_point(player_global_pos):
		start_death_sequence()

func start_death_sequence():
	is_dying = true
	death_timer.start()
	# Optional: Add death effects here
	# set_physics_process(false)  # Optionally freeze player movement immediately

func player_death():
	print("Player died!")
	is_dying = false
	restart_level()

func restart_level():
	# Get the current scene path
	var current_scene = get_tree().current_scene.scene_file_path
	# Reload the current scene
	get_tree().reload_current_scene()
