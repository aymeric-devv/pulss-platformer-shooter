#region Prev code

#class_name Player
#extends CharacterBody2D
#
#@export var can_dash: bool = true
#@export var dash_direction_object: Node2D
#@export var SPEED: int = 80
#@export var IN_AIR_SPEED: int = 60 #Custom in-air speed
#@export var jump_buffer_time: int  = 20 
#@export var cayote_time: int = 15
#@export var jump_height: float = 15
#@export var jump_time_to_peak: float = 0.25
#@export var jump_time_to_descent: float = 0.15
#@export var movements_lock: bool = false
#@export var bullet_1_force: float = 200
#@export var bullet_2_force: float = 0.1
#@export var spam_delay_bullet_1: float = 0.5
#@export var spam_delay_bullet_2: float = 0.15
#
#@onready var jump_velocity: float = ((2.0 * jump_height)  / jump_time_to_peak) * -1.0
#@onready var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
#@onready var fall_gravity: float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
#@onready var animated_sprite: AnimatedSprite2D = $Animations
#@onready var bullets: Node2D = $Bullets  #Where the bullets will be stored
#@onready var camera: Camera2D = $"../Camera"
#
#var BULLET_1 = preload("res://scenes/bullets/bullet_1.tscn") #Preload the bullet 1
#var BULLET_2 = preload("res://scenes/bullets/bullet_2.tscn") #Preload the bullet 2
#
#var jump_buffer_counter : int = 0
#var cayote_counter : int = 0
#var player_state = "idle" #Store player state in a variable
#var prev_player_state = "idle" #Store the old player state
#var idle_cooldown = 10.0 #A cooldown beetwen each idles animations
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#var current_speed
#var can_shoot_bullet_1 = true #A bool to know if player can shoot the bullet 1
#var can_shoot_bullet_2 = true #A bool to know if player can shoot the bullet 2
#var mouse_mod = true #Hide the cursor by default
#var prev_animations 
#var prev_state #Bool, true -> player is on floor false -> player not on floor
#var respawn_position = global_position #Where player respawn
#var last_moved_dir = 0
#
#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("echap"): #Press esc to show cursor or quit the game
		#mouse_mod = !mouse_mod
	#if mouse_mod:
		#Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	#else:
		#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		#
#func _physics_process(delta):
	##Engine.time_scale = 0.1
	#var direction = Input.get_axis("move_left", "move_right") #Get the direction
	#
	#if !prev_state and is_on_floor(): #Check if player land to the floor
		#camera.start_shake(1, 1.5, 15) #Shake the camera
		#
	#if is_on_floor(): #If player is in air
		#global_rotation_degrees = 0
		#current_speed = SPEED #Set the ground speed
		#cayote_counter = cayote_time
		#if player_state != "idle" and player_state != "run" and player_state != "shooting":
			#player_state = "nothing" #Set this variable after a jump to finish it
	#else:
		#current_speed = IN_AIR_SPEED #SSet the in-air speed
		#velocity.y += get_current_gravity() * delta #Add gravity in air
		#if cayote_counter > 0: #Counter for cayote time
			#cayote_counter -= 1
	#
	#if direction: #if player press a key
		#last_moved_dir = direction
		#if !movements_lock: #the player moves only if he can
			#if is_on_floor(): #If player want to move on floor
				#if player_state != "jumping": #Play the annimation if player isn't jumping 
					#if player_state != "shooting":
						#player_state = "run"
						#play_animation("run")
			#else: #Else
				#if player_state != "jumping" and player_state != "dashing":
					#player_state = "fly" #Play fly animation
					#play_animation("jump2")
				#
			#if direction > 0: #Turn the player
				#animated_sprite.flip_h = false
			#else:
				#animated_sprite.flip_h = true
		#
			#velocity.x = direction * current_speed #Apply speed only if player isn't dashing
			#slow_friction(delta)
			#idle_cooldown = 10.0
				#
	#else: #If player doesn't move
		#velocity.x = move_toward(velocity.x, 0, SPEED) #Stop the player
		#if is_on_floor(): #If doesn't move in ground
			#if player_state != "jumping" && player_state != "shooting": #If player isn't jumping to prevent animation conflict	 	
				#player_state = "idle"
				#idle_cooldown -= 0.01
				#if idle_cooldown > 9.5: #Play animations
					#play_animation("wait")
				#elif idle_cooldown > 3:
					#play_animation("idle")
				#else:
					#play_animation("sleep")
					#
		#else: #Else, if player doesn't move in air
			#if player_state != "jumping" and player_state != "shooting" and player_state != "dashing":
				#player_state = "fall"
				#play_animation("in-air") #Play in air animation
	#
	#if Input.is_action_just_pressed("dash") and can_dash:
			#player_state = "dashing"
			#print("dash")
			#velocity = dash_direction_object.global_position * 40
			#player_state = "nothing"
	#
