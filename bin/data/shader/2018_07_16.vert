#version 150

#define PI 3.141592653589793

uniform mat4 modelViewProjectionMatrix;

in vec4 position;

in vec4 normal;
uniform float time;
uniform int vertex_num;
uniform vec4 seed0;
out vec4 v_color;

float rnd(vec2 n){
    return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}


void main(){
    vec4 v_pos = vec4(float(gl_VertexID) / vertex_num * 20000. - 10000., sin(time + gl_VertexID) * 200., 0.0, 1.0);
    vec4 t_pos = vec4(cos(gl_VertexID + time) * 500., sin(gl_VertexID + time) * 500., 1.0, 1.0);

    float th_x = (gl_VertexID + time * 100.) / float(vertex_num) * 2 * PI;
    float th_y = (float(vertex_num) - gl_VertexID + rnd(vec2(time, float(gl_VertexID / vertex_num))) * 100.) / float(vertex_num) * 2 * PI;
    float r = 500. * sin(2 * th_y) - 250.;
    float size = exp(sin(time) + 10. + rnd(vec2(1., float(gl_VertexID / vertex_num)))) / 10. - 1200.;
    vec3 v_position = vec3(cos(th_x) * cos(r)*r + rnd(vec2(gl_VertexID, seed0.x)), rnd(vec2(cos(th_y), float(gl_VertexID / vertex_num))) + sin(th_x) * r + rnd(vec2(gl_VertexID, seed0.y)), 500. * sin(2 * th_y)  + rnd(vec2(gl_VertexID, seed0.z)) * 30.);

    float time_x = mod(time, 5.0);

    vec4 x_pos = v_pos * smoothstep(1.0, 4.0, time_x) + vec4(v_position, 1.0) * smoothstep(-5.0, -1.0, -time_x);

    gl_Position = modelViewProjectionMatrix * x_pos;
    v_color = vec4(1.0);
}
