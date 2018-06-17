#version 150

#define PI 3.141592653589793

uniform mat4 modelViewProjectionMatrix;
uniform float time;
uniform int vertex_num;
uniform vec4 seed0;
in vec4 position;


vec3 rnd(float n, vec3 s){
    return vec3((fract(sin(dot(vec2(n, s.x), vec2(12.9898, 4.1414))) * 43758.5453) - 0.5) * 20.,
                (fract(sin(dot(vec2(n, s.y), vec2(12.9898, 4.1414))) * 43758.5453) - 0.5) * 20.,
                (fract(sin(dot(vec2(n, s.z), vec2(12.9898, 4.1414))) * 43758.5453) - 0.5) * 20.);
}

float rnd(vec2 n){
    return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

void main() {
    float th_x = (gl_VertexID + time * 100.) / float(vertex_num) * 2 * PI;
    float th_y = (float(vertex_num) - gl_VertexID + rnd(vec2(time, float(gl_VertexID / vertex_num))) * 100.) / float(vertex_num) * 2 * PI;
    float r = 500. * sin(2 * th_y) - 250.;
    float size = exp(sin(time) + 10. + rnd(vec2(1., float(gl_VertexID / vertex_num)))) / 10. - 1200.;
    vec3 v_position = vec3(cos(th_x) * r + rnd(vec2(gl_VertexID, seed0.x)) * size, rnd(vec2(cos(th_y), float(gl_VertexID / vertex_num))) + sin(th_x) * r + rnd(vec2(gl_VertexID, seed0.y)) * size, 500. * sin(2 * th_y)  + rnd(vec2(gl_VertexID, seed0.z)) * 30.) - vec3(800.);
    gl_Position = modelViewProjectionMatrix * vec4(v_position, 1.);
}