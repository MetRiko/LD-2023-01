extends KinematicBody2D

var vel := Vector2.ZERO
var speed := 80
var acc := 10

func _physics_process(delta):
	var dir = get_input_dir()
	
	vel = Vector2(
		lerp(vel.x, dir.x * speed, acc * delta),
		lerp(vel.y, dir.y * speed, acc * delta)
	)
	
	vel = move_and_slide(vel)
	
	
func get_input_dir() -> Vector2:
	var dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	return dir
