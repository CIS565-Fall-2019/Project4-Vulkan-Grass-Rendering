#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(vertices = 1) out;

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// TODO: Declare tessellation control shader inputs and outputs
// Understanding the pipeline: Inputs are from grass.vert
layout(location = 0) in vec4 v0[];
layout(location = 1) in vec4 v1[];
layout(location = 2) in vec4 v2[];
layout(location = 3) in vec4 up[];

// Outputs are passed into grass.tese
layout(location = 0) out vec4 oV0[];
layout(location = 1) out vec4 oV1[];
layout(location = 2) out vec4 oV2[];
layout(location = 3) out vec4 oUp[];


void main() {
	// Don't move the origin location of the patch
    gl_out[gl_InvocationID].gl_Position = gl_in[gl_InvocationID].gl_Position;

	// TODO: Write any shader outputs 
	//  - to the tessellation evaluation shader to determine vertex positions
	oV0[gl_InvocationID] = v0[gl_InvocationID];
	oV1[gl_InvocationID] = v1[gl_InvocationID];
	oV2[gl_InvocationID] = v2[gl_InvocationID];
	oUp[gl_InvocationID] = up[gl_InvocationID];

	// TODO: Set level of tesselation
    gl_TessLevelInner[0] = 2.f; // horizontal tessellation
    gl_TessLevelInner[1] = 8.f; // vertical tessellation

    gl_TessLevelOuter[0] = 8.f; // edge 0-3 (vertical)
    gl_TessLevelOuter[1] = 2.f; // edge 2-3
    gl_TessLevelOuter[2] = 8.f; // edge 1-2 (vertical)
    gl_TessLevelOuter[3] = 2.f; // edge 0-1
	// change based on camera distance later
}
