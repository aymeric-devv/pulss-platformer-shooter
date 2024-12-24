class_name Player
extends CharacterBody2D

# ++ GLOBAL VARARIABLES ++

# ** NO CATEGORIES
@export var movements_lock: bool = false
var idle_cooldown : float = 10.0 
var respawn_position : Vector2 = global_position

# ** MOVEMENTS & SHOOT **
# -- Simple moves --
@export const GRAVITY : float = ProjectSettings.get_setting("physics/2d/default_gravity")
@export const SPEED : int = 80 # Speed
@export const IN_AIR_SPEED : int = 60 # In-air speed
var current_speed : int # Where the speed is stored
var last_moved_dir : int = 0 # Where the last direction where player wanted to go. Can be -1 or 1
# -- Jump --
@export const jump_buffer_time : int  = 20  # Time for jump buffer
@export const cayote_time : int = 15 # Coyote time
@export const jump_time_to_peak : float = 0.25 # Time to peak when player jumps
@export const jump_time_to_descent : float = 0.15 # Time to descent when player jumps
const jump_velocity : float = ((2.0 * jump_height)  / jump_time_to_peak) * -1.0 # Calculate the jump velocity
const jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0 # Calculate the jump gravity
const fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0 # Calculate the gravity when the player falls
var jump_buffer_counter : int = 0 # Count jumps for jump buffer
var cayote_counter : int = 0 # Count cayote time
# -- Bullets --
@export const bullet_1_force: float = 200 # Force to shoot bullet 1
@export const bullet_2_force: float = 0.1 # Same for bullet 2
@export const spam_delay_bullet_1: float = 0.5 # Small cooldown to prevent spam
@export const spam_delay_bullet_2: float = 0.15 # Same for bullet 2
#var BULLET_1 = preload("res://scenes/bullets/bullet_1.tscn") #Preload the bullet 1
#var BULLET_2 = preload("res://scenes/bullets/bullet_2.tscn") #Same for bullet 2
var can_shoot_bullet_1 : bool = true #A bool to know if player can shoot the bullet 1
var can_shoot_bullet_2 : bool = true #Same for bullet 2

# ** PLAYER'S INPUT **
var direction : int = 0 # Direction variable, can be -1, 0, 1
var want_to_jump : bool = false # If player want to jump
var want_to_dash : bool = false # Same for dash
var want_to_shoot_bullet_1 : bool = false # Same for bullet 1
var want_to_shoot_bullet_2 : bool = false # Same for bullet 2

# ** PLAYER'S STATES **
enum PlayerState { # Enum for player's state
    NOTHINGS,
    RUNNINGS,
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
@export var sprites : AnimatedSprite2D # Animated sprite of player
@export var camera : Camera2D # Player's camera
@export var bullet_1 : PackedScene # Set a variable for bullet 1
@export var bullet_2 : PackedScene # Same for bullet 2

# ++ FUNCTIONS ++

# ** CONTROL'S FUNCTIONS **
func _ready():
    pass

func _process(delta):
    pass

func _physics_process(delta):
    get_inputs() # Get player's input first
    move() # Just move the player according inputs, including movements, jump and dash
    

# ** USEFUL FUNCTIONS **
func get_inputs() -> void: # Get inputs and store them in input variables
    direction = Input.get_axis("move_left", "move_right") # Get the direction, -1, 0, 1
    want_to_jump = Input.is_action_just_pressed("jump") # Bool for jump
    want_to_dash = Input.is_action_just_pressed("dash") # Same dash
    want_to_shoot_bullet_1 = Input.is_action_just_pressed("bullet_1_shoot") # Same for bullet 1
    want_to_shoot_bullet_2 = Input.is_action_just_pressed("bullet_2_shoot") # Same for bullet 2

func move() -> void: # Get inputs from get_inputs() to perform the requested movement
    if is_on_floor(): # First check if player is on floor or not to do some things
        current_speed = SPEED # Set on floor speed
        cayote_counter = cayote_time # Start cayote timer
    else:
        current_speed = IN_AIR_SPEED # Set in-air speed
        velocity.y += get_current_gravity() * delta
        if cayote_counter > 0: #Counter for cayote time
			cayote_counter -= 1

    if direction: # If direction is -1 or 1, move !
        last_moved_dir = direction # Store the direction
        if is_on_floor(): 
            if player_state

    move_and_slide()

func get_current_gravity() -> float: # A function to get the gravity 
	return jump_gravity if velocity.y < 0.0 else fall_gravity # Don't care about this..