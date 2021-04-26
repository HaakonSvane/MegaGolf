#define M_PI 3.1415926535897932384626433832795


void main() {
    int stripes = 4;
    float speed = 1.0;
    vec4 current_color = v_color_mix;
    
    float x_sign = sign(cos(u_angle));
    float y_sign = sign(sin(u_angle));
    
    float pos = mix(x_sign * v_tex_coord.x, y_sign * v_tex_coord.y, abs(sin(u_angle)));

    int alpha_mult = floor(fract(pos * stripes + u_time * speed) + 0.5);
    gl_FragColor = current_color * alpha_mult;
}
