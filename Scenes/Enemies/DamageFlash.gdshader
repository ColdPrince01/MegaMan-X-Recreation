shader_type canvas_item;

uniform vec4 flash_color : source_color = vec4(1.0);
uniform float flash_modifier: hint_range(0.0, 1.0) = 1;
uniform float alpha : hint_range(0.0, 1.0) = 1;


void fragment() { ///Runs for every pixel, determines what color should be
	vec4 color = texture(TEXTURE, UV); 
	color.rgb = mix(color.rgb, flash_color.rgb,  flash_modifier);
	
	COLOR = color;
	
}
