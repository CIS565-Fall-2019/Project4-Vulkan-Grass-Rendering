#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(vertices = 1) out;

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// TODO: Declare tessellation control shader inputs and outputs

layout(location = 0) in vec4 inV0[];
layout(location = 1) in vec4 inV1[];
layout(location = 2) in vec4 inV2[];
layout(location = 3) in vec4 inUp[];

layout(location = 0) out vec4 outV0[];
layout(location = 1) out vec4 outV1[];
layout(location = 2) out vec4 outV2[];

void main() {
	// Don't move the origin location of the patch
    gl_out[gl_InvocationID].gl_Position = gl_in[gl_InvocationID].gl_Position;

	// TODO: Write any shader outputs
	outV0[gl_InvocationID] = inV0[gl_InvocationID];
	outV1[gl_InvocationID] = inV1[gl_InvocationID];
	outV2[gl_InvocationID] = inV2[gl_InvocationID];


	gl_TessLevelInner[0] = 2.0;
	gl_TessLevelInner[1] = 5.0;

	gl_TessLevelOuter[0] = 5.0;
	gl_TessLevelOuter[1] = 2.0;
	gl_TessLevelOuter[2] = 5.0;
	gl_TessLevelOuter[3] = 2.0;
}
