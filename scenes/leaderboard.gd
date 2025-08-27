extends Object

class_name Leaderboard

## Manage high scores.

# maximum number of scores saved
const MAX_SCORES = 5

# filename containing high score in json format
const FILENAME = "user://high_scores.json"

var scores: Array[Score] = []


# invoke with Leaderboard.new()
func _init() -> void:
	# load the highest score from storage
	scores = _load_high_scores()	


# The new score is added only if higher than the lowest one recorded
func add_new_score_value(_name: String, _score: int) -> bool:
	var score = Score.new(_name, _score)
	return add_new_score(score)


# The new score is added only if higher than the lowest one recorded
func add_new_score(score:Score) -> bool:
	if scores.size() > MAX_SCORES:
		if is_score_better_than_min(score.score):
			# remove last element
			scores.pop_back()
		else:
			# new score is worse than the min one
			# so it's not saved
			return false
	scores.append(score)
	# sort scores
	scores.sort_custom(Score.sort_by_score_descending)
	# save high scores
	_save_high_scores(scores)
	return true


# check if the score should be added to the list of highest score
func is_score_better_than_min(score:int) -> bool:
	if scores.size() < MAX_SCORES:
		# the list is not full
		return true
	# check if the given score is higher than the minimum one recorded
	var min_score = 0
	for s in scores:
		if s.score < min_score:
			min_score = s.score
	return score > min_score


# clear the list
func clear():
	self.scores = []
	_save_high_scores([])


static func clear_scores():
	_save_high_scores([])


# save the list on storage
static func _save_high_scores(scores: Array) -> void:
	var file = FileAccess.open(FILENAME, FileAccess.WRITE)
	if file != null:
		# JSON.stringify() cannot convert custom types so
		# converts the Score array into an array of dictionaries
		var dict_array = scores.map(func(x): return x.to_dict())
		var data = {"scores": dict_array}
		var text = JSON.stringify(data)
		# print(text) # debugging
		file.store_string(text)
		file.close()
	else:
		printerr("Error opening file: " + FILENAME)

		
static func _load_high_scores() -> Array:
	var scores: Array[Score] = []
	var file = FileAccess.open(FILENAME, FileAccess.READ)

	if file == null:
		printerr("Failed to open high scores file: " + FILENAME)

	else:	
		var text = file.get_as_text()
		#print(text)
		var data = JSON.parse_string(text)
		if (
			typeof(data) == TYPE_DICTIONARY and 
			data.has("scores") and 
			typeof(data["scores"]) == TYPE_ARRAY
			):
			var dict_array = data["scores"]
			scores = []
			for dict in dict_array:
				scores.append(Score.from_dict(dict))
			file.close()
		
	# fallback if data is not in the expected format
	return scores


# print the leaderboard as in: print(str(leaderboard))
# useful while debugging
func _to_string() -> String:
	var output = ""
	for s in scores:
		output = output + str(s) + "\n"
	return output
