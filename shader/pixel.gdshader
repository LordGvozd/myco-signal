shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform int pixel_size : hint_range(1, 64) = 32; // Размер квадрата в пикселях

void fragment() {
    // Получаем размер экрана в пикселях
    vec2 tex_size = vec2(textureSize(screen_texture, 0));
    float pixels_x = tex_size.x / float(pixel_size);
    float pixels_y = tex_size.y / float(pixel_size);
    
    // Округляем UV до ближайшего "блока"
    vec2 pixelated_uv = floor(SCREEN_UV * vec2(pixels_x, pixels_y)) / vec2(pixels_x, pixels_y);
    
    // Важно: оставляем sampling без фильтрации, чтобы пиксели были четкими
    // Для этого в настройках текстуры screen_texture нужно убрать галочку "Filter" или использовать флаг hint_anisotropic (но проще в свойствах текстуры в редакторе)
    COLOR = texture(screen_texture, pixelated_uv);
}