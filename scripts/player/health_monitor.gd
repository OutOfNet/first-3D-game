extends Label3D

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("../../../KinematicBody")


func _process(_delta):
	text = str("Max Health : ", player.MAX_HEALTH, " | Health : ", player.health, " | FPS : ", Engine.get_frames_per_second(), " | Frame time : ", 1/Engine.get_frames_per_second(), "ms")
