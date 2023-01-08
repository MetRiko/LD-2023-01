extends KinematicBody2D
class_name Player

const MAX_SPEED := 160
const ACCELERATION := 20

onready var anim := $Anim
onready var hammer := $Hammer
onready var start_hammer_pos : Vector2
var hammer_locked_pos := Vector2.ZERO
var move_direction := Vector2.ZERO
var velocity := Vector2.ZERO
var hammer_pos_radius := Vector2(16.0, 8.0)

func _ready():
	hammer.connect("hit", self, "_on_hit")
	
func _on_hit():
#	var space = get_world_2d().get_direct_space_state()
#	var results = space.intersect_point(hitpoint.global_position, 32, [], 2, false, true)

	var areas = $HammerHitbox.get_overlapping_areas()

	for area in areas:
		var slime = area.get_parent()
		if slime is Slime:
			slime.do_squish()

func _input(event):
	if event.is_action_pressed("game_swing"):
		hammer_locked_pos = hammer.position
		hammer.play_swing()

func _process(_delta):
	var orientation = get_orientation()
	var viewing_angle = get_viewing_angle()
	
	$HammerHitbox.global_position = global_position + hammer.hammer_elipse_vec * 4.0
	
#	set_animation_frame()

func _physics_process(delta):
	move_direction = Input.get_vector("game_left", "game_right", "game_up", "game_down")
#	move_direction = move_direction.normalized()
	
	var hammer_factor := 0.4 if hammer.is_swinging() else 1.0
	velocity = Vector2(
		lerp(velocity.x, move_direction.x * MAX_SPEED * hammer_factor, ACCELERATION * delta),
		lerp(velocity.y, move_direction.y * MAX_SPEED * hammer_factor, ACCELERATION * delta)
	)
	
	_update_animations()
	
	var new_velocity = move_and_slide(velocity, Vector2.ZERO, false, 4, 0.785398, false)
	
	for i in range(get_slide_count()):
		var obj = get_slide_collision(i).collider
		if obj is Slime:
			var push_force_factor = lerp(1.0, 0.2, obj.proper_scale * obj.proper_scale)
			obj.linear_velocity = velocity.normalized() * MAX_SPEED * push_force_factor
	
	velocity = new_velocity
	

func _update_animations():
	if is_moving():
		if anim.current_animation != "Walk":
			anim.play("Walk", 0.1, 2.0)
	else:
		if anim.current_animation != "Idle":
			anim.play("Idle")

#func set_animation_frame():
#	var frame = get_action_frame()
#	match frame:
#		"IDLE":
#			$AnimationPlayer.play(frame)
#		"WALK":
#			if move_direction.x < 0.0:
#				$AnimationPlayer.play_backwards(frame)
#			elif move_direction.x > 0.0:
#				$AnimationPlayer.play(frame)
#			if move_direction.y < 0.0:
#				$AnimationPlayer.play_backwards(frame)
#			elif move_direction.y > 0.0:
#				$AnimationPlayer.play(frame)

#func get_action_frame():
#	if is_moving():
#		return "WALK"
#	return "IDLE"

func get_distance_to_mouse():
	var diff = get_viewport().get_mouse_position() - get_transform().get_origin()
	return sqrt(pow(diff.x, 2.0) + pow(diff.y, 2.0))

func get_viewing_angle():
	var diff = get_viewport().get_mouse_position() - get_transform().get_origin()
	return atan2(diff.y, diff.x)

func get_orientation():
	return sign(get_viewport().get_mouse_position().x - get_transform().get_origin().x)

func is_moving():
	return move_direction != Vector2.ZERO
