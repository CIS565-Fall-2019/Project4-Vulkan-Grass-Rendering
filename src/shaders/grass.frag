#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// TODO: Declare fragment shader inputs

layout(location = 0) in vec4 inPos;
layout(location = 1) in vec3 inNormal;
layout(location = 2) in vec2 inUV;

layout(location = 0) out vec4 outColor;

void main() {
    // TODO: Compute fragment color
	// interpolate color from bottom to top
	vec4 top = vec4(125, 193, 21, 255) / 255;
	vec4 bot = vec4(65, 121, 37, 255) / 255;

	vec4 color = mix(bot, top, inUV.y);

	vec3 light = normalize(vec3(-1.f, 0.f, -1.0));
	vec4 ambient_term = vec4(0.1, 0.15, 0.1, 1.0);
	float lambert = clamp(dot(light, inNormal), 0.1, 1.0);
	outColor = clamp(color * lambert + ambient_term, 0.2, 1.0);
}
