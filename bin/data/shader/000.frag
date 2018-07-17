#version 150

uniform float time;
uniform vec2 u_resolution;

out vec4 outColor;

void main() {
  outColor = vec4(vec3(gl_FragCoord.x /  u_resolution.x),1.0);
}
