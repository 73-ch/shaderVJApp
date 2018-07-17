#version 150

#define PI 3.141592653589793
#define PI_2 6.283185307179586
#define SQRT_2 1.4142135623730951
#define H_SQRT_2 0.7071067811865476

#define L_SIZE 200.
#define SPAN 20.
#define L_SIZE_SPAN L_SIZE/2.+SPAN

#define L_NUM 500000.
#define V_L_NUM 0.000002

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

vec2 random2(vec2 st){
    st = vec2( dot(st,vec2(127.1,311.7)),
              dot(st,vec2(269.5,183.3)) );
    return -1.0 + 2.0*fract(sin(st)*43758.5453123);
}


float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    vec2 u = f*f*(3.0-2.0*f);

    return mix( mix( dot( random2(i + vec2(0.0,0.0) ), f - vec2(0.0,0.0) ),
                    dot( random2(i + vec2(1.0,0.0) ), f - vec2(1.0,0.0) ), u.x),
               mix( dot( random2(i + vec2(0.0,1.0) ), f - vec2(0.0,1.0) ),
                   dot( random2(i + vec2(1.0,1.0) ), f - vec2(1.0,1.0) ), u.x), u.y);
}

vec3 G(float x) {
    float t = (.23+(x*1.25)*1.5)*PI;
    return vec3(vec2(cos(t),sin(t))*step(-.8,-x)+vec2(cos(H_SQRT_2),(x-.8)*10.*sin(H_SQRT_2))*step(-.9,-x)*step(.80001,x)+vec2((x-.9)*cos(H_SQRT_2)*10.,0.)*step(.9,x),0.) * .5;
}

vec3 L(float x) {
    return vec3(vec2(-.3,x*2.-.5)*step(-.5,-x)+vec2((x-.5) * 1.2-.3,.5)*step(.500001,x),.0);
}

vec3 S(float x) {
    vec2 c = vec2(cos((x*2.)*PI_2), (abs(sin((x*2.)*PI_2))+1.) * sign(x-.250001)) * step(-.5,-x);
    vec2 a = vec2(cos(x*PI_2), (sin(x*PI_2)+ 1.) * sign(x-.75)) * step(.5000001, x);
    return vec3((c+a)*vec2(.3,.25),.0);
}


void main(){
    vec3 v_pos = vec3(float(gl_VertexID) / vertex_num * 20000. - 10000., sin(time + gl_VertexID) * 200., 0.0);
    vec3 t_pos = vec3(cos(gl_VertexID + time) * 500., sin(gl_VertexID + time) * 500., 1.0);

    float th_x = (gl_VertexID + time * 100.) / float(vertex_num) * 2 * PI;
    float th_y = (float(vertex_num) - gl_VertexID + rnd(vec2(time, float(gl_VertexID / vertex_num))) * 100.) / float(vertex_num) * 2 * PI;
    float r = 500. * sin(2 * th_y) - 250.;
    vec3 a_pos = vec3(cos(th_x) * cos(r)*r + rnd(vec2(gl_VertexID, 0.378347)) * 1000., rnd(vec2(cos(th_y), float(gl_VertexID / vertex_num))) + sin(th_x) * sin(r + time * 2.) * r + rnd(vec2(gl_VertexID, seed0.y)), 500. * sin(2 * th_y)  + rnd(vec2(gl_VertexID, seed0.z)) * 500.) - vec3(noise(vec2(time* 0.1, gl_VertexID)-0.25) * 4000., 0. ,0.);

    vec3 l_pos = vec3(.0,.0,100000.);
    if (gl_VertexID <= L_NUM) {
        l_pos = G(gl_VertexID * V_L_NUM)*L_SIZE+vec3(-(L_SIZE_SPAN)*3.,.0,.0);
    } else if(gl_VertexID <= L_NUM *2.) {
        l_pos = L((gl_VertexID - L_NUM) * V_L_NUM) * L_SIZE+vec3(-(L_SIZE_SPAN),.0,.0);
    } else if(gl_VertexID <= L_NUM* 3.) {
        l_pos = S((gl_VertexID - L_NUM * 2.) * V_L_NUM) * L_SIZE+vec3(L_SIZE_SPAN,.0,.0);
    } else if(gl_VertexID <= L_NUM*4.) {
        l_pos = L((gl_VertexID - L_NUM*3.) * V_L_NUM) * L_SIZE+vec3((L_SIZE_SPAN)*3.,.0,.0);
    }

    // l_pos *= sin(time + gl_VertexID * 0.000002);

    float time_x = abs(sin(time * 0.2)) * 5.0;

    vec3 x_pos = l_pos * smoothstep(1.0, 4.0, time_x) + a_pos * smoothstep(-4.0, -1.0, -time_x);

    gl_Position = modelViewProjectionMatrix * vec4(x_pos, 1.0);
    v_color = vec4(1.0);
}
