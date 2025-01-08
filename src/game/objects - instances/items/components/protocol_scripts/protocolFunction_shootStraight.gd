extends ProtocolScript

func start_processing(body: CharacterBody2D):
	pass

func process_bullet(delta, position, velocity, orientation) -> Array[Vector2]:
	position += Vector2(1000 * (2 * orientation - 1), 0) * delta
	return [position, velocity]
