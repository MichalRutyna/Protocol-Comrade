extends Node

signal enemyDied

signal protocolChanged

signal minutePassed

# internal signals distributed to components
signal pauseGame
signal unpauseGame
signal overrideForcePause

# signals from input manager - possibly could be moved to input manager as it's not very strong coupling
signal pause_input_pressed
signal eq_input_pressed
signal cheat_input_pressed
