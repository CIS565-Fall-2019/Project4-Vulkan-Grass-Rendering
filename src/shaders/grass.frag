#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// TODO: Declare fragment shader inputs
//layout(location = 0) in vec4 in_pos;
layout(location = 0) in vec4 in_nor;

layout(location = 0) out vec4 outColor;

void main() {
    // TODO: Compute fragment color
	vec3 color = vec3(0, 1, 0);
	vec4 lightPos = vec4(1, 1, 1, 1);

	// lambertian shading
	float diffuse = clamp(dot(normalize(in_nor), normalize(lightPos)), 0.0, 1.0);
	float ambient = 0.1;
	vec3 shadedColor = vec3(color * (diffuse + ambient));

    outColor = vec4(color, 1.0);
}
