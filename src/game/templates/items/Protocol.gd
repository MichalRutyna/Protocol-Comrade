class_name Protocol
extends Resource

## A unique identificator
@export var id: String = "basic_protocol"

## In-game name to be displayed
@export var name: String = "Basic protocol"

## Icon texture to be displayed in inventory
@export var icon: CompressedTexture2D

## Board texture used to socket slots
@export var board_texture: CompressedTexture2D


@export_category("Gameplay")
## List containing slots defined specificaly for this Protocol
@export var slots: Array[InstantiatedSlot]

## Script to be called during item effects
@export var effect_scripts: Array[GDScript]

## The script containing processing functions
@export var processing_script: GDScript

var scenes_for_updates: Array[PackedScene]

func update():
	var t
				
	# reset all stats
	for slot in slots:
		t = slot.slotted_item
		if t != null:
			
			print("reseting ", t, " (", t.item.name, ")", " from ", name)
			t.reset_stats()
			
	# apply effects from all items
	for slot in slots:
		if slot.slotted_item != null:
			for script in slot.slotted_item.item.effect_scripts:
				for s in slots:
					if s.slotted_item != null:
						print("applying ", slot.slotted_item, " (", slot.slotted_item.item.name, ")", " to ", s.slotted_item, " (", s.slotted_item.item.name, ")")
						script.apply_to_item(s.slotted_item)
					
	# apply own effects
	for scr in effect_scripts:
		for s in slots:
			if s.slotted_item != null:
				print("applying ", name, " script to ", s.slotted_item.name)
				scr.apply_to_item(s.slotted_item)
					
	print("End of processing protocol ", name)
func process_protocol(delta):
	if processing_script != null:
		# call processing of all items
		for slot in slots:
			if slot.slotted_item:
				if slot.slotted_item.item.spawn_scene:
					slot.slotted_item.process_item(delta, processing_script.resource_path)
