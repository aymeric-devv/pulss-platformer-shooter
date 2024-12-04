extends Node2D

@onready var gun_1: Sprite2D = $Sprites/Gun_1
@onready var sprites: Node2D = $Sprites


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(get_global_mouse_position())

	
