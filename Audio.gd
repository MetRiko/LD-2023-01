extends Node

onready var root = get_tree().root.get_node("Root")

onready var audio_players = root.get_node("AudioPlayers")

func _ready():
	randomize()

const pitches = {
	"OnEggHit": 1.5,
	"OnEggPick": 1.0,
	"OnJarPick": 1.0,
	"OnSlimeHit": 0.8,
	"OnSlimePick": 1.3,
	"OnSlimePickTooMuch": 1.0,
	"OnHammerHit": 1.5,
	"OnSlimeSpawn": 1.0,
	"OnDrop": 1.0
}

const slime_hit_sounds = [
	preload("res://res/on_slime_hit_2a.wav"),
	preload("res://res/on_slime_hit_2b.wav"),
	preload("res://res/on_slime_hit_2c.wav")
]

#const slime_picks_sounds = [
#	preload("res://res/on_slime_pick_2.wav"),
#	preload("res://res/on_slime_pick_too_much.wav")
#]

func play(id):
#	if id == "OnSlimeHit":
#		var ap : AudioStreamPlayer = audio_players.get_node("OnSlimeHit")
#		ap.play()
#	else:
	var ap : AudioStreamPlayer = audio_players.get_node(id)
	var base_pitch = pitches[id]
	ap.pitch_scale = base_pitch + (randi() % 5 - 2) * 0.1
	if id == "OnSlimeHit":
		ap.stream = slime_hit_sounds[randi() % 3]
#	elif id == "OnSlimePick":
#		ap.stream = slime_picks_sounds[randi() % 2]
	ap.play()
