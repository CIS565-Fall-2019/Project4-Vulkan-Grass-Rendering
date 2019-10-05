#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(quads, equal_spacing, ccw) in;

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// Tessellation evaluation shader inputs and outputs

layout(location = 0) in vec4 iv0[];
layout(location = 1) in vec4 iv1[];
layout(location = 2) in vec4 iv2[];
layout(location = 3) in vec4 iup[];

layout(location = 0) out vec3 pos;

void main() {
    float u = gl_TessCoord.x;
    float v = gl_TessCoord.y;

	// Use u and v to parameterize along the grass blade and output positions for each vertex of the grass blade
	vec3 lerp1 = mix(iv0[0].xyz, (iv1[0] - iv0[0]).xyz, v);
	vec3 lerp2 = mix(iv1[0].xyz, (iv2[0] - iv1[0]).xyz, v);
	vec3 bilerp = mix(lerp1, lerp2, u);

	pos = bilerp;
	gl_Position = camera.proj * camera.view * vec4(pos, 1.0f);
}
