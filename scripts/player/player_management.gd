extends KinematicBody

const GRAVITY = 150
const MAX_HEALTH = 150
const CAMERA_NEUTRAL_ROTATION = -0.35
const INT_MAX = 2147483647

export var speed = 15.0

var target_rotation = Vector2.ZERO
var velocity = Vector3.ZERO
var health = MAX_HEALTH
var is_rotating = false
var is_attacking = false
var camera
var cooldowns_left = {
	"attack_1": 2.0,
	"attack_2": 4.0,
	"attack_3": 6.0,
	"attack_4": 10.0
}

var attack_cooldowns = {
	"attack_1": false,
	"attack_2": false,
	"attack_3": false,
	"attack_4": false
}

var camera_angles = [0, 0.785398, 1.570796, 2.356194, 3.141592, -3.141593, -2.356195, -1.570797, -0.785399, -0.000001]



func _ready():
	camera = get_node("Camera")


func find_closest(value, array) -> float:
	
	var best_match = null
	var least_diff = INT_MAX
	
	for number in array:
		
		var diff = abs(value - number)
		
		if(diff < least_diff):
			best_match = number
			least_diff = diff
			
	return best_match


func rotate_camera(rotate_direction):
	if rotate_direction == "left" && is_rotating == false:
		if is_equal_approx(3.141593, rotation.y) == true:
			rotation.y = -3.141593
		is_rotating = true
		target_rotation.x = rotation.y + 0.785398
		# Smoothly rotates the player along with the camera
		while rotation.y <= target_rotation.x - 0.02:
			rotation.y -= (rotation.y - target_rotation.x) / 4
			yield(get_tree().create_timer(0.0125), "timeout")
		# When close enough, snaps the rotation to the target rotation
		rotation.y = target_rotation.x
		is_rotating = false
		
	elif rotate_direction == "right" && is_rotating == false:
		if is_equal_approx(-3.141593, rotation.y) == true:
			rotation.y = 3.141593
		is_rotating = true
		target_rotation.x = rotation.y - 0.785398
		# Smoothly rotates the player along with the camera
		while rotation.y >= target_rotation.x + 0.02:
			rotation.y -= (rotation.y - target_rotation.x) / 4
			yield(get_tree().create_timer(0.0125), "timeout")
		# When close enough, snaps the rotation to the target rotation
		rotation.y = target_rotation.x
		is_rotating = false


func _physics_process(delta):
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = move_toward(0, direction.x, .95) * speed
		velocity.z = move_toward(0, direction.z, .95) * speed
		if is_attacking == false:
			get_node("AnimationPlayer").play("walk")
	elif direction == Vector3.ZERO && range(-0.01, 0.01).has(velocity.x) == false && range(-0.01, 0.01).has(velocity.x) == false:
		velocity.x -= velocity.x / 4
		velocity.z -= velocity.z / 4
		if is_attacking == false:
			get_node("AnimationPlayer").play("idle")
	elif direction == Vector3.ZERO:
		velocity.x = 0
		velocity.z = 0
	
	if camera_angles.has(rotation.y) == false && is_rotating == false:
		rotation.y = find_closest(rotation.y, camera_angles)

	velocity.y -= delta * GRAVITY
	velocity = move_and_slide(velocity, Vector3.UP, true)


func _input(_event):
	if Input.is_action_just_pressed("camera_left"):
		if is_rotating == false:
			yield(get_tree().create_timer(0.02), "timeout")
			rotate_camera("left")
	elif Input.is_action_just_pressed("camera_right"):
		if is_rotating == false:
			yield(get_tree().create_timer(0.02), "timeout")
			rotate_camera("right")
	elif Input.is_action_just_pressed("camera_up"):
		if is_rotating == false:
			is_rotating = true
			yield(get_tree().create_timer(0.02), "timeout")
			target_rotation.y = camera.rotation.x + 0.5
			# Smoothly rotates the camera upwards.
			while camera.rotation.x <= target_rotation.y - 0.025:
				camera.rotation.x -= (camera.rotation.x - target_rotation.y) / 4
				yield(get_tree().create_timer(0.0125), "timeout")
			camera.rotation.x = target_rotation.y
	elif Input.is_action_just_pressed("camera_down"):
		if is_rotating == false:
			is_rotating = true
			yield(get_tree().create_timer(0.02), "timeout")
			target_rotation.y = camera.rotation.x - 0.5
			# Smoothly rotates the camera downwards.
			while camera.rotation.x >= target_rotation.y + 0.025:
				camera.rotation.x -= (camera.rotation.x - target_rotation.y) / 4
				yield(get_tree().create_timer(0.0125), "timeout")
			camera.rotation.x = target_rotation.y
	if Input.is_action_just_released("camera_down") or Input.is_action_just_released("camera_up"):
		target_rotation.y = CAMERA_NEUTRAL_ROTATION
		yield(get_tree().create_timer(0.02), "timeout")
		# Smoothly rotates the camera towards the neutral rotation.
		while camera.rotation.x >= target_rotation.y + 0.025 or camera.rotation.x <= target_rotation.y - 0.025:
			camera.rotation.x -= (camera.rotation.x - target_rotation.y) / 4
			yield(get_tree().create_timer(0.0125), "timeout")
		camera.rotation.x = target_rotation.y
		is_rotating = false
	
	if Input.is_action_just_pressed("attack_1") && is_attacking == false && attack_cooldowns.attack_1 == false:
		is_attacking = true
		get_node("AnimationPlayer").play("slap")
		attack_cooldowns.attack_1 = true
		yield(get_tree().create_timer(1), "timeout")
		is_attacking = false
		for _i in range(0, 20):
			yield(get_tree().create_timer(0.1), "timeout")
			print("Attack 1 cooldown : ", cooldowns_left.attack_1)
			cooldowns_left.attack_1 -= 0.1
		cooldowns_left.attack_1 = 2
		attack_cooldowns.attack_1 = false
