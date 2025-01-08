class_name ProtocolScript
extends GDScript
#
#func start_processing(position: Vector2, velocity: Vector2)-> Array[Vector2]:
	#return [Vector2.ZERO, Vector2.ZERO]

func process_bullet(delta, position, velocity, orientation) -> Array[Vector2]:
	return [Vector2.ZERO, Vector2.ZERO]
