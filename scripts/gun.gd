extends Node2D

func _physics_process(delta: float) -> void:
	var dir : float = Input.get_axis("right", "left")
	global_rotation_degrees += dir * 6.3
	
	if Input.is_action_just_pressed("up"):
		global_rotation_degrees = -90
	elif Input.is_action_just_pressed("down"):
		global_rotation_degrees = 90
