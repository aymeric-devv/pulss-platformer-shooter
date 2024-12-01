extends CharacterBody2D

@export var max_speed : int = 100
@export var gravity : float = 20
@export var jump_force : int = 225
@export var acceleration : int = 150
@export var jump_buffer_time : int  = 15
@export var cayote_time : int = 15

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var jump_buffer_counter : int = 0
var cayote_counter : int = 0
var requested_animation = "idle"
var player_state = "idle"

func _physics_process(_delta):
	if not is_on_floor():
		if cayote_counter > 0:
			cayote_counter -= 1
		velocity.y += gravity
		if velocity.y > 2000:
			velocity.y = 2000
			
	if Input.is_action_pressed("move_right"): #Go right
		velocity.x += acceleration
		if player_state != "jumping": 
			requested_animation = "run"
		animated_sprite.flip_h = false
	elif Input.is_action_pressed("move_left"): #Go left
		velocity.x -= acceleration
		if player_state != "jumping":
			requested_animation = "run"
		animated_sprite.flip_h = true
	else: #No movements
		velocity.x = lerp(velocity.x,0.0,0.2)
		if player_state != "jumping":
			requested_animation = "wait" #TO DO : Set idle after 2s and sleeping after 7s
		
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	
	if is_on_floor():
		cayote_counter = cayote_time
		player_state = "nothing"
		
	if Input.is_action_just_pressed("jump"): 
		jump_buffer_counter = jump_buffer_time
	
	if jump_buffer_counter > 0:
		jump_buffer_counter -= 1
	
	if jump_buffer_counter > 0 and cayote_counter > 0: #Jump
		player_state = "jumping"
		requested_animation = "jump"
		velocity.y = -jump_force
		jump_buffer_counter = 0
		cayote_counter = 0
		
		
	animated_sprite.play(requested_animation)
	move_and_slide()
