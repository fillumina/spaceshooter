extends Node2D

# load the scenes that will be called in the code in a local class variable
# this is much faster than load them each time they are needed.
var rock_meteor_scene: PackedScene = load("res://scenes/meteor.tscn")
var ice_meteor_scene: PackedScene = load("res://scenes/ice_meteor.tscn")
var laser_scene: PackedScene = load("res://scenes/laser.tscn")

# init the random number generator
var rng := RandomNumberGenerator.new()

# number of lives left initialized at the total
var health := 5


# called once when the scene is added to the visualization tree
func _ready():
	# call the method ui#set_healt(health) in ui.gd
	# ui is the group (see Node tab to the left of Inspector panel)
	# a group allows to treat a number of objects as a single entity.
	# using this way it is possible to call a method in a different scene.
	# this is equivalent to: 	$UI.set_health(health)
	get_tree().call_group("ui", "set_health", health)

	# get the viewport size (x, y)
	var size := get_viewport().get_visible_rect().size
	_scale_background(size)
	_add_shining_stars(size)
		

# adapt the background to the viewport by changing its scale (hack).
func _scale_background(size: Vector2) -> void:
	# 1270 is the background image width
	var common_scale = size.x / 1270
	$Background.scale = Vector2(common_scale, common_scale)
	# print("background scale: " + str(common_scale))


# add some shining stars to the background
func _add_shining_stars(size: Vector2) -> void:
	for star in $Stars.get_children():
		# size
		var x = rng.randf_range(0, size.x)
		var y = rng.randf_range(0, size.y)
		star.position = Vector2(x, y)
		
		# scale
		var s = rng.randf_range(0.2, 0.6)
		star.scale = Vector2(s, s)
		
		# speed
		star.speed_scale = rng.randf_range(0.5, 1)	


# called when the $MeteorTimer expires to create new meteors
func _on_meteor_timer_timeout() -> void:
	# create new meteors randombly chosen as icy or rocky
	var meteor
	if rng.randi_range(0, 1) == 0:
		meteor = rock_meteor_scene.instantiate()
	else:
		meteor = ice_meteor_scene.instantiate()
	
	# connect the signal 'collision' defined in the base_meteor.gd
	# to method _on_meteor_collision() on both
	# IceMeteor (ice_meteor.gd) and RockMeteor (meteor.gd)
	# where it calls the super mothod 
	# base_meteor.gd#_on_body_entered(self)
	meteor.connect('collision', _on_meteor_collision)

	# attach this node to the scene tree
	$Meteors.add_child(meteor)


# programmatically connected to the meteors signal 'collision' by 
# meteor.connect('collision', _on_meteor_collision)
# in method _on_meteor_timer_timeout()
func _on_meteor_collision():
	$Player.do_collision()

	health -= 1
	# update the health status on the UI
	get_tree().call_group("ui", "set_health", health)
	if health <= 0:
		# last life gone, go to game over scene
		# must use call_deferrend to avoid concurrent removal of objects error
		call_deferred("_game_over")


# invoked by _on_meteor_collision() to change to game_over scene
func _game_over():
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")


# called when the laser(pos) signal is fired on player.gd
func _on_player_laser(pos: Vector2) -> void:
	# instantiate a new laser
	var laser = laser_scene.instantiate()
	# set the position to the current spaceship position
	laser.position = pos
	# add the laser to the tree
	$Lasers.add_child(laser)
	
