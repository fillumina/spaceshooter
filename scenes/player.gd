extends CharacterBody2D

## manage the spaceship

# The @export keyword make the property appear in the node's Inspector panel.
# The := symbol means that the variable gets the type of the argument and
# would not accept any other types. The given value is the default one if
# it's not modified in the Node panel.
@export var speed := 500

# when the laser fires it has to wait for a timer to expire to be able to fire 
# again.
# the := symbol assign the value and bound the variable to that type as well
var can_shoot := true

# create a custom signal to be called by other scenes 
# see on level.gd: _on_player_laser(pos: Vector2)
signal laser(pos)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var viewport_size: Vector2 = get_viewport_rect().size
	# set the initial spaceship position
	position = Vector2(viewport_size.x / 2, viewport_size.y * 2/3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# to allow the user to un-pause the game the Player node is set to 
	# be always active (Inspector : Process : Mode = 'Always') even when
	# the game is paused so it can still receive the user inputs
	
	# defines actions to perform following the input
	# see menu Project -> Project Settings... -> Input Map (tab)
	if Input.is_action_pressed("quit"):
		get_tree().quit(0)
		
	if Input.is_action_pressed("pause"):
		# note that the player scene must be set Process:Mode = Always
		# so it is not paused and can catch the P input that will un-pause
		# the game
		var pause_status = not get_tree().paused
		# set the 'paused' label in the UI
		get_tree().call_group("ui", "set_pause", pause_status)
		# pause the game (except Player itself to be able to get unpause input)
		get_tree().paused = pause_status

	# player should manage movements only when unpaused
	if not get_tree().paused:
		var direction = Input.get_vector("left", "right", "up", "down")
		velocity = direction * speed
		
		# that's ok:
		#position += velocity * _delta
		# but this is better:
		move_and_slide()

		# rotate slightly the starship right or left when moving
		var left_pressed = Input.is_action_just_pressed("left")
		var left_released = Input.is_action_just_released("left")
		var right_pressed = Input.is_action_just_pressed("right")
		var right_released = Input.is_action_just_released("right")
		if left_pressed or left_released or right_pressed or right_released:
			var tween = create_tween()
			var angle = PI/20
			var time = 0.5

			if left_pressed:
				tween.tween_property($PlayerImage, "rotation", -angle, time).from(0)

			if left_released:
				tween.tween_property($PlayerImage, "rotation", 0, time).from(-angle)

			if right_pressed:
				tween.tween_property($PlayerImage, "rotation", angle, time).from(0)

			if right_released:
				tween.tween_property($PlayerImage, "rotation", 0, time).from(angle)
			
		# process the shoot input 
		if can_shoot and Input.is_action_just_pressed("shoot"):
			# use the Marker2D to get the starting position of the laser
			# in respect of the player
			var start_laser_position = $LaserStartPosition.global_position
			# it will be captured by level.gs: _on_player_laser(pos: Vector2)
			laser.emit(start_laser_position)
			# disallow continuous shooting, 
			# wait for 1 sec before being allowed again
			can_shoot = false
			$LaserTimer.start()
			# play the laser sound
			$LaserSound.play()

# called when the laser timer expires. it allows the player to shoot again.
func _on_laser_timer_timeout() -> void:
	can_shoot = true

# called by lever.bg#_on_meteor_collision()
func do_collision() -> void:
	_play_collision_sound()
	_shake()

func _play_collision_sound() -> void:
	$DamageSound.play()

func _shake() -> void:
	var angle = PI/12
	var time = 0.07
	var tween = create_tween()
	tween.tween_property($PlayerImage, "rotation", angle, time).from(0)
	tween.tween_property($PlayerImage, "rotation", -angle, time).from(angle)
	tween.tween_property($PlayerImage, "rotation", 0, time).from(-angle)
