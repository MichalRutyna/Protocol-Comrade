extends CharacterBody2D

var speed = 550
var orientation = 0 
var from_player = -1
var processing_script: GDScript

# Called when the node enters the scene tree for the first time.
func _ready():
	processing_script = processing_script.new()
	$Sprite2D.flip_h = orientation
	processing_script.start_processing(self)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var result = processing_script.process_bullet(delta, position, velocity, orientation)
	position = result[0]
	velocity = result[1]

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
