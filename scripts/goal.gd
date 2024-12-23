extends Area2D

@export var ball: Node
@export var start_pos_ball: Marker2D

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func _on_body_entered(body:Node2D) -> void:
	if body is Ball:
		print("goal !")
		ball.stop_ball()
		await get_tree().create_timer(2.0).timeout
		ball.restart_ball()
		
