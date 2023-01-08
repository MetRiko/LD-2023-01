extends Node2D
class_name Hammer

signal hit

onready var anim = $Anim
onready var hitpoint = $Body/HitPoint

onready var start_hammer_pos : Vector2

var hammer_pos_radius := Vector2(16.0, 8.0)

var hammer_elipse_vec : Vector2

func _ready():
	start_hammer_pos = position

func _process(delta):
	if not is_swinging():
		_update_hammer_pos()

func _update_hammer_pos():
	var vec = get_global_mouse_position() - global_position
	var dir = vec.normalized()
	var factor = min(vec.length() / 100.0, 1.0) * 0.8 + 0.2
	
	var max_vec = dir * hammer_pos_radius
	vec = max_vec * factor
	hammer_elipse_vec = vec
	
	position = start_hammer_pos + vec
	
	scale.x = 1.0 if vec.x >= 0 else -1.0 
	$Body/Sprite.z_index = 0 if vec.y >= 0 else -1
	
	rotation = Vector2(vec.x * scale.x, vec.y * scale.x).angle()

func play_swing():
	anim.play("Swing")
	
func play_idle():
	anim.play("Idle")

func is_swinging():
	return anim.current_animation == "Swing"

func _try_hit():
	emit_signal("hit")
#	var space = get_world_2d().get_direct_space_state()
#	var results = space.intersect_point(hitpoint.global_position, 32, [], 2, false, true)
#
#	for result in results:
#		var slime = result.collider.get_parent()
#		if slime is Slime:
#			slime.do_squish()
