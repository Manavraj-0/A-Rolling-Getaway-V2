extends RigidBody2D

@onready var ground_check: CollisionShape2D = $GroundCheck

signal health_changed(new_health)

# Movement variables
var move_speed = 300
var jump_force = -250
var has_moved = false
var is_dying = false
var max_health = 3
var current_health = max_health

@onready var tilemap = get_node_or_null("/root/Lvl1/Tilemaps")
@onready var death_timer = Timer.new()

# Coyote Time variables
var coyote_time = 0.2  # Duration after leaving the ground where a jump is still allowed
var coyote_timer = 0.0  # Timer for tracking coyote time

var is_grounded = false  # Whether the player is on the ground

func _ready():
	gravity_scale = 1.0
	contact_monitor = true
	max_contacts_reported = 3
	
	var current_skin = GameProgress.get_current_skin()
	var texture_path = GameProgress.get_skin_texture_path(current_skin)
	$Sprite2D.texture = load(texture_path)
	
	add_child(death_timer)
	death_timer.wait_time = 1
	death_timer.one_shot = true
	death_timer.timeout.connect(player_death)

func _physics_process(delta):
	# Update ground detection using get_contact_count
	is_grounded = get_contact_count() > 0
	
	# Coyote timer management
	if is_grounded:
		coyote_timer = coyote_time  # Reset the timer when on the ground
	else:
		coyote_timer -= delta  # Decrease the timer when not grounded
	
	if not is_dying and has_moved:
		# Handle horizontal movement
		var horizontal_input = Input.get_axis("ui_left", "ui_right")
		if horizontal_input != 0:
			apply_central_force(Vector2(horizontal_input * move_speed, 0))
		
		# Jump logic, allowing for coyote time
		if Input.is_action_just_pressed("ui_up") and (is_grounded or coyote_timer > 0):
			apply_central_impulse(Vector2(0, jump_force))
			# Reset coyote timer to avoid "double jumping" during the grace period
			coyote_timer = 0.0

func _process(_delta):
	if is_dying:
		return

	var cam := get_viewport().get_camera_2d()
	if cam == null:
		return  # No camera to base bounds on
	
	var margin = 50
	var screen_size = get_viewport().get_visible_rect().size
	var camera_center = cam.global_position
	var visible_rect = Rect2(camera_center - screen_size / 2, screen_size).grow(margin)

	if not visible_rect.has_point(global_position):
		start_death_sequence()

func start_death_sequence():
	await reset_input_actions()
	is_dying = true
	death_timer.start()

func take_damage(amount: int):
	current_health -= amount
	health_changed.emit(current_health)
	if current_health <= 0:
		die()

func die():
	get_tree().reload_current_scene()

func player_death():
	print("Player died!")
	is_dying = false
	restart_level()

func restart_level():
	get_tree().reload_current_scene()

func reset_input_actions():
	Input.action_release("ui_left")
	Input.action_release("ui_right")
	Input.action_release("ui_up")

func notify_level_started():
	has_moved = true
