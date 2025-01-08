class_name Item
extends Resource

@export var icon: CompressedTexture2D

@export var id: String = "item"
@export var name: String = "Item"

@export var tags: Array[ItemTag]

## Optional scene used for spawning bullets
@export var spawn_scene: PackedScene

## Called only on refresh
@export var effect_scripts: Array[GDScript]
## Called on every frame with delta argument
@export var process_scripts: Array[GDScript]

## All stats shoud have a base_ counterpart,
## their value will be then properly reset during effect calculations
@export_category("Statistics")
@export var base_cooldown: float = 1.0
@export var base_damage: float = 1.0
@export var base_lifespan: float = 1.0
@export var base_speed: float = 1.0
