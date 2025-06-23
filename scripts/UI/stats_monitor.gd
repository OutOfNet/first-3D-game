extends Label

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("../../../KinematicBody")


func _process(_delta):
	text = str("Health : ", player.health, "/", player.MAX_HEALTH, " | FPS : ", Engine.get_frames_per_second(), " | heal praticles emitting : ", get_node("../../heal_indicators/12_heal").get("emitting"))
