extends Label3D

func display_damage(type, amount):
	if type == "heal":
		modulate = Color8(80, 240, 80)
		scale = Vector3(1, 1, 1)
		text = str("+", amount)
		yield(get_tree().create_timer(1), "timeout")
		for i in range(1, 5):
			scale += Vector3(0.25, 0.25, 0.25)/i
			yield(get_tree().create_timer(0.1), "timeout")
		for i in range(1, 5):
			scale /= i*4
			yield(get_tree().create_timer(0.1), "timeout")
	elif type == "damage":
		modulate = Color8(240, 20, 20, 255)
		scale = Vector3(1, 1, 1)
		text = str("-", amount)
		yield(get_tree().create_timer(1), "timeout")
		for i in range(1, 5):
			scale += Vector3(0.25, 0.25, 0.25)/i
			yield(get_tree().create_timer(0.1), "timeout")
		for i in range(1, 5):
			scale /= i*4
			yield(get_tree().create_timer(0.1), "timeout")
