extends Node

onready var root = get_tree().root.get_node("Root")

onready var audio_players = root.get_node("AudioPlayers")

func play(id):
	audio_players.get_node(id).play()
