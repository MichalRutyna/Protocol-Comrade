extends EffectScript

static func apply_to_item(item_to_apply_to: InstantiatedItem):
	item_to_apply_to.cooldown /= 2
	
 
