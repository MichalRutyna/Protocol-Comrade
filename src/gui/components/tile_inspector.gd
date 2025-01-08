extends Control


func _can_drop_data(_position, data):
	if data is Protocol:
		return true
	
func _drop_data(_position, data):
	var prot: Protocol = data
	%ProtocolBoard.texture = data.board_texture
	for c in $Slots.get_children():
		c.queue_free()
	for inst_slot in prot.slots:
		var s = DataImport.board_slot_scene.instantiate()
		$Slots.add_child(s)
		s.set_slot(inst_slot)
		s.position = inst_slot.position
