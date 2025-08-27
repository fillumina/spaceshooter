extends Node

## A container for the score that is accessible by every scenes
## To define a global script go to the menu:
## Project -> Project Settings -> Globals
## To use it just type:
## Global.score = 23

# used by:
# - ui.gd _on_score_timer_timeout()
# - game_over.gd _ready()
var score := 0
