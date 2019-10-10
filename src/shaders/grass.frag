#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// DONE: Declare fragment shader inputs
layout(location = 0) in vec2 in_uv;
layout(location = 1) in float in_height;

layout(location = 0) out vec4 outColor;

void main() {
	const float MAX_HEIGHT = 2.5f;

    // DONE: Compute fragment color
	float over255 = 1.0 / 255.0;

	// green gradient color
	vec3 green1 = vec3(16.0, 82.0, 50.0) * over255;
	vec3 green2 = vec3(121.0, 161.0, 98.0) * over255;
	vec3 green3 = vec3(169.0, 224.0, 81.0) * over255;

	float t = (in_uv.y * in_height / MAX_HEIGHT);

	vec3 color = mix(mix(green1, green2, t), mix(green2, green3, t), t);
	//color = mix(mix(green1, green2, in_uv.y), mix(green2, green3, in_uv.y), in_uv.y);

    outColor = vec4(color, 1.0);
}
