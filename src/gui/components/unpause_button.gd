extends Button

func _on_pressed():
	SignalBus.unpauseGame.emit()