#
	#if Input.is_action_just_pressed("bullet_1_shoot"): #Shooting
		#if can_shoot_bullet_1 and !movements_lock:
			#player_state = "shooting"
			#idle_cooldown = 10.0
			#camera.start_shake(1.5, 1.0, 10) #Start a camera shake
			#play_animation("shoot_bullet_1")
			#shoot_bullet_1()
			#can_shoot_bullet_1 = false
			#await get_tree().create_timer(spam_delay_bullet_1).timeout
			#can_shoot_bullet_1 = true
			#player_state = "nothing"
			#
	#if Input.is_action_just_pressed("bullet_2_shoot"): #Shooting
		#if can_shoot_bullet_2 and !movements_lock:
			#player_state = "shooting"
			#idle_cooldown = 10.0
			#camera.start_shake(0.5, 0.5, 30)
			#play_animation("shoot_bullet_2")
			#shoot_bullet_2()
			#can_shoot_bullet_2 = false
			#await get_tree().create_timer(spam_delay_bullet_2).timeout
			#can_shoot_bullet_2 = true
			#player_state = "nothing"
		#
	#if jump_buffer_counter > 0: #Jump buffer counter
		#jump_buffer_counter -= 1
		#
	#if Input.is_action_just_pressed("jump"): #Look if player jump
		#jump_buffer_counter = jump_buffer_time #Set buffer time
		#
	#if jump_buffer_counter > 0 and cayote_counter > 0 and !movements_lock: #Jump 
		#jump()
		#
	#prev_player_state = player_state
	#prev_state = is_on_floor()
	#move_and_slide()
	#
#func slow_friction(d):
	#velocity.x -= .02 * d
#
#func get_current_gravity():
	#return jump_gravity if velocity.y < 0.0 else fall_gravity
#
#func shoot_bullet_1(): #Shoot projectiles
	#var bullet_1 = BULLET_1.instantiate() #Prefab of projectile
	#var angle = $Gun/Tip.global_rotation #Set the rotation of the gun
	#bullet_1.position = $Gun/Tip.global_position
	#bullet_1.rotation = angle
	#get_tree().current_scene.add_child(bullet_1)
	#bullet_1.apply_central_impulse(Vector2(cos(angle), sin(angle)) * bullet_1_force) 
	#
#func shoot_bullet_2():
	#var bullet_2 = BULLET_2.instantiate() #Prefab of projectile
	#bullet_2.position = $Gun/Tip.global_position
	#get_tree().current_scene.add_child(bullet_2)
	#bullet_2.apply_central_force(Vector2(0, bullet_2_force))
#
#func play_animation(animation):
	##print(animation)
	#animated_sprite.play(animation)
	#prev_animations = animation
	#
#func jump():
	#player_state = "jumping"
	#idle_cooldown = 10.0 #Reset the player idle cooldown
	#play_animation("jump")
	#velocity.y = jump_velocity #Jump
	#jump_buffer_counter = 0 #Reset jump buffer
	#cayote_counter = 0 #Reset cayote time
#
#func get_player_state():
	#return player_state
	#
#func set_player_position(position):
	#global_position = position
#
#func set_respawn_position(position):
	#respawn_position = position
	#
#func respawn() -> void:
	#await get_tree().create_timer(0.05).timeout
	#global_position = respawn_position
#endregion

class_name Player
extends CharacterBody2D

#region VARIABLES

# ++ GLOBAL VARARIABLES ++

# ** NO CATEGORIES
@export var movements_lock: bool = false # A bool to know if player can move and shoot
const IDLE_COOLDOWN : float = 10.0 # Store the value of idle cooldown
var _idle_cooldown : float # Store the current value of cooldown
var respawn_position : Vector2 = global_position
var player_name : String = "Aymeric-devv"

