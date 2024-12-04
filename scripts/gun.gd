extends Node2D

@onready var sprites: Node2D = $Sprites
@onready var gun_1: Sprite2D = $Sprites/Gun1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	print(mouse_pos)
	if mouse_pos < Vector2.ZERO:
		gun_1.flip_v = true
	look_at(to_global(to_local(mouse_pos)))
