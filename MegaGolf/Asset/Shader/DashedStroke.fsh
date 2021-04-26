void main() {
    vec4 current_color = v_color_mix;
    int stripe = int(u_path_length) / 150;
    int h = int(v_path_distance) / stripe % 2;
    gl_FragColor = current_color*h;
}
