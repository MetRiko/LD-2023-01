extends Node2D
class_name SlimeParticle

var start_pos : Vector2
var final_pos : Vector2

var distance : float

var shader : ShaderMaterial
var tween : SceneTreeTween

var prev_pos := Vector2.ZERO
var start_scale : float

var start_color : Color
var final_color : Color

func extract_some_gel(amount: int):
	if amount > 0:
		tween.custom_step(1.0)
		if not tween.is_running():
			queue_free()

func _ready():
	randomize()
	shader = $Sprite.material.duplicate()
	$HitBox/Shape.shape = $HitBox/Shape.shape.duplicate()
	$Sprite.material = shader
	$HitBox.monitorable = false
	shader.set_shader_param("u_delta_time", randf() * 10.0 * 1000.0)

func set_color(col : Color):
	start_color = col
	shader.set_shader_param("u_color", col)
	final_color = Color.from_hsv(col.h, col.s, col.v * 0.8)
	
func play_animation(final_pos : Vector2, particle_scale : float):
	start_pos = global_position
	self.final_pos = final_pos
	
	distance = (final_pos - start_pos).length()
	distance = sqrt(distance)
	
	tween = get_tree().create_tween()
	tween.tween_method(self, "_on_animation", 0.0, 1.0, distance * 0.05) # dur based on length
#	shader.set_shader_param("scale", particle_scale)
	start_scale = particle_scale * rand_range(0.5, 1.0)
	$Sprite.scale = Vector2.ONE * start_scale
	tween.connect("finished", self, "_on_hit")
	
func _start_fading():
	var tween = get_tree().create_tween()
	tween.tween_method(self, "_on_fading", 0.0, 1.0, 3.0 + start_scale * 3.0 + rand_range(0.0, 2.0)) # dur based on length
	tween.connect("finished", self, "_on_faded")
	
func _on_fading(x : float):
	var factor = pow(sin(x * 0.5 * PI + PI * 0.5), 0.4)
	$Sprite.modulate.a = factor
#	$Sprite.scale = Vector2.ONE * lerp(start_scale, 0.0, x)
	$Sprite.scale = Vector2.ONE * start_scale * factor
	
	var hitbox_circle : CircleShape2D = $HitBox/Shape.shape
	hitbox_circle.radius = start_scale * factor * 6.0
	
func _on_faded():
	queue_free()
	
func _on_hit():
	shader.set_shader_param("u_particle_speed", 0.0)
	shader.set_shader_param("u_speed", 0.0)
	shader.set_shader_param("squash_factor", Vector2(1.0, 0.01))
	_start_fading()
	$HitBox.monitorable = true
	
#	var hitbox_circle : CircleShape2D = $HitBox/Shape.shape
#	hitbox_circle.radius = $Sprite.scale.x * 6.0
	
func _on_animation(x : float):
	
	var next_col = lerp(start_color, final_color, x)
	shader.set_shader_param("u_color", next_col)
	
	var vec = final_pos - start_pos
	
	var pos_on_vec = start_pos + vec * x
	global_position = pos_on_vec

	$Sprite.position.y = -sin(x * PI) * distance * 3.0 # height based on length
		
#	var dir = Vector2(
#		pos_on_vec.x,
#		pos_on_vec.y - sin(x * PI) * 120.0
#	)
	
	var curr_pos = vec * x + Vector2(0, $Sprite.position.y)
	var dir = curr_pos - prev_pos
	
	shader.set_shader_param("u_vel", -dir.normalized())
	shader.set_shader_param("u_particle_speed", (1.0 - sin(x * PI)) * 2.0)
	
	prev_pos = curr_pos
	
#	var rand_col = Color.from_hsv(randf(), 0.8, 0.9)
#	shader.set_shader_param("u_color", rand_col)
