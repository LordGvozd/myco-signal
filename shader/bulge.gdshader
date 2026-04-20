shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform vec2 center = vec2(0.5, 0.5); // Центр эффекта (в UV-координатах)
uniform float radius : hint_range(0.0, 1.0) = 0.4; // Радиус линзы
uniform float strength : hint_range(-1.0, 1.0) = -0.5; // Сила искажения (положительное - выпуклость)

void fragment() {
    vec2 uv = SCREEN_UV;

    // Вектор от центра до текущего пикселя
    vec2 delta = uv - center;

    // Расстояние от центра
    float dist = length(delta);

    // Применяем искажение только внутри радиуса
    if (dist < radius) {
        // Функция спада искажения к краям линзы (smoothstep)
        float factor = 1.0 - smoothstep(0.0, radius, dist);
        // Смещаем UV-координаты. Strength управляет направлением и силой.
        // Делим на радиус, чтобы смещение было пропорционально расстоянию от центра
        uv = uv - delta * factor * strength;
    }

    // Ограничиваем UV, чтобы не выйти за края экрана (clamp)
    // uv = clamp(uv, 0.001, 0.999); // Раскомментируйте, если видите артефакты по краям

    COLOR = texture(screen_texture, uv);
}