# ** MOVEMENTS & SHOOT **
# -- Simple moves --
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var SPEED : int = 80 # Speed
@export var IN_AIR_SPEED : int = 60 # In-air speed
var current_speed : int # Where the speed is stored
var last_moved_dir : float = 0 # Where the last direction where player wanted to go. Can be -1 or 1
# -- Jump --
@export var jump_height: int = 15
@export var jump_buffer_time : int  = 20  # Time for jump buffer
@export var cayote_time : int = 15 # Coyote time
@export var jump_time_to_peak : float = 0.25 # Time to peak when player jumps
@export var jump_time_to_descent : float = 0.15 # Time to descent when player jumps
var jump_velocity : float = ((2.0 * jump_height)  / jump_time_to_peak) * -1.0 # Calculate the jump velocity
var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0 # Calculate the jump gravity
var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0 # Calculate the gravity when the player falls
var jump_buffer_counter : int = 0 # Count jumps for jump buffer
var cayote_counter : int = 0 # Count cayote time
# -- Bullets --
@export var bullet_1_force: float = 200 # Force to shoot bullet 1
@export var bullet_2_force: float = 0.1 # Same for bullet 2
@export var spam_delay_bullet_1: float = 0.5 # Small cooldown to prevent spam
@export var spam_delay_bullet_2: float = 0.15 # Same for bullet 2
#var BULLET_1 = preload("res://scenes/bullets/bullet_1.tscn") #Preload the bullet 1
#var BULLET_2 = preload("res://scenes/bullets/bullet_2.tscn") #Same for bullet 2
var can_shoot_bullet_1 : bool = true #A bool to know if player can shoot the bullet 1
var can_shoot_bullet_2 : bool = true #Same for bullet 2

# ** PLAYER'S INPUT **
var direction : float = 0 # Direction variable, can be -1, 0, 1
var want_to_jump : bool = false # If player want to jump
var want_to_dash : bool = false # Same for dash
var want_to_shoot_bullet_1 : bool = false # Same for bullet 1
var want_to_shoot_bullet_2 : bool = false # Same for bullet 2

# ** PLAYER'S STATES **
enum PlayerState { # Enum for player's state
	NOTHING,
	RUNNING,
	IDLE,
	JUMPING,
	DASHING,
	SHOOTING,
	FLYING,
	FALLING
}
var player_state = PlayerState.IDLE # Where the player's state from the enum will be stored
var prev_player_state = player_state # Just store the prev player's state

# ** NODES & SCENES ** 
@onready var sprites: AnimatedSprite2D = $Animations # Animated sprite of player
@export var camera : Camera2D # Player's camera
@export var bullet_1 : PackedScene # Set a variable for bullet 1
@export var bullet_2 : PackedScene # Same for bullet 2
@onready var gun: Node2D = $Gun # Same for gun
@onready var gun_tip: Marker2D = $Gun/Tip # Same for gun's tip

#endregion

#region FUNCTIONS

# ++ FUNCTIONS ++

# ** CONTROL'S FUNCTIONS **
func _ready():
	pass

func _process(delta):
	pass

func _physics_process(delta):
	#Engine.time_scale = 0.001
	get_inputs() # Get player's input first
	if !movements_lock:
		move(delta) # Just move the player according inputs, including movements, jump and dash
		shoot() # A function to manage player's shoots  
	move_and_slide() # Finally, move !

# ** USEFUL FUNCTIONS **
func get_inputs() -> void: # Get inputs and store them in input variables
	direction = Input.get_axis("move_left", "move_right") # Get the direction, -1, 0, 1
	want_to_jump = Input.is_action_just_pressed("jump") # Bool for jump
	want_to_dash = Input.is_action_just_pressed("dash") # Same dash
	want_to_shoot_bullet_1 = Input.is_action_just_pressed("bullet_1_shoot") # Same for bullet 1
	want_to_shoot_bullet_2 = Input.is_action_just_pressed("bullet_2_shoot") # Same for bullet 2

func move(delta) -> void: # Get inputs from get_inputs() to perform the requested movement
	if is_on_floor(): # First check if player is on floor or not to do some things
		current_speed = SPEED # Set on floor speed
		cayote_counter = cayote_time # Start cayote timer
	else:
		current_speed = IN_AIR_SPEED # Set in-air speed
		velocity.y += get_current_gravity() * delta
		if cayote_counter > 0: # Decrease for cayote time
			cayote_counter -= 1

	if jump_buffer_counter > 0: # Same for jump buffer cooldown but not when player is on floor
		jump_buffer_counter -= 1

	if direction: # If direction is -1 or 1, move !
		last_moved_dir = direction # Store the direction
		if is_on_floor(): # If player is on floor
			if player_state != PlayerState.JUMPING: # Play on floor animation only if player isn't jumping
				if player_state != PlayerState.SHOOTING: # Same for shooting
					player_state = PlayerState.RUNNING
					play_animation("run")
		else: # Else
			if player_state != PlayerState.JUMPING: # Play in-air animation only if player isn't jumping
				if player_state != PlayerState.DASHING: # Same for dash
					player_state = PlayerState.FLYING
					play_animation("jump2") # Play fly animation
		
		if direction > 0: # Turn the player's sprite
			sprites.flip_h = false
		else:
			sprites.flip_h = true
		
		velocity.x = direction * current_speed # Apply movements to velocity.x
		slow_friction(delta)
		reset_idle_cooldown()
	
	else: # If player doesn't move
		velocity.x = move_toward(velocity.x, 0, current_speed) # Stop the player
		if is_on_floor(): # Check if player is idle in-air or not
			if player_state != PlayerState.JUMPING: # Play idle animation only if player isn't jumping
				if player_state != PlayerState.SHOOTING: # Same for shooting
					player_state = PlayerState.IDLE
					_idle_cooldown -= 0.01
					if _idle_cooldown > 9.5:
						play_animation("wait") # First play wait animation
					elif _idle_cooldown > 3:
						play_animation("idle")
					else:
						play_animation("sleep")
	
	if want_to_jump:
		jump_buffer_counter = jump_buffer_time # Set buffer time when player want to jump
	
	if jump_buffer_counter > 0 and cayote_counter > 0 and !movements_lock: # All of condition for jump ! 
		player_state = PlayerState.JUMPING
		reset_idle_cooldown()
		play_animation("jump")
		velocity.y = jump_velocity # Apply jump
		jump_buffer_counter = 0 # Reset jump buffer
		cayote_counter = 0 # Reset cayote time
		player_state = PlayerState.NOTHING

	# Turn the player with the gun
	if player_state == PlayerState.IDLE or player_state == PlayerState.SHOOTING: # Only if idling or shooting
		if gun.global_rotation > -1 and gun.global_rotation < 1: # If it's between -1 and 1
			sprites.flip_h = false
		else:
			sprites.flip_h = true

