#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// TODO: Declare fragment shader inputs
layout(location = 0) in vec4 normal;

layout(location = 0) out vec4 outColor;

void main() {
    // TODO: Compute fragment color
	float lambertianTerm = dot(normal, vec4(1.f));
	float ambient = 0.2;
	vec4 color = vec4(0.f, 1.f, 0.f, 1.f);

    outColor = color * clamp((ambient + lambertianTerm), 0.f, 1.f);
}
