extends AcceptDialog

## Dialog to get the player's name to add to the high score list

# just equivalent to use $LineEdit in the code but this is:
# - safer (typed) allows autocompletition
# - faster (don't need to search the element every time)
# - easily refactorable
@onready var name_input: LineEdit = $CenterContainer/LineEdit

signal name_chosen(name: String)

# show the dialog
# called by game_over.gd _ready()
func ask_name():
	popup()
	name_input.text = ""
	# wait for dialog to manage input and relay control
	await get_tree().create_timer(0.5).timeout
	# grab focus to the line edit control
	name_input.grab_focus()


# called when the dialog is confirmed
func _on_confirmed() -> void:
	var player_name = name_input.text.strip_edges()
	if player_name == "":
		player_name = "Player"
	print("Player's name:", player_name)
	hide()
	emit_signal("name_chosen", player_name)


# called when the user press ENTER in the line edit field
func _on_line_edit_text_submitted(_new_text: String) -> void:
	# just call the dialog confirmed event handler
	_on_confirmed()
