shader_type canvas_item;

void fragment() {
	COLOR = texture(TEXTURE,UV);
	
	COLOR.r = 0.37;
	COLOR.g = 0.18;
	COLOR.b = 0.27;
}