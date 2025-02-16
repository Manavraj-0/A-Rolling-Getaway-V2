extends Button

var skin_name: String
var price: int
var owned: bool = false
var texture_path: String

@onready var skin_icon = $VBoxContainer/Icon/SkinIcon
@onready var price_label = $VBoxContainer/Labels/PriceLabel
@onready var status_label = $VBoxContainer/Labels/StatusLabel
@onready var vbox = $VBoxContainer
@onready var labels_container = $VBoxContainer/Labels

#func _ready():
	# Set button properties
	#custom_minimum_size = Vector2(120, 150)
	#size_flags_horizontal = SIZE_EXPAND_FILL
	#size_flags_vertical = SIZE_EXPAND_FILL
	#
	## Configure VBoxContainer
	#vbox.size_flags_horizontal = SIZE_EXPAND_FILL
	#vbox.size_flags_vertical = SIZE_EXPAND_FILL
	#vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	#
	## Configure Labels container
	#labels_container.size_flags_horizontal = SIZE_EXPAND_FILL
	#labels_container.size_flags_vertical = SIZE_SHRINK_CENTER
	#
	## Configure individual labels
	#price_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	#price_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	#price_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	#price_label.custom_minimum_size = Vector2(0, 30)
	#
	#status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	#status_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	#status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	#status_label.custom_minimum_size = Vector2(0, 30)
	#
	## Configure icon
	#skin_icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH
	#skin_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	#skin_icon.custom_minimum_size = Vector2(80, 80)

func setup_display():
	# Load and set the skin texture
	skin_icon.texture = load(texture_path)
	
	# Update labels
	if !owned:
		price_label.text = str(price) + " coins"
		price_label.visible = true
		status_label.text = "Buy"
		status_label.add_theme_color_override("font_color", Color(1, 1, 1))  # White
	else:
		price_label.text = ""
		price_label.visible = false
		status_label.text = "Owned"
		status_label.add_theme_color_override("font_color", Color(0, 1, 0))  # Green
	
	# If this is the currently equipped skin
	if GameProgress.get_current_skin() == skin_name:
		status_label.text = "Equipped"
		status_label.add_theme_color_override("font_color", Color(0, 1, 1))  # Cyan
