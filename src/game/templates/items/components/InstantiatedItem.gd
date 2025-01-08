class_name InstantiatedItem
extends Resource

@export var item: Item

var cooldown: float = 1.0
var damage: float = 1.0
var lifespan: float = 1.0
var speed: float = 1.0

var current_cooldown_passed: float = 0.0

static func create(item: Item):
	var instance = InstantiatedItem.new()
	instance.item = item
	return instance

func reset_stats():
	for property in item.get_property_list():
		if property["name"].left(5) == "base_":
			set(property["name"].right(-5), item.get(property["name"])) 

func process_item(delta, protocol_script: String):
	current_cooldown_passed += delta
	while current_cooldown_passed > cooldown:
		current_cooldown_passed -= cooldown
		GlobalCharacter.spawn_bullet.rpc_id(1,
			[item.spawn_scene.resource_path,
			protocol_script,
			GlobalCharacter.position, 
			GlobalCharacter.orientation, 
			GlobalCharacter.unique_id])
