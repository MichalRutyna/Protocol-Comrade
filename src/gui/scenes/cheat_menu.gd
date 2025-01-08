extends Control

func _ready():
	get_tree().paused = true
	
	var tile_scene = DataImport.item_tile_scene
	
	var pGrid = %ProtocolGrid
	for p in DataImport.protocols:
		var t = tile_scene.instantiate()
		t.set_protocol(p)
		t.custom_minimum_size = Vector2(0, 58)
		t.create_items = true
		pGrid.add_child(t)
		
	
	var itGrid = %ItemGrid
	for it in DataImport.items:
		var t = tile_scene.instantiate()
		t.set_item(InstantiatedItem.create(it))
		t.custom_minimum_size = Vector2(0, 58)
		t.create_items = true
		itGrid.add_child(t)
	
