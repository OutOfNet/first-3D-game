extends KinematicBody

const GRAVITY = 150
const MAX_HEALTH = 150
const JUMP_FORCE = 50

export var speed = 15.0

var velocity = Vector3.ZERO
var health = MAX_HEALTH

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = move_toward(0, direction.x, .95) * speed
		velocity.z = move_toward(0, direction.z, .95) * speed
	if direction.x == 0 && direction.z == 0:
		if (velocity.x >= -0.01 && velocity.x <= 0.01) && (velocity.z >= -0.01 && velocity.z <= 0.01):
			velocity.x = 0
			velocity.z = 0
		else:
			velocity.x -= velocity.x / 4
			velocity.z -= velocity.z / 4
	
	velocity.y -= delta * GRAVITY
	
	velocity = move_and_slide(velocity, Vector3.UP, true)
	
	print(velocity.z)
	

func _input(_event):
	if Input.is_action_just_pressed("jump"):
		velocity.y += JUMP_FORCE
	if Input.is_action_pressed("camera_left"):
		rotation.y += lerp_angle(rotation.y, rotation.y+1, 0)
