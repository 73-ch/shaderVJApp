#version 150

uniform float time;
uniform vec2 u_resolution;
uniform vec4 seed0;

out vec4 outColor;

void main() {
	outColor = vec4(seed0.x);
}