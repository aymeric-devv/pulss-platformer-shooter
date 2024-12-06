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
@onready var bullets: Node2D = $Bullets  #Where the bullets will be stored

var BULLET_1 = preload("res://scenes/bullet_1.tscn") #Preload the bullet 1
var BULLET_2 = preload("res://scenes/bullet_2.tscn") #Preload the bullet 2

var jump_buffer_counter : int = 0
var cayote_counter : int = 0
var player_state = "idle" #Store player state in a variable
var prev_player_state = "idle" #Store the old player state
var idle_cooldown = 10.0 #A cooldown beetwen each idles animations
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var current_speed
var can_shoot_bullet_1 = true #A bool to know if player can shoot the bullet 1
var can_shoot_bullet_2 = true #A bool to know if player can shoot the bullet 2
var mouse_mod = true #Hide the cursor by default
var prev_animation

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("echap"): #Press esc to show cursor or quit the game
		mouse_mod = !mouse_mod
	if mouse_mod:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
func _physics_process(delta):
	if is_on_floor(): #If player is in air
		current_speed = SPEED #Set the ground speed
		cayote_counter = cayote_time
		if player_state != "idle" and player_state != "run" and player_state != "shooting":
			player_state = "nothing" #Set this variable after a jump to finish it
	else:
		current_speed = IN_AIR_SPEED #SSet the in-air speed
		velocity.y += get_current_gravity() * delta #Add gravity in air
		if cayote_counter > 0: #Counter for cayote time
			cayote_counter -= 1
		
	var direction = Input.get_axis("move_left", "move_right") #Get the direction
	if direction: #if player press a key
		if is_on_floor(): #If player moves on floor
			if player_state != "jumping": #Play the annimation if player isn't jumping 
				if player_state != "shooting":
					player_state = "run"
					play_animation("run")
		else: #Else
			if player_state != "jumping":
				player_state = "fly" #Play fly animation
				play_animation("jump2")
				
		if direction > 0: #Turn the player
			animated_sprite.flip_h = false
		else:
			animated_sprite.flip_h = true
		velocity.x = direction * current_speed #Apply speed
		slow_friction(delta)
		idle_cooldown = 10.0
			
	else: #If player doesn't move
		velocity.x = move_toward(velocity.x, 0, SPEED) #Stop the player
		if is_on_floor(): #If doesn't move in ground
			if player_state != "jumping" && player_state != "shooting": #If player isn't jumping to prevent animation conflict	 	
				player_state = "idle"
				idle_cooldown -= 0.01
				if idle_cooldown > 9.5: #Play animations
					play_animation("wait")
				elif idle_cooldown > 3:
					play_animation("idle")
				else:
					player_state = "sleeping"
					play_animation("sleep")
					
		else: #Else, if player doesn't move in air
			if player_state != "jumping" and player_state != "shooting":
				player_state = "fall"
				play_animation("in-air") #Play in air animation
	
	if Input.is_action_just_pressed("bullet_1_shoot"): #Shooting
		if can_shoot_bullet_1:
			player_state = "shooting"
			idle_cooldown = 10.0
			play_animation("shoot_bullet_1")
			shoot_bullet_1()
			can_shoot_bullet_1 = false
			await get_tree().create_timer(0.5).timeout
			can_shoot_bullet_1 = true
			player_state = "nothing"
			
	if Input.is_action_just_pressed("bullet_2_shoot"): #Shooting
		if can_shoot_bullet_2:
			player_state = "shooting"
			idle_cooldown = 10.0
			play_animation("shoot_bullet_2")
			shoot_bullet_2()
			can_shoot_bullet_2 = false
			await get_tree().create_timer(0.3).timeout
			can_shoot_bullet_2 = true
			player_state = "nothing"
		
	if jump_buffer_counter > 0: #Jump buffer counter
		jump_buffer_counter -= 1
		
	if Input.is_action_just_pressed("jump"): #Look if player jump
		jump_buffer_counter = jump_buffer_time #Set buffer time
		
	if jump_buffer_counter > 0 and cayote_counter > 0: #Jump 
		jump()
		
	prev_player_state = player_state
	move_and_slide()
	
func slow_friction(d):
	velocity.x -= .02 * d

func get_current_gravity():
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func shoot_bullet_1(): #Shoot projectiles
	var bullet_1 = BULLET_1.instantiate() #Prefab of projectile
	var angle = $Gun/Tip.global_rotation #Set the rotation of the gun
	bullet_1.position = $Gun/Tip.global_position
	bullet_1.rotation = angle
	get_tree().current_scene.add_child(bullet_1)
	bullet_1.apply_central_impulse(Vector2(cos(angle), sin(angle)) * 150) 
	
func shoot_bullet_2():
	var bullet_2 = BULLET_2.instantiate() #Prefab of projectile
	bullet_2.position = $Gun/Tip.global_position
	get_tree().current_scene.add_child(bullet_2)
	bullet_2.apply_central_force(Vector2(0, 0.5))

func play_animation(animation):
	#print(animation)
	animated_sprite.play(animation)
	prev_animation = animation

func jump():
	player_state = "jumping"
	idle_cooldown = 10.0 #Reset the player idle cooldown
	play_animation("jump")
	velocity.y = jump_velocity #Jump
	jump_buffer_counter = 0 #Reset jump buffer
	cayote_counter = 0 #Reset cayote time

func get_player_state():
	return player_state
	
