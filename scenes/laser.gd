extends Area2D

@export var speed := 500

func _ready():
	var tween = create_tween()
	tween.tween_property($Sprite2D, "scale", Vector2(1,1), 0.2).from(Vector2(0,0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y -= speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.name == "UpBorder":
		print("remove out of view laser")
		# wait a little bit before removing to avoid sudden disappearence
		await get_tree().create_timer(0.5).timeout
		queue_free()