func shoot() -> void: # Get inputs from get_inputs() to perform shoots, independant of move()
	# Shoot bullet 1
	if want_to_shoot_bullet_1:
		if can_shoot_bullet_1:
			player_state = PlayerState.SHOOTING
			reset_idle_cooldown()
			camera_shake(1.5, 1.0, 10) # Start a camera shake
			play_animation("shoot_bullet_1")
			# Shoot bullet
			var _bullet_1 = bullet_1.instantiate() # Prefab of projectile
			var angle = gun_tip.global_rotation # Store the rotation of the gun
			_bullet_1.position = gun_tip.global_position # Set position of the bullet
			_bullet_1.rotation =  angle # Same for rotation
			get_tree().current_scene.add_child(_bullet_1) # Add bullet to player's scene
			_bullet_1.add_to_group(player_name)
			_bullet_1.apply_central_impulse(Vector2(cos(angle), sin(angle)) * bullet_1_force) # Propulse bullet 
			# Set spam cooldown
			can_shoot_bullet_1 = false
			await get_tree().create_timer(spam_delay_bullet_1).timeout
			can_shoot_bullet_1 = true
			player_state = PlayerState.NOTHING

	# Shoot bullet 2
	if want_to_shoot_bullet_2:
		if can_shoot_bullet_2:
			player_state = PlayerState.SHOOTING
			reset_idle_cooldown()
			camera_shake(0.5, 0.5, 30) # Start a camera shake
			play_animation("shoot_bullet_2")
			# Shoot bullet
			var _bullet_2 = bullet_2.instantiate() #Prefab of projectile
			_bullet_2.position = gun_tip.global_position
			get_tree().current_scene.add_child(_bullet_2)
			_bullet_2.add_to_group(player_name)
			_bullet_2.apply_central_force(Vector2(0, bullet_2_force))
			# Spam cooldown
			can_shoot_bullet_2 = false
			await get_tree().create_timer(spam_delay_bullet_2).timeout
			can_shoot_bullet_2 = true
			player_state = PlayerState.NOTHING

func get_current_gravity() -> float: # A function to get the gravity 
	return jump_gravity if velocity.y < 0.0 else fall_gravity # Don't care about this..

func play_animation(animation : String) -> void: # A function to simply play an animation
	sprites.play(animation) # Play the animation

func slow_friction(delta) -> void: # Just apply a friction to player's movement
	velocity.x -= .02 * delta # I can't explain this line sorry..

func set_player_position(position) -> void: # Simply set player pos
	global_position = position

func set_respawn_position(position) -> void:  # Simply set the respawn position 
	respawn_position = position

func get_player_state() -> String:
	return player_state

func respawn_player(): # Simply respawn the player to the s set_respawn_position()'s location
	global_position = respawn_position

func reset_idle_cooldown(): # Reset the player's idle cooldown in one function
	_idle_cooldown = IDLE_COOLDOWN

# -- CAMERA EFFECTS --
func camera_shake(intensity : float = 1.5, duration : float  = 1.0, decay : float = 1.0) -> void: # Passerel between player.gd and camera.gd for shakes
	camera.start_shake(intensity, duration, decay) # Call camera.gd with args

func camera_rotation(angle : float) -> void: # Same for rotation
	camera.perform_rotation(angle) # Same

#endregion
