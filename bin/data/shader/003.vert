#version 150

#define PI 3.141592653589793

uniform mat4 modelViewProjectionMatrix;
uniform float time;
uniform int vertex_num;
uniform vec4 seed0;
uniform vec3 cam_pos;
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
    float x = 1.0;
    float y = 1.0;
    float z = sin(gl_VertexID/ 1000. + seed0.x) * 100.;
    
    int side_num = int(pow(vertex_num, 0.3333333));
    float pitch = 60.;
    
    x = mod(gl_VertexID, side_num) - side_num / 2 + rnd(vec2(seed0.y, gl_VertexID));
    y = mod(floor(gl_VertexID / side_num), side_num)- side_num / 2 + rnd(vec2(seed0.x, gl_VertexID));
    gl_PointSize = (floor(gl_VertexID / side_num / side_num) - side_num / 2)/2.;

    gl_Position = modelViewProjectionMatrix * vec4(x * pitch, y * pitch, z, 1.);
    v_color = vec4(sin(mod(gl_VertexID, side_num)/ side_num + time), sin(mod(floor(gl_VertexID / side_num), side_num))/side_num, 1.0, 1.0);
    
}