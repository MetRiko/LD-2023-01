extends Node2D

onready var camera : Camera2D = $Camera

var current_room_id := -1

func _ready():
	set_process(false)
	yield(VisualServer, 'frame_post_draw')
	set_process(true)

func _process(delta):
	var player := Game.player
	if player:
		var pos = player.global_position
		var room_id = floor((pos.y + 360.0) / 360.0)
		
		if current_room_id != room_id:
			player.get_parent().remove_child(player)
			get_child(room_id).get_node("YSort").add_child(player)
			player.global_position = pos
			
			if current_room_id == -1:
				camera.position.y = (room_id - 1) * 360.0
			else:
				var tween := get_tree().create_tween()
				tween.set_trans(Tween.TRANS_SINE)
				tween.set_ease(Tween.EASE_OUT)
				tween.tween_property(camera, "position:y", (room_id - 1) * 360.0, 1.2)
			current_room_id = room_id
#			camera.position.y = (current_room_id - 1) * 360.0
