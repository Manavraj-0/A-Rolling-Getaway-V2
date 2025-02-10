extends Node

var level_status = {
	1: {"unlocked": true, "completed": false},  # First level starts unlocked
	2: {"unlocked": false, "completed": false},
	3: {"unlocked": false, "completed": false},
}

var player_data = {
	"total_coins": 0,
	"current_skin": "default",
	"skins": {
		"default": {
			"owned": true,
			"price": 0,
			"texture_path": "res://assets/player/sphere1.png"
		},
		"earth": {
			"owned": false,
			"price": 15,
			"texture_path": "res://assets/player/earth.png"
		},
		"venus": {
			"owned": false,
			"price": 15,
			"texture_path": "res://assets/player/venus.png"
		},
		"sun": {
			"owned": false,
			"price": 15,
			"texture_path": "res://assets/player/sun.png"
		},
		"saturn": {
			"owned": false,
			"price": 15,
			"texture_path": "res://assets/player/saturn.png"
		},
		"neptune": {
			"owned": false,
			"price": 15,
			"texture_path": "res://assets/player/neptune.png"
		},
		"mercury": {
			"owned": false,
			"price": 15,
			"texture_path": "res://assets/player/mercury.png"
		},
		"mars": {
			"owned": false,
			"price": 15,
			"texture_path": "res://assets/player/mars.png"
		},
		"jupiter": {
			"owned": false,
			"price": 15,
			"texture_path": "res://assets/player/jupiter.png"
		}
	}
}

# Called when the node enters the scene tree
func _ready():
	load_progress()  # Load saved progress when game starts

func get_current_skin() -> String:
	return player_data["current_skin"]
	
func get_skin_data(skin_name: String) -> Dictionary:
	#print("Fetching skin data for: ", skin_name)  # Debugging
	if skin_name in player_data["skins"]:
		#print("Skin data found: ", player_data["skins"][skin_name])  # Debugging
		return player_data["skins"][skin_name]
	#print("Skin not found, returning empty dictionary")  # Debugging
	return {}
	
func is_skin_owned(skin_name: String) -> bool:
	if skin_name in player_data["skins"]:
		return player_data["skins"].get(skin_name, {}).get("owned", false)
	return false

func get_skin_price(skin_name: String) -> int:
	if skin_name in player_data["skins"]:
		return player_data["skins"][skin_name]["price"]
	return 0
	
func get_skin_texture_path(skin_name: String) -> String:
	if skin_name in player_data["skins"]:
		return player_data["skins"][skin_name]["texture_path"]
	return ""

func buy_skin(skin_name: String) -> bool:
	if skin_name in player_data["skins"] and not player_data["skins"][skin_name]["owned"]:
		var price = player_data["skins"][skin_name]["price"]
		if player_data["total_coins"] >= price:
			player_data["total_coins"] -= price
			player_data["skins"][skin_name]["owned"] = true
			save_progress()
			return true
	return false

func equip_skin(skin_name: String) -> bool:
	if is_skin_owned(skin_name):
		player_data["current_skin"] = skin_name
		save_progress()
		return true
	return false

func complete_level(level_number: int):
	if level_number in level_status:
		# Mark current level as completed
		level_status[level_number]["completed"] = true
		
		# Unlock next level if it exists
		if level_number + 1 in level_status:
			level_status[level_number + 1]["unlocked"] = true
			
		# Save progress immediately after completion
		save_progress()
		
		# Return true to confirm level was completed successfully
		return true
	return false

func is_level_unlocked(level_number: int) -> bool:
	if level_number in level_status:
		return level_status[level_number]["unlocked"]
	return false

func is_level_completed(level_number: int) -> bool:
	if level_number in level_status:
		return level_status[level_number]["completed"]
	return false

func get_highest_unlocked_level() -> int:
	var highest = 1
	for level in level_status.keys():
		if level_status[level]["unlocked"]:
			highest = max(highest, level)
	return highest

# COIN PART

func add_coins(amount: int):
	player_data["total_coins"] += amount
	save_progress()
	return player_data["total_coins"]

func get_total_coins() -> int:
	return player_data["total_coins"]

func reset_progress():
	# Reset all levels except first one
	for level in level_status.keys():
		level_status[level]["completed"] = false
		level_status[level]["unlocked"] = (level == 1)
	save_progress()

func save_progress():
	var save_file = FileAccess.open("user://game_progress.save", FileAccess.WRITE)
	if save_file:
		var save_data = {
			"level_status": level_status,
			"player_data": player_data
		}
		save_file.store_var(save_data)
		return true
	return false

func load_progress():
	if FileAccess.file_exists("user://game_progress.save"):
		var save_file = FileAccess.open("user://game_progress.save", FileAccess.READ)
		if save_file:
			var loaded_data = save_file.get_var()
			# Validate loaded data
			if typeof(loaded_data) == TYPE_DICTIONARY:
				if "level_status" in loaded_data:
					level_status = loaded_data["level_status"]
				if "player_data" in loaded_data:
					player_data = loaded_data["player_data"]
				return true
	return false
