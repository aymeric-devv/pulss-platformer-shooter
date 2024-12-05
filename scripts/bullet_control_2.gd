extends RigidBody2D

var dispawn_cooldown = 5.0
var need_to_dispawn = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(dispawn_cooldown).timeout
	need_to_dispawn = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if need_to_dispawn:
		queue_free()

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		await get_tree().create_timer(1).timeout
		need_to_dispawn = true
