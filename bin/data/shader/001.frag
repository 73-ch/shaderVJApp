#version 150

#define TWO_PI 6.28318530718

uniform float time;
uniform vec2 u_resolution;
uniform vec4 seed0;

out vec4 outColor;

vec3 genPolygon(in vec2 pol, in int vertex_num, in float size, in vec3 color){
    float d = 0.;
    float a = atan(pol.x, pol.y);
    float r = TWO_PI / float(vertex_num);
    d = cos(floor(.5 + a / r) * r - a) * length(pol) / size;
    
    return color * vec3(1. - smoothstep(.4, .4001, d));
}

void main() {
    vec2 st = gl_FragCoord.xy / u_resolution;
    vec2 pol = (gl_FragCoord.xy - u_resolution/2.) / u_resolution.y;
//    st.x *= st.y * seed0.x;
    
    float final = 0.;
    float c1 = 1., c2 = 1.;
    vec3 poly;
    
    for (int i = 0; i < 10; i++) {
        if (st.x * seed0.y< c2/144.) {
            final = c2/144.;
            poly = genPolygon(pol, int(mod(int(time*8. + i-1), 10.)), 1.1, vec3(1.0));
            break;
        } else if (i == 9) {
            final = 1.0;
            poly = genPolygon(pol, int(mod(int(time*8. + i), 10.)), 1.1, vec3(1.0));
            break;
        }
        float a = c1 + c2;
        c1 = c2;
        c2 = a;
    }
    
//    vec3 poly = genPolygon(pol, 4, 0.3, vec3(0.3));
    
    outColor = vec4(vec3(final) * poly, 1.0);
//    outColor = vec4(1.0);
}