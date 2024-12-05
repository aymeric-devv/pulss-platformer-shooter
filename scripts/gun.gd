extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $"../Animations"
@onready var player: CharacterBody2D = $".."

func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())
	if player.get_player_state() == "idle" or player.get_player_state() == "shooting":
		if global_rotation > -1  and global_rotation < 1:
			animated_sprite.flip_h = false
		else:
			animated_sprite.flip_h = true

	
