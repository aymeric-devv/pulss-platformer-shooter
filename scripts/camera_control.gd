class_name Camera
extends Camera2D

#region VARIABLES

# ++ GLOBAL VARIABLE ++

# ** SHAKE **
var noise = FastNoiseLite.new() # Noise for shake
@export var noise_frequency: float = 20.0 # Noise frequency
var shake_intensity: float = 0.0
var shake_decay: float = 1.0
var shake_time: float = 400.0
var noise_time: float = 0.0

# ** FOLLOW AN OBJECT ** 
@export var follow_object: bool = true # Enable camera follow an object by default
@export var object_to_follow: Node # What object to follow ? Can be player, ball, etc

# ** ZOOM ** 
# We will calculate the distance bewteen two object and dezoom proportionnaly with the distance
@export var zoom_effect: bool = false # Disable zoom by default
@export var zoom_object_1: Node # Zoom object one 
@export var zoom_object_2: Node # Zoom object two
@export var max_zoom: float = 2.5 # Max zoom value
@export var min_zoom: float = 1.5 # Mib zoom value

#endregion

#region FUNCTIONS

# ++ FUNCTIONS ++

# ** NODE'S FUNCTIONS **
func _ready() -> void:
	# Initialize noise for shake
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = noise_frequency

func _process(delta: float) -> void:
	calculate_shake(delta)
	

func _physics_process(delta: float) -> void:
	if zoom_effect: # Apply zoom effect
		perform_zoom(calculate_zoom(zoom_object_1.global_position.x, zoom_object_2.global_position.x)) # Do a zoom with the calculated value

# ** USER'S FUNCTIONS **
func calculate_shake(delta: float): # Calculate shake offset and time (Come from chatgpt sorry..)
	if shake_time > 0: 
		shake_time -= delta
		noise_time += delta
		var x_offset = noise.get_noise_2d(noise_time, 0) * shake_intensity
		var y_offset = noise.get_noise_2d(0, noise_time) * shake_intensity
		offset = Vector2(x_offset, y_offset)
		shake_intensity = max(shake_intensity - shake_decay * delta, 0.0)
	else:
		offset = Vector2.ZERO

func start_shake(intensity: float, duration: float, decay: float = 1.0) -> void: # Just start shake
	shake_intensity = intensity
	shake_time = duration
	shake_decay = decay

func calculate_zoom(object1: float, object2: float): # Calculate the zoom value
	return remap(abs(object1 - object2), 0, 700, max_zoom, min_zoom) #Return distance between the two objects remaped to be applied to zoom level
 
func perform_zoom(value: float):
	zoom = Vector2(value, value)

#endregion	
	
	
	
	
	
	
	
	
	
	
