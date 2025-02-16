# coin.gd
extends Area2D

signal collected

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		
		collected.emit()
		# Find the HUD and update coins
		#var hud = get_tree().get_first_node_in_group("hud")
		#if hud:
			#hud.update_coins(hud.coins + 1)
		# Delete the coin
		queue_free()
