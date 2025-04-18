extends TileMap

var start_x: float
var move_map: bool = false
var dynamic_speed: float = 0.0  # Speed from Level1 script

@onready var bg: TextureRect = $"../Bg"
@onready var nebula: TextureRect = $"../Nebula"
@onready var stars: TextureRect = $"../Stars"
@onready var planets: TextureRect = $"../Planets"
#@onready var planets_2: TextureRect = $"../Planets2"

func _ready():
	start_x = position.x

func _process(delta):
	if move_map:
		position = Vector2(start_x, position.y - dynamic_speed * delta)
		nebula.position.y -= (dynamic_speed * 0.4) * delta
		planets.position.y -= (dynamic_speed * 0.5) * delta
		stars.position.y -= (dynamic_speed * 0.7) * delta

func move_ground(speed: float):
	dynamic_speed = speed
	move_map = true

func stop_movement():
	move_map = false
	dynamic_speed = 0.0
