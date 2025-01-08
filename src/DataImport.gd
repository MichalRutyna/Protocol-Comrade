extends Node

var protocols: Array[Protocol]

var items: Array[Item]

var enemies: Dictionary

var tooltip_stats_scene: PackedScene
var board_slot_scene: PackedScene
var cheat_menu_scene: PackedScene
var equipment_scene: PackedScene
var item_tile_scene: PackedScene
var game_scene: PackedScene

func _ready():
	# TODO Resource group loading
	tooltip_stats_scene = preload("res://src/gui/components/tooltip_stats.tscn")
	board_slot_scene = preload("res://src/gui/components/board_slot.tscn")
	item_tile_scene = preload("res://src/gui/components/item_tile.tscn")
	cheat_menu_scene = preload("res://src/gui/scenes/cheat_menu.tscn")
	equipment_scene = preload("res://src/gui/scenes/equipment.tscn")
	game_scene = preload("res://src/game/game.tscn")
	
	# Protocols
	var p_paths = [
		"res://src/game/objects - instances/items/protocols/protocol_shootOrbital.tres",
		"res://src/game/objects - instances/items/protocols/protocol_shootStraight.tres"
	]
		
	# Items
	var it_paths = [
		"res://src/game/objects - instances/items/Items/item_cooldownDuplicator.tres",
		"res://src/game/objects - instances/items/Items/item_cooldownHalver.tres",
		"res://src/game/objects - instances/items/Items/item_flameThrower.tres",
		"res://src/game/objects - instances/items/Items/item_machineGun.tres",
		"res://src/game/objects - instances/items/Items/item_waterBaller.tres",
		
	]
	
	#Enemies
	var enemy_paths = [
		"res://src/game/objects - instances/entities/enemies/base_enemy_1.tscn",
		"res://src/game/objects - instances/entities/enemies/base_enemy_2.tscn",
		"res://src/game/objects - instances/entities/enemies/shooting_enemy_1.tscn",
		
	]

	for p in p_paths:
		protocols.append(load(p))
		
	for it in it_paths:
		items.append(load(it))
		
	for enemy in enemy_paths:
		var name = enemy.rsplit("/", true, 1)[1].left(-5)
		enemies[name] = load(enemy)
		
