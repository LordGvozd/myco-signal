shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float noise_amount : hint_range(0.0, 0.5) = 0.5; // Сила шума
uniform float scanline_strength : hint_range(0.0, 1.0) = 0.5; // Яркость линий развертки

// Функция генерации псевдослучайного шума
float rand(vec2 n) { 
    return fract(sin(dot(n, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    vec4 col = texture(screen_texture, SCREEN_UV);
    
    // 1. Шум
    float noise = rand(SCREEN_UV + fract(TIME)); // Меняющийся шум
    // Накладываем шум (вычитаем, чтобы затемнить, или прибавляем)
    col.rgb += (noise - 0.5) * noise_amount;
    
   
    // 3. Легкое виньетирование для объема
    float dist = length(SCREEN_UV - 0.5);
    col.rgb *= 1.0 - dist * 0.3;
    
    COLOR = col;
}