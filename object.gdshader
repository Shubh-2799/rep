shader_type canvas_item;

uniform sampler2D palette_tex : hint_default_black;
uniform int color_count = 4; // Number of swappable colors

void fragment() {
    vec4 base_color = texture(TEXTURE, UV);

    // Loop through palette to find a match
    for (int i = 0; i < color_count; i++) {
        float index = float(i) / float(color_count);

        vec4 orig_color = texture(palette_tex, vec2(index, 0.0));
        if (distance(base_color.rgb, orig_color.rgb) < 0.05) {
            vec4 new_color = texture(palette_tex, vec2(index, 1.0));
            COLOR = vec4(new_color.rgb, base_color.a);
        }
    }

    COLOR = base_color;
}