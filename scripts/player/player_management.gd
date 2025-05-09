extends KinematicBody

const GRAVITY = 150
const MAX_HEALTH = 150
const JUMP_FORCE = 50

export var speed = 15.0

var target_rotation = 0
var velocity = Vector3.ZERO
var health = MAX_HEALTH
var is_rotating = false



func rotate_player(rotate_direction):
	if rotate_direction == "left" && is_rotating == false:
		if is_equal_approx(3.141593, rotation.y) == true:
			rotation.y = -3.141593
		is_rotating = true
		target_rotation = rotation.y + 0.785398
		# Smoothly rotates the player along with the camera
		while rotation.y <= target_rotation - 0.1:
			print(rotation.y)
			rotation.y -= (rotation.y - target_rotation) / 2
			yield(get_tree().create_timer(0.05), "timeout")
			print("rotated successfully")
		# When close enough, snaps the rotation to the target rotation
		rotation.y = target_rotation
		print(rotation.y)
		is_rotating = false
		
	elif rotate_direction == "right" && is_rotating == false:
		if is_equal_approx(-3.141593, rotation.y) == true:
			rotation.y = 3.141593
		is_rotating = true
		target_rotation = rotation.y - 0.785398
		# Smoothly rotates the player along with the camera
		while rotation.y >= target_rotation + 0.1:
			rotation.y -= (rotation.y - target_rotation) / 2
			yield(get_tree().create_timer(0.05), "timeout")
			print("rotated successfully")
			print(rotation.y)
		# When close enough, snaps the rotation to the target rotation
		rotation.y = target_rotation
		print(rotation.y)
		is_rotating = false


func _physics_process(delta):
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = move_toward(0, direction.x, .95) * speed
		velocity.z = move_toward(0, direction.z, .95) * speed
	elif direction == Vector3.ZERO && range(-0.01, 0.01).has(velocity.x) == false && range(-0.01, 0.01).has(velocity.x) == false:
		velocity.x -= velocity.x / 4
		velocity.z -= velocity.z / 4
	elif direction == Vector3.ZERO:
		velocity.x = 0
		velocity.z = 0
	
	print(rotation.y)

	velocity.y -= delta * GRAVITY
	velocity = move_and_slide(velocity, Vector3.UP, true)


func _input(_event):
	if Input.is_action_just_pressed("camera_left"):
		rotate_player("left")
	elif Input.is_action_just_pressed("camera_right"):
		rotate_player("right")

	if Input.is_action_just_pressed("jump"):
		velocity.y += JUMP_FORCE
