extends KinematicBody2D

var MAX_SPEED = 300
var ACCELERATION = 600

var speed = 0
var move_dir = Vector2(0.0, 0.0)

func _ready():
	pass

func _process(delta):
	var orientation = get_orientation()
	$Hammer.position.x = orientation * (8.0 + clamp(get_distance_to_mouse() * 0.1, 0.0, 16.0))
	set_sprites_orientation(orientation)
	set_animation_frame()

func _physics_process(delta):
	move_dir.x = int(Input.is_action_pressed("game_right")) - int(Input.is_action_pressed("game_left"))
	move_dir.y = int(Input.is_action_pressed("game_down")) - int(Input.is_action_pressed("game_up"))
	if is_moving():
		speed = clamp(speed + ACCELERATION * delta, 0.0, MAX_SPEED)
		move_and_slide(move_dir.normalized() * speed)
	else:
		speed = 0

func set_sprites_orientation(orientation):
	if orientation < 0.0:
		$Sprite.flip_h = true
		$Hammer/Sprite.flip_h = true
	elif orientation > 0.0:
		$Sprite.flip_h = false
		$Hammer/Sprite.flip_h = false

func set_animation_frame():
	var frame = get_action_frame()
	match frame:
		"IDLE":
			$Sprite/AnimationPlayer.play(frame)
		"WALK":
			if move_dir.x < 0.0:
				$Sprite/AnimationPlayer.play_backwards(frame)
			elif move_dir.x > 0.0:
				$Sprite/AnimationPlayer.play(frame)
			if move_dir.y < 0.0:
				$Sprite/AnimationPlayer.play_backwards(frame)
			elif move_dir.y > 0.0:
				$Sprite/AnimationPlayer.play(frame)

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
	return move_dir != Vector2(0.0, 0.0)
