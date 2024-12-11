#Come from chatgpt
extends Camera2D

# Pour FastNoiseLite
@export var noise_frequency: float = 20.0
var noise = FastNoiseLite.new()

# Variables pour le tremblement
var shake_intensity: float = 0.0
var shake_decay: float = 1.0
var shake_time: float = 400.0
var noise_time: float = 0.0

# Initialisation
func _ready() -> void:
	# Configurer le bruit
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = noise_frequency

# Appelée à chaque frame
func _process(delta: float) -> void:
	if shake_time > 0:
		shake_time -= delta
		noise_time += delta
		
		# Calculer le décalage avec FastNoiseLite
		var x_offset = noise.get_noise_2d(noise_time, 0) * shake_intensity
		var y_offset = noise.get_noise_2d(0, noise_time) * shake_intensity
		
		# Appliquer le tremblement
		offset = Vector2(x_offset, y_offset)
		
		# Réduire l'intensité avec le temps
		shake_intensity = max(shake_intensity - shake_decay * delta, 0.0)
	else:
		offset = Vector2.ZERO

# Démarrer un tremblement
func start_shake(intensity: float, duration: float, decay: float = 1.0) -> void:
	print("shake")
	shake_intensity = intensity
	shake_time = duration
	shake_decay = decay
