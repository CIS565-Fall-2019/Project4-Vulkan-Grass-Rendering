#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// TODO: Declare fragment shader inputs
layout(location = 0) in vec4 normal;
layout(location = 1) in vec4 lightDir;
layout(location = 2) in float height;

layout(location = 0) out vec4 outColor;

void main() {
    // TODO: Compute fragment color
	float lambertianTerm = clamp(abs(dot(normal, lightDir)), 0.0, 1.0);
	lambertianTerm = mix(height, lambertianTerm, 0.01);
	float ambient = 0.15;
	vec4 color = vec4(0.45f, 0.6f, 0.45f, 1.f);

    outColor = color * clamp((ambient + lambertianTerm), 0.f, 1.f);
}
