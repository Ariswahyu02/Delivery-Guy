shader_type canvas_item;

uniform bool u_active = false;
uniform vec4 u_tint_color : source_color = vec4(0.2, 0.8, 1.0, 1.0); // warna saat boost
uniform float u_tint_strength : hint_range(0.0, 1.0) = 0.6;          // intensitas tint
uniform float u_edge_strength : hint_range(0.0, 3.0) = 1.2;          // kekuatan "glow tepi"
uniform float u_edge_threshold : hint_range(0.0, 1.0) = 0.2;         // ambang tepi

void fragment() {
    vec4 base = texture(TEXTURE, UV) * COLOR;

    if (!u_active) {
        COLOR = base;
        
    }

    // Sobel teraproksimasi sederhana menggunakan layar piksel (FX sederhana)
    vec2 px = SCREEN_PIXEL_SIZE * 1.0;
    float s00 = texture(TEXTURE, UV + vec2(-px.x, -px.y)).a;
    float s01 = texture(TEXTURE, UV + vec2(0.0,     -px.y)).a;
    float s02 = texture(TEXTURE, UV + vec2( px.x,   -px.y)).a;
    float s10 = texture(TEXTURE, UV + vec2(-px.x, 0.0)).a;
    float s12 = texture(TEXTURE, UV + vec2( px.x, 0.0)).a;
    float s20 = texture(TEXTURE, UV + vec2(-px.x,  px.y)).a;
    float s21 = texture(TEXTURE, UV + vec2(0.0,      px.y)).a;
    float s22 = texture(TEXTURE, UV + vec2( px.x,    px.y)).a;

    float gx = (s02 + 2.0*s12 + s22) - (s00 + 2.0*s10 + s20);
    float gy = (s20 + 2.0*s21 + s22) - (s00 + 2.0*s01 + s02);
    float edge = clamp(abs(gx) + abs(gy), 0.0, 1.0);

    // threshold supaya hanya tepi yang menyala
    float edge_mask = smoothstep(u_edge_threshold, 1.0, edge) * u_edge_strength;

    // tint keseluruhan + highlight tepi
    vec4 tinted = mix(base, u_tint_color, u_tint_strength);
    tinted.rgb += u_tint_color.rgb * edge_mask * 0.25;

    // jaga alpha aslinya
    tinted.a = base.a;
    COLOR = tinted;
}
