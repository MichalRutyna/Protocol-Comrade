extends Control

signal player_list_changed

const MAX_PLAYERS = 2

var player_name: String
var native_id: int

var players := {}
var players_peers = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	Steam.steamInitEx(true, 3224070)
	get_tree().get_root().get_node("GlobalCharacter").process_mode = Node.PROCESS_MODE_DISABLED
	
	player_name = Steam.getPersonaName()
	
	Steam.lobby_created.connect(
		func(response: int, lobby_id: int):
			var success: bool = true
			match response:
				Steam.RESULT_OK:
					print("Created lobby %s" % lobby_id)
					native_id = lobby_id
				_:
					print("There was an error while creating a lobby: %s" % connect)
					success = false
					
			if success:
				$"menu/Lobby status".text += "Created lobby %s \n" % lobby_id
				#var set_joinable: bool = Steam.setLobbyJoinable(lobby_id, true)
				#print("The lobby has been set joinable: %s" % set_joinable)
				var peer = SteamMultiplayerPeer.new()
				peer.create_host(0, [])
				multiplayer.multiplayer_peer = peer
				register_peer.rpc(player_name)
				
	)
	
	Steam.lobby_joined.connect(
		func(lobby_id: int, _permissions: int, _locked: bool, response: int):
			var success: bool = true
			match response:
				Steam.CHAT_ROOM_ENTER_RESPONSE_SUCCESS:
					print("Connection to lobby %s successful" % lobby_id)
				_:
					print("There was an error while joining a lobby: %s" % response)
					success = false
			if success:
				native_id = lobby_id
				$"menu/Lobby status".text += "Joined lobby %s \n" % lobby_id
				get_lobby_players()
				var host = Steam.getLobbyOwner(lobby_id)
				if Steam.getSteamID() != host:
					var peer = SteamMultiplayerPeer.new()
					peer.create_client(host, 0, [])
					multiplayer.multiplayer_peer = peer
					
	)
	
	multiplayer.connected_to_server.connect(
		func():
			register_peer.rpc(player_name)
			request_registration.rpc()
	)
	
	Steam.lobby_chat_update.connect(
		func(_lobby_id: int, _changed_user_id: int, _making_user_change_id: int, _user_new_chat_state: int):
			# PLAYER JOINED
			
			if Steam.getNumLobbyMembers(native_id) == Steam.getLobbyMemberLimit(native_id):
				# full lobby
				if multiplayer.is_server():
					$menu/Start.disabled = false
	)
	
	Steam.join_requested.connect(
		func(lobby_id: int, _proxy_id: int):
			print("Trying to connect")
			Steam.joinLobby(lobby_id)
	)

	Steam.lobby_invite.connect(
		func(inviter: int, lobby_id: int, _game_id: int):
			print("User %s invited you to lobby %s" % inviter, lobby_id)
	)
	
@rpc("any_peer", "call_local")
func register_peer(peer_name):
	players_peers[multiplayer.get_remote_sender_id()] = peer_name
	print("Registered ", peer_name, " locally")
	get_lobby_players()
	
@rpc("any_peer", "call_remote")
func request_registration():
	print("Requesting registration from ", multiplayer.get_remote_sender_id())
	register_peer.rpc_id(multiplayer.get_remote_sender_id(), player_name)

func get_lobby_players():
	var these_members: int = Steam.getNumLobbyMembers(native_id)
	# Update the player list title
	$menu/PlayerList/Title.set_text("Player List (%s)" % these_members)
	# Get the data of these players from Steam
	for i in range(0, these_members):
		# Get the member's Steam ID and name
		var member_steam_id: int = Steam.getLobbyMemberByIndex(native_id, i)
		var member_steam_name: String = Steam.getFriendPersonaName(member_steam_id)
		# Add them to the steam id player list
		players[member_steam_id] = member_steam_name
	player_list_changed.emit()


func start_game():
	print("Start game called - this is the server")
	# server-only
	assert(multiplayer.is_server())
	# start game on all clients
	start_world.rpc()
	
	var world = get_tree().get_root().get_node("Game")
	var player_scene := load("res://src/game/objects - instances/player/player.tscn")
	
	for peer_id in players_peers:
		print("Spawning player of ", peer_id)
		#spawning synchronised by spawner
		var player = player_scene.instantiate()
		player.set_player_name(players_peers[peer_id])
		world.get_node("MultiplayerSpawner/Players").add_child(player, true)
		player.set_authority.rpc(peer_id)
		player.teleport.rpc(world.get_node("MultiplayerSpawner/Spawnpoint").position + Vector2(randi() % 200, randi() % 200))
		


@rpc("authority", "call_local")
func start_world():
	var world = DataImport.game_scene.instantiate()
	get_tree().get_root().get_node("GlobalCharacter").process_mode = Node.PROCESS_MODE_INHERIT
	get_tree().get_root().add_child(world)
	get_tree().get_root().get_node("start/menu").hide()
	
	if multiplayer.is_server():
		print("Game world detected a host client")
		world.get_node("EnemySpawner/SpawningButton").disabled = false 
		world.get_node("EnemySpawner/SpawningButton/Label").hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	Steam.run_callbacks()


func _on_close_pressed():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()    


func _on_begin_pressed():
	Steam.createLobby(Steam.LOBBY_TYPE_FRIENDS_ONLY, MAX_PLAYERS)
	print("Create lobby requested")

func _on_join_pressed():
	player_list_changed.emit()

