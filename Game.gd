extends Node

onready var root = get_tree().root.get_node("Root")

onready var slimes = root.get_node("SlimeTesting/Slimes")

func add_particle(particle : Node):
	slimes.add_child(particle)

func add_slime(slime : Node):
	slimes.add_child(slime)
