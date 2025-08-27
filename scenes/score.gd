extends Object

class_name Score

## score in the best score leaderbord
## Note that godot 4 doen't allow to define a class inside another class

# fields
var name: String = ""
var score: int = 0

# constructor, call with: Score.new('Pippo', 1)
func _init(_name: String, _value: int) -> void:
	name = _name
	score = _value

# gets the string representation as in: var text: String = str(score)
# useful for logging with: print("Score: " + str(score))
func _to_string() -> String:
	return name + ": " + str(score)

# NOTE:
# JSON.stringify() and JSON.parse() only accept primitive types so to convert
# a custom class to JSON it must be transformed to and from a dictionary.

# for JSON serialization
# JSON.stringify() only converts primitive types
func to_dict() -> Dictionary:
	return {
		"name": name,
		"score": score
	}

# convert from dictionay (JSON) to class
static func from_dict(data: Dictionary) -> Score:
	return Score.new(data["name"], int(data["score"]))

# used to sort an array or a list of Scores
# allows to sort list of Score
# i.e.: list.sort(sort_by_score)
static func sort_by_score_descending(a:Score, b:Score) -> bool:
	if a.score > b.score:
		return true
	return false
