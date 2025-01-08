extends MultiplayerSpawner

func _init():
	spawn_function = _spawn_bullet


func _spawn_bullet(data):
	# scene, processing_script, position, orientation, from_player
	if data.size() != 5 \
	 or typeof(data[0]) != TYPE_STRING \
	 or typeof(data[1]) != TYPE_STRING \
	 or typeof(data[2]) != TYPE_VECTOR2 \
	 or typeof(data[3]) != TYPE_INT \
	 or typeof(data[4]) != TYPE_INT: 
		print("invalid type of attempted spawn")
		return null
	var bullet = load(data[0]).instantiate()
	bullet.processing_script =  load(data[1])
	bullet.position = data[2]
	bullet.orientation = data[3]
	bullet.from_player = data[4]
	return bullet
