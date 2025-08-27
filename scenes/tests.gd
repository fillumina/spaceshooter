extends Node2D

## This scene is used to perform tests. It's not called during the game.
## It can be executed with F6 or clicking in the "Execute current scene" 
## button in the godot top right.
## NOTE: The GUT test framework addon offers much better testing support.

# this is the function that is always executed
func _init() -> void:
	# comment the tests you don't want to execute
	_test_leaderboard_add()

# check if scores are correctly added and ordered in the leaderboard
func _test_leaderboard_add():
	var lb = Leaderboard.new()
	lb.clear()
	lb.add_new_score_value("Pippo", 10)
	lb.add_new_score_value("Puppo", 5)
	lb.add_new_score_value("Alfo", 20)
	print(str(lb))
	
	assert(lb.scores.size() == 3)
	_assert_score(lb.scores, 0, "Alfo", 20)
	_assert_score(lb.scores, 1, "Pippo", 10)
	_assert_score(lb.scores, 2, "Puppo", 5)
	
	
func _assert_score(
		scores: Array[Score], 
		index: int,
		name: String,
		score: int
	):
	assert(scores[index].name == name)
	assert(scores[index].score == score)
	
