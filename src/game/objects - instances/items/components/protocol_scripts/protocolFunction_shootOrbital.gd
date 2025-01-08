extends ProtocolScript

var progress = 0.0
# in seconds
var tan_velocity = 40
var radius = 9

func start_processing(body: CharacterBody2D):
	body.position.y -= 120

func process_bullet(delta, position: Vector2, velocity: Vector2, orientation) -> Array[Vector2]:
	progress += delta
	radius += delta / 3
	position.x += cos(progress * (tan_velocity / radius)) * radius * (2 * orientation - 1)
	position.y += sin(progress * (tan_velocity / radius)) * radius
	return [position, velocity]
