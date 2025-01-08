class_name ItemTile
extends TextureRect

var item: InstantiatedItem
var protocol: Protocol

var create_items := false

var _inside := false
var _tooltip_shown := false

func _ready():
	mouse_entered.connect(func(): %HoverTimer.start())
	mouse_entered.connect(func(): %HoverTimer.timeout.connect(_show_tooltip))
	mouse_exited.connect(func(): disconnect_all(%HoverTimer.timeout))
	
	mouse_entered.connect(func(): _inside = true)
	mouse_exited.connect(func(): _inside = false)
	mouse_exited.connect(func(): _tooltip_shown = false)


func _get_drag_data(_at_position):
	var mydata;
	if item:
		if create_items:
			mydata = item.duplicate()
		else:
			mydata = item
	elif protocol:
		if create_items:
			mydata = protocol.duplicate()
		else:
			mydata = protocol
	else:
		pass
	set_drag_preview(make_preview())
	return mydata

func make_preview():
	var preview = TextureRect.new()
	preview.scale = Vector2(.3, .3)
	preview.set_rotation(.1)
	preview.texture = item.item.icon if item else protocol.icon
	preview.top_level = true
	preview.z_index = 50
	return preview

func set_item(it: InstantiatedItem):
	self.item = it
	texture = it.item.icon
	
func set_protocol(pr: Protocol):
	self.protocol = pr
	texture = pr.icon

func set_icon(txt: CompressedTexture2D):
	texture = txt
	
func disconnect_all(sig: Signal):
	for dict in sig.get_connections():
		sig.disconnect(dict.callable)


func _show_tooltip():
	if _tooltip_shown:
		return
	_tooltip_shown = true
	if item:
		_show_item_tooltip()
	elif protocol:
		_show_protocol_tooltip()
	else:
		pass
		

func _show_item_tooltip():
	var tooltip = DataImport.tooltip_stats_scene.instantiate()
	tooltip.show_item(item)
	add_child(tooltip)
	
	
func _show_protocol_tooltip():
	var tooltip = DataImport.tooltip_stats_scene.instantiate()
	tooltip.show_protocol(protocol)
	add_child(tooltip)
	tooltip.position = Vector2(0, 0)
