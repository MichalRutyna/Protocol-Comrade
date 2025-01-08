extends Node

var waves: Dictionary
var wave := 0

var mobs_data: Array
var all_enemies: Array
var max_wave = 3

var _mob_choice: Array

func _ready():
	_read_wave_data()
	SignalBus.minutePassed.connect(func(): _on_wave_change(wave + 1))
	_on_wave_change(1)
	
	
func _on_wave_change(new_wave):
	if new_wave > max_wave:
		return
	wave = new_wave
	var new_wave_data = waves[str(wave)]
	%EnemySpawnTimer.wait_time = 1 / new_wave_data["spawnsPerSecond"]
	mobs_data = new_wave_data["mobs"]
	for mob in mobs_data:
		var name = mob["name"]
		var amount = int(mob["amount"])
		for i in range(amount):
			_mob_choice.append(name)
	print("Wave ", new_wave, " started, enemy list: ", mobs_data)
		

func _on_enemy_spawn_timer_timeout():
	if multiplayer.is_server():
		
		var mob = _mob_choice[randi_range(0, len(_mob_choice) - 1)]
		var spawn_data = [DataImport.enemies[mob].resource_path, 0, 0, 0]
		if !spawn_data[0]:
			print("Wave contains an not existing mob")
			return
		
		# Choose a random location on Path2D.
		var mob_spawn_location = %EnemySpawnLocation
		mob_spawn_location.progress_ratio = randf()
		spawn_data[1] = (mob_spawn_location.position)
		
		var direction = mob_spawn_location.rotation + PI / 2
		direction += randf_range(-PI / 4, PI / 4)
		spawn_data[2] = direction
		spawn_data[3] = Vector2(GlobalCharacter.position - spawn_data[1])
	
		%EnemySpawner.spawn(spawn_data)


func _on_spawning_button_toggled(toggled_on):
	if toggled_on:
		%EnemySpawnTimer.start()
	else:
		%EnemySpawnTimer.stop()

	
func _read_wave_data():
	var file = FileAccess.open("res://data/waves.json", FileAccess.READ)
	waves = JSON.parse_string(file.get_as_text())
