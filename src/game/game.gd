extends Node2D


var score := 0:
	set(value):
		score = value
		$Score.text = "Enemies killed: " + str(score)

var wave := 0



func _ready():
	#%TestPlayer.queue_free()
	
	SignalBus.pauseGame.connect(_pause_game)
	SignalBus.unpauseGame.connect(_unpause_game)
	
	SignalBus.enemyDied.connect(_on_enemy_died) 
	
	SignalBus.overrideForcePause.emit()
	GlobalCharacter.world_ready()
	

func _pause_game():
	get_tree().paused = true
	
func _unpause_game():
	get_tree().paused = false

func _on_enemy_died():
	print(score)
	score += 1
