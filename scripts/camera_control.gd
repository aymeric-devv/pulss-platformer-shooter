#Shake snippet come from chatgpt...
extends Camera2D

@export var noise_frequency: float = 20.0
@export var follow_object: bool = true
@export var object_to_follow: Node
@export var zoom_effect: bool = false
@export var zoom_player: Node
@export var zoom_object: Node
@export var max_zoom: float = 2.5
@export var min_zoom: float = 1.5

var noise = FastNoiseLite.new() #Noise for shake

var shake_intensity: float = 0.0
var shake_decay: float = 1.0
var shake_time: float = 400.0
var noise_time: float = 0.0
var prev_zoom_value = 0.0 #Store prev zoom value to don't apply zoom if value has no difference with the old value

func _ready() -> void:
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = noise_frequency

func _process(delta: float) -> void:
	var direction = Input.get_axis("move_left", "move_right") #Get the direction for camera rotation independament of player.gd
	if direction:
		global_rotation = direction * 0.015
	else:
		global_rotation = 0
		
	if shake_time > 0: 
		shake_time -= delta
		noise_time += delta
		var x_offset = noise.get_noise_2d(noise_time, 0) * shake_intensity
		var y_offset = noise.get_noise_2d(0, noise_time) * shake_intensity
		offset = Vector2(x_offset, y_offset)
		shake_intensity = max(shake_intensity - shake_decay * delta, 0.0)
	else:
		offset = Vector2.ZERO

func _physics_process(delta: float) -> void:
	
	if follow_object: #Follow an object, like player for example
		global_position = object_to_follow.global_position
	
	if zoom_effect: #Apply zoom effect
		var zoom_value = calculate_zoom(zoom_player.global_position.x, zoom_object.global_position.x) #Calculate first
		zoom = Vector2(zoom_value, zoom_value)
		prev_zoom_value = zoom_value


func start_shake(intensity: float, duration: float, decay: float = 1.0) -> void: #Just shake
	shake_intensity = intensity
	shake_time = duration
	shake_decay = decay

func calculate_zoom(object1: float, object2: float):
	return remap(abs(object1 - object2), 0, 700, max_zoom, min_zoom) #Return distance between the two objects remaped to be applied to zoom level
	
	
	
	
	
	
	
	
	
	
	
