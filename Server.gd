extends Node2D

const DEFAULT_PORT = 8910
const MAX_PEERS    = 2

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnect")
#10.20.85.189
func start_server():
	var host  = NetworkedMultiplayerENet.new()
	
	var err = host.create_server(DEFAULT_PORT, MAX_PEERS)
	
	if (err!=OK):
		join_server()
		return
	get_tree().set_network_peer(host)
	
func join_server():
	var host  = NetworkedMultiplayerENet.new()
	
	host.create_client($txtIP.text, int($txtPort.text))
	get_tree().set_network_peer(host)

func _player_connected():
	print("TOTAL PLAYERS : " + str(get_tree().get_network_connected_peers().size()+1))

func _player_disconnected():
	print("Player disconnected")

func _connected_ok():
	print("User connected")
	print(get_tree().get_network_unique_id())
	var id = get_tree().get_network_unique_id()
	rpc_id(1,"salut",id)
	
func _connected_fail():
	pass

func _server_disconnect():
	print("Disconnected")

func _on_btnHost_pressed():
	start_server()

func _on_btnJoin_pressed():
	print("Join request")
	join_server()

func spawn_player(id):
	print(id)
	
	var player_scene = load("res://testplayer.tscn")
	var player = player_scene.instance()

	if id == get_tree().get_network_unique_id():
		player.set_network_master(id)
	
	get_parent().add_child(player)

remote func salut(id):
	print(id)
