
#version 150

#define PI 3.141592653589793
#define PI_2 6.283185307179586
#define SQRT_2 1.4142135623730951
#define H_SQRT_2 0.7071067811865476

#define L_SIZE 200.
#define SPAN 20.
#define L_SIZE_SPAN L_SIZE/2.+SPAN

#define L_NUM 250000.
#define V_L_NUM 0.000004


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

vec3 A(float x){return vec3((vec2(x*1.25-.5,((mod(x*1.25,.5)-.25)*2.)*-sign(step(.4,x)-.1))*step(-.7999,-x)+vec2((x-.8)*2.5-.25,.0)*step(.8,x))*vec2(.8,1.),0.);}
vec3 C(float x){float t=(.25+x*1.5)*PI;return vec3(cos(t),sin(t),0.)*.5;}
vec3 G(float x){float t=(.27+(x*1.25)*1.5)*PI;return vec3(vec2(cos(t),sin(t))*step(-.8,-x)+vec2(cos(H_SQRT_2),-(x-.8)*10.*sin(H_SQRT_2))*step(-.9,-x)*step(.80001,x)+vec2((x-.9)*cos(H_SQRT_2)*10.,0.)*step(.9,x),0.) * .5;}
vec3 H(float x){return vec3(vec2(step(.4,x)*.6-.3,mod(x,.4)*2.5-.5)*step(-.80001,-x-.0001)+vec2((x-.8)*3.-.3,.0)*step(.8,x),.0);}
vec3 I(float x){return vec3(0.,x-.5,0.);}
vec3 L(float x){return vec3(vec2(-.3,x*2.-.5)*step(-.5,-x)+vec2((x-.5)*1.2-.3,-.5)*step(.500001,x),.0);}
vec3 O(float x){return vec3(cos(x*PI_2)*.45,sin(x*PI_2)*.5,.0);}
vec3 Q(float x){return vec3(vec2(cos(x*PI_2*1.25)*.45,sin(x*PI_2*1.25)*.5)*step(-0.8001, -x) + vec2(x-.6, -(x-.5))*step(0.8001,x),.0);}
vec3 S(float x){return vec3((vec2(cos((x*2.)*PI_2),(abs(sin((x*2.)*PI_2))+1.)*sign(x-.250001))*step(-.5,-x)+vec2(cos(x*PI_2),(sin(x*PI_2)+1.) * sign(x-.75))*step(.5000001,x))*vec2(.3,-.25),.0);}
vec3 T(float x){return vec3(vec2(0.,x*2.-.5)*step(-.5,-x)+vec2((x-.5)*1.2-.3,.5)*step(.500001,x),.0);}
vec3 V(float x){return vec3((x-.5)*.8,((mod(x,.50001)-.25)*2)*sign(step(.50001,x)-.1),0.);}
vec3 W(float x){return vec3(x-.5,(mod(x,.25)-.125)*4./(1.+step(-.24999,-abs(x-.5)))*-sign(step(-.24999999,-mod(x,.5))-.1)-.25*step(-.24999,-abs(x-.5)),.0);}


void main(){
    vec3 pos = vec3(.0,.0,100000.);
    if (gl_VertexID <= L_NUM) {
        pos = H(gl_VertexID * V_L_NUM)*L_SIZE+vec3(-(L_SIZE_SPAN)*3.,.0,.0);
    } else if(gl_VertexID <= L_NUM *2.) {
        pos = L((gl_VertexID - L_NUM) * V_L_NUM) * L_SIZE+vec3(-(L_SIZE_SPAN),.0,.0);
    } else if(gl_VertexID <= L_NUM* 3.) {
        pos = S((gl_VertexID - L_NUM * 2.) * V_L_NUM) * L_SIZE+vec3(L_SIZE_SPAN,.0,.0);
    } else if(gl_VertexID <= L_NUM*4.) {
        pos = L((gl_VertexID - L_NUM*3.) * V_L_NUM) * L_SIZE+vec3((L_SIZE_SPAN)*3.,.0,.0);
    }

   // pos *= sin(time + gl_VertexID * 0.000002);

   gl_PointSize = 1.0;

    gl_Position = modelViewProjectionMatrix * vec4(pos,1.0);
    // v_color = vec4(0.3, noise(vec2(gl_VertexID/ vertex_num * seed0.x, time * seed0.y)), 1.0, 1.0);
    v_color = vec4(1.0);
}
