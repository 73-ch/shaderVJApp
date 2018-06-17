#version 150
out vec4 outColor;
in vec4 v_color;

void main() {
    vec2 test = gl_PointCoord;
    vec2 st = gl_PointCoord;
    vec2 pos = vec2(0.5) - st;
    float r = length(pos)*2.0;
    vec3 color = vec3(1.-step(0.1,r));
    outColor = v_color * vec4(color,1.0);
}