extends RigidBody2D
class_name Slime

var shader : ShaderMaterial

var anim_speed = 0.0
var anim_vel = Vector2.RIGHT
#var radius = 0.3
var squash_factor = Vector2(1.0, 0.3)

var target_pos = Vector2(0.0, 0.0)
var proper_scale = 0.5
var anim_scale = proper_scale
var current_color : Color

const slime_particle := preload("res://slimes/SlimeParticle.tscn") 

export var res : Resource

var squish_tween : SceneTreeTween
var anim_squish : float = 0.0

func change_size(factor: float):
	anim_scale = factor
	_change_proper_scale(factor)
	play_squish()

func create_random_particle():
	var p = slime_particle.instance()
#	p.global_position = global_position
	Game.add_particle(p)
	p.global_position = global_position
	var ang = rand_range(0, TAU)
	var offset = Vector2(
		cos(ang) * squash_factor.x * proper_scale * 200.0,
		sin(ang) * squash_factor.y * proper_scale * 200.0
	)
	p.play_animation(global_position + offset, proper_scale * 2.0)
	p.set_color(current_color)

func do_squish():
	proper_scale = max(proper_scale - 0.1, 0.1)
	_change_proper_scale(proper_scale)
	play_squish()
	
	for i in range(randi() % 5 + 3):
		create_random_particle()
		
	if proper_scale - 0.1 < 0.1:
		yield(get_tree().create_timer(0.6), "timeout")
		queue_free()

func _change_proper_scale(value : float):
	proper_scale = value
	var circle : CircleShape2D = $Shape.shape
	circle.radius = proper_scale * 24.0
	var hitbox_circle : CircleShape2D = $Hitbox/Shape.shape
	hitbox_circle.radius = proper_scale * 24.0 + 7.0

func play_squish():
	if squish_tween:
		squish_tween.kill()
	squish_tween = get_tree().create_tween()
	squish_tween.tween_method(self, "_on_squish", 0.0, 1.0, 1.2)

func set_color(color : Color):
	current_color = color
	shader.set_shader_param("u_color", current_color)

func _on_squish(x : float):
	x = x * PI
#	var target_squish = 0.5 * (sin((x - 10) * 12.0) + 1.0) * (x-10) * (x-10) * 0.01
	var target_squish = 0.5 * (sin(6 * x + PI * 0.5) + 1.0) * cos(x * 0.5)
	anim_squish = lerp(anim_squish, target_squish, 0.5)
	var scale_factor = (1.0 - target_squish) * 0.5 + 0.5
	anim_scale = lerp(anim_scale, scale_factor * proper_scale, 0.5)
#	anim_squish = target_squish
	squash_factor.y = anim_squish

func grow():
	change_size(min(1.0, proper_scale + 0.2))

func _select_random_target():
	target_pos = get_viewport_rect().size * get_viewport_transform().get_scale()
	target_pos.x = rand_range(0.0, target_pos.x)
	target_pos.y = rand_range(0.0, target_pos.y)

func _ready():
	randomize()
	$Timer.connect("timeout", self, "_on_timeout")
	
	$Shape.shape = $Shape.shape.duplicate()
	$Hitbox/Shape.shape = $Hitbox/Shape.shape.duplicate()
	
	shader = $Icon.material.duplicate()
	$Icon.material = shader
	shader.set_shader_param("u_delta_time", randf() * 10.0 * 1000.0)
	
	current_color = Color.from_hsv(randf(), 0.8, 0.9)
	shader.set_shader_param("u_color", current_color)
	
	_select_random_target()
	_change_proper_scale(proper_scale)
	
#func _input(event):
#	if event is InputEventMouseButton and event.is_pressed():
#		do_squish()
	
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
	shader.set_shader_param("scale", anim_scale)
	
	var vec = (target_pos - global_position)
	var vel = vec.normalized() *  vec.length() * 0.01 * proper_scale
	apply_impulse(Vector2.ZERO, vel)
	
func _on_timeout():
	_select_random_target()
	
	var ang = rand_range(0.0, PI * 2.0)
	var imp = Vector2(cos(ang), sin(ang)) * 400.0
#	apply_impulse(Vector2.ZERO, imp);
#	radius = radius * 0.5
