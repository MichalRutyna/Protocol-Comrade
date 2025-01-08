extends Node

#FIXME change loads into some game logic
@export var protocols: Array[Protocol] = [load("res://src/game/objects - instances/items/protocols/protocol_shootOrbital.tres"), load("res://src/game/objects - instances/items/protocols/protocol_shootStraight.tres")]
@export var items: Array[InstantiatedItem] = [InstantiatedItem.create(load("res://src/game/objects - instances/items/Items/item_cooldownDuplicator.tres")), InstantiatedItem.create(load("res://src/game/objects - instances/items/Items/item_cooldownHalver.tres")), InstantiatedItem.create(load("res://src/game/objects - instances/items/Items/item_machineGun.tres"))]

var xp = 0
var lvl = 1

var bullet_spawner: MultiplayerSpawner
var position: Vector2
var orientation: int = 1
var unique_id: int = -1

func world_ready():
	bullet_spawner = get_node("/root/Game/BulletSpawner")
	update_protocols()
	SignalBus.protocolChanged.connect(update_protocols)
	SignalBus.enemyDied.connect(func(): xp_pickup(10))

func _ready():
	protocols[1].slots[0].slotted_item = items[0]
	protocols[1].slots[1].slotted_item = items[1]
	unique_id = multiplayer.get_unique_id()
	

func _physics_process(delta): 
	for prot in protocols:
		prot.process_protocol(delta)

func update_protocols():
	for prot in protocols:
		prot.update()
		
@rpc("any_peer", "call_local")
func spawn_bullet(data: Array) -> void:
	bullet_spawner.spawn(data)
	
@rpc("any_peer", "call_local")
func xp_pickup(amount: int) -> void:
	var bar = get_parent().get_node("Game/Hud/xp_bar")
	xp += amount
	while xp >= bar.max_value:
		xp -= bar.max_value
		bar.max_value += 1
		lvl_up()
	bar.value = xp
	
func lvl_up():
	lvl += 1
	get_parent().get_node("Game/Hud/level").text = "Leavel: " + str(lvl)
	
