extends CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var inputs = Input.get_vector("right", "left", "up", "down")
	velocity = inputs * 500
	move_and_slide()
