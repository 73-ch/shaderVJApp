
#version 150

#define PI 3.14159265359
#define TWO_PI 6.28318530718

uniform vec2 u_resolution;
uniform float time;
uniform vec4 seed0;

out vec4 outColor;

// 2D Random
float random (in vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

// 2D Noise based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
vec2 random2(vec2 st){
    st = vec2( dot(st,vec2(127.1,311.7)),
              dot(st,vec2(269.5,183.3)) );
    return -1.0 + 2.0*fract(sin(st)*43758.5453123);
}

// Value Noise by Inigo Quilez - iq/2013
// https://www.shadertoy.com/view/lsf3WH
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    
    vec2 u = f*f*(3.0-2.0*f);
    
    return mix( mix( dot( random2(i + vec2(0.0,0.0) ), f - vec2(0.0,0.0) ),
                    dot( random2(i + vec2(1.0,0.0) ), f - vec2(1.0,0.0) ), u.x),
               mix( dot( random2(i + vec2(0.0,1.0) ), f - vec2(0.0,1.0) ),
                   dot( random2(i + vec2(1.0,1.0) ), f - vec2(1.0,1.0) ), u.x), u.y);
}

void genPolygon(in float a, in float d, in float N,  in float time, in float velocity, in float size, in vec3 color, out vec3 result){
    a += time * velocity * 2.;
    float r = TWO_PI / float(N);
    d = cos(floor(.5 + a / r) * r - a) * d / size;
    
    result = color * vec3(1. - smoothstep(.4, .41, d));
}

void main() {
//    time = time*1.4;
    float s_time = time * 1.0;
    vec2 st = (gl_FragCoord.xy - u_resolution * .5) / u_resolution.y;
    
    vec3 final = vec3(.0);
    
    for (int i = 0; i < 10; i++) {
        st += vec2(sin(s_time)-cos(seed0.x + i)+0.5,mod(s_time, 1.)-0.5)*seed0.y;
        
        float r = atan(-st.y,-st.x);
        float l = length(abs(st));
        
        s_time += 10000.8765785;
        
        vec3 res;
        float n = floor(mod(s_time, 4.)+ 3.);
        genPolygon(r,l, n, s_time, 1.2, 0.2, vec3(1.0), res);
        r+= exp(mod(s_time,1.))/mod(s_time,1.);
        float th = (int((r+PI) * 1000.) % (int((TWO_PI / n) * 1000.)))*0.001;
        float line = smoothstep(1.-pow(l*0.1*(1.-seed0.x), 2.2), 1., th) - smoothstep(1., 1.+pow(l*0.1,2.8), th);
        vec3 b_out = res+vec3(line);
        final += b_out* vec3(1.- step(noise(st-s_time),0.2) * step(i,5), step(random(vec2(i,th)),.5),step(noise(-st-s_time) ,0.2));
    }
    
    outColor = vec4(final ,1.0);
}
