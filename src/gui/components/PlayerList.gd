extends ItemList
	
func _on_player_list_changed():
	var player_list = get_parent().get_parent().players
	var peers = get_parent().get_parent().players_peers
	clear()
	print("Updated player list")
	for player in player_list:
		add_item(str(player))
		add_item(player_list[player])
		print(peers)
		var peer_id = peers.find_key(player_list[player])
		if peer_id:
			add_item(str(peer_id))
		else:
			add_item("")
