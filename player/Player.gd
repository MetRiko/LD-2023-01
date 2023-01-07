extends KinematicBody2D

const MAX_SPEED = 160
const ACCELERATION = 20

var move_dir = Vector2.ZERO
var velocity = Vector2.ZERO

func _ready():
	pass

func _process(_delta):
	var orientation = get_orientation()
	var viewing_angle = get_viewing_angle()
	
	$Hammer.position = Vector2(
		cos(viewing_angle) * clamp(get_distance_to_mouse() * 0.1, 8.0, 20.0),
		sin(viewing_angle) * clamp(get_distance_to_mouse() * 0.1, 4.0, 6.0) - 8.0
	)
	
	if orientation < 0.0:
		$Sprite.flip_h = true
		$Hammer.scale.x = -1.0
	elif orientation > 0.0:
		$Sprite.flip_h = false
		$Hammer.scale.x = 1.0
	
	set_animation_frame()

func _physics_process(delta):
	move_dir.x = int(Input.is_action_pressed("game_right")) - int(Input.is_action_pressed("game_left"))
	move_dir.y = int(Input.is_action_pressed("game_down")) - int(Input.is_action_pressed("game_up"))
	velocity = Vector2(
		lerp(velocity.x, move_dir.x * MAX_SPEED, ACCELERATION * delta),
		lerp(velocity.y, move_dir.y * MAX_SPEED, ACCELERATION * delta)
	)
	velocity = move_and_slide(velocity)

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
