extends Node

var game_paused := false

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_PAUSE:
			SignalBus.pause_input_pressed.emit()
		if game_paused:
			return
			
		if Input.is_action_just_pressed("open_eq"):
			SignalBus.eq_input_pressed.emit()
		elif Input.is_action_just_pressed("open_cheats"):
			SignalBus.cheat_input_pressed.emit()

