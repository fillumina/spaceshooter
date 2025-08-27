extends Window

@onready var name_input: LineEdit = $LineEdit
@onready var ok_button: Button = $Button

func _ready():
	# Make it a popup window
	self.mode = Window.MODE_WINDOWED
	# Connect button signal
	ok_button.pressed.connect(_on_ok_pressed)

func ask_name():
	popup_centered()  # Shows the dialog in the center
	name_input.text = ""  # Clear previous input
	name_input.grab_focus()

func _on_ok_pressed():
	var player_name = name_input.text.strip_edges()
	if player_name == "":
		player_name = "Player"  # fallback default
	hide()
	print("Player's name:", player_name)
	# TODO: store player_name in your game state
