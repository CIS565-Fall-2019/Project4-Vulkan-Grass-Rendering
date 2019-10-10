#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(vertices = 1) out;

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// DONE: Declare tessellation control shader inputs and outputs
layout(location = 0) in vec4[] in_v0;
layout(location = 1) in vec4[] in_v1;
layout(location = 2) in vec4[] in_v2;
layout(location = 3) in vec4[] in_up;

layout(location = 0) out vec4[] out_v0;
layout(location = 1) out vec4[] out_v1;
layout(location = 2) out vec4[] out_v2;

void main() {
	// Don't move the origin location of the patch
    gl_out[gl_InvocationID].gl_Position = gl_in[gl_InvocationID].gl_Position;

	// DONE: Write any shader outputs
	out_v0[gl_InvocationID] = in_v0[gl_InvocationID];
	out_v1[gl_InvocationID] = in_v1[gl_InvocationID];
	out_v2[gl_InvocationID] = in_v2[gl_InvocationID];

	// DONE: Set level of tessellation
	// TODO: base level of tessellation on distance from camera
	//mat4 invView = inverse(camera.view);
	//vec3 cameraPos = vec3(invView[3][0], invView[3][1], invView[3][2]);
	//float dist = length(cameraPos - vec3(camera.proj * camera.view * in_v0[gl_InvocationID])) / 50.0;

    gl_TessLevelInner[0] = 2;
	gl_TessLevelInner[1] = 8;
    gl_TessLevelOuter[0] = 8;
    gl_TessLevelOuter[1] = 2;
    gl_TessLevelOuter[2] = 8;
    gl_TessLevelOuter[3] = 8;
}
