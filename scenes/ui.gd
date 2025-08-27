extends CanvasLayer

var image = load("res://assets/ship_small.png")
var time_elapsed := 0

# rererences to elements
@onready var lives_box: BoxContainer = $MarginContainer2/Lives
@onready var scores_label: Label = $MarginContainer/Score
@onready var pause_label: Label = $PauseLabel


# Called by level.gd _ready() to set the initial health
func set_health(amount:int) -> void:
	# remove all children
	for child in lives_box.get_children():
		child.queue_free()
	
	# create as many children as health
	for i in amount:
		var text_rect = TextureRect.new()
		text_rect.texture = image
		text_rect.stretch_mode = TextureRect.STRETCH_KEEP
		lives_box.add_child(text_rect)


# Called each time the ScoreTimer expires
func _on_score_timer_timeout() -> void:
	# increment the elapsed time counter
	time_elapsed += 1
	# visualize the elapsed time (text accepts only strings)
	scores_label.text = str(time_elapsed)
	# set the global score to the elapsed time,
	# see global/global.gb global file
	Global.score = time_elapsed


# Called by player.gd _process() when the user press the pause button
func set_pause(status: bool) -> void:
	# set the pause label visibility
	pause_label.visible = status
