extends RigidBody2D

@export var dispawn_cooldown : float = 5.0
var need_to_dispawn : bool = false

func _ready() -> void:
	await get_tree().create_timer(dispawn_cooldown).timeout # After launch create a cooldown to dispawn it
	need_to_dispawn = true # Say that it must be dispawned

func _process(delta: float) -> void:
	if need_to_dispawn: # Check if it must be dispawn
		queue_free() # Dispawn !

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"): # Else if it's touch a player it start an other timer
		await get_tree().create_timer(dispawn_cooldown).timeout
		need_to_dispawn = true
