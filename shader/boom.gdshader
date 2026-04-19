shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform vec2 center = vec2(0.5, 0.5);
uniform float radius : hint_range(0.0, 1.0) =0.7;
uniform float strength : hint_range(0.0, 0.1) = 0.08; // Сила искажения
uniform float width : hint_range(0.0, 0.1) = 0.04;   // Ширина кольца волны
uniform float feather : hint_range(0.0, 1.0) = 0.135; // Размытие краев волны

void fragment() {
    vec2 st = SCREEN_UV;
    float aspect_ratio = SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;

    // Корректируем соотношение сторон, чтобы волна была круглой
    vec2 scaled_st = (st - vec2(0.0, 0.5)) / vec2(1.0, aspect_ratio) + vec2(0.0, 0.5);
    vec2 dist_center = scaled_st - center;

    // Создаем маску в форме кольца для волны
    float dist = length(dist_center);
    float mask = (1.0 - smoothstep(radius - feather, radius, dist)) *
                 smoothstep(radius - width - feather, radius - width, dist);

    // Рассчитываем смещение
    vec2 offset = normalize(dist_center) * strength * mask;
    vec2 final_uv = st + offset * mask; // Применяем смещение к UV

    // Ограничиваем UV, чтобы избежать артефактов на краях
    final_uv = clamp(final_uv, 0.001, 0.999);

    COLOR = texture(SCREEN_TEXTURE, final_uv);
}