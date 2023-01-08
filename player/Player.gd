extends KinematicBody2D
class_name Player

const MAX_SPEED = 160
const ACCELERATION = 20

var move_direction = Vector2.ZERO
var velocity = Vector2.ZERO
var hammer_locked_pos = Vector2.ZERO

func _ready():
	pass

func _process(_delta):
	var orientation = get_orientation()
	var viewing_angle = get_viewing_angle()
	
	if $Hammer/AnimationPlayer.is_playing():
		$Hammer.position = hammer_locked_pos
	else:
		$Sprite.flip_h = orientation < 0.0
		$Hammer.scale.x = orientation
		$Hammer.position = Vector2(
			cos(viewing_angle) * clamp(get_distance_to_mouse() * 0.1, 8.0, 20.0),
			sin(viewing_angle) * clamp(get_distance_to_mouse() * 0.1, 4.0, 6.0) - 14.0
		)
	
	set_animation_frame()
	
	if Input.is_action_just_pressed("game_swing"):
		hammer_locked_pos = $Hammer.position
		if orientation < 0.0:
			$Hammer/AnimationPlayer.play("SWING_L")
		else:
			$Hammer/AnimationPlayer.play("SWING_R")

func _physics_process(delta):
	move_direction.x = int(Input.is_action_pressed("game_right")) - int(Input.is_action_pressed("game_left"))
	move_direction.y = int(Input.is_action_pressed("game_down")) - int(Input.is_action_pressed("game_up"))
	move_direction = move_direction.normalized()
	velocity = Vector2(
		lerp(velocity.x, move_direction.x * MAX_SPEED, ACCELERATION * delta),
		lerp(velocity.y, move_direction.y * MAX_SPEED, ACCELERATION * delta)
	)
	
	var new_velocity = move_and_slide(velocity, Vector2.ZERO, false, 4, 0.785398, false)
	
	for i in range(get_slide_count()):
		var obj = get_slide_collision(i).collider
		if obj is Slime:
			var push_force_factor = lerp(1.0, 0.2, obj.proper_scale * obj.proper_scale)
			obj.linear_velocity = velocity.normalized() * MAX_SPEED * push_force_factor
	
	velocity = new_velocity

func set_animation_frame():
	var frame = get_action_frame()
	match frame:
		"IDLE":
			$AnimationPlayer.play(frame)
		"WALK":
			if move_direction.x < 0.0:
				$AnimationPlayer.play_backwards(frame)
			elif move_direction.x > 0.0:
				$AnimationPlayer.play(frame)
			if move_direction.y < 0.0:
				$AnimationPlayer.play_backwards(frame)
			elif move_direction.y > 0.0:
				$AnimationPlayer.play(frame)

func get_action_frame():
	if is_moving():
		return "WALK"
	return "IDLE"

func get_distance_to_mouse():
	var diff = get_viewport().get_mouse_position() - get_transform().get_origin()
	return sqrt(pow(diff.x, 2.0) + pow(diff.y, 2.0))

func get_viewing_angle():
	var diff = get_viewport().get_mouse_position() - get_transform().get_origin()
	return atan2(diff.y, diff.x)

func get_orientation():
	return sign(get_viewport().get_mouse_position().x - get_transform().get_origin().x)

func is_moving():
	return move_direction != Vector2(0.0, 0.0)
