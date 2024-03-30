shader_type canvas_item;

uniform vec4 flash_color : source_color = vec4(1.0);
uniform float flash_modifier: hint_range(0.0, 1.0) = 1;
uniform float alpha : hint_range(0.0, 1.0) = 0.5;
uniform vec4 alpha_set : source_color = vec4(vec3(0.12, 0.0, 1.0), 1.0);

void fragment() {
	
	vec4 ghostcolor = texture(TEXTURE, UV);
	ghostcolor.rgb = mix(ghostcolor.rgb, flash_color.rgb,  flash_modifier);
	ghostcolor.a *= 0.75;
	ghostcolor.a *= alpha;
	
	COLOR = ghostcolor;
}
