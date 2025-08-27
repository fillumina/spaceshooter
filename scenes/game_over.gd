extends Control

## This scene appears when the player loose the last life.

# @export variables appear in the Node panel and can be attached using the IDE.
# This visual approach is faster and flexible but less documented.

# Connect the starting scene using the Inspector or use the given default
@export var level_scene: PackedScene = load("res://scenes/level.tscn")

# References to components
@onready var scores_list: ItemList = $CenterContainer/BestScores
@onready var name_dialog: AcceptDialog = $NameDialog
@onready var score_text: Label = $MarginContainer2/VBoxContainer/ScoreLabel

# The leaderboard containing the highest scores
var leaderboard = Leaderboard.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score_text.text += str(Global.score)
	
	if leaderboard.is_score_better_than_min(Global.score):
		# if the player score is within the bests scores ask for their name
		name_dialog.name_chosen.connect(_on_name_chosen)
		name_dialog.ask_name()
	else:
		# hide the dialog
		name_dialog.hide()
		# update the shown scores
		_update_score_list()


# Called at every frame. 'delta' is the elapsed time since the previous frame.
func _input(event) -> void:
	if event.is_action_pressed("shoot"):
		get_tree().change_scene_to_packed(level_scene)
		
	if event.is_action_pressed("quit"):
		get_tree().quit(0)
		
	if event.is_action_pressed("cancel"):
		Leaderboard.clear_scores()


# Called when the OK button on the dialog is pressed
func _on_name_chosen(_name: String) -> void:
	leaderboard.add_new_score_value(_name, Global.score)
	_update_score_list()


# Update the ItemList component BestScore with the score list
func _update_score_list():
	scores_list.clear()  # remove old items

	for entry in leaderboard.scores:
		scores_list.add_item(str(entry.score))
		scores_list.add_item(entry.name)
