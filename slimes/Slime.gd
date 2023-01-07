extends RigidBody2D

var shader : ShaderMaterial

var anim_speed = 0.0
var anim_vel = Vector2.RIGHT
#var radius = 0.3
var squash_factor = Vector2(1.0, 0.3)

var target_pos = Vector2(0.0, 0.0)

func _select_random_target():
	target_pos = get_viewport_rect().size * get_viewport_transform().get_scale()
	target_pos.x = rand_range(0.0, target_pos.x)
	target_pos.y = rand_range(0.0, target_pos.y)

func _ready():
	randomize()
	$Timer.connect("timeout", self, "_on_timeout")
	
	shader = $Icon.material.duplicate()
	$Icon.material = shader
	shader.set_shader_param("u_delta_time", randf() * 10.0 * 1000.0)
	
	var rand_col = Color.from_hsv(randf(), 0.8, 0.9)
	shader.set_shader_param("u_color", rand_col)
	
	_select_random_target()
	
func _process(delta):
	var v = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	squash_factor += v * 0.01
	squash_factor.x = max(squash_factor.x, 0.2)
	squash_factor.y = max(squash_factor.y, 0.2)
#	if Input.is_action_pressed("ui_up"):
#		squash_factor.x
#		radius = min(1.0, radius + 0.01)
#
#	if Input.is_action_pressed("ui_down"):
#		radius = max(0.01, radius - 0.01)
	
	anim_vel = lerp(anim_vel, linear_velocity.normalized(), 0.1)
	
	shader.set_shader_param("u_vel", -anim_vel.normalized())
	var normal_speed = linear_velocity.length()
	normal_speed = min(normal_speed, 100.0) / 100.0;
	anim_speed = lerp(anim_speed, normal_speed, 0.02)
	shader.set_shader_param("u_speed", anim_speed)
#	shader.set_shader_param("u_rad", radius)
#	var small_rad = radius * radius
#	var small_rad = 0.02
#	shader.set_shader_param("u_small_rad", small_rad)
	shader.set_shader_param("squash_factor", squash_factor)
	
	var vec = (target_pos - global_position)
	var vecn = vec.normalized()
	apply_impulse(Vector2.ZERO, vecn * vec.length() * 0.01)
	
func _on_timeout():
	_select_random_target()
	
	var ang = rand_range(0.0, PI * 2.0)
	var imp = Vector2(cos(ang), sin(ang)) * 400.0
#	apply_impulse(Vector2.ZERO, imp);
#	radius = radius * 0.5
