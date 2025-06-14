extends Label3D

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent()


func _process(_delta):
	text = str("Max Health : ", player.MAX_HEALTH, " | Health : ", player.health)
