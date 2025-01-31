shader_type canvas_item;

uniform vec4 top_color = vec4(1.0, 1.0, 1.0, 1.0); // Brightest color (top)
uniform vec4 bottom_color = vec4(0.0, 0.0, 0.0, 1.0); // Darkest color (bottom)

void fragment() {
    // Get the vertical position (UV.y ranges from 0 at the top to 1 at the bottom)
    float gradient_factor = UV.y;

    // Interpolate between the top and bottom colors based on the vertical position
    vec4 gradient_color = mix(top_color, bottom_color, gradient_factor);

    // Apply the gradient to the TileMap's texture
    COLOR = texture(TEXTURE, UV) * gradient_color;
}