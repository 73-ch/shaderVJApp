#version 150

#define PI 3.141592653589793

uniform mat4 modelViewProjectionMatrix;
uniform float time;
uniform int vertex_num;
uniform vec4 seed0;
in vec4 position;
out vec4 v_color;


vec3 rnd(float n, vec3 s){
    return vec3((fract(sin(dot(vec2(n, s.x), vec2(12.9898, 4.1414))) * 43758.5453) - 0.5) * 20.,
                (fract(sin(dot(vec2(n, s.y), vec2(12.9898, 4.1414))) * 43758.5453) - 0.5) * 20.,
                (fract(sin(dot(vec2(n, s.z), vec2(12.9898, 4.1414))) * 43758.5453) - 0.5) * 20.);
}

float rnd(vec2 n){
    return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

void main() {
	vec3 position = vec3(gl_VertexID / vertex_num)* 0.000001;
    gl_Position = modelViewProjectionMatrix * vec4(vec3(.0, 10., 0.), 1.);
    // gl_PointSize = 100.0;
    v_color = vec4(1.0);
}