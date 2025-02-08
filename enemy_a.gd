extends CharacterBody2D

const SPEED = 125.0
var direction = 1

@onready var edge_check = $EdgeCheck  # RayCast2D node
@onready var sprite = $AnimatedSprite2D  # Reference to your Sprite2D node
@onready var hitbox = $Hitbox  # Reference to Area2D node for player detection

func _ready():
	# Check for required nodes
	if not edge_check:
		push_error("EdgeCheck node not found! Add a RayCast2D node named 'EdgeCheck'")
	if not sprite:
		push_error("Sprite2D node not found! Add a Sprite2D node named 'Sprite2D'")
	if hitbox:
		hitbox.body_entered.connect(_on_hitbox_body_entered)

func add_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

func move_enemy():
	velocity.x = SPEED * direction
	sprite.flip_h = (direction > 0)

func reverse_direction():
	if is_on_wall() or !edge_check.is_colliding():
		direction = -direction
		edge_check.position.x *= -1

func _physics_process(delta: float) -> void:
	add_gravity(delta)
	
	if is_on_floor():
		move_enemy()
		
	move_and_slide()
	reverse_direction()

func _on_hitbox_body_entered(body: Node2D):
	if body.is_in_group("player") and body.has_method("take_damage"):
		print("Hit player!") # Replace with damage logic later
		body.take_damage(1)
