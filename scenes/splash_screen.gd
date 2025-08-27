extends Control

func _input(event: InputEvent) -> void:
	# start the game when the 'shoot' key is pressed
	if event.is_action("shoot"):
		get_tree().change_scene_to_file("res://scenes/level.tscn")

	# quit
	if event.is_action("quit"):
		get_tree().quit(0)
