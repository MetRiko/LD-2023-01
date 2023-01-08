shader_type canvas_item;

uniform vec4 u_color = vec4(0.2, 0.0, 0.1, 1.0);
uniform float u_fill_level = 0.5;
uniform float u_max_height_diff = 0.6;
uniform float u_angle_level = 0.4;

void vertex() {
	UV.y = 1.0 - UV.y;
}

void fragment() {
	
	vec4 color = vec4(0.2, 0.0, 0.1, 1.0);
	vec4 trans = vec4(color.rgb, 0.0);
	
	float fill_level = u_fill_level; //0.85; //(1.0 + sin(TIME)) * 0.5;
	float max_height_diff = u_max_height_diff; //0.4;
	float angle_level = u_angle_level; //sin(TIME * 4.0);
	
	if (fill_level <= 0.0) {
		COLOR = trans;
	}
	else {
		
		max_height_diff = min(1.0 - fill_level, max_height_diff);
		
		float x = UV.x + angle_level * max_height_diff * 0.5;
		float curve_factor = (x - 0.5) * (max_height_diff * angle_level);
		
		curve_factor += sin(x * 5.0 - TIME * 5.0) * 0.04 * (1.0 - abs(angle_level) * 0.5);
		
		float y = mix(0.0, 1.0, UV.y);
		y = clamp(y + curve_factor, 0.0, 1.0);
		
		vec4 left_color = vec4(0.514, 0.937, 0.627, 0.6);
		vec4 right_color = vec4(vec3(0.11, 0.408, 0.314) * 0.5, 1.0);
		
		COLOR = mix(trans, right_color, (1.0 - pow(sin((1.0-UV.x) * 3.14159 * 0.5), 1.8)));
		COLOR = mix(COLOR, color, step(y, fill_level));
		
//		COLOR = mix(vec4(0.0, 1.0, 0.0, 1.0), COLOR, UV.x);
		COLOR = mix(COLOR, left_color, (1.0 - pow(sin(UV.x * 3.14159 * 0.5), 0.4)));
		
	//	COLOR = vec4(UV.x, UV.y, 0.0, 1.0);
	}
	

}