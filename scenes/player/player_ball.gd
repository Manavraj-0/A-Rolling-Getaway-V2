extends RigidBody2D

@onready var ground_check := get_parent().get_node("GroundCheck")

signal health_changed(new_health)

# Movement
var move_speed = 300
var jump_force = -250
var has_moved = false
var is_dying = false
var max_health = 3
var current_health = max_health

# Ground detection
var floor_contacts = 0
var is_grounded = false

# Coyote‑time (grace period to still jump after leaving ground)
var coyote_time = 0.01
var coyote_timer = 0.0

# Death timer
@onready var death_timer = Timer.new()

func _ready():
	# GroundCheck triggers
	ground_check.body_entered.connect(_on_ground_entered)
	ground_check.body_exited.connect(_on_ground_exited)
	
	gravity_scale = 1.0
	contact_monitor = true
	max_contacts_reported = 3
	
	# Skin
	var current_skin = GameProgress.get_current_skin()
	$Sprite2D.texture = load(GameProgress.get_skin_texture_path(current_skin))
	
	# Death timer
	add_child(death_timer)
	death_timer.wait_time = 1
	death_timer.one_shot = true
	death_timer.timeout.connect(player_death)

func _physics_process(delta):
	# 1) Reposition & lock the GroundCheck so it never rotates with the ball
	if ground_check:
		ground_check.global_position = global_position + Vector2(0, 20)
		ground_check.rotation = 0

	#print("Ball: ", global_position, " | GroundCheck: ", ground_check.global_position)

	# 2) Coyote‑time update
	if is_grounded:
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta

	# 3) Movement + jump
	if not is_dying and has_moved:
		var h = Input.get_axis("ui_left", "ui_right")
		if h != 0:
			apply_central_force(Vector2(h * move_speed, 0))

		if Input.is_action_just_pressed("ui_up") and coyote_timer > 0.0:
			# reset any downward speed for a snappy jump
			linear_velocity.y = 0
			apply_central_impulse(Vector2(0, jump_force))
			coyote_timer = 0.0  # prevent double‑jump

func _on_ground_entered(body):
	if body.is_in_group("ground"):
		floor_contacts += 1
		is_grounded = true

func _on_ground_exited(body):
	if body.is_in_group("ground"):
		floor_contacts = max(floor_contacts - 1, 0)
		is_grounded = floor_contacts > 0

func _process(delta):
	if is_dying:
		return

	# Death if out of view (handles both Level 2 camera and Level 1 no‑camera)
	var margin = 50
	var rect: Rect2
	var cam = get_viewport().get_camera_2d()
	if cam:
		# Level 2: camera moving
		var size = get_viewport().get_visible_rect().size
		rect = Rect2(cam.global_position - size/2, size).grow(margin)
	else:
		# Level 1: no camera, just the window
		rect = get_viewport_rect().grow(margin)

	if not rect.has_point(global_position):
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
	is_dying = false
	restart_level()

func restart_level():
	get_tree().reload_current_scene()

func reset_input_actions():
	Input.action_release("ui_left")
	Input.action_release("ui_right")
	Input.action_release("ui_up")

# Called by your Level scripts to kick off movement
func notify_level_started():
	has_moved = true
