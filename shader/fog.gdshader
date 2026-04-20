shader_type canvas_item;

// Noise texture
uniform sampler2D noise_texture: repeat_enable, filter_nearest;
// Fog density
uniform float density: hint_range(0.0, 1.0) = 0.25;

uniform vec2 speed = vec2(0.03, 0.01);


void fragment() {
	vec2 uv = UV + speed * TIME;
	// Sample the noise tetxure
	float noise = texture(noise_texture, uv).r;
	
	float fog = clamp(noise * 2.0 - 1.0, 0.0, 1.0);
	
	// Apply the fog event
	COLOR.a *= fog * density;
	
	
	
}