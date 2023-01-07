shader_type canvas_item;

uniform float u_rad = 0.6; //0.4
uniform float u_small_rad = 0.15;
uniform vec2 u_vel = vec2(1.0, 0.0);
uniform float u_speed = 0.0;
uniform vec2 squash_factor = vec2(1.0, 0.01);
uniform float scale = 0.5;
uniform float u_delta_time = 0.0;
uniform vec4 u_color = vec4(0.0, 1.0, 0.0, 1.0);

float msign(in float x) { return (x<0.0)?-1.0:1.0; }

float sdEllipse( vec2 p, in vec2 ab )
{
  //if( ab.x==ab.y ) return length(p)-ab.x;

	p = abs( p ); 
    if( p.x>p.y ){ p=p.yx; ab=ab.yx; }
	
	float l = ab.y*ab.y - ab.x*ab.x;
	
    float m = ab.x*p.x/l; 
	float n = ab.y*p.y/l; 
	float m2 = m*m;
	float n2 = n*n;
	
    float c = (m2+n2-1.0)/3.0; 
	float c3 = c*c*c;

    float d = c3 + m2*n2;
    float q = d  + m2*n2;
    float g = m  + m *n2;

    float co;

    if( d<0.0 )
    {
        float h = acos(q/c3)/3.0;
        float s = cos(h) + 2.0;
        float t = sin(h) * sqrt(3.0);
        float rx = sqrt( m2-c*(s+t) );
        float ry = sqrt( m2-c*(s-t) );
        co = ry + sign(l)*rx + abs(g)/(rx*ry);
    }
    else
    {
        float h = 2.0*m*n*sqrt(d);
        float s = msign(q+h)*pow( abs(q+h), 1.0/3.0 );
        float t = msign(q-h)*pow( abs(q-h), 1.0/3.0 );
        float rx = -(s+t) - c*4.0 + 2.0*m2;
        float ry =  (s-t)*sqrt(3.0);
        float rm = sqrt( rx*rx + ry*ry );
        co = ry/sqrt(rm-rx) + 2.0*g/rm;
    }
    co = (co-m)/2.0;

    float si = sqrt( max(1.0-co*co,0.0) );
 
    vec2 r = ab * vec2(co,si);
	
    return length(r-p) * msign(p.y-r.y);
}

void vertex() {
	UV -= vec2(0.5);
	UV *= 2.0 / scale;
	UV.y += squash_factor.y * 0.25;
	UV.y -= scale * 0.3;
}

vec2 point_on_slime_outline_shape(vec2 v, float rad) {
	
	v = normalize(v);
	
	if (v.y <= 0.0) {
		return v * rad * squash_factor.x;
	}
	return vec2(rad * squash_factor.x * v.x, rad * squash_factor.y * v.y);
//	return vec2(rad * v.x, rad * 0.3 * v.y);
	
//	vec2 r = vec2(rad, rad * 0.3);
////	vec2 v = vec2(cos(a), sin(a));
//	float c = v.x;
//	float s = v.y;
//	float ta = s / c; // tan(a)
//	float tt = ta * r.x / r.y; // tan(t)
//	float d = 1. / sqrt(1. + tt * tt);
//	float x = r.x * d * sign(c);
//	float y = r.y * tt * d * sign(s);
//	return vec2(x, y);
}

float dis_slime_shape(vec2 p, vec2 s, float rad) {
	vec2 v = p - s;
	float ang = atan(v.y, v.x);
	if (v.y <= 0.0) {
		return max(length(v) - rad * squash_factor.x, 0.0);
//		return length(v);
	}
	else {
		return max(0.0, sdEllipse(v, vec2(rad * squash_factor.x, rad * squash_factor.y)));
//		return length(v) / abs(v.y);
//		if (abs(v.x) < rad * 4.0) return abs(v.y) * 4.0;
//		else return distance(p, s + vec2(rad * 0.25, 0.0) * sign(v.x));
//		else return 100.0;
	}
//	float ang = atan()
}

