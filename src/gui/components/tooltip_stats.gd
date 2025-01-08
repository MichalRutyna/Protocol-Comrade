extends Control

@export var stats_to_display := [
	["cooldown", "Cooldown:"],
	["damage", "Damage:"],
	["lifespan", "Lifespan:"],
	["speed", "Speed:"],
	["foo", "Bar:"],
]

var pos

func show_item(item: InstantiatedItem):
	var x
	var a
	%ItemIcon.texture = item.item.icon
	for n in %ItemStats.get_children():
		%ItemStats.remove_child(n)
		n.queue_free()
	for stat in stats_to_display:
		x = item.get(stat[0])
		if x != null:
			a = Label.new()
			a.text = stat[1]
			%ItemStats.add_child(a)
			a = Label.new()
			a.text = str(x)
			%ItemStats.add_child(a)
			
func show_protocol(prot: Protocol):
	%ItemIcon.texture = prot.icon
	for n in %ItemStats.get_children():
		%ItemStats.remove_child(n)
		n.queue_free()
	var a = Label.new()
	a.text = "This is a protocol"
	%ItemStats.add_child(a)
	
func _ready():	
	pos = get_viewport().get_mouse_position()

func _process(_delta):
	if (get_viewport().get_mouse_position().distance_to(pos)) > 40:
		queue_free()
