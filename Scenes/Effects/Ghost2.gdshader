shader_type canvas_item;

uniform vec4 flash_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float flash_modifier: hint_range(0.0, 1.0) = 1;
uniform float alpha : hint_range(0.0, 1.0) = 1;
uniform bool fade = false;



void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	texture_color.rgba = mix(texture_color.rgba, flash_color.rgba, flash_modifier);
	
	COLOR = texture_color;
	
	
}
