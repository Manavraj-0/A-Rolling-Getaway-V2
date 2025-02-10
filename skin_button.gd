extends Button

var skin_name: String
var price: int
var owned: bool = false
var texture_path: String

@onready var skin_icon = $VBoxContainer/Icon/SkinIcon
@onready var price_label = $VBoxContainer/Labels/PriceLabel
@onready var status_label = $VBoxContainer/Labels/StatusLabel

func setup_display():
	# Load and set the skin texture
	skin_icon.texture = load(texture_path)
	
	# Update labels
	if !owned:
		price_label.text = str(price) + " coins"
		status_label.text = "Buy"
	else:
		price_label.text = ""
		status_label.text = "Owned"
		
	# If this is the currently equipped skin
	if GameProgress.get_current_skin() == skin_name:
		status_label.text = "Equipped"
