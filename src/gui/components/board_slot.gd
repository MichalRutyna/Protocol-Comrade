class_name BoardSlot
extends ItemTile

var slot: InstantiatedSlot

func _ready():
	super._ready()
	set_empty()
	SignalBus.protocolChanged.connect(reload)

func set_empty():
	item = null
	protocol = null
	if slot:
		slot.slotted_item = null
		SignalBus.protocolChanged.emit()
	
func _input(event):
	if _inside and event.is_action_pressed("empty_slot"):
		set_empty()

func _can_drop_data(_position, data):
	if data is InstantiatedItem:
		return true
	
func _drop_data(_position, data):
	var it: InstantiatedItem = data
	# check if slotted somewhere else
	for prot in GlobalCharacter.protocols:
		for slot in prot.slots:
			if slot.slotted_item:
				if slot.slotted_item.get_instance_id() == data.get_instance_id():
					slot.slotted_item = null
	set_item(it)
	
func set_protocol(pr: Protocol):
	super.set_protocol(pr)
	SignalBus.protocolChanged.emit()
	
func set_item(it: InstantiatedItem):
	super.set_item(it)
	slot.slotted_item = it
	SignalBus.protocolChanged.emit()
	
func reload():
	if slot.slotted_item:
		texture = slot.slotted_item.item.icon
		item = slot.slotted_item
	else:
		texture = slot.slot.slot_icon
	
func set_slot(sl: InstantiatedSlot):
	slot = sl
	reload()
	
