extends Control

var tile_scene = DataImport.item_tile_scene


func _ready():
	var t
	var protocols = GlobalCharacter.protocols
	var items = GlobalCharacter.items
	
	for n in %ProtocolList.get_children():
		%ProtocolList.remove_child(n)
		n.queue_free()
	for n in %ItemList.get_children():
		%ItemList.remove_child(n)
		n.queue_free()
	
	for protocol in protocols:
		t = tile_scene.instantiate()
		%ProtocolList.add_child(t)
		t.set_icon(protocol.icon)
		t.set_protocol(protocol)
		
	for item in items:
		t = tile_scene.instantiate()
		%ItemList.add_child(t)
		t.set_icon(item.item.icon)
		t.set_item(item)


func _on_update_protocols_pressed():
	GlobalCharacter.update_protocols()
