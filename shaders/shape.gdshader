shader_type canvas_item;

uniform vec4 color : source_color = vec4(1, 1, 1, 1);

void fragment() {
	COLOR = color;
}
