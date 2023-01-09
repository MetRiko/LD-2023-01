extends Node2D

var clients_positions := []

var free_positions_idx := []

const client_tscn := preload("res://rooms/Client.tscn")

const egg_tscn := preload("res://pickable/SlimeEgg.tscn")

var clients = {
	0: null,
	1: null,
	2: null,
	3: null
}

var day := 0
var clients_left := 5

func _ready():
	randomize()
	var i := 0
	for pos in $ClientsSpawnPositions.get_children():
		clients_positions.append(pos.global_position)
		free_positions_idx.append(i)
		i += 1
	
	$Fade.visible = true
	$Fade.color = Color.black
	start_new_day()
	$Score.modulate.a = 0

func remove_client(client):
	for i in clients:
		if clients[i] == client:
			clients[i] == null
			free_positions_idx.append(i)
	var tween = get_tree().create_tween()
	tween.tween_property(client, "modulate:a", 0.0, 0.8)
	yield(tween, "finished")
	client.queue_free()
	create_client_in_random_free_position()
	if free_positions_idx.size() == 4:
		start_new_day()

func start_new_day():
	var tween := get_tree().create_tween()
	tween.tween_property($Fade, "modulate:a", 1.0, 1.5)
	yield(tween, "finished")
	
	get_tree().call_group("Slime", "grow")
	
	var tween2 := get_tree().create_tween()
	tween2.tween_property($Fade, "modulate:a", 0.0, 1.5)
	yield(tween2, "finished")
	# fade in
	# fade out
	day += 1
	$Day.text = "Day " + str(day)
	clients_left = 1 + day
	for i in range(min(clients_left, 4)):
		create_client_in_random_free_position()
		yield(get_tree().create_timer(0.5), "timeout")

func create_client_in_random_free_position():
	if free_positions_idx.size() > 0 and clients_left > 0:
		clients_left -= 1
		var rand_idx = free_positions_idx.pop_at(randi() % free_positions_idx.size())
		var client = client_tscn.instance()
		client.connect("jar_delivered", self, "_on_jar_delivered", [client])
		clients[rand_idx] = client
		$YSort.add_child(client)
		
		var target_pos = clients_positions[rand_idx]
		client.global_position = target_pos + Vector2.UP * 300.0

		client.move_to_position(target_pos)
#		new_client.init()

func _on_jar_delivered(color : Color, fill_factor : float, color_match_factor : float, client):
	$Score.modulate = color
	$Score.modulate.a = 0
	$Score.text = "COLOR MATCH: " + str(ceil(color_match_factor * 100.0)) + "%\nFILLED IN: " + str(ceil(fill_factor * 100.0)) + "%"
	if color_match_factor >= 0.8:
		$Score.text += "\nPERFECT MATCH!!!"
		if fill_factor >= 0.95:
			$Score.text += "\nNEW JAM MONSTER EGG FOR PERFECT DELIVERY!!!"
			var egg := egg_tscn.instance()
			Game.add_slime(egg)
			egg.global_position = client.global_position + Vector2.DOWN * 12.0
			
	var tween = get_tree().create_tween()
	tween.tween_property($Score, "modulate:a", 1.0, 0.3)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	yield(tween, "finished")
	var tween2 = get_tree().create_tween()
	tween2.tween_property($Score, "modulate:a", 0.0, 5.0)
	tween2.set_trans(Tween.TRANS_SINE)
#	yield(tween2, "finished")
	
	
	# color_match_factor - How different is colo 0.0-1.0 (1.0 = identical)
	# fill_factor - How much jar is filled 0.0-1.0 (1.0 = full)
	remove_client(client)
	$"/root/Game".hud.addPoints(ceil(fill_factor*color_match_factor*100))
	print('jar delivered: ', fill_factor, ' ', color_match_factor, ' ', client)
