extends Node2D

func _ready():
	for slime in $YSort.get_children():
		if slime.visible == false:
			slime.queue_free()
