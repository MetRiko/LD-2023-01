extends Pickable
class_name SlimeJar

var shader : ShaderMaterial

var gels := []
var all_gels_count := 0
var final_color : Color
#var fill_level := 0.0
var max_gels_count := 20
var angle_level := 0.0

func reset_angle_level_with_animation():
	var tween = get_tree().create_tween()
	tween.tween_method(self, "change_angle_level", angle_level, 0.0, 0.4)

func add_gel(color: Color, amount: int):
	var overflow := 0
	if all_gels_count < max_gels_count: 
		var gel = {
			color = color,
			amount = amount
		}
		gels.append(gel)
		all_gels_count += amount
		if all_gels_count > max_gels_count:
			overflow = all_gels_count - max_gels_count
			gel.amount -= overflow
			all_gels_count = max_gels_count
		final_color = _calculate_color()
		shader.set_shader_param("u_color", final_color)
		shader.set_shader_param("u_fill_level", float(all_gels_count) / max_gels_count)
	else:
		overflow = amount
	return overflow

func change_angle_level(level: float):
	angle_level = level
	shader.set_shader_param("u_angle_level", level)

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		var n = add_gel(Color.from_hsv(rand_range(0.0, 1.0), 0.8, 1.0, 1.0), 1)

func _calculate_color():
	if gels.size() > 0:
		var h = gels[0].color.h
		var s = gels[0].color.s
		var v = gels[0].color.v
		for gel in gels:
#			c = lerp(c, gel.color, float(gel.amount) / all_gels_count)
			var factor = float(gel.amount) / all_gels_count
			h = lerp(h, gel.color.h, factor)
			v = lerp(v, gel.color.v, factor)
		return Color.from_hsv(h, s, v)
	return Color.black

func _on_pickable_changed(pickable: bool):
	$Jar.frame = int(pickable)

func _ready():
	connect("is_pickable_changed", self, "_on_pickable_changed")
	shader = $Liquid.material.duplicate()
	$Liquid.material = shader
	
	shader.set_shader_param("u_color", final_color)
	shader.set_shader_param("u_fill_level", all_gels_count / max_gels_count)
	change_angle_level(angle_level)

	$Jar.frame = 0
