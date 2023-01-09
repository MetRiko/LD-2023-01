extends Node2D

var clients_positions := []

var free_positions_idx := []

const client_tscn := preload("res://rooms/Client.tscn")

var clients = {
	0: null,
	1: null,
	2: null,
	3: null
}

func _ready():
	randomize()
	var i := 0
	for pos in $ClientsSpawnPositions.get_children():
		clients_positions.append(pos.global_position)
		free_positions_idx.append(i)
		i += 1
		
	for pos in clients_positions:
		yield(get_tree().create_timer(0.5), "timeout")
		create_client_in_random_free_position()

func remove_client(client):
	client.queue_free()

func create_client_in_random_free_position():
	if free_positions_idx.size() > 0:
		var rand_idx = free_positions_idx.pop_at(randi() % free_positions_idx.size())
		var client = client_tscn.instance()
		client.connect("jar_delivered", self, "_on_jar_delivered", [client])
		clients[rand_idx] = client
		$YSort.add_child(client)
		
		var target_pos = clients_positions[rand_idx]
		client.global_position = target_pos
		client.init()

func _on_jar_delivered(fill_factor : float, color_match_factor : float, client):
	# color_match_factor - How different is colo 0.0-1.0 (1.0 = identical)
	# fill_factor - How much jar is filled 0.0-1.0 (1.0 = full)
	remove_client(client)
	print('jar delivered: ', fill_factor, ' ', color_match_factor, ' ', client)
