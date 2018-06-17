#version 150

#define PI 3.141592653589793
#define PI2 6.2831853072

uniform mat4 modelViewProjectionMatrix;
uniform float time;
uniform int vertex_num;
uniform vec4 seed0;
in vec4 position;
in vec4 normal;
out vec4 v_color;

float rnd(vec2 n){
    return fract(sin(dot(n, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
    float id = float(gl_VertexID) / vertex_num;
    
    float u_time = time / (seed0.z + 0.05) / 20.;
    
    float r = pow(rnd(vec2(id, 0.28283)), 1.0/ 3.0);
    float z = clamp(rnd(vec2(0.388484, id)), 0.0, 1.0) * 2. - 1.;
    float th = clamp(rnd(vec2(id, 0.7939282)), 0.0, 1.0) * PI2;
    
    vec3 v_position = 800. * (seed0.x + 0.5) * vec3(r * clamp(sqrt(1. - z*z + seed0.x) * cos(th* u_time), -1.0, 1.0), r * clamp(sqrt(1. - z*z+ seed0.x) * sin(th* u_time * seed0.y), -1., 1.), r * clamp(z, -1., 1.));
    
    gl_PointSize = 2.;
    gl_Position = modelViewProjectionMatrix * vec4(v_position, 1.);
    v_color = vec4(1.0);
}