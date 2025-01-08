extends CharacterBody2D


const SPEED = 300.0
var player_name = "Player"


var orientation = 1
@export var bullet_scene: PackedScene

# Get the gravity from the project settings to be synced with RigidBody nodes.
 
@rpc("any_peer", "call_local")
func set_authority(id : int) -> void:
	set_multiplayer_authority(id)

func _physics_process(_delta):
#region Client processing
	if is_multiplayer_authority():
		GlobalCharacter.position = position
		var direction : Vector2 = Input.get_vector(
				"ui_left", "ui_right", 
				"ui_up", "ui_down")  
		if direction:
			velocity = direction.normalized() * SPEED
			if velocity.x > 0:
				orientation = 1
			elif velocity.x < 0: 
				orientation = 0
			GlobalCharacter.orientation = orientation
		else:
			velocity = velocity.move_toward(Vector2.ZERO, SPEED)
		
#endregion
			
#region Everyone processing
	if velocity.x == 0 and velocity.y == 0:
		$AnimatedSprite2D.play("idle")
	else:
		$AnimatedSprite2D.play("walk")
		
	$AnimatedSprite2D.flip_h = not orientation
	
	# Movement prediction
	move_and_slide()
#endregion

@rpc("any_peer", "call_local")
func teleport(new_position: Vector2) -> void:
	position = new_position
	

func set_player_name(new_name: String) -> void:
	player_name = new_name
	$Name.text = player_name
	
