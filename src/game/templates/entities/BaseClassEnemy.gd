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

#region Movement
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
	
	#position += velocity * delta
	var closest_player = _find_closest_player()
	position = position.move_toward(closest_player.position, (speed + temp_speed) * delta)
	
func _find_closest_player() -> Node :
	"""
		Returns Node closest_player
	"""
	var players = get_tree().get_nodes_in_group("Players")
	if players.size() == 0:
		print("Enemy pathfinding found 0 players in Players group")
		return null
	var closest_player_index = 0
	var closest_player_distance = INF
	for index in range(players.size()):
		var distance = position.distance_squared_to(players[index].position)
		if distance < closest_player_distance:
			closest_player_index = index
			closest_player_distance = distance
	return players[closest_player_index]
	

#endregion

#region Collision

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body: Node2D):
	if body.is_in_group("Players"):
		print("Player hit")
	else:
		hide()
		$CollisionShape2D.set_deferred("disabled", true)
		SignalBus.enemyDied.emit()
	
	
#endregion
