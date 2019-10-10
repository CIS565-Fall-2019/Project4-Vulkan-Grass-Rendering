#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// Declare fragment shader inputs
layout(location = 0) in vec3 pos;
layout(location = 1) in vec3 nor;
layout(location = 2) in float h;

layout(location = 0) out vec4 outColor;

void main() {
    vec3 lightDir = vec3(1.0, 1.0, 1.0);
	float lambert = abs(dot(lightDir, nor));

	vec3 col = (1.0 - h) * vec3(0.1, 0.2, 0.0) + h * vec3(0.3, 0.6, 0.0);

	outColor = vec4(col, 1.0);// * clamp(lambert, 0.2, 1.0);
}
