shader_type canvas_item;

// Цвет, который мы хотим сделать прозрачным (например, черный)
uniform vec3 chroma_key_color : source_color = vec3(0.0, 0.0, 0.0);
// Допустимое отклонение от ключевого цвета
uniform float pickup_range : hint_range(0.0, 1.0) = 0.1;
// Степень сглаживания краев
uniform float fade_amount : hint_range(0.0, 1.0) = 0.05;

void fragment() {
    // Получаем цвет пикселя из видео
    vec4 video_color = texture(TEXTURE, UV);
    
    // Вычисляем "расстояние" между цветом пикселя и целевым цветом фона
    float distance = length(video_color.rgb - chroma_key_color);
    
    // Если цвет достаточно близок к фону, делаем пиксель полностью прозрачным
    if (distance <= pickup_range) {
        discard; // Отбрасываем пиксель
    }
    
    // Плавно изменяем прозрачность для пикселей на границе, чтобы не было "рваных" краев
    float alpha = smoothstep(pickup_range, pickup_range + fade_amount, distance);
    
    // Устанавливаем итоговый цвет пикселя с учетом новой прозрачности
    COLOR = vec4(video_color.rgb, alpha);
}