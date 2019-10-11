
#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(set = 1, binding = 0) uniform ModelBufferObject {
    mat4 model;
};

// TODO: Declare vertex shader inputs and outputs
layout(location = 0) in vec4 v0;
layout(location = 1) in vec4 v1;
layout(location = 2) in vec4 v2;
layout(location = 3) in vec4 up;

layout(location = 0) out vec4 v0Out;
layout(location = 1) out vec4 v1Out;
layout(location = 2) out vec4 v2Out;
layout(location = 3) out vec4 upOut;

out gl_PerVertex {
    vec4 gl_Position;
};

void main() {
	// TODO: Write gl_Position and any other shader outputs
	v0Out = model * v0;
	v1Out = model * v1;
	v2Out = model * v2;
	upOut = model * upOut;

	gl_Position = model * v0;
}
