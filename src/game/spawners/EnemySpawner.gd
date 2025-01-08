extends MultiplayerSpawner

func _init():
	spawn_function = _spawn_enemy

func _spawn_enemy(data):
	if data.size() != 4 \
	 or typeof(data[0]) != TYPE_STRING \
	 or typeof(data[1]) != TYPE_VECTOR2 \
	 or typeof(data[2]) != TYPE_FLOAT \
	 or typeof(data[3]) != TYPE_VECTOR2:
	 #or typeof(data[4]) != TYPE_INT: 
		print("invalid type of attempted enemy spawn")
		return null
	var enemy = load(data[0]).instantiate()
	enemy.position = data[1]
	enemy.rotation = data[2]
	enemy.velocity = data[3]
	return enemy

