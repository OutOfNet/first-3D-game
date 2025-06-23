extends CPUParticles2D

func display_damage():
	if emitting == true:
		yield(get_tree().create_timer(.05), "timeout")
		emitting = true
		print("Delayed heal particle emission.")
	else:
		pass
	emitting = true
	yield(get_tree().create_timer(.01), "timeout")
	emitting = false
	print("Emitted heal particle.")
