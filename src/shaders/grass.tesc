#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(vertices = 1) out;

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// Declare tessellation control shader inputs and outputs
layout (location = 0) in vec4 v0[];
layout (location = 1) in vec4 v1[];
layout (location = 2) in vec4 v2[];
layout (location = 3) in vec4 up[];

layout (location = 0) out vec4 v0o[];
layout (location = 1) out vec4 v1o[];
layout (location = 2) out vec4 v2o[];
layout (location = 3) out vec4 upo[];

void main() {
	// Don't move the origin location of the patch
    gl_out[gl_InvocationID].gl_Position = gl_in[gl_InvocationID].gl_Position;

	// Write any shader outputs
  v0o[gl_InvocationID] = v0[gl_InvocationID];
  v1o[gl_InvocationID] = v1[gl_InvocationID];
  v2o[gl_InvocationID] = v2[gl_InvocationID];
  upo[gl_InvocationID] = up[gl_InvocationID];

	// Set level of tesselation
  gl_TessLevelInner[0] = 15;
  gl_TessLevelInner[1] = 15;
  gl_TessLevelOuter[0] = 15;
  gl_TessLevelOuter[1] = 2;
  gl_TessLevelOuter[2] = 15;
  gl_TessLevelOuter[3] = 2;
}
