extends Node2D

func _ready():
	for slime in $Slimes.get_children():
		if slime.visible == false:
			slime.queue_free()
