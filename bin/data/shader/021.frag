
#version 150
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

void circle(in vec2 st,in vec2 pos, in float rad, in vec3 col, in float smoothEdges, out vec3 res){
    vec2 dist = st - vec2(pos);
    float aa = smoothEdges * .5;
    float pct = 1. - smoothstep(rad, rad + aa, dot(dist, dist) * 5.);
    res = vec3(col * pct);
}

void main() {
//    vec2 b_uv = mod(gl_FragCoord.xy + mod(time, 0.3), u_resolution);
    vec2 b_uv = mod(gl_FragCoord.xy*20., 1.0)/20.;
    vec2 uv = b_uv/u_resolution.y;
    
    uv = uv *2. -1.;
    float l = length(uv);
    l = sin(l + time*seed0.y*exp(mod(time, 1.0 - seed0.x)) + noise(vec2(gl_FragCoord.x/u_resolution.x, seed0.x)) * 10.);
    outColor = vec4(vec3(l),1.0);
}
