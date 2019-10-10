#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(vertices = 1) out;

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// Tessellation control shader inputs and outputs

layout(location = 0) in vec4 iv0[];
layout(location = 1) in vec4 iv1[];
layout(location = 2) in vec4 iv2[];
layout(location = 3) in vec4 iup[];

layout(location = 0) out vec4 ov0[];
layout(location = 1) out vec4 ov1[];
layout(location = 2) out vec4 ov2[];
layout(location = 3) out vec4 oup[];

void main() {
	// Don't move the origin location of the patch
    gl_out[gl_InvocationID].gl_Position = gl_in[gl_InvocationID].gl_Position;

	// Write any shader outputs
	ov0[gl_InvocationID] = iv0[gl_InvocationID];
	ov1[gl_InvocationID] = iv1[gl_InvocationID];
	ov2[gl_InvocationID] = iv2[gl_InvocationID];
	oup[gl_InvocationID] = iup[gl_InvocationID];

	// Set level of tesselation
	// Should have more vertical tesselation than horizontal
    gl_TessLevelInner[0] = 2.0;
	gl_TessLevelInner[1] = 7.0;
    gl_TessLevelOuter[0] = 5.0;
    gl_TessLevelOuter[1] = 2.0;
    gl_TessLevelOuter[2] = 5.0;
	gl_TessLevelOuter[3] = 2.0;
}
