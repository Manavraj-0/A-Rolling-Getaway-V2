extends TileMap

@export var speed: float = 50  # Pixels per second
var start_x: float  # Store the initial X position
var move_map: bool = false  # Flag to control movement
#@onready var camera_2d: Camera2D = $"../Camera2D"
#var timer: float = 0.0  # Timer for delay

# BG
@onready var bg: TextureRect = $"../Bg"
@onready var nebula: TextureRect = $"../Nebula"
@onready var stars: TextureRect = $"../Stars"
@onready var planets: TextureRect = $"../Planets"
@onready var planets_2: TextureRect = $"../Planets2"

func _ready():
	start_x = position.x  # Store the original X position

func _process(delta):
	if move_map:
		position = Vector2(start_x, position.y - speed * delta)  # Move only up
		#bg.position.y -= (speed * 0.2) * delta
		nebula.position.y -= (speed * 0.4) * delta
		planets.position.y -= (speed * 0.5) * delta
		planets_2.position.y -= (speed * 0.5) * delta
		stars.position.y -= (speed * 0.7) * delta

	
func start_movement():
	if !move_map:
		move_map = true
		
		print("start..")

func stop_movement():
	if move_map:
		move_map = false
		print("stop..")
