extends CharacterBody2D

@export var max_speed : int = 100
@export var gravity : float = 20
@export var jump_force : int = 225
@export var acceleration : int = 50
@export var jump_buffer_time : int  = 15
@export var cayote_time : int = 7

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var jump_buffer_counter : int = 0
var cayote_counter : int = 0
var player_state = "idle" #Store player state in a variable
var idle_cooldown = 10 #A cooldown beetwen each idles animations

func _physics_process(_delta):
	if not is_on_floor():
		if cayote_counter > 0:
			cayote_counter -= 1
		velocity.y += gravity
		if velocity.y > 2000:
			velocity.y = 2000
			
	if Input.is_action_pressed("move_right"): #Go right
		velocity.x += acceleration
		if is_on_floor() and player_state != "jumping": #If player isn't jumping to prevent animation conflict
			animated_sprite.play("run") 
		animated_sprite.flip_h = false
		idle_cooldown = 10.0 #Reset the player idle cooldown
	elif Input.is_action_pressed("move_left"): #Go left
		velocity.x -= acceleration
		if is_on_floor() and player_state != "jumping": #If player isn't jumping to prevent animation conflict
			animated_sprite.play("run")
		animated_sprite.flip_h = true
		idle_cooldown = 10.0 #Reset the player idle cooldown
	else: #No movements
		velocity.x = lerp(velocity.x,0.0,0.2)
		if is_on_floor() and player_state != "jumping": #If player isn't jumping to prevent animation conflict	 	
			player_state = "idle"
			idle_cooldown -= 0.01
			if idle_cooldown > 9.5:
				animated_sprite.play("wait") 
			elif idle_cooldown > 3:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("sleep")
		
	if not is_on_floor() and player_state != "jumping":
		animated_sprite.play("in-air")

	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	
	if is_on_floor():
		cayote_counter = cayote_time
		player_state = "nothing"
		
	if jump_buffer_counter > 0:
		jump_buffer_counter -= 1
		
	if Input.is_action_just_pressed("jump"): #Look if player jump
		jump_buffer_counter = jump_buffer_time #Set buffer time
		
	if jump_buffer_counter > 0 and cayote_counter > 0: #Jump 
		player_state = "jumping"
		idle_cooldown = 10.0 #Reset the player idle cooldown
		if abs(velocity.x) == 100: #If player speed is high
			animated_sprite.play("jump2") #Play a special jump animation
		else:
			animated_sprite.play("jump")
		velocity.y = -jump_force
		jump_buffer_counter = 0
		cayote_counter = 0
	move_and_slide()
	
