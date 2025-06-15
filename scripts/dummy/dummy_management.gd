extends KinematicBody

const MAX_HEALTH = 5000
const INVINCIBILITY_TIME = 1.5

var is_invincible = false
var health = MAX_HEALTH

func take_damage(amount):
	if is_invincible == true:
		pass
	elif amount >= health:
		health = 0
		is_invincible = true
		yield(get_tree().create_timer(INVINCIBILITY_TIME), "timeout")
		is_invincible = false
	else:
		health -= amount
		is_invincible = true
		yield(get_tree().create_timer(INVINCIBILITY_TIME), "timeout")
		is_invincible = false
