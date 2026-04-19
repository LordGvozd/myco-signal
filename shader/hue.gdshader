shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float speed : hint_range(0.0, 2.0) = 0.5; // Скорость смены цветов

// Функция для конвертации HSV в RGB
vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void fragment() {
    vec4 original_color = texture(screen_texture, SCREEN_UV);

    // Преобразуем RGB в HSV (упрощенно, но работает для сдвига тона)
    float hue = fract(TIME * speed); // TIME - встроенная переменная Godot

    // Применяем сдвиг тона (Hue)
    vec3 hsv = vec3(hue, 1.0, 1.0);
    vec3 rainbow_tint = hsv2rgb(hsv);

    // Смешиваем оригинальный цвет с радужным оттенком
    // Используем яркость оригинального цвета, чтобы сохранить детали
    float gray = dot(original_color.rgb, vec3(0.299, 0.587, 0.114));
    COLOR.rgb = original_color.rgb * rainbow_tint;
    COLOR.a = original_color.a;
}