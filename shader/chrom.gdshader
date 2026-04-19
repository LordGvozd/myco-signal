shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float strength : hint_range(0.0, 0.05) = 1; // Сила смещения каналов
uniform vec2 center = vec2(0.5, 0.5); // Центр, от которого идет искажение (обычно центр экрана)

void fragment() {
    vec2 uv = SCREEN_UV;
    
    // Вектор направления от центра к пикселю
    vec2 direction = uv - center;
    
    // Смещаем UV для красного канала (в сторону от центра)
    vec2 uv_r = uv + direction * strength;
    // Смещаем UV для синего канала (в противоположную сторону)
    vec2 uv_b = uv - direction * strength;
    
    // Зеленый канал оставляем без смещения для резкости
    float g = texture(screen_texture, uv).g;
    float r = texture(screen_texture, uv_r).r;
    float b = texture(screen_texture, uv_b).b;
    
    COLOR = vec4(r, g, b, 1.0);
}