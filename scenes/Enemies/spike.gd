extends Area2D

@onready var hitbox = self  # This Area2D is the hitbox

func _ready():
	connect("body_entered", _on_hitbox_body_entered)

func _on_hitbox_body_entered(body: Node2D):
	if body.is_in_group("player") and body.has_method("take_damage"):
		print("Spike hit player!")
		body.take_damage(1)
