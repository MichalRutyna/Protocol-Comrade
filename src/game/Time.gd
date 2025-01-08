extends Label

var seconds := 0
var minutes := 0

func _on_game_timer_timeout():
	seconds += 1
	if seconds >= 60:
		minutes += 1
		seconds -= 60
		SignalBus.minutePassed.emit()

	text = text.left(-5) + "%02d:%02d" % [minutes, seconds]
