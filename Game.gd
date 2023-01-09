extends Node

onready var root = get_tree().root.get_node("Root")

onready var slimes = root.get_node("RoomSwitcher/SlimeRoom/YSort")
onready var hud = root.get_node("HUD/Control")

var player : Player

func add_particle(particle : Node):
	slimes.add_child(particle)

func add_slime(slime : Node):
	slimes.add_child(slime)
