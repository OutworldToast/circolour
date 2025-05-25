shader_type canvas_item;

uniform vec4 previous_color: source_color = vec4(1);
uniform vec4 color : source_color = vec4(1);

uniform float blend_strength: hint_range(0.0, 1.0, 0.1) = 0.0;

uniform float radius : hint_range(0.0, 1.0, 0.01) = 0.45;
uniform float edge : hint_range(0.001, 0,2) = 0.05;

void fragment() {

	float dist = distance(UV, vec2(0.5));

	float alpha = 1.0 - smoothstep(radius, radius + edge, dist);
	
	vec4 blended_color = mix(color, previous_color, blend_strength);

	COLOR = vec4(blended_color.rgb, color.a * alpha);
}
