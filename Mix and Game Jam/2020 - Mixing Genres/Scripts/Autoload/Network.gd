extends Node

#const DEFAULT_IP = '127.0.0.1'
var DEFAULT_IP = "81.169.173.40"
const DEFAULT_PORT = 31400
const MAX_PLAYERS = 16
var server_data = {
	"name": "Server",
	"position": Vector2(0,0),
	"control": "server",
	"character": 1,
	"is_master": true
	}

var server_is_player = true

#signal player_disconnected
#signal server_disconnected

func _ready():
	get_tree().connect('network_peer_disconnected', self, '_on_player_disconnected')
	get_tree().connect('network_peer_connected', self, '_on_player_connected')
	
	if "--server" in OS.get_cmdline_args():
		server_is_player = true
		create_server("")

#func _process(delta):
#	check_disconnects()

func create_server(player_nickname):
	print("Create server")
	Global.player_data = {}
	Global.add_player(1,server_data)
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(DEFAULT_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(peer)
	print(String(IP.get_local_addresses()))
	
	get_tree().set_refuse_new_network_connections(true)

func connect_to_server(ip = DEFAULT_IP):
	Global.player_data = {}
	get_tree().connect('connected_to_server', self, '_connected_to_server')
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(DEFAULT_IP, DEFAULT_PORT)
	get_tree().set_network_peer(peer)

func _connected_to_server():
	var local_player_id = get_tree().get_network_unique_id()
	Global.add_player(local_player_id,Global.local_data)
	rpc('_send_player_info', local_player_id, Global.local_data)

func _on_player_disconnected(id):
	Global.player_data.erase(id)
	print("Player left: " + str(id))

func _on_player_connected(connected_player_id):
	var local_player_id = get_tree().get_network_unique_id()
	if not(get_tree().is_network_server()):
		rpc_id(1, '_request_player_info', local_player_id, connected_player_id)
		print("Player joined: " + str(connected_player_id))

remote func _request_player_info(request_from_id, player_id):
	if get_tree().is_network_server():
		rpc_id(request_from_id, '_send_player_info', player_id, Global.player_data[player_id])

# A function to be used if needed. The purpose is to request all players in the current session.
remote func _request_players(request_from_id):
	if get_tree().is_network_server():
		for peer_id in Global.player_data:
			if( peer_id != request_from_id):
				rpc_id(request_from_id, '_send_player_info', peer_id, Global.player_data[peer_id])

remote func _send_player_info(id, info):
	Global.add_player(id,info)
	Global.init_player(id,false)

func check_disconnects():
	if get_tree().network_peer != null:
		if get_tree().is_network_server():
			for p in Global.player_data:
				if p != 1 && Array(get_tree().get_network_connected_peers()).has(p):
					Global.player_data.erase(p)

func update_position(id, position):
	if get_tree().network_peer != null:
		if Global.player_data.has(id):
			Global.player_data[id].position = position

func update_name(id,nickname):
	if get_tree().network_peer != null:
		if Global.player_data.has(id):
			Global.player_data[id]["name"] = nickname

func update_skin(id,skin):
	if get_tree().network_peer != null:
		if Global.player_data.has(id):
			Global.player_data[id]["character"] = skin
