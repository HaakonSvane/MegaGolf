void main() {
    vec4 current_color = v_color_mix;
    
    vec2 offset = vec2(0.5, 0.5);
    float r = distance(v_tex_coord, offset);
    float h = 0.8 - r;
    gl_FragColor = current_color*h;
}
