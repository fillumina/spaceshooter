extends Area2D
class_name BaseMeteor

## This class is the common parent for both RockMeteor and IceMeteor.
## They behave exactly the same so it makes sense to share their logic.

# Load a scene and saves in the instance to be used later.
# Like python parentheses can be used to split a long line.
var meteor_explosion_scene: PackedScene = load(
	"res://scenes/meteor_explosion.tscn"
)

# Instance fields (will be initialized in _ready() )
var speed: int
var rotation_speed: int
var direction_x: float

# programmatically connected in level.gd#_on_meteor_timer_timeout()
signal collision


# Called when the node enters the scene tree for the first time and never again.
# This is not like _init() which initialize the object.
func _ready() -> void:
	# init the meteor state to random values
	var rng := RandomNumberGenerator.new()

	# read the viewport size
	var width = get_viewport().get_visible_rect().size.x
	var random_x = rng.randi_range(30, width-30)
	var random_y = rng.randi_range(-150, 50)
	# set the start position
	position = Vector2(random_x, random_y)
	
	# set speed / rotation / direction
	speed = rng.randi_range(200, 500)
	direction_x = rng.randf_range(-1, 1)
	rotation_speed = rng.randi_range(40, 100)

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# change meteor position
	position += Vector2(direction_x, 1.0) * speed * delta
	# change meteor rotation angle
	rotation_degrees += rotation_speed * delta


# Called by signal body_entered (collisions events)
# Look at Node tab of both RockMeteor and IceMeteor scenes
func _on_body_entered(body: Node2D) -> void:
	if body.get_parent().name == "Borders":
		# collision with the upper border makes no effect
		if body.name != "UpBorder":
			print("remove out of view meteor")
			# wait a little bit before removing to avoid sudden disappearence
			await get_tree().create_timer(0.5).timeout
			# remove the object
			queue_free()
	elif visible:
		# if it's not a border then it's a laser or the starship
		# those events are managed by the Level scene.
		collision.emit()


# Called by signal area_entered (see Node in RockMeteor and IceMeteor)
# Look at Node tab of both RockMeteor and IceMeteor scenes
func _on_area_entered(area: Area2D) -> void:
	# it it's hidden it means it is already been hit
	if visible:
		# remove the colliding object (laser)
		area.queue_free()
		# we need time to play the sound and animation
		# so we hide the object instead of removing it
		self.hide()
		# create the explosion animation scene
		var explosion_scene = meteor_explosion_scene.instantiate()
		# set the explosion animation scene position to actual position
		explosion_scene.position = self.position
		# add the explosion scene to the parent
		self.get_parent().add_child(explosion_scene)
		# wait 1 second for the explosion to play
		await get_tree().create_timer(1).timeout
		# remove both explosion and meteor
		self.queue_free()
		explosion_scene.queue_free()
