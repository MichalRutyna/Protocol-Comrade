class_name Enemy
extends Area2D

@export var enemy_name = ""

@export var speed = 100
var temp_speed = 0
# 0 left 1 right
var orientation = 1
var velocity = Vector2(Vector2.ZERO)

func _ready():
	pass


func _physics_process(delta):
	if velocity.x > 0:
		orientation = 1
	elif velocity.x < 0:
		orientation = 0
		
	var sprite = $Sprite2D
	sprite.flip_h = orientation

	if velocity.length() > 0:
		velocity = velocity.normalized() * (speed + temp_speed)
		temp_speed = 0
	
	position += velocity * delta
	

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	hide()
	$CollisionShape2D.set_deferred("disabled", true)
	SignalBus.enemyDied.emit()
