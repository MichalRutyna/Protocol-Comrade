extends Node


var eq_open := false
var cheats_open := false
var game_paused := false

var _pause_sources := 0

func _ready():
	
	SignalBus.pause_input_pressed.connect(_pause_input)
	SignalBus.eq_input_pressed.connect(_eq_input)
	SignalBus.cheat_input_pressed.connect(_cheat_input)
	SignalBus.overrideForcePause.connect(_override_force_pause)

func _eq_input():
	print("eq")
	if not eq_open:
		eq_open = true
		_pause_sources += 1
		if _pause_sources == 1:
			SignalBus.pauseGame.emit()
		_load_eq()
	else:
		_pause_sources -= 1
		if _pause_sources == 0:
			SignalBus.unpauseGame.emit()
		_unload_eq()
		eq_open = false
	
func _cheat_input():
	if not cheats_open:
		cheats_open = true
		_pause_sources += 1
		if _pause_sources == 1:
			SignalBus.pauseGame.emit()
		_load_cheats()
	else:
		_pause_sources -= 1
		if _pause_sources == 0:
			SignalBus.unpauseGame.emit()
		_unload_cheats()
		cheats_open = false
	
func _pause_input():
	if not game_paused:
		game_paused = true
		$"../InputManager".game_paused = true
		_pause_sources += 1
		if _pause_sources == 1:
			SignalBus.pauseGame.emit()
		_load_pause_menu()
	else:
		_pause_sources -= 1
		if _pause_sources == 0:
			SignalBus.unpauseGame.emit()
		_unload_pause_menu()
		$"../InputManager".game_paused = false
		game_paused = false
	

func _override_force_pause():
	if game_paused:
		return
	_pause_input()


func _load_eq():
	var eq = DataImport.equipment_scene.instantiate()
	add_child(eq)
	
func _unload_eq():
	$Equipment.queue_free()
	
func _load_cheats():
	var menu = DataImport.cheat_menu_scene.instantiate()
	add_child(menu)
	
func _unload_cheats():
	$CheatMenu.queue_free()
		
func _load_pause_menu():
	%Pause.visible = true
	%Pause.pressed.connect(_pause_input)
	
func _unload_pause_menu():
	%Pause.visible = false
