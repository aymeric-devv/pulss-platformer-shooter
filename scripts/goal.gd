extends Area2D

@export var ball : Node
@export var start_pos_ball : Marker2D
@export var restart_timer : float = 2.0
@export var can_goal_cooldown : float = 3.0
var can_goal : bool = true

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func _on_body_entered(body:Node2D) -> void:
	if body is Ball:
		if can_goal:
			can_goal = false
			print("goal !")
			ball.stop_ball()
			await get_tree().create_timer(restart_timer).timeout
			ball.restart_ball()
			await get_tree().create_timer(can_goal_cooldown).timeout
			can_goal = true
		
		
		
		