float dis_orb_shape(vec2 p, vec2 s, float rad) {
	vec2 v = p - s;
	float d = length(v);
	d = max(d - rad, 0.0);
//	if (d > rad) d *= 2.0;
	return d;
}

void fragment() {
	float PI = 3.14159;
	float TAU = 3.14159 * 2.0;
//	float start_angles[] = {0.0, TAU * 0.3333, TAU * 0.6666, TAU * 1.0};
//	float start_dists[] = {0.25, 0.15, 0.2, 0.175};
//	float start_dists[] = {0.2, 0.2, 0.2, 0.2};
	float start_radiuses[] = {0.05, 0.05, 0.05, 0.05};

	COLOR = vec4(0.0, 0.0, 0.0, 0.0);
	
	float fd = 0.0;
	int n = 30; //30
	
//	u_speed = 0.0;
//	float ta = TIME * 1.5;
//	u_vel = normalize(vec2(cos(ta), sin(ta)));
//	u_speed = (sin(TIME * 0.75) + 1.0) * 0.5;
//	u_speed = 1.0;
//	u_speed = 1.0;
	
	float time = TIME + u_delta_time;
	
	for (int ix = 0; ix < n; ++ix) {
		int i = ix % 4;
//		float ang = start_angles[i];
//		float dis = start_dists[i];
//		float dis = u_rad;
//		float rad = start_radiuses[i];
		float rad = (float(i) + 1.0) * 0.05 * u_small_rad;
		int s = (ix % 2) * 2 - 1;
//		ang += float(s) * TIME * 0.8 + float(s) * ((sin(TIME * 0.5) + 1.0) * 0.1) * 8.0 + (sin(float(ix+1))) * 0.3;
		
		float ang = (float(ix) / float(n-1)) * TAU;
//		ang += (sin(TIME * 1.8 * float(ix) * 0.1) + 1.0) * 0.5 * float(s);
		ang += (sin(time * 9.8 * 0.1 * float(ix % 10)) + 1.0) * 0.5 * float(s);
//		ang += TIME;
		
		float a = mod(ang, PI); // 0 - TAU
		float up_force = sin(ang) * u_rad * 0.8;
		
		up_force = max(up_force, 0.0);
		
//		if (up_force < 0.0) {
//			up_force *= -5.0;
//		}
//		if 
		
//		ang = 0.6;
		
		vec2 offset = vec2(0.0, 0.0);

		if (ix > 0) {
//			dis *= 0.75;
//			dis = (dis + (sin(TIME * float(i) * 0.1) + 1.0) * 0.5 * 0.05) * 0.75;
			
//			dis = 0.1 + 0.01;
//			dis = u_rad;
//			dis = dis_slime_shape(offset, vec2(0.0, 0.0), u_rad);
			float factor = (sin(time + float(ix) * 1234.0) + 1.0) * 0.5 * 0.3 + 0.8;
			offset = point_on_slime_outline_shape(vec2(cos(ang), sin(ang)), u_rad * factor);
//			if (ix < n / 2) {
//				dis = u_rad * 0.7;
//			}
//			dis = u_rad / sqrt(float(ix));
			
//			dis = (dis + sin(TIME * float(ix + 1) * 0.1) * 0.05) * 0.75;
		}
		else {
			ang = PI + 0.1;
			rad = u_rad;
//			dis = 0.0;
			up_force = 0.0;
		}
		
//		vec2 offset = vec2(cos(ang), sin(ang)) * dis;
//		offset.y -= up_force;
		
		vec2 vel_offset = (u_vel * 0.25 - offset);// * 0.2 * u_speed;
		float dd = length(vel_offset);
//		offset += vel_offset * (1.0 / dd) * 0.2;
//		offset += -offset * (u_small_rad * (1.0 - u_speed));

		if (ix > 0) {
			offset += u_vel * u_speed * 0.4;
			float factor = (sin(time * 10.0 + float(ix) * 2.0) + 1.0) * 0.5; // 0.0 - 1.0
			offset -= offset * u_speed * factor * 0.6;
//			offset = u_vel * 0.5;
		}
//		offset += vel_offset * u_speed * (sin(TIME * 10.0 + float(ix) * 2.0) + 1.0) * 0.6;
//		offset += vel_offset * 0.6 * u_speed;
		
//		offset += vel_offset * u_speed;
//		offset = u_vel * 0.2 * u_speed;
		
		float thickness = 0.3;
//		float thickness = 0.4;
//		if (ix == 0) thickness = 1.0;
		float thickness_rad = thickness + rad;
		
//		float d = distance(UV, offset) * (abs(sin(ang * 0.5)) * 0.1 + 0.9);
		float d = distance(UV, offset);

		
//		d /= rad / 20.0;
//		float nd2 = max(min(d, thickness_rad) - rad, 0.0) / thickness;

		if (ix == 0) {
//			float speed_rad = u_rad * (1.0 - u_speed);
			d = dis_slime_shape(UV, offset, u_rad) + u_speed;
//			nd2 = d;
		}
		else {
			float speed_factor = 1.0 - u_speed * 0.8;
			float time_factor = (sin(time * 4.0 + float(ix) * 1234.0) + 1.0) * 0.5 * 0.8 + 0.2;
			d = dis_orb_shape(UV, offset, u_small_rad * time_factor * speed_factor);
//			if (mod(ang, TAU) < PI) {
//				d *= (sin(ang)) * 0.5 + 1.0;
//			}
		}
//		if (ix % 2 == 1) {
//			nd2 = nd2 - 1.0;
//		}
		
//		float nd = min(max(d - rad, 0.0), thickness) / thickness;
//		nd = 1.0 - nd;
		
//		if (nd2 <= 1.0) {
//			fd += nd2;
//			++count;
//		}

//		fd = min(fd, d);
//		float nd = 1.0 / nd2;
		float nd = 1.0 / d;
		
//		if (ix == 0) {
//			nd *= 20.0;
//		}
		
//		fd = min(fd, nd);
		
		fd += nd;
//		fd = min(6.0 * float(n), fd);
//		fd = min(fd, nd);
//		if (ix % 2 == 1) {
//			fd -= 1.2 * nd;
//
//		}

//		d = (rad - min(rad, d)) / rad;
//		fd = max(fd, nd2);
//		if (d < rad) {
//			COLOR = vec4(0.0, 0.0, 0.0, 1.0);
//		}
	}
	
//	fd = fd / rad_sum;
	fd = fd / float(n);
	
	float x = fd * fd * 0.01;
	if (x > 0.05) {
//		COLOR = vec4(0.0, 1.0, 0.0, 1.0);
		COLOR = u_color;
//		COLOR = vec4(u_color.rgb, pow(max(min(fd * fd * 0.12, 1.0), 0.0), 3.0));
	}
//	COLOR = vec4(0.0, fd,  0.0, max(min(fd * 0.02, 1.0), 0.0));
//	COLOR = vec4(0.0, fd * fd * 0.01,  0.0, max(min(fd * 0.02, 1.0), 0.0));
//	COLOR = vec4(0.0, fd * fd * 0.01,  0.0, 1.0);
//	else if (fd < -4.0) {
//		COLOR = vec4(1.0, 0.0, 0.0, 1.0);
//	}
//	COLOR = vec4(0.0, fd , 0.0, 1.0);
//	if (fd < 2.0) {
//		COLOR = vec4(0.0, 1.0, 0.0, 1.0);
//	}
//	fd /= float(count);
	
//	if (fd < 0.2) {
//		COLOR = vec4(0.0, 1.0, 0.0, 1.0);
//	}

//	float dis = length(UV);
//
//	if (dis < 0.3) {
//		COLOR = vec4(0.0, 0.0, 0.0, 1.0);
//	}
	
//	float dis = sqrt(UV.x * UV.x + UV.y * UV.y);
//
//	float angle = atan(UV.y, UV.x) * 10.0 * sin(TIME) ;
//
//	float range = 0.3 + sin(TIME + angle) * 0.01;
	
//	else {
//		COLOR = vec4(0.0, 0.0, 0.0, 0.0);
//	}
}