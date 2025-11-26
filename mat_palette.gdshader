shader_type canvas_item;

uniform vec4 palette_0  : source_color;
uniform vec4 palette_1  : source_color;
uniform vec4 palette_2  : source_color;
uniform vec4 palette_3  : source_color;
uniform vec4 palette_4  : source_color;
uniform vec4 palette_5  : source_color;
uniform vec4 palette_6  : source_color;
uniform vec4 palette_7  : source_color;
uniform vec4 palette_8  : source_color;
uniform vec4 palette_9  : source_color;
uniform vec4 palette_10 : source_color;
uniform vec4 palette_11 : source_color;

const int N_COLORS = 12;

uniform sampler2D screen_texture : hint_screen_texture;

void fragment() {
	vec4 palette[N_COLORS] = { palette_0, palette_1, palette_2, palette_3, palette_4, palette_5, palette_6, palette_7, palette_8, palette_9, palette_10, palette_11 };
	vec4 screen_color = texture(screen_texture, SCREEN_UV);
	// Compute source color value
	float sv = 0.f;
	for (int i = 0; i < 3; i++) {
		if (screen_color[i] > sv) { sv = screen_color[i]; }
	}
	
	int pal_i = int(floor((sv * 0.99f) * float(N_COLORS)));
	vec4 result = palette[pal_i];
	/*
	float min_dist = 999.f; // always bigger than 1.0
	vec4 result;
	for (int i = 0; i < N_COLORS; i++) {
		vec4 pc = palette[i];
		// Compute palette color value
		float pv = 0.f;
		for (int j = 0; j < 3; j++) {
			if (pc[j] > pv) { pv = pc[j]; }
		}
		float dist = abs(pv - sv);
		if (dist < min_dist) {
			min_dist = dist;
			result = pc;
		}
	}
	*/
	COLOR = vec4(result.rgb, COLOR.a);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
