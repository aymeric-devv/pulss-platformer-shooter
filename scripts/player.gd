extends CharacterBody2D

@export var SPEED : int = 80
@export var IN_AIR_SPEED : int = 60 #Custom in-air speed
@export var jump_buffer_time : int  = 15 
@export var cayote_time : int = 7
@export var jump_height : float = 15
@export var jump_time_to_peak : float = 0.25
@export var jump_time_to_descent : float = 0.15

@onready var jump_velocity : float = ((2.0 * jump_height)  / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

@onready var animated_sprite: AnimatedSprite2D = $Animations
@onready var bullets: Node2D = $Bullets #Where the bullets will be stored

var bullet = preload("res://scenes/bullet_1.tscn") #Preload the bullet

var jump_buffer_counter : int = 0
var cayote_counter : int = 0
var player_state = "idle" #Store player state in a variable
var prev_player_state = "idle" #Store the old player state
var idle_cooldown = 10.0 #A cooldown beetwen each idles animations
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var current_speed
var can_shoot = true #A bool to know if player can shoot

func _physics_process(delta):
	if not is_on_floor(): #If player is in air
		current_speed = IN_AIR_SPEED #SSet the in-air speed
		velocity.y += get_current_gravity() * delta #Add gravity in air
		if cayote_counter > 0: #Counter for cayote time
			cayote_counter -= 1
		
	var direction = Input.get_axis("move_left", "move_right") #Get the direction
	if direction: #if player press a key
		if is_on_floor():
			if player_state != "jumping": #Play the annimation if player isn't jumping 
				player_state = "run"
				animated_sprite.play("run") 
		else:
			if player_state != "jumping":
				player_state = "fly"
				animated_sprite.play("jump2") 
		if direction > 0: #Turn the player
			animated_sprite.flip_h = false
		else:
			animated_sprite.flip_h = true
		velocity.x = direction * current_speed
		slow_friction(delta)
		idle_cooldown = 10.0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			if player_state != "jumping": #If player isn't jumping to prevent animation conflict	 	
				player_state = "idle"
				idle_cooldown -= 0.01
				if idle_cooldown > 9.5:
					animated_sprite.play("wait") 
				elif idle_cooldown > 3:
					animated_sprite.play("idle")
				else:
					animated_sprite.play("sleep")
		else:
			if player_state != "jumping":
				player_state = "fall"
				animated_sprite.play("in-air")
	
	if is_on_floor(): #If player is on ground
		current_speed = SPEED #Set the ground speed
		cayote_counter = cayote_time
		if player_state != "idle" and player_state != "run":
			player_state = "nothing" #Set this variable after a jump to finish it
		
	if jump_buffer_counter > 0: #Jump buffer counter
		jump_buffer_counter -= 1
		
	if Input.is_action_just_pressed("jump"): #Look if player jump
		jump_buffer_counter = jump_buffer_time #Set buffer time
		
	if jump_buffer_counter > 0 and cayote_counter > 0: #Jump 
		player_state = "jumping"
		idle_cooldown = 10.0 #Reset the player idle cooldown":			
		animated_sprite.play("jump")
		velocity.y = jump_velocity #Jump
		jump_buffer_counter = 0 #Reset jump buffer
		cayote_counter = 0 #Reset cayote time
		
	if Input.is_action_just_pressed("shoot"):
		if can_shoot:
			idle_cooldown = 10.0
			shoot()
			can_shoot = false
			await get_tree().create_timer(0.2).timeout
			can_shoot = true
		
		
	prev_player_state = player_state	
	move_and_slide()
	
		
func slow_friction(d):
	velocity.x -= .02 * d

func get_current_gravity():
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func shoot(): #Shoot projectiles
	var projectile = bullet.instantiate() #Prefab of projectile
	var angle = $Gun/Tip.global_rotation #Set the rotation of the gun
	projectile.position = $Gun/Tip.global_position
	projectile.rotation = angle
	get_tree().current_scene.add_child(projectile)
	projectile.apply_central_impulse(Vector2(cos(angle), sin(angle)) * 75) #TODO -> timer
	
