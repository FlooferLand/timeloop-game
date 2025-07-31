shader_type canvas_item;

uniform vec2 tile = vec2(1.0, 1.0);
varying vec4 modulate;

void vertex() {
	modulate = COLOR;
}

void fragment() {
    vec2 uv = UV * tile;
    COLOR = texture(TEXTURE, fract(uv)) * modulate;
}